//
//  UtilityMethods.h
//  AirplanePath
//
//  Created by Don Mag on 11/13/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UtilityMethods : NSObject
+ (CGRect)boundsForRect:(CGRect)origR withRotation:(CGFloat)angleInRadians;
@end

NS_ASSUME_NONNULL_END
