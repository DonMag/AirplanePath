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

- (CGMutablePathRef)copterPath {
	CGMutablePathRef currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 66.1050, -117.2930);
	CGPathAddLineToPoint(currentPath, NULL, 68.1990, -117.9690);
	CGPathAddLineToPoint(currentPath, NULL, 68.2460, -119.0550);
	CGPathAddLineToPoint(currentPath, NULL, 65.0310, -119.9570);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 66.1050, -117.2930);
	CGPathMoveToPoint(currentPath, NULL, 65.3120, -42.7380);
	CGPathAddLineToPoint(currentPath, NULL, 72.6330, -37.9840);
	CGPathAddLineToPoint(currentPath, NULL, 72.7030, -34.8120);
	CGPathAddLineToPoint(currentPath, NULL, 105.0470, -1.4220);
	CGPathAddLineToPoint(currentPath, NULL, 106.3050, -2.4650);
	CGPathAddLineToPoint(currentPath, NULL, 105.7700, -6.5660);
	CGPathAddLineToPoint(currentPath, NULL, 67.6600, -45.1640);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 65.3120, -42.7380);
	CGPathMoveToPoint(currentPath, NULL, 60.6450, -48.8090);
	CGPathAddLineToPoint(currentPath, NULL, 55.8870, -41.4920);
	CGPathAddLineToPoint(currentPath, NULL, 52.7190, -41.4220);
	CGPathAddLineToPoint(currentPath, NULL, 19.3280, -9.0780);
	CGPathAddLineToPoint(currentPath, NULL, 20.3710, -7.8160);
	CGPathAddLineToPoint(currentPath, NULL, 24.4730, -8.3550);
	CGPathAddLineToPoint(currentPath, NULL, 63.0700, -46.4610);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 60.6450, -48.8090);
	CGPathMoveToPoint(currentPath, NULL, 63.0780, -52.6020);
	CGPathAddLineToPoint(currentPath, NULL, 55.7620, -57.3550);
	CGPathAddLineToPoint(currentPath, NULL, 55.6910, -60.5230);
	CGPathAddLineToPoint(currentPath, NULL, 23.3440, -93.9180);
	CGPathAddLineToPoint(currentPath, NULL, 22.0860, -92.8710);
	CGPathAddLineToPoint(currentPath, NULL, 22.6250, -88.7700);
	CGPathAddLineToPoint(currentPath, NULL, 60.7300, -50.1720);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 63.0780, -52.6020);
	CGPathMoveToPoint(currentPath, NULL, 67.7500, -46.5270);
	CGPathAddLineToPoint(currentPath, NULL, 72.5040, -53.8440);
	CGPathAddLineToPoint(currentPath, NULL, 75.6720, -53.9140);
	CGPathAddLineToPoint(currentPath, NULL, 109.0660, -86.2580);
	CGPathAddLineToPoint(currentPath, NULL, 108.0200, -87.5200);
	CGPathAddLineToPoint(currentPath, NULL, 103.9180, -86.9800);
	CGPathAddLineToPoint(currentPath, NULL, 65.3200, -48.8750);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 67.7500, -46.5270);
	CGPathMoveToPoint(currentPath, NULL, 68.4300, -110.3050);
	CGPathAddLineToPoint(currentPath, NULL, 68.4300, -126.2420);
	CGPathMoveToPoint(currentPath, NULL, 64.1640, -124.1020);
	CGPathAddCurveToPoint(currentPath, NULL, 64.0590, -123.9570, 63.2230, -122.7700, 62.9650, -121.3240);
	CGPathAddCurveToPoint(currentPath, NULL, 62.6880, -119.7810, 62.1520, -116.8360, 62.1520, -116.8360);
	CGPathAddLineToPoint(currentPath, NULL, 61.6290, -105.6250);
	CGPathAddLineToPoint(currentPath, NULL, 50.4730, -104.3590);
	CGPathAddLineToPoint(currentPath, NULL, 50.7420, -101.9960);
	CGPathAddLineToPoint(currentPath, NULL, 61.0200, -100.7420);
	CGPathAddCurveToPoint(currentPath, NULL, 61.0200, -100.7420, 60.4840, -87.8630, 60.4020, -86.1880);
	CGPathAddCurveToPoint(currentPath, NULL, 60.3200, -84.5120, 60.1840, -81.8440, 60.1840, -81.8440);
	CGPathAddCurveToPoint(currentPath, NULL, 60.1840, -81.8440, 57.2770, -62.6170, 57.0040, -60.4020);
	CGPathAddCurveToPoint(currentPath, NULL, 56.7340, -58.1880, 56.2300, -53.4690, 56.2300, -53.4690);
	CGPathAddCurveToPoint(currentPath, NULL, 56.2300, -53.4690, 56.4570, -21.0860, 56.7850, -16.5350);
	CGPathAddCurveToPoint(currentPath, NULL, 57.1130, -11.9920, 62.0430, -9.2380, 63.8980, -9.2970);
	CGPathAddCurveToPoint(currentPath, NULL, 65.7580, -9.2380, 70.6760, -11.9920, 71.0040, -16.5350);
	CGPathAddCurveToPoint(currentPath, NULL, 71.3320, -21.0860, 71.5590, -53.4690, 71.5590, -53.4690);
	CGPathAddCurveToPoint(currentPath, NULL, 71.5590, -53.4690, 71.0550, -58.1880, 70.7850, -60.4020);
	CGPathAddCurveToPoint(currentPath, NULL, 70.5120, -62.6170, 67.6050, -81.8440, 67.6050, -81.8440);
	CGPathAddCurveToPoint(currentPath, NULL, 67.6050, -81.8440, 67.4690, -84.5120, 67.3870, -86.1880);
	CGPathAddCurveToPoint(currentPath, NULL, 67.3050, -87.8630, 66.7700, -100.7420, 66.7700, -100.7420);
	CGPathAddLineToPoint(currentPath, NULL, 77.0470, -101.9960);
	CGPathAddLineToPoint(currentPath, NULL, 77.3160, -104.3590);
	CGPathAddLineToPoint(currentPath, NULL, 66.1600, -105.6250);
	CGPathAddLineToPoint(currentPath, NULL, 65.6370, -116.8360);
	CGPathAddCurveToPoint(currentPath, NULL, 65.6370, -116.8360, 65.1020, -119.7810, 64.8240, -121.3240);
	CGPathAddCurveToPoint(currentPath, NULL, 64.5510, -122.8630, 64.1720, -124.1170, 64.1720, -124.1170);
	CGPathCloseSubpath(currentPath);
	
	return currentPath;
}

