//
//  RotatablePDFImageView.m
//  AirplanePath
//
//  Created by Don Mag on 11/11/24.
//

#import "RotatablePDFImageView.h"

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
	rotationRadians = d  * (M_PI / 180.0);
	[self setNeedsLayout:YES];
}
- (void)rotateByRadians:(CGFloat)r {
	rotationRadians = r;
	[self setNeedsLayout:YES];
}
- (void)doRotate {
	CGRect newR = [self adjustedRect:self.bounds withRotation:rotationRadians];
	theImageView.frame = newR;
	[theImageView rotateByAngle:rotationRadians * 180.0 / M_PI];
}
- (void)setImage:(NSImage *)img {
	theImageView.image = img;
}
- (void)setColor:(NSColor *)color {
	theImageView.contentTintColor = color;
}
- (CGRect)adjustedRect:(CGRect)origR withRotation:(CGFloat)angleInRadians {
	// Calculate the cosine and sine of the rotation angle
	CGFloat cosAngle = fabs(cos(angleInRadians));
	CGFloat sinAngle = fabs(sin(angleInRadians));
	
	// Calculate the scaling factors to maintain the original bounding box size
	CGFloat scaleX = 1.0 / (cosAngle + sinAngle);
	CGFloat scaleY = 1.0 / (cosAngle + sinAngle);
	
	CGSize newSZ = CGSizeMake(origR.size.width * scaleX, origR.size.height * scaleY);
	CGRect newR = origR;
	newR.size = newSZ;
	newR.origin.x += (origR.size.width - newSZ.width) * 0.5;
	newR.origin.y += (origR.size.height - newSZ.height) * 0.5;
	
	return newR;
}

@end
