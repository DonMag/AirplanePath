//
//  ViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AirplaneView.h"

typedef struct {
	CGPoint pt1;  // First point of the line segment
	CGPoint pt2;  // Second point of the line segment
	CGPoint cp;   // Center point of line segment
	CGFloat rad;  // Radian (angle of line segment)
} LineSeg;

// Function to initialize a LineSeg structure
LineSeg LineSegMake(CGPoint pt1, CGPoint pt2) {
	LineSeg lineSeg;
	lineSeg.pt1 = pt1;
	lineSeg.pt2 = pt2;
	lineSeg.cp = CGPointMake((pt1.x + pt2.x) / 2.0, (pt1.y + pt2.y) / 2.0);
	lineSeg.rad = atan2(pt2.y - pt1.y, pt2.x - pt1.x);
	return lineSeg;
}

// Function to convert LineSeg to NSValue for storage in NSMutableArray
NSValue *LineSegToNSValue(LineSeg lineSeg) {
	return [NSValue valueWithBytes:&lineSeg objCType:@encode(LineSeg)];
}

@interface ViewController ()
{
	// size of airplane views (1:1 ratio)
	//	the airplane path shape will be scaled maintaining proportion
	//	and centered in the view
	CGFloat airplaneSize;
	
	NSColor *airplaneFillColor;
	NSColor *airplaneStrokeColor;
	CGFloat airplaneStrokeWidth;

	NSColor *linePathColor;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// values for this example
	//	adjust as desired
	airplaneSize = 40.0;
	airplaneStrokeWidth = 1.0;
	
	airplaneFillColor = [NSColor yellowColor];
	airplaneStrokeColor = [NSColor redColor];
	
	linePathColor = [NSColor lightGrayColor];
	
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	
	// Create and add a CAShapeLayer to airplanesView for the "line path"
	CAShapeLayer *cLine = [CAShapeLayer layer];
	cLine.fillColor = NULL;
	cLine.strokeColor = [linePathColor CGColor];
	[self.view.layer addSublayer:cLine];
	
	CGPoint pt1, pt2;
	
	// Create a mutable array to hold LineSeg structures
	NSMutableArray<NSValue *> *lineSegmentsArray = [NSMutableArray array];
	
	// create some example line segments
	
	pt1 = CGPointMake( 40.0,  40.0);
	pt2 = CGPointMake( 80.0, 120.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(180.0, 160.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(280.0, 300.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(380.0, 300.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(460.0, 220.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(280.0, 60.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
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
		//	put center AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (airplaneSize * 0.5), lineSeg.cp.y - (airplaneSize * 0.5), airplaneSize, airplaneSize);
		
		// create AirplaneView and add to airplanesView
		AirplaneView *v = [[AirplaneView alloc] initWithFrame:r];
		[self.view addSubview:v];
		
		// set the rotation
		[v rotateByRadians:lineSeg.rad];
		
		v.strokeWidth = airplaneStrokeWidth;
		
		v.fillColor = [fillColors objectAtIndex:i % fillColors.count];
		v.strokeColor = [strokeColors objectAtIndex:i % strokeColors.count];
		
	}
	
	// set the line path
	cLine.path = linePath;
	
	CGPathRelease(linePath);
}


@end
