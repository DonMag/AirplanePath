//
//  MultiViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/10/24.
//

#import "MultiViewController.h"

// needed for FlightPath line CAShapeLayer
#import <QuartzCore/QuartzCore.h>

#import "UtilityMethods.h"
#import "CGPathTransformer.h"
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
	//aircraftSize = CGSizeMake(80.0, 80.0);

	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
		imagePath = [[NSBundle mainBundle] pathForResource:@"myairplane" ofType:@"pdf"];
	//	imagePath = [[NSBundle mainBundle] pathForResource:@"AC130" ofType:@"pdf"];
	imagePath = [[NSBundle mainBundle] pathForResource:@"zAW109" ofType:@"pdf"];
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
		//rv.image = radarImg;
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
		cLine.strokeColor = NSColor.lightGrayColor.CGColor;
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

	// Add NSSegmentedControl to the view
	NSSegmentedControl *segmentedControl = [NSSegmentedControl new];
	segmentedControl = [NSSegmentedControl new];
	[segmentedControl setSegmentCount:4];
	[segmentedControl setTarget:self];
	[segmentedControl setAction:@selector(segmentedControlChanged:)];
	
	[segmentedControl setLabel:@"Image Layers" forSegment:0];
	[segmentedControl setLabel:@"PDF Image Subviews" forSegment:1];
	[segmentedControl setLabel:@"PDFPath Layers" forSegment:2];
	[segmentedControl setLabel:@"Custom Path Subviews" forSegment:3];
	
	[segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
	[segmentedControl setSegmentStyle:NSSegmentStyleRounded];
	[segmentedControl setSelectedSegment:0];
	
	NSTextField *swLabel = [NSTextField new];
	
	swLabel.stringValue = @"Show background Radar map:";
	swLabel.editable = NO;
	swLabel.bezeled = NO;
	swLabel.drawsBackground = NO;
	swLabel.selectable = NO;
	swLabel.font = [NSFont systemFontOfSize:15.0];
	
	NSSwitch *sw = [NSSwitch new];
	[sw setAction:@selector(switchChanged:)];

	segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:segmentedControl];
	swLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:swLabel];
	sw.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:sw];

	// Set constraints or frame for segmented control
	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[
		[segmentedControl.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[segmentedControl.topAnchor constraintEqualToAnchor:g.topAnchor constant:16.0],
		[swLabel.leadingAnchor constraintEqualToAnchor:segmentedControl.leadingAnchor constant:12.0],
		[swLabel.centerYAnchor constraintEqualToAnchor:sw.centerYAnchor constant:0.0],
		[sw.leadingAnchor constraintEqualToAnchor:swLabel.trailingAnchor constant:12.0],
		[sw.topAnchor constraintEqualToAnchor:segmentedControl.bottomAnchor constant:12.0],
	]];

	[self useImageLayers:[radarViews objectAtIndex:0] pdfUrl:pdfUrl];
	[self usePDFImageClass:[radarViews objectAtIndex:1] pdfUrl:pdfUrl];
	[self usePDFPathLayers:[radarViews objectAtIndex:2] pdfUrl:pdfUrl];

	CGPathRef aPth = [AircraftCGPath copterPath];
	//aPth = [AircraftCGPath airplanePath];
	aPth = [AircraftCGPath demoPath];
	
//	NSArray<id> *vectorPaths = [UtilityMethods extractVectorPathsFromPDF:pdfUrl];
//	aPth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);

	[self usePathView:[radarViews objectAtIndex:3] aPath:aPth];
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
		
		NSImage *pdfImg = [UtilityMethods imageFromPDFPage:pdfUrl pageNum:1 targetSize:aircraftSize rotationRadians:radians withColor:[aircraftColors objectAtIndex:i % aircraftColors.count]];
		
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
		[rv.layer addSublayer:c];
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
		
		[planes addObject:v];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		NSView *v = [planes objectAtIndex:i];
		[rv addSubview:v];
		[v.layer setZPosition:1000 + i];
	}
	
}

