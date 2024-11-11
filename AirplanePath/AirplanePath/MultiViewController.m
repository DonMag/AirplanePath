//
//  MultiViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/10/24.
//

#import "MultiViewController.h"

// needed for FlightPath line CAShapeLayer
#import <QuartzCore/QuartzCore.h>

#import "PDFExtractor.h"
#import "LineSegObj.h"
#import "FlightPath.h"

#import "AircraftImageView.h"
#import "AircraftPathView.h"
#import "AircraftCGPath.h"
#import "RotatablePDFImageView.h"

#define FatalError(msg) { NSLog(@"Fatal error: %@", msg); assert(false); }

@interface MultiViewController ()
{
	NSImage *radarImg;
	NSMutableArray<NSImageView *> *radarViews;
	NSMutableArray<NSTextField *> *labelViews;
	
	NSMutableArray<NSValue *> *lineSegmentsArray;
	NSArray<NSColor *> *aircraftColors;
	CGSize aircraftSize;
}

@end

@implementation MultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// size of airplane views (1:1 ratio)
	//	the airplane path shape will be scaled maintaining proportion
	aircraftSize = CGSizeMake(40.0, 40.0);

	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	//	imagePath = [[NSBundle mainBundle] pathForResource:@"myairplane" ofType:@"pdf"];
	//	imagePath = [[NSBundle mainBundle] pathForResource:@"AC130" ofType:@"pdf"];
	if (!imagePath) {
		FatalError(@"Could not find AW109.pdf !!");
	}

	NSURL *pdfUrl = [NSURL fileURLWithPath:imagePath isDirectory:NO];

	// "background" radar image
	radarImg = [NSImage imageNamed:@"Radar"];
	if (!radarImg) {
		FatalError(@"Could not load Radar image !!");
	}
	
	aircraftColors = @[
		NSColor.redColor,
		NSColor.systemGreenColor,
		NSColor.blueColor,
		NSColor.systemCyanColor,
		NSColor.systemYellowColor,
		[NSColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0],
	];
	
	radarViews = [NSMutableArray array];
	labelViews = [NSMutableArray array];
	
	lineSegmentsArray = [FlightPath sampleFlightPath];
	
	CGMutablePathRef linePath = CGPathCreateMutable();
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// add segment to line path
		CGPathMoveToPoint(linePath, NULL, lineSeg.pt1.x, lineSeg.pt1.y);
		CGPathAddLineToPoint(linePath, NULL, lineSeg.pt2.x, lineSeg.pt2.y);
		
	}
	
	for (int i = 0; i < 4; i++) {

		NSTextField *label = [NSTextField new];
		
		label.stringValue = @"Click anywhere to toggle the background map visibility...";
		label.editable = NO;
		label.bezeled = NO;
		label.drawsBackground = NO;
		label.selectable = NO;
		label.alignment = NSTextAlignmentCenter;
		label.font = [NSFont systemFontOfSize:16.0];
		
		label.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:label];
		[labelViews addObject:label];
		
		NSImageView *rv = [NSImageView new];
		
		rv.wantsLayer = YES;
		rv.image = radarImg;
		rv.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:rv];
		[radarViews addObject:rv];

		// Create a CAShapeLayer for the "line path"
		CAShapeLayer *cLine = [CAShapeLayer layer];
		
		[rv.layer addSublayer:cLine];
		[cLine setZPosition:1];
		
		// set the line path properties
		cLine.path = linePath;
		cLine.fillColor = NULL;
		cLine.strokeColor = NSColor.blackColor.CGColor;
		cLine.lineWidth = 1;

		NSView *g = self.view;
		[NSLayoutConstraint activateConstraints:@[
			[label.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:40.0],
			[label.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-40.0],
			[label.bottomAnchor constraintEqualToAnchor:rv.topAnchor constant:-8.0],
			
			[rv.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
			[rv.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
			[rv.widthAnchor constraintEqualToConstant:radarImg.size.width],
			[rv.heightAnchor constraintEqualToConstant:radarImg.size.height],
		]];
		
		label.hidden = i != 0;
		rv.hidden = i != 0;

	}

	CGPathRelease(linePath);

	//[self useImageLayers:[radarViews objectAtIndex:0] pdfUrl:pdfUrl];
	//[self usePDFImageClass:[radarViews objectAtIndex:0] pdfUrl:pdfUrl];
	CGPathRef aPth = [[AircraftCGPath new] copterPath];
	[self usePathView:[radarViews objectAtIndex:0] aPath:aPth];
}

