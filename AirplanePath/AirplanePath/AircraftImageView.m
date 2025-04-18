//
//  AirplaneImageView.m
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import "AircraftImageView.h"


@interface AircraftImageView ()
{
	CGFloat rotationRadians;
}
@end

@implementation AircraftImageView

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

- (void)drawRect:(NSRect)dirtyRect {
	NSAffineTransform *transform = [[NSAffineTransform alloc] init];
	[transform translateXBy:self.bounds.size.width / 2 yBy:self.bounds.size.height / 2];
	// Apply rotation
	[transform rotateByRadians:-rotationRadians];
	// Translate back
	[transform translateXBy:-self.bounds.size.width / 2 yBy:-self.bounds.size.height / 2];
	[transform set];
	[super drawRect:dirtyRect];
}

- (void)setupView {
	self.wantsLayer = YES;
	self.imageScaling = NSImageScaleProportionallyUpOrDown;
	self.layer.backgroundColor = [[NSColor cyanColor] CGColor];
	self.layer.masksToBounds = NO;
	self.clipsToBounds = NO;
}
- (void)rotateByDegrees:(CGFloat)d {
	rotationRadians = d  * (M_PI / 180.0);
	[self setNeedsDisplay:YES];
}
- (void)rotateByRadians:(CGFloat)r {
	rotationRadians = r;
	[self setNeedsDisplay:YES];
}
- (void)setFillColor:(NSColor *)fillColor {
	self.contentTintColor = fillColor;
}
@end