- (CGMutablePathRef)badcopterPath {
	CGMutablePathRef currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 66.1046, 10.7071);
	CGPathAddLineToPoint(currentPath, NULL, 68.1990, 10.0307);
	CGPathAddLineToPoint(currentPath, NULL, 68.2449, 8.9437);
	CGPathAddLineToPoint(currentPath, NULL, 65.0297, 8.0430);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 65.3144, 85.2626);
	CGPathAddLineToPoint(currentPath, NULL, 72.6310, 90.0170);

//	stack underflow.

	CGPathAddLineToPoint(currentPath, NULL, 72.7019, 93.1868);
	CGPathAddLineToPoint(currentPath, NULL, 105.0460, 126.5790);
	CGPathAddLineToPoint(currentPath, NULL, 106.3060, 125.5340);
	CGPathAddLineToPoint(currentPath, NULL, 105.7680, 121.4320);
	CGPathAddLineToPoint(currentPath, NULL, 67.6611, 82.8345);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 60.6430, 79.1909);
	CGPathAddLineToPoint(currentPath, NULL, 55.8886, 86.5075);
	CGPathAddLineToPoint(currentPath, NULL, 52.7188, 86.5784);
	CGPathAddLineToPoint(currentPath, NULL, 19.3266, 118.9220);
	CGPathAddLineToPoint(currentPath, NULL, 20.3720, 120.1820);
	CGPathAddLineToPoint(currentPath, NULL, 24.4732, 119.6440);
	CGPathAddLineToPoint(currentPath, NULL, 63.0712, 81.5376);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 63.0770, 75.4002);
	CGPathAddLineToPoint(currentPath, NULL, 55.7604, 70.6458);
	CGPathAddLineToPoint(currentPath, NULL, 55.6896, 67.4760);
	CGPathAddLineToPoint(currentPath, NULL, 23.3457, 34.0837);
	CGPathAddLineToPoint(currentPath, NULL, 22.0858, 35.1291);
	CGPathAddLineToPoint(currentPath, NULL, 22.6234, 39.2304);
	CGPathAddLineToPoint(currentPath, NULL, 60.7303, 77.8283);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 67.7484, 81.4719);
	CGPathAddLineToPoint(currentPath, NULL, 72.5028, 74.1553);
	CGPathAddLineToPoint(currentPath, NULL, 75.6726, 74.0845);
	CGPathAddLineToPoint(currentPath, NULL, 109.0650, 41.7406);
	CGPathAddLineToPoint(currentPath, NULL, 108.0190, 40.4807);
	CGPathAddLineToPoint(currentPath, NULL, 103.9180, 41.0183);
	CGPathAddLineToPoint(currentPath, NULL, 65.3203, 79.1252);
	CGPathCloseSubpath(currentPath);
	CGPathMoveToPoint(currentPath, NULL, 68.4315, 17.6935);
	CGPathAddLineToPoint(currentPath, NULL, 68.4315, 1.7586);
	CGPathMoveToPoint(currentPath, NULL, 64.1624, 3.8982);
	CGPathAddCurveToPoint(currentPath, NULL, 64.0589, 4.0414, 63.2227, 5.2324, 62.9637, 6.6773);
	CGPathAddLineToPoint(currentPath, NULL, 61.6283, 22.3735);
	CGPathAddLineToPoint(currentPath, NULL, 50.4743, 23.6398);
	CGPathAddLineToPoint(currentPath, NULL, 50.7435, 26.0040);
	CGPathAddLineToPoint(currentPath, NULL, 61.0203, 27.2591);
	CGPathAddCurveToPoint(currentPath, NULL, 57.1122, 116.0090, 62.0422, 118.7630, 63.8992, 118.7020);
	CGPathAddCurveToPoint(currentPath, NULL, 65.7563, 118.7630, 70.6770, 116.0090, 71.0037, 111.4630);
	CGPathAddLineToPoint(currentPath, NULL, 77.0458, 26.0040);
	CGPathAddLineToPoint(currentPath, NULL, 77.3150, 23.6398);
	CGPathAddLineToPoint(currentPath, NULL, 66.1609, 22.3735);
	CGPathAddLineToPoint(currentPath, NULL, 65.6360, 11.1644);
	CGPathCloseSubpath(currentPath);
	
	return currentPath;
}

