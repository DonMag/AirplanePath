//
//  FlightPath.m
//  AirplanePath
//
//  Created by Don Mag on 11/9/24.
//

#import "FlightPath.h"
#import "LineSegObj.h"

@implementation FlightPath

+ (NSMutableArray<NSValue *> *)sampleFlightPath {
	
	CGPoint pt1, pt2;
	
	// Create a mutable array to hold LineSeg structures
	NSMutableArray<NSValue *> *segmentsArray = [NSMutableArray array];
	
	// create some example line segments
	
	pt1 = CGPointMake( 20.0,  20.0);
	pt2 = CGPointMake( 60.0, 160.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(160.0, 280.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(340.0, 280.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(400.0, 100.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(250.0,  50.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(170.0, 150.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(240.0, 220.0);
	[segmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];

	return segmentsArray;
	
}

@end