- (void)useImageLayers:(NSImageView *)rv pdfUrl:(NSURL *)pdfUrl
{
	// generate aircraft images from PDF
	//	set each as content for CALayer
	//	add CALayer as sublayer for each instance
	
	// array to hold layers
	NSMutableArray <CALayer *> *planes = [NSMutableArray array];
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// create a scaled, rotated, color image from PDF
		// CGContextRotateCTM goes counter-clockwise
		CGFloat radians = -lineSeg.radians;
		
		// if image is pointing right instead of up
		//radians += M_PI * 0.5;
		
		NSImage *pdfImg = [PDFExtractor imageFromPDFPage:pdfUrl pageNum:1 targetSize:aircraftSize rotationRadians:radians withColor:[aircraftColors objectAtIndex:i % aircraftColors.count]];
		
		// rect for generated aircraft image
		//	put center image at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (pdfImg.size.width * 0.5), lineSeg.cp.y - (pdfImg.size.height * 0.5), pdfImg.size.width, pdfImg.size.height);
		CALayer *c = [CALayer new];
		c.frame = r;
		c.contents = pdfImg;
		[planes addObject:c];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		CALayer *c = [planes objectAtIndex:i];
		[radarViews[0].layer addSublayer:c];
		[c setZPosition:1000 + i];
	}

}

- (void)usePDFImageClass:(NSImageView *)rv pdfUrl:(NSURL *)pdfUrl
{
	// generate AircraftImageView images from PDF
	//	add as subview for each instance
	
	NSImage *img = [[NSImage alloc] initWithContentsOfURL:pdfUrl];
	if (!img) {
		FatalError(@"Could not load AW109.pdf as NSImage !!");
	}
	img.template = YES;
	
	// array to hold aircraft
	NSMutableArray <RotatablePDFImageView *> *planes = [NSMutableArray array];
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// create a scaled, rotated, color image from PDF
		// CGContextRotateCTM goes counter-clockwise
		CGFloat radians = lineSeg.radians;
		
		// if image is pointing right instead of up
		//radians += M_PI * 0.5;
		
		// rect for airplane
		//	put center AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (aircraftSize.width * 0.5), lineSeg.cp.y - (aircraftSize.height * 0.5), aircraftSize.width, aircraftSize.height);
		
		RotatablePDFImageView *v = [[RotatablePDFImageView alloc] initWithFrame:r];
		v.wantsLayer = YES;
		[v setImage:img];
		
		[v setColor:[aircraftColors objectAtIndex:i % aircraftColors.count]];
		[v rotateByRadians:-radians];
		
		[rv addSubview:v];
		[planes addObject:v];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		NSView *v = [planes objectAtIndex:i];
		[v.layer setZPosition:1000 + i];
	}
	
}

- (void)usePathView:(NSImageView *)rv aPath:(CGPathRef)pth
{
	// array to hold aircraft
	NSMutableArray <AircraftPathView *> *planes = [NSMutableArray array];
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// create a scaled, rotated, color image from PDF
		// CGContextRotateCTM goes counter-clockwise
		CGFloat radians = lineSeg.radians;
		
		// if image is pointing right instead of up
		//radians += M_PI * 0.5;
		
		// rect for airplane
		//	put center AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (aircraftSize.width * 0.5), lineSeg.cp.y - (aircraftSize.height * 0.5), aircraftSize.width, aircraftSize.height);
		
		AircraftPathView *v = [[AircraftPathView alloc] initWithFrame:r];
		v.wantsLayer = YES;
		[v setThePath:pth];
		
		[v setFillColor:[aircraftColors objectAtIndex:i % aircraftColors.count]];
		[v setStrokeColor:v.fillColor];
		[v setStrokeWidth:1.0];
		[v rotateByRadians:-radians];
		
		[rv addSubview:v];
		[planes addObject:v];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		NSView *v = [planes objectAtIndex:i];
		[v.layer setZPosition:1000 + i];
	}
	
}

- (void)mouseUp:(NSEvent *)event {
	for (NSImageView *v in radarViews) {
		if (!v.image) {
			v.image = radarImg;
			((CAShapeLayer *)v.layer.sublayers.firstObject).strokeColor = NSColor.blackColor.CGColor;
		} else {
			v.image = NULL;
			((CAShapeLayer *)v.layer.sublayers.firstObject).strokeColor = NSColor.lightGrayColor.CGColor;
		}
	}
	
}

@end
