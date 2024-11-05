//
//  Airplane.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "AirplaneCGPath.h"

@implementation AirplaneCGPath

- (CGMutablePathRef)airplanePath {

	// Create a CGMutablePath
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, 55.81, 57.4);
	CGPathAddLineToPoint(path, NULL, 55.74, 60.57);
	CGPathAddLineToPoint(path, NULL, 23.39, 93.96);
	CGPathAddLineToPoint(path, NULL, 22.13, 92.92);
	CGPathAddLineToPoint(path, NULL, 22.67, 88.82);
	CGPathAddLineToPoint(path, NULL, 56.4, 54.65);
	CGPathAddLineToPoint(path, NULL, 56.28, 53.52);
	CGPathAddLineToPoint(path, NULL, 56.38, 42.22);
	CGPathAddLineToPoint(path, NULL, 55.94, 41.54);
	CGPathAddLineToPoint(path, NULL, 52.77, 41.47);
	CGPathAddLineToPoint(path, NULL, 19.37, 9.12);
	CGPathAddLineToPoint(path, NULL, 20.42, 7.86);
	CGPathAddLineToPoint(path, NULL, 24.52, 8.4);
	CGPathAddLineToPoint(path, NULL, 56.4, 39.88);
	CGPathAddLineToPoint(path, NULL, 56.53, 28.97);
	CGPathAddLineToPoint(path, NULL, 56.65, 22.01);
	CGPathAddLineToPoint(path, NULL, 56.73, 19.04);
	CGPathAddLineToPoint(path, NULL, 56.79, 17.31);
	CGPathAddLineToPoint(path, NULL, 56.82, 16.84);
	CGPathAddLineToPoint(path, NULL, 56.83, 16.58);
	CGPathAddCurveToPoint(path, NULL, 57.15, 12.13, 61.89, 9.4, 63.83, 9.34);
	CGPathAddLineToPoint(path, NULL, 63.95, 9.34);
	CGPathAddCurveToPoint(path, NULL, 65.8, 9.28, 70.72, 12.04, 71.05, 16.58);
	CGPathAddLineToPoint(path, NULL, 71.08, 17.14);
	CGPathAddLineToPoint(path, NULL, 71.12, 18.09);
	CGPathAddLineToPoint(path, NULL, 71.19, 20.13);
	CGPathAddLineToPoint(path, NULL, 71.29, 25.29);
	CGPathAddLineToPoint(path, NULL, 71.39, 31.57);
	CGPathAddLineToPoint(path, NULL, 71.47, 38.81);
	CGPathAddLineToPoint(path, NULL, 72.68, 38.03);
	CGPathAddLineToPoint(path, NULL, 72.75, 34.86);
	CGPathAddLineToPoint(path, NULL, 105.09, 1.47);
	CGPathAddLineToPoint(path, NULL, 106.35, 2.51);
	CGPathAddLineToPoint(path, NULL, 105.81, 6.61);
	CGPathAddLineToPoint(path, NULL, 71.5, 41.37);
	CGPathAddLineToPoint(path, NULL, 71.6, 52.43);
	CGPathAddLineToPoint(path, NULL, 72.55, 53.89);
	CGPathAddLineToPoint(path, NULL, 75.72, 53.96);
	CGPathAddLineToPoint(path, NULL, 109.11, 86.31);
	CGPathAddLineToPoint(path, NULL, 108.07, 87.57);
	CGPathAddLineToPoint(path, NULL, 103.96, 87.03);
	CGPathAddLineToPoint(path, NULL, 71.45, 54.93);
	CGPathAddLineToPoint(path, NULL, 71.01, 58.96);
	CGPathAddLineToPoint(path, NULL, 70.81, 60.63);
	CGPathAddLineToPoint(path, NULL, 70.6, 62.09);
	CGPathAddLineToPoint(path, NULL, 69.48, 69.71);
	CGPathAddLineToPoint(path, NULL, 67.65, 81.9);
	CGPathAddLineToPoint(path, NULL, 67.36, 87.89);
	CGPathAddLineToPoint(path, NULL, 66.82, 100.79);
	CGPathAddLineToPoint(path, NULL, 77.09, 102.04);
	CGPathAddLineToPoint(path, NULL, 77.36, 104.41);
	CGPathAddLineToPoint(path, NULL, 66.21, 105.67);
	CGPathAddLineToPoint(path, NULL, 65.68, 116.88);
	CGPathAddLineToPoint(path, NULL, 68.95, 117.95);
	CGPathAddLineToPoint(path, NULL, 68.95, 110.45);
	CGPathAddLineToPoint(path, NULL, 69.45, 110.45);
	CGPathAddLineToPoint(path, NULL, 69.45, 125.95);
	CGPathAddLineToPoint(path, NULL, 68.95, 125.95);
	CGPathAddLineToPoint(path, NULL, 68.95, 118.95);
	CGPathAddLineToPoint(path, NULL, 65.05, 120.05);
	CGPathAddLineToPoint(path, NULL, 64.83, 121.58);
	CGPathAddLineToPoint(path, NULL, 64.45, 123.45);
	CGPathAddLineToPoint(path, NULL, 64.22, 124.16);
	CGPathAddLineToPoint(path, NULL, 63.59, 123.09);
	CGPathAddCurveToPoint(path, NULL, 63.36, 122.62, 63.13, 122.02, 63.01, 121.37);
	CGPathAddLineToPoint(path, NULL, 62.2, 116.88);
	CGPathAddLineToPoint(path, NULL, 61.68, 105.67);
	CGPathAddLineToPoint(path, NULL, 50.52, 104.41);
	CGPathAddLineToPoint(path, NULL, 50.79, 102.04);
	CGPathAddLineToPoint(path, NULL, 61.07, 100.79);
	CGPathAddLineToPoint(path, NULL, 60.43, 85.86);
	CGPathAddLineToPoint(path, NULL, 60.23, 81.87);
	CGPathAddLineToPoint(path, NULL, 57.94, 66.58);
	CGPathAddLineToPoint(path, NULL, 57.19, 61.5);
	CGPathAddLineToPoint(path, NULL, 57.06, 60.53);
	CGPathAddLineToPoint(path, NULL, 56.8, 58.29);
	CGPathAddLineToPoint(path, NULL, 56.64, 56.86);
	CGPathAddLineToPoint(path, NULL, 55.81, 57.4);
	
	// Close the path
	CGPathCloseSubpath(path);
	
	// Flip and rotate the path
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformScale(transform, -1.0, 1.0);
	transform = CGAffineTransformRotate(transform, M_PI * 1.5);
	
	// Create a new path by applying the transformation to the original path
	CGMutablePathRef transformedPath = CGPathCreateMutableCopyByTransformingPath(path, &transform);
	CGPathRelease(path);

	return transformedPath;
	
}

- (CGMutablePathRef)mairplanePath {
	
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
