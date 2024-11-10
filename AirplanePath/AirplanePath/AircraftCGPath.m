//
//  Airplane.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "AircraftCGPath.h"

@implementation AircraftCGPath

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

@end