- (NSMutableArray *)createArrayOfPaths {
	// Initialize an array to hold CGMutablePathRef objects
	NSMutableArray *pathsArray = [NSMutableArray array];
	
	CGMutablePathRef currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 66.1050, -117.2930);
	CGPathAddLineToPoint(currentPath, NULL, 68.1990, -117.9690);
	CGPathAddLineToPoint(currentPath, NULL, 68.2460, -119.0550);
	CGPathAddLineToPoint(currentPath, NULL, 65.0310, -119.9570);
	CGPathCloseSubpath(currentPath);
	
	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 66.1050, -117.2930);
	CGPathMoveToPoint(currentPath, NULL, 65.3120, -42.7380);
	CGPathAddLineToPoint(currentPath, NULL, 72.6330, -37.9840);
	CGPathAddLineToPoint(currentPath, NULL, 72.7030, -34.8120);
	CGPathAddLineToPoint(currentPath, NULL, 105.0470, -1.4220);
	CGPathAddLineToPoint(currentPath, NULL, 106.3050, -2.4650);
	CGPathAddLineToPoint(currentPath, NULL, 105.7700, -6.5660);
	CGPathAddLineToPoint(currentPath, NULL, 67.6600, -45.1640);
	CGPathCloseSubpath(currentPath);

	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 65.3120, -42.7380);
	CGPathMoveToPoint(currentPath, NULL, 60.6450, -48.8090);
	CGPathAddLineToPoint(currentPath, NULL, 55.8870, -41.4920);
	CGPathAddLineToPoint(currentPath, NULL, 52.7190, -41.4220);
	CGPathAddLineToPoint(currentPath, NULL, 19.3280, -9.0780);
	CGPathAddLineToPoint(currentPath, NULL, 20.3710, -7.8160);
	CGPathAddLineToPoint(currentPath, NULL, 24.4730, -8.3550);
	CGPathAddLineToPoint(currentPath, NULL, 63.0700, -46.4610);
	CGPathCloseSubpath(currentPath);

	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 60.6450, -48.8090);
	CGPathMoveToPoint(currentPath, NULL, 63.0780, -52.6020);
	CGPathAddLineToPoint(currentPath, NULL, 55.7620, -57.3550);
	CGPathAddLineToPoint(currentPath, NULL, 55.6910, -60.5230);
	CGPathAddLineToPoint(currentPath, NULL, 23.3440, -93.9180);
	CGPathAddLineToPoint(currentPath, NULL, 22.0860, -92.8710);
	CGPathAddLineToPoint(currentPath, NULL, 22.6250, -88.7700);
	CGPathAddLineToPoint(currentPath, NULL, 60.7300, -50.1720);
	CGPathCloseSubpath(currentPath);
	
	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 63.0780, -52.6020);
	CGPathMoveToPoint(currentPath, NULL, 67.7500, -46.5270);
	CGPathAddLineToPoint(currentPath, NULL, 72.5040, -53.8440);
	CGPathAddLineToPoint(currentPath, NULL, 75.6720, -53.9140);
	CGPathAddLineToPoint(currentPath, NULL, 109.0660, -86.2580);
	CGPathAddLineToPoint(currentPath, NULL, 108.0200, -87.5200);
	CGPathAddLineToPoint(currentPath, NULL, 103.9180, -86.9800);
	CGPathAddLineToPoint(currentPath, NULL, 65.3200, -48.8750);
	CGPathCloseSubpath(currentPath);

	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	currentPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(currentPath, NULL, 67.7500, -46.5270);
	CGPathMoveToPoint(currentPath, NULL, 68.4300, -110.3050);
	CGPathAddLineToPoint(currentPath, NULL, 68.4300, -126.2420);
	CGPathMoveToPoint(currentPath, NULL, 64.1640, -124.1020);
	CGPathAddCurveToPoint(currentPath, NULL, 64.0590, -123.9570, 63.2230, -122.7700, 62.9650, -121.3240);
	CGPathAddCurveToPoint(currentPath, NULL, 62.6880, -119.7810, 62.1520, -116.8360, 62.1520, -116.8360);
	CGPathAddLineToPoint(currentPath, NULL, 61.6290, -105.6250);
	CGPathAddLineToPoint(currentPath, NULL, 50.4730, -104.3590);
	CGPathAddLineToPoint(currentPath, NULL, 50.7420, -101.9960);
	CGPathAddLineToPoint(currentPath, NULL, 61.0200, -100.7420);
	CGPathAddCurveToPoint(currentPath, NULL, 61.0200, -100.7420, 60.4840, -87.8630, 60.4020, -86.1880);
	CGPathAddCurveToPoint(currentPath, NULL, 60.3200, -84.5120, 60.1840, -81.8440, 60.1840, -81.8440);
	CGPathAddCurveToPoint(currentPath, NULL, 60.1840, -81.8440, 57.2770, -62.6170, 57.0040, -60.4020);
	CGPathAddCurveToPoint(currentPath, NULL, 56.7340, -58.1880, 56.2300, -53.4690, 56.2300, -53.4690);
	CGPathAddCurveToPoint(currentPath, NULL, 56.2300, -53.4690, 56.4570, -21.0860, 56.7850, -16.5350);
	CGPathAddCurveToPoint(currentPath, NULL, 57.1130, -11.9920, 62.0430, -9.2380, 63.8980, -9.2970);
	CGPathAddCurveToPoint(currentPath, NULL, 65.7580, -9.2380, 70.6760, -11.9920, 71.0040, -16.5350);
	CGPathAddCurveToPoint(currentPath, NULL, 71.3320, -21.0860, 71.5590, -53.4690, 71.5590, -53.4690);
	CGPathAddCurveToPoint(currentPath, NULL, 71.5590, -53.4690, 71.0550, -58.1880, 70.7850, -60.4020);
	CGPathAddCurveToPoint(currentPath, NULL, 70.5120, -62.6170, 67.6050, -81.8440, 67.6050, -81.8440);
	CGPathAddCurveToPoint(currentPath, NULL, 67.6050, -81.8440, 67.4690, -84.5120, 67.3870, -86.1880);
	CGPathAddCurveToPoint(currentPath, NULL, 67.3050, -87.8630, 66.7700, -100.7420, 66.7700, -100.7420);
	CGPathAddLineToPoint(currentPath, NULL, 77.0470, -101.9960);
	CGPathAddLineToPoint(currentPath, NULL, 77.3160, -104.3590);
	CGPathAddLineToPoint(currentPath, NULL, 66.1600, -105.6250);
	CGPathAddLineToPoint(currentPath, NULL, 65.6370, -116.8360);
	CGPathAddCurveToPoint(currentPath, NULL, 65.6370, -116.8360, 65.1020, -119.7810, 64.8240, -121.3240);
	CGPathAddCurveToPoint(currentPath, NULL, 64.5510, -122.8630, 64.1720, -124.1170, 64.1720, -124.1170);
	CGPathCloseSubpath(currentPath);

	[pathsArray addObject:(__bridge id)currentPath];
	CGPathRelease(currentPath);
	
	return pathsArray;
}
@end
