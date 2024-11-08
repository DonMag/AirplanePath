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
	
	// calculate center point on line
	lineSeg.cp = CGPointMake((pt1.x + pt2.x) / 2.0, (pt1.y + pt2.y) / 2.0);
	
	// calculate the angle (in radians) in this orientation
	// 	clockwise with 0.0 at 12 o'clock
	
	//
	//              pi * 0.0                            0º
	//   pi * 1.5              pi * 0.5        270º           90º
	//              pi * 1.0                           180º
	//
	
	//CGFloat deltaX = pt2.x - pt1.x;
	//CGFloat deltaY = pt2.y - pt1.y;
	
	// Calculate the angle in radians using atan2
	CGFloat radians = atan2(pt2.y - pt1.y, pt2.x - pt1.x);
	CGFloat adjusted = fmod((M_PI * 2.5 - radians), M_PI * 2.0);
	
	lineSeg.radians = adjusted;

	return lineSeg;
}

// Function to convert LineSeg to NSValue for storage in NSMutableArray
NSValue *LineSegToNSValue(LineSeg lineSeg) {
	return [NSValue valueWithBytes:&lineSeg objCType:@encode(LineSeg)];
}

@end
