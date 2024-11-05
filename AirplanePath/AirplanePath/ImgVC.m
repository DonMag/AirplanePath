//
//  ImgVC.m
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import "ImgVC.h"
#import <QuartzCore/QuartzCore.h>
#import "LineSegObj.h"
#import "AirplaneImageView.h"

@interface ImgVC ()
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

@implementation ImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// values for this example
	//	adjust as desired
	airplaneSize = 80.0;
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
	
//	NSImage *img = [NSImage imageNamed:@"HAW109"];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
	img.template = YES;
	
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
		AirplaneImageView *v = [[AirplaneImageView alloc] initWithFrame:r];
//		NSImageView *v = [[NSImageView alloc] initWithFrame:r];
		v.wantsLayer = YES;
		[v setImage:img];
		[v setContentTintColor:[strokeColors objectAtIndex:i % strokeColors.count]];
		[self.view addSubview:v];
		
		//[self rotateImageView:v byDegrees:lineSeg.rad];
//		[self rotateImageView:v byDegrees:45];
		
//		[v rotateByAngle:(lineSeg.rad * (180.0 / M_PI)) - 90.0];
		
//		[v rotateByAngle:(lineSeg.rad * (180.0 / M_PI))];
//		[v rotateByAngle:-90.0];
//		v.layer.backgroundColor = [[NSColor yellowColor] CGColor];
		
		[v rotateByRadians:lineSeg.rad - M_PI * 0.5];
		
//		CGAffineTransform rTransform = CGAffineTransformMakeRotation(lineSeg.rad);
//		v.layer.affineTransform = rTransform;

//		// set the rotation
//		[v rotateByRadians:lineSeg.rad];
//		
//		v.strokeWidth = airplaneStrokeWidth;
//		
//		v.fillColor = [fillColors objectAtIndex:i % fillColors.count];
//		v.strokeColor = [strokeColors objectAtIndex:i % strokeColors.count];
		
	}
	
	// set the line path
	cLine.path = linePath;
	
	CGPathRelease(linePath);

	CGRect r = CGRectMake(20, 20, 400, 1000);
	AirplaneImageView *v = [[AirplaneImageView alloc] initWithFrame:r];
	v.imageScaling = NSImageScaleProportionallyUpOrDown;
	v.wantsLayer = YES;
	[v setImage:img];
	[v setContentTintColor:NSColor.redColor];
	[self.view addSubview:v];
	

}

- (void)viewDidAppear {
	[super viewDidAppear];
	
	NSImageView *v = (NSImageView *)self.view.subviews.lastObject;
	NSImage *i = v.image;
	NSLog(@"sz: %@", [NSValue valueWithSize:i.size]);
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
	img.template = YES;
	
	CGFloat f = 128 * 4;
	NSImage *s = [self scaleImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor];
	NSLog(@"sz: %@", [NSValue valueWithSize:s.size]);
	NSLog(@"");

}
- (NSImage *)scaleImage:(NSImage *)image toSize:(NSSize)newSize withBackgroundColor:(NSColor *)backgroundColor {
	NSImage *scaledImage = [[NSImage alloc] initWithSize:newSize];
	
	[scaledImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, newSize.width, newSize.height));
	
	// Draw the original image scaled to the new size
	[image drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height)
			 fromRect:NSMakeRect(0, 0, image.size.width, image.size.height)
			//operation:NSCompositingOperationSourceOver
			//operation:NSCompositingOperationXOR
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[scaledImage unlockFocus];
	
	return scaledImage;
}

- (void)rotateImageView:(NSImageView *)imageView byDegrees:(CGFloat)degrees {
	// Convert degrees to radians
	CGFloat radians = degrees; //* M_PI / 180.0;
	
	// Create a CGAffineTransform for rotation around the center of the view
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	// Translate to center, rotate, and translate back
	transform = CGAffineTransformTranslate(transform, imageView.bounds.size.width / 2, imageView.bounds.size.height / 2);
	transform = CGAffineTransformRotate(transform, radians);
	transform = CGAffineTransformTranslate(transform, -imageView.bounds.size.width / 2, -imageView.bounds.size.height / 2);
	
	// Apply the transform to the layer
	if (!imageView.wantsLayer) {
		imageView.wantsLayer = YES;
	}
	imageView.layer.affineTransform = transform;
}

@end
