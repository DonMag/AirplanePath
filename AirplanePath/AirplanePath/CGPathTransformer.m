//
//  CGPathTransformer.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "CGPathTransformer.h"

@implementation CGPathTransformer

+ (CGMutablePathRef)pathInTargetRect:(CGRect)targetRect rotatedBy:(CGFloat)radian withPath:(CGMutablePathRef)path {
	if (!path) return NULL;
	
	// Rotate the path
	CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(radian);
	CGMutablePathRef rotatedPath = CGPathCreateMutableCopyByTransformingPath(path, &rotateTransform);
	if (!rotatedPath) return NULL;
	
	// Get the current bounding rect of the rotated path
	CGRect boundingBox = CGPathGetBoundingBox(rotatedPath);
	
	// Translate the path to origin
	CGAffineTransform translateToOrigin = CGAffineTransformMakeTranslation(-boundingBox.origin.x, -boundingBox.origin.y);
	CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(rotatedPath, &translateToOrigin);
	CGPathRelease(rotatedPath); // Release the rotated path
	
	if (!translatedPath) return NULL;
	
	// Scale the path to fit the target rectangle
	CGAffineTransform scaleTransform = CGAffineTransformMakeScale(targetRect.size.width / boundingBox.size.width,
																  targetRect.size.height / boundingBox.size.height);
	CGMutablePathRef scaledPath = CGPathCreateMutableCopyByTransformingPath(translatedPath, &scaleTransform);
	CGPathRelease(translatedPath); // Release the translated path
	
	if (!scaledPath) return NULL;
	
	// Translate the path to the target rectangle's origin
	CGAffineTransform translateToTarget = CGAffineTransformMakeTranslation(targetRect.origin.x, targetRect.origin.y);
	CGMutablePathRef finalPath = CGPathCreateMutableCopyByTransformingPath(scaledPath, &translateToTarget);
	CGPathRelease(scaledPath); // Release the scaled path
	
	return finalPath;
}

+ (CGMutablePathRef)pathInTargetRect:(CGRect)targetRect withPath:(CGMutablePathRef)path {
	if (!path) return NULL;
	
	// Get the current bounding rect of the path
	CGRect boundingBox = CGPathGetBoundingBox(path);
	
	// Translate the path to origin
	CGAffineTransform translateToOrigin = CGAffineTransformMakeTranslation(-boundingBox.origin.x, -boundingBox.origin.y);
	CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(path, &translateToOrigin);
	
	if (!translatedPath) return NULL;
	
	// Scale the path to fit the target rectangle
	CGAffineTransform scaleTransform = CGAffineTransformMakeScale(targetRect.size.width / boundingBox.size.width,
																  targetRect.size.height / boundingBox.size.height);
	CGMutablePathRef scaledPath = CGPathCreateMutableCopyByTransformingPath(translatedPath, &scaleTransform);
	CGPathRelease(translatedPath); // Release the translated path
	
	if (!scaledPath) return NULL;
	
	// Translate the path to the target rectangle's origin
	CGAffineTransform translateToTarget = CGAffineTransformMakeTranslation(targetRect.origin.x, targetRect.origin.y);
	CGMutablePathRef finalPath = CGPathCreateMutableCopyByTransformingPath(scaledPath, &translateToTarget);
	CGPathRelease(scaledPath); // Release the scaled path
	
	return finalPath;
}

@end