- (void)usePDFPathLayers:(NSImageView *)rv pdfUrl:(NSURL *)pdfUrl
{
	// generate aircraft images from PDF
	//	set each as content for CALayer
	//	add CALayer as sublayer for each instance
	
	NSArray<id> *vectorPaths = [UtilityMethods extractVectorPathsFromPDF:pdfUrl];
	CGPathRef pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	
	// calculate target rect
	//	center and maintain aspect ratio
	CGRect pathRect = CGPathGetBoundingBox(pth);
	CGRect boundsRect = CGRectMake(0, 0, aircraftSize.width, aircraftSize.height);
	
	CGRect targRect = [UtilityMethods scaleRect:pathRect toFit:boundsRect];
	
	// transform airplane path to fit
	CGMutablePathRef cpth2 = [CGPathTransformer pathInTargetRect:targRect withPath:pth];
	if (!cpth2) {
		return;
	}
	
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
		
		// rect for generated aircraft image
		//	put center image at midpoint of line segment
		CGRect r = CGRectOffset(boundsRect, lineSeg.cp.x - (boundsRect.size.width * 0.5), lineSeg.cp.y - (boundsRect.size.height * 0.5));
		CAShapeLayer *c = [CAShapeLayer new];
		c.frame = r;
		c.path = cpth2;
		c.fillColor = [[aircraftColors objectAtIndex:i % aircraftColors.count] CGColor];
		c.strokeColor = c.fillColor;
		c.lineWidth = 0.5;
		CGAffineTransform rTransform = CGAffineTransformMakeRotation(radians);
		c.affineTransform = rTransform;
		
		[planes addObject:c];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		CALayer *c = [planes objectAtIndex:i];
		[rv.layer addSublayer:c];
		[c setZPosition:1000 + i];
	}
	
	CGPathRelease(cpth2);
	
}

- (void)useCustomPathLayers:(NSImageView *)rv aPath:(CGPathRef)pth
{
	// calculate target rect
	//	center and maintain aspect ratio
	CGRect pathRect = CGPathGetBoundingBox(pth);
	CGRect boundsRect = CGRectMake(0, 0, aircraftSize.width, aircraftSize.height);
	
	CGRect targRect = [UtilityMethods scaleRect:pathRect toFit:boundsRect];
	
	// transform airplane path to fit
	CGMutablePathRef cpth2 = [CGPathTransformer pathInTargetRect:targRect withPath:pth];
	if (!cpth2) {
		return;
	}
	
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
		
		// rect for generated aircraft image
		//	put center image at midpoint of line segment
		CGRect r = CGRectOffset(boundsRect, lineSeg.cp.x - (boundsRect.size.width * 0.5), lineSeg.cp.y - (boundsRect.size.height * 0.5));
		CAShapeLayer *c = [CAShapeLayer new];
		c.frame = r;
		c.path = cpth2;
		c.fillColor = [[aircraftColors objectAtIndex:i % aircraftColors.count] CGColor];
		c.strokeColor = c.fillColor;
		c.lineWidth = 0.5;
		CGAffineTransform rTransform = CGAffineTransformMakeRotation(radians);
		c.affineTransform = rTransform;
		
		[planes addObject:c];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		CALayer *c = [planes objectAtIndex:i];
		[rv.layer addSublayer:c];
		[c setZPosition:1000 + i];
	}
	
	CGPathRelease(cpth2);
	
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
		[v setStrokeWidth:0.5];
		[v rotateByRadians:-radians];
		
		[planes addObject:v];
	}
	
	for (NSInteger i = 0; i < planes.count; i++) {
		NSView *v = [planes objectAtIndex:i];
		[rv addSubview:v];
		[v.layer setZPosition:1000 + i];
	}
	
}

- (void)switchChanged:(NSSwitch *)sender {
	NSLog(@"%@", sender.state == YES ? @"On" : @"Off");
	for (NSImageView *v in radarViews) {
		if (sender.state) {
			v.image = radarImg;
			((CAShapeLayer *)v.layer.sublayers.firstObject).strokeColor = NSColor.blackColor.CGColor;
		} else {
			v.image = NULL;
			((CAShapeLayer *)v.layer.sublayers.firstObject).strokeColor = NSColor.lightGrayColor.CGColor;
		}
	}
}
- (void)segmentedControlChanged:(NSSegmentedControl *)sender {
	NSInteger selectedSegment = sender.selectedSegment;
	NSLog(@"Selected segment: %ld", (long)selectedSegment);
	
	switch (selectedSegment) {
		case 0:
			// Handle Option 1
			NSLog(@"Option 1 selected");
			break;
		case 1:
			// Handle Option 2
			NSLog(@"Option 2 selected");
			break;
		case 2:
			// Handle Option 3
			NSLog(@"Option 3 selected");
			break;
		default:
			break;
	}
	
	for (int i = 0; i < radarViews.count; i++) {
		radarViews[i].hidden = i != selectedSegment;
	}
	
}

@end
