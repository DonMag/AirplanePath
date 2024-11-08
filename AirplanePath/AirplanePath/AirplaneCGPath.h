//
//  AirplaneCGPath.h
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AirplaneCGPath : NSObject
- (CGMutablePathRef)airplanePath;
- (CGMutablePathRef)copterPath;
- (CGMutablePathRef)badcopterPath;
- (NSMutableArray *)createArrayOfPaths;
@end

NS_ASSUME_NONNULL_END
