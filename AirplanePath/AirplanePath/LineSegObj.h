//
//  LineSegObj.h
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
	CGPoint pt1;  // First point of the line segment
	CGPoint pt2;  // Second point of the line segment
	CGPoint cp;   // Center point of line segment
	CGFloat rad;  // Radian (angle of line segment)
} LineSeg;

@interface LineSegObj : NSObject

LineSeg LineSegMake(CGPoint pt1, CGPoint pt2);
NSValue *LineSegToNSValue(LineSeg lineSeg);

@end

NS_ASSUME_NONNULL_END
