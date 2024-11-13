//
//  RotatablePDFImageView.m
//  AirplanePath
//
//  Created by Don Mag on 11/11/24.
//

#import "RotatablePDFImageView.h"
#import "UtilityMethods.h"

@interface RotatablePDFImageView ()
{
	CGFloat rotationRadians;
	NSImageView *theImageView;
}
@end

@implementation RotatablePDFImageView

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self) {
		[self setupView];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		[self setupView];
	}
	return self;
}

- (void)setupView {
	self.wantsLayer = YES;
	theImageView = [NSImageView new];
	theImageView.wantsLayer = YES;
	theImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
	[self addSubview:theImageView];
	self.clipsToBounds = NO;
}
- (void)layout {
	[super layout];
	NSLog(@"layout");
	[self doRotate];
}
- (void)rotateByDegrees:(CGFloat)d {
	rotationRadians = d * (M_PI / 180.0);
	[self setNeedsLayout:YES];
}
- (void)rotateByRadians:(CGFloat)r {
	rotationRadians = r;
	[self setNeedsLayout:YES];
}
- (void)doRotate {
	CGRect newR = [UtilityMethods boundsForRect:self.bounds withRotation:rotationRadians];
	theImageView.frame = newR;
	[theImageView rotateByAngle:rotationRadians * 180.0 / M_PI];
}
- (void)setImage:(NSImage *)img {
	theImageView.image = img;
}
- (void)setColor:(NSColor *)color {
	theImageView.contentTintColor = color;
}

@end
