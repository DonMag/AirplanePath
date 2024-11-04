//
//  Airplane.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "AirplaneCGPath.h"

@implementation AirplaneCGPath

- (CGMutablePathRef)qairplanePath {

	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, 99.3, 281.6);
	CGPathAddLineToPoint(path, NULL, 248.08, 281.68);
	CGPathAddLineToPoint(path, NULL, 178.94, 0.54);
	CGPathAddLineToPoint(path, NULL, 248.08, 0.54);
	CGPathAddCurveToPoint(path, NULL, 248.08, 0.54, 391.81, 281.6, 393.11, 281.6);
	CGPathAddLineToPoint(path, NULL, 591.47, 281.6);
	CGPathAddCurveToPoint(path, NULL, 658.12, 281.6, 654.2, 359.46, 591.47, 359.46);
	CGPathAddLineToPoint(path, NULL, 391.87, 359.46);
	CGPathAddLineToPoint(path, NULL, 235.02, 640.54);
	CGPathAddLineToPoint(path, NULL, 165.89, 640.54);
	CGPathAddLineToPoint(path, NULL, 246.76, 359.46);
	CGPathAddLineToPoint(path, NULL, 97.95, 359.46);
	CGPathAddLineToPoint(path, NULL, 52.29, 412.49);
	CGPathAddLineToPoint(path, NULL, 0, 412.49);
	CGPathAddLineToPoint(path, NULL, 27.51, 320.61);
	CGPathAddLineToPoint(path, NULL, 1.32, 218.24);
	CGPathAddLineToPoint(path, NULL, 52.29, 218.24);
	CGPathAddLineToPoint(path, NULL, 99.3, 281.6);
	CGPathCloseSubpath(path);
	
	return path;
	
}

- (CGMutablePathRef)airplanePath {
	
	CGMutablePathRef path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, 99.3, 201.06);
	CGPathAddLineToPoint(path, NULL, 248.08, 201.14);
	CGPathAddLineToPoint(path, NULL, 178.94, 0);
	CGPathAddLineToPoint(path, NULL, 248.08, 0);
	CGPathAddCurveToPoint(path, NULL, 248.08, 0, 391.81, 201.06, 393.11, 201.06);
	CGPathAddLineToPoint(path, NULL, 591.47, 201.06);
	CGPathAddCurveToPoint(path, NULL, 658.12, 201.06, 654.2, 278.92, 591.47, 278.92);
	CGPathAddLineToPoint(path, NULL, 391.87, 278.92);
	CGPathAddLineToPoint(path, NULL, 235.02, 480);
	CGPathAddLineToPoint(path, NULL, 165.89, 480);
	CGPathAddLineToPoint(path, NULL, 246.76, 278.92);
	CGPathAddLineToPoint(path, NULL, 97.95, 278.92);
	CGPathAddLineToPoint(path, NULL, 52.29, 331.96);
	CGPathAddLineToPoint(path, NULL, 0, 331.96);
	CGPathAddLineToPoint(path, NULL, 27.51, 240.07);
	CGPathAddLineToPoint(path, NULL, 1.32, 137.7);
	CGPathAddLineToPoint(path, NULL, 52.29, 137.7);
	CGPathAddLineToPoint(path, NULL, 99.3, 201.06);
	CGPathCloseSubpath(path);
	
	return path;
}
@end
