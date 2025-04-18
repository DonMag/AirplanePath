//
//  AirplaneView.h
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AircraftPathView : NSView

@property (assign, readwrite) CGPathRef thePath;

@property (strong, nonatomic) NSColor *fillColor;
@property (strong, nonatomic) NSColor *strokeColor;
@property (assign, readwrite) CGFloat strokeWidth;

- (void)rotateByRadians: (CGFloat)r;
- (void)rotateByDegrees:(CGFloat)d;

@end

NS_ASSUME_NONNULL_END
