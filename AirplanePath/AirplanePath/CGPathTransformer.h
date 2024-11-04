//
//  CGPathTransformer.h
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGPathTransformer : NSObject
+ (CGMutablePathRef)pathInTargetRect:(CGRect)targetRect rotatedBy:(CGFloat)radian withPath:(CGMutablePathRef)path;
+ (CGMutablePathRef)pathInTargetRect:(CGRect)targetRect withPath:(CGMutablePathRef)path;
@end

NS_ASSUME_NONNULL_END
