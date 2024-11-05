//
//  LineSeg.m
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import "LineSegObj.h"

@implementation LineSegObj

// Function to initialize a LineSeg structure
LineSeg LineSegMake(CGPoint pt1, CGPoint pt2) {
	LineSeg lineSeg;
	lineSeg.pt1 = pt1;
	lineSeg.pt2 = pt2;
	lineSeg.cp = CGPointMake((pt1.x + pt2.x) / 2.0, (pt1.y + pt2.y) / 2.0);
	lineSeg.rad = atan2(pt2.y - pt1.y, pt2.x - pt1.x);
	return lineSeg;
}

// Function to convert LineSeg to NSValue for storage in NSMutableArray
NSValue *LineSegToNSValue(LineSeg lineSeg) {
	return [NSValue valueWithBytes:&lineSeg objCType:@encode(LineSeg)];
}

@end
