//
//  UtilityMethods.m
//  AirplanePath
//
//  Created by Don Mag on 11/13/24.
//

#import "UtilityMethods.h"

@implementation UtilityMethods

+ (CGRect)boundsForRect:(CGRect)origR withRotation:(CGFloat)angleInRadians {
	// Calculate the cosine and sine of the rotation angle
	CGFloat cosAngle = fabs(cos(angleInRadians));
	CGFloat sinAngle = fabs(sin(angleInRadians));
	
	// Calculate the scaling factors to maintain the original bounding box size
	CGFloat scaleX = 1.0 / (cosAngle + sinAngle);
	CGFloat scaleY = 1.0 / (cosAngle + sinAngle);
	
	CGSize newSZ = CGSizeMake(origR.size.width * scaleX, origR.size.height * scaleY);
	CGRect newR = origR;
	newR.size = newSZ;
	newR.origin.x += (origR.size.width - newSZ.width) * 0.5;
	newR.origin.y += (origR.size.height - newSZ.height) * 0.5;
	
	return newR;
}

@end
