//
//  AirplaneImageView.h
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AircraftImageView : NSImageView

@property (strong, nonatomic) NSColor *fillColor;

- (void)rotateByRadians: (CGFloat)r;
- (void)rotateByDegrees:(CGFloat)d;

@end

NS_ASSUME_NONNULL_END
