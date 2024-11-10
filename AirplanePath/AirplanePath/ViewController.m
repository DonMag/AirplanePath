//
//  ViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LineSegObj.h"
#import "FlightPath.h"
#import "AircraftPathView.h"

#define FatalError(msg) { NSLog(@"Fatal error: %@", msg); assert(false); }

@interface ViewController ()
{
	NSImage *radarImg;
	NSImageView *radarImgView;

	NSColor *airplaneFillColor;
	NSColor *airplaneStrokeColor;
	CGFloat airplaneStrokeWidth;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	
	// values for this example
	//	adjust as desired

	// size of airplane views (1:1 ratio)
	//	the airplane path shape will be scaled maintaining proportion
	CGFloat airplaneSize = 40.0;
	
	// color of the "flight path" line
	NSColor *linePathColor = NSColor.blackColor;
	
	// make sure we can load the images
	// "background" radar image
	radarImg = [NSImage imageNamed:@"Radar"];
	if (!radarImg) {
		FatalError(@"Could not load Radar image !!");
	}
	
	radarImgView = [NSImageView new];
	
	// load the PDF
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	//	imagePath = [[NSBundle mainBundle] pathForResource:@"myairplane" ofType:@"pdf"];
	//	imagePath = [[NSBundle mainBundle] pathForResource:@"AC130" ofType:@"pdf"];
	if (!imagePath) {
		FatalError(@"Could not find AW109.pdf !!");
	}
	
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
	
	// add image view to view
	radarImgView.wantsLayer = YES;
	radarImgView.image = radarImg;
	radarImgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:radarImgView];
	
	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[
		[label.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:40.0],
		[label.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-40.0],
		[label.bottomAnchor constraintEqualToAnchor:radarImgView.topAnchor constant:-8.0],
		
		[radarImgView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[radarImgView.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
		[radarImgView.widthAnchor constraintEqualToConstant:radarImg.size.width],
		[radarImgView.heightAnchor constraintEqualToConstant:radarImg.size.height],
	]];
	
	// Create a CAShapeLayer for the "line path"
	CAShapeLayer *cLine = [CAShapeLayer layer];

	NSMutableArray<NSValue *> *lineSegmentsArray = [FlightPath sampleFlightPath];
	
	CGMutablePathRef linePath = CGPathCreateMutable();
	
	NSArray<NSColor *> *fillColors = @[
		[NSColor colorWithRed:1.00 green:0.75 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.75 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:1.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0],
	];
	
	NSArray<NSColor *> *strokeColors = @[
		[NSColor colorWithRed:0.50 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.50 alpha:1.0],
		[NSColor colorWithRed:0.75 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],
	];
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// add segment to line path
		CGPathMoveToPoint(linePath, NULL, lineSeg.pt1.x, lineSeg.pt1.y);
		CGPathAddLineToPoint(linePath, NULL, lineSeg.pt2.x, lineSeg.pt2.y);
		
		// rect for airplane
		//	we want the center of AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (airplaneSize * 0.5), lineSeg.cp.y - (airplaneSize * 0.5), airplaneSize, airplaneSize);
		
		// create AirplaneView and add to airplanesView
		AircraftPathView *v = [[AircraftPathView alloc] initWithFrame:r];
		[radarImgView addSubview:v];
		
		// set the rotation
		CGFloat radians = -lineSeg.radians;
		
		// if image is pointing right instead of up
		radians += M_PI * 0.5;
		
		[v rotateByRadians:radians];
		
		v.strokeWidth = airplaneStrokeWidth;
		
		v.fillColor = [fillColors objectAtIndex:i % fillColors.count];
		v.strokeColor = [strokeColors objectAtIndex:i % strokeColors.count];
		
	}
	
	[radarImgView.layer addSublayer:cLine];
	[cLine setZPosition:1];
	for (NSInteger i = 0; i < radarImgView.subviews.count; i++) {
		NSView *v = [radarImgView.subviews objectAtIndex:i];
		[v.layer setZPosition:cLine.zPosition + i];
	}

	// set the line path properties
	cLine.path = linePath;
	cLine.fillColor = NULL;
	cLine.strokeColor = [linePathColor CGColor];
	cLine.lineWidth = 1;

	CGPathRelease(linePath);
}

- (void)mouseUp:(NSEvent *)event {
	if (!radarImgView.image) {
		radarImgView.image = radarImg;
		((CAShapeLayer *)radarImgView.layer.sublayers.firstObject).strokeColor = NSColor.blackColor.CGColor;
	} else {
		radarImgView.image = NULL;
		((CAShapeLayer *)radarImgView.layer.sublayers.firstObject).strokeColor = NSColor.lightGrayColor.CGColor;
	}
	
}

@end
