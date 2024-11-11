//
//  RotatablePDFImageView.h
//  AirplanePath
//
//  Created by Don Mag on 11/11/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RotatablePDFImageView : NSView

- (void)setImage:(NSImage *)img;
- (void)setColor:(NSColor *)color;

- (void)rotateByRadians: (CGFloat)r;
- (void)rotateByDegrees:(CGFloat)d;

@end

NS_ASSUME_NONNULL_END
