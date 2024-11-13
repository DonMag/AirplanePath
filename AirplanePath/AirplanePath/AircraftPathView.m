//
//  AirplaneView.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "AircraftPathView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGPathTransformer.h"
#import "UtilityMethods.h"

@interface AircraftPathView ()
{
	CGFloat rotationRadians;
}
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation AircraftPathView

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self) {
		[self setupShapeLayer];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		[self setupShapeLayer];
	}
	return self;
}

- (void)setupShapeLayer {
	self.wantsLayer = YES;
	
	// defaults
	self.fillColor = [NSColor yellowColor];
	self.strokeColor = [NSColor redColor];
	self.strokeWidth = 2.0;
	
	// Create and configure the CAShapeLayer
	self.shapeLayer = [CAShapeLayer layer];

	self.shapeLayer.fillColor = [self.fillColor CGColor];
	self.shapeLayer.strokeColor = [self.strokeColor CGColor];
	self.shapeLayer.lineWidth = self.strokeWidth;

	rotationRadians = 0.0;
	
	// Add the shape layer to the view's layer
	[self.layer addSublayer:self.shapeLayer];
	self.layer.masksToBounds = NO;
	
	// during development / debugging
	//	to see the view framing
	//self.layer.backgroundColor = NSColor.yellowColor.CGColor;
}

- (void)layout {
	[super layout];

	self.shapeLayer.fillColor = [self.fillColor CGColor];
	self.shapeLayer.strokeColor = [self.strokeColor CGColor];
	self.shapeLayer.lineWidth = self.strokeWidth;

	[self.shapeLayer setFrame:self.bounds];
	self.shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);

	// calculate target rect
	//	center and maintain aspect ratio
	//CGRect pathRect = CGPathGetBoundingBox(pth);
	CGRect pathRect = CGPathGetBoundingBox(self.thePath);
	CGRect boundsRect = self.bounds;
	
	CGRect targRect = [UtilityMethods scaleRect:pathRect toFit:boundsRect];

	// transform airplane path to fit
	//CGMutablePathRef cpth2 = [CGPathTransformer pathInTargetRect:targRect withPath:pth];
	CGMutablePathRef cpth2 = [CGPathTransformer pathInTargetRect:targRect withPath:self.thePath];
	if (cpth2) {
		self.shapeLayer.path = cpth2;
	}
	
	CGPathRelease(cpth2);
	
	// rotate the shape layer
	[self doRotation];
}
- (void)doRotation {
	CGAffineTransform rTransform = CGAffineTransformMakeRotation(rotationRadians);
	self.shapeLayer.affineTransform = rTransform;
}

- (void)rotateByDegrees:(CGFloat)d {
	rotationRadians = d  * (M_PI / 180.0);
	[self setNeedsLayout:YES];
}
- (void)rotateByRadians:(CGFloat)r {
	rotationRadians = r;
	[self setNeedsLayout:YES];
}

@end
