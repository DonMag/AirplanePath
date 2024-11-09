//
//  ImgVC.m
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import "ImgVC.h"
#import <QuartzCore/QuartzCore.h>
#import "LineSegObj.h"
#import "FlightPath.h"
#import "AirplaneImageView.h"

@interface ImgVC ()
{
	// size of airplane views (1:1 ratio)
	//	the airplane path shape will be scaled maintaining proportion
	//	and centered in the view
	CGFloat airplaneSize;
	
	NSColor *airplaneFillColor;
	NSColor *airplaneStrokeColor;
	CGFloat airplaneStrokeWidth;
	
	NSColor *linePathColor;
}
@end

@implementation ImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// values for this example
	//	adjust as desired
	airplaneSize = 80.0;
	airplaneStrokeWidth = 1.0;
	
	airplaneFillColor = [NSColor yellowColor];
	airplaneStrokeColor = [NSColor redColor];
	
	linePathColor = [NSColor lightGrayColor];
	
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	
	// Create and add a CAShapeLayer to airplanesView for the "line path"
	CAShapeLayer *cLine = [CAShapeLayer layer];
	cLine.fillColor = NULL;
	cLine.strokeColor = [linePathColor CGColor];
	[self.view.layer addSublayer:cLine];
	
	NSMutableArray<NSValue *> *lineSegmentsArray = [FlightPath sampleFlightPath];
	
	CGMutablePathRef linePath = CGPathCreateMutable();
	
	NSArray<NSColor *> *fillColors = @[
		[NSColor colorWithRed:1.00 green:0.75 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.75 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:1.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0],
	];
	
	NSArray<NSColor *> *strokeColors = @[
		[NSColor colorWithRed:0.50 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.50 alpha:1.0],
		[NSColor colorWithRed:0.75 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],
	];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
	img.template = YES;
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// add segment to line path
		CGPathMoveToPoint(linePath, NULL, lineSeg.pt1.x, lineSeg.pt1.y);
		CGPathAddLineToPoint(linePath, NULL, lineSeg.pt2.x, lineSeg.pt2.y);
		
		// rect for airplane
		//	put center AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (airplaneSize * 0.5), lineSeg.cp.y - (airplaneSize * 0.5), airplaneSize, airplaneSize);
		
		// create AirplaneView and add to airplanesView
		AirplaneImageView *v = [[AirplaneImageView alloc] initWithFrame:r];
		v.wantsLayer = YES;
		[v setImage:img];
		[v setContentTintColor:[strokeColors objectAtIndex:i % strokeColors.count]];
		[self.view addSubview:v];
		
		CGFloat d = (lineSeg.radians * (180.0 / M_PI));
		NSLog(@"d: %f", d);
		[v rotateByRadians:lineSeg.radians];
		
	}
	
	// set the line path
	cLine.path = linePath;
	
	CGPathRelease(linePath);

}

NSBezierPath *rotateBezierPath(NSBezierPath *path, CGFloat angleDegrees, NSPoint center) {
	// Convert the angle to radians
	CGFloat angleRadians = angleDegrees * M_PI / 180.0;
	
	// Create a rotation transform
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	// Move the path to the origin of rotation
	[transform translateXBy:center.x yBy:center.y];
	// Apply rotation
	[transform rotateByRadians:angleRadians];
	// Move the path back to its original position
	[transform translateXBy:-center.x yBy:-center.y];
	
	// Apply the transform to the path
	NSBezierPath *rotatedPath = [path copy];
	[rotatedPath transformUsingAffineTransform:transform];
	
	return rotatedPath;
}

- (void)viewDidAppear {
	[super viewDidAppear];
	
	NSImageView *v = (NSImageView *)self.view.subviews.lastObject;
	NSImage *i = v.image;
	NSLog(@"sz: %@", [NSValue valueWithSize:i.size]);

	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
	CGFloat f = 40;

	NSURL *nsurl = [NSURL fileURLWithPath:imagePath isDirectory:NO];
	CFURLRef url = (CFURLRef)CFBridgingRetain(nsurl);
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL (url);
	CGPDFPageRef page = CGPDFDocumentGetPage (pdf, 1);
	
	//NSImage *pdfImg = imageFromPDFPage(page, NSMakeSize(f, f), 30.0);
	NSImage *pdfImg = [self pimageFromPDFPage:page targetSize:NSMakeSize(f, f) rotationRadians:-M_PI * 0.2 withColor:NSColor.greenColor];
	
	NSLog(@"sz: %@", [NSValue valueWithSize:pdfImg.size]);
	NSLog(@"");
	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
	NSImage *aimg = [NSImage imageNamed:@"HAW109"];
	//img.template = YES;

	f = img.size.width * 4;
	
	NSImage *cImg = [self recolorImage:img withColor:NSColor.redColor];
	NSLog(@"sz: %@", [NSValue valueWithSize:cImg.size]);
	NSLog(@"");

	NSImage *dImg = [self recolorImage:img withColor:NSColor.systemBlueColor];
	NSLog(@"sz: %@", [NSValue valueWithSize:dImg.size]);
	NSLog(@"");
	
	//NSImage *s = [self scaleImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor];
	//NSImage *s = [self scaleAndRotateImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor rotation:45.0 withColor:NSColor.orangeColor];
	NSImage *s = [self scaleAndRotateImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor rotation:-30.0 bInOrNot:YES];
	NSLog(@"sz: %@", [NSValue valueWithSize:s.size]);
	NSLog(@"");
	s = [self scaleAndRotateImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor rotation:-30.0 bInOrNot:NO];
	NSLog(@"sz: %@", [NSValue valueWithSize:s.size]);
	NSLog(@"");
	f = 40.0;
	s = [self scaleAndRotateImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor rotation:-30.0 bInOrNot:YES];
	NSLog(@"sz: %@", [NSValue valueWithSize:s.size]);
	NSLog(@"");
	s = [self scaleAndRotateImage:img toSize:NSMakeSize(f, f) withBackgroundColor:NSColor.blueColor rotation:-30.0 bInOrNot:NO];
	NSLog(@"sz: %@", [NSValue valueWithSize:s.size]);
	NSLog(@"");

	v.image = s;
	
	
	/* Might need to create another CGPDFPageRef from the original and draw
	 into it with the correct colour. */
	

}

- (NSImage *)pimageFromPDFPage:(CGPDFPageRef)pdfPage targetSize:(CGSize)targetSize rotationRadians:(CGFloat)radians withColor:(NSColor *)withColor
{
	// Get the PDF page bounding box
	CGRect mediaBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
	
	// Scale to fit target size while maintaining aspect ratio
	CGFloat scaleX = targetSize.width / mediaBox.size.width;
	CGFloat scaleY = targetSize.height / mediaBox.size.height;
	CGFloat scale = MIN(scaleX, scaleY);
	
	// Calculate the rotated bounds size
	CGFloat rotatedWidth = fabs(mediaBox.size.width * cos(radians)) + fabs(mediaBox.size.height * sin(radians));
	CGFloat rotatedHeight = fabs(mediaBox.size.height * cos(radians)) + fabs(mediaBox.size.width * sin(radians));
	
	// Adjust target size to fit the rotated bounds, scaled appropriately
	CGSize adjustedSize = CGSizeMake(rotatedWidth * scale, rotatedHeight * scale);
	
	// Create a new NSImage with the adjusted size
	NSImage *image = [[NSImage alloc] initWithSize:adjustedSize];
	
	[image lockFocus]; // Start drawing into the NSImage context
	
	CGContextRef context = [NSGraphicsContext currentContext].CGContext;
	
	// Fill the context with desired color
	CGContextSetFillColorWithColor(context, withColor.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, adjustedSize.width, adjustedSize.height));
	
	// Save the initial state of the context
	CGContextSaveGState(context);
	
	// Translate to the center of the adjusted image area
	CGContextTranslateCTM(context, adjustedSize.width / 2, adjustedSize.height / 2);
	
	// Apply rotation
	CGContextRotateCTM(context, radians);
	
	// Apply scaling
	CGContextScaleCTM(context, scale, scale);
	
	// Translate back to align the PDF's origin for drawing
	CGContextTranslateCTM(context, -mediaBox.size.width / 2, -mediaBox.size.height / 2);
	
	// kCGBlendModeDestinationIn
	//	The destination image wherever both images are opaque, and transparent elsewhere.
	CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
	
	// Draw the PDF page into the context
	CGContextDrawPDFPage(context, pdfPage);
	
	// Restore the original context state
	CGContextRestoreGState(context);
	
	[image unlockFocus]; // Finish drawing into the NSImage context
	
	return image;
}
NSImage *imageFromPDFPage(CGPDFPageRef pdfPage, CGSize targetSize, CGFloat rotationAngle) {
	// Get the PDF page bounding box
	CGRect mediaBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
	
	// Scale to fit target size while maintaining aspect ratio
	CGFloat scaleX = targetSize.width / mediaBox.size.width;
	CGFloat scaleY = targetSize.height / mediaBox.size.height;
	CGFloat scale = MIN(scaleX, scaleY);
	
	// Calculate the rotated bounds size
	CGFloat radians = rotationAngle * M_PI / 180.0;
	CGFloat rotatedWidth = fabs(mediaBox.size.width * cos(radians)) + fabs(mediaBox.size.height * sin(radians));
	CGFloat rotatedHeight = fabs(mediaBox.size.height * cos(radians)) + fabs(mediaBox.size.width * sin(radians));
	
	// Adjust target size to fit the rotated bounds, scaled appropriately
	CGSize adjustedSize = CGSizeMake(rotatedWidth * scale, rotatedHeight * scale);
	
	// Create a new NSImage with the adjusted size
	NSImage *image = [[NSImage alloc] initWithSize:adjustedSize];
	
	[image lockFocus]; // Start drawing into the NSImage context
	
	CGContextRef context = [NSGraphicsContext currentContext].CGContext;
	
	CGColorRef rColor = NSColor.redColor.CGColor;
	CGContextSetFillColorWithColor(context, rColor);
	CGContextFillRect(context, CGRectMake(0, 0, adjustedSize.width, adjustedSize.height));

	// Fill the context with a transparent background
	//CGContextClearRect(context, CGRectMake(0, 0, adjustedSize.width, adjustedSize.height));
	
	// Save the initial state of the context
	CGContextSaveGState(context);
	
	// Translate to the center of the adjusted image area
	CGContextTranslateCTM(context, adjustedSize.width / 2, adjustedSize.height / 2);
	
	// Apply rotation
	CGContextRotateCTM(context, radians);
	
	// Apply scaling
	CGContextScaleCTM(context, scale, scale);
	
	// Translate back to align the PDF's origin for drawing
	CGContextTranslateCTM(context, -mediaBox.size.width / 2, -mediaBox.size.height / 2);
	
	CGContextSetBlendMode(context, kCGBlendModeDestinationIn);

	// Draw the PDF page into the context
	CGContextDrawPDFPage(context, pdfPage);
	
	// Restore the original context state
	CGContextRestoreGState(context);
	
	[image unlockFocus]; // Finish drawing into the NSImage context
	
	return image;
}

- (NSImage *)recolorImage:(NSImage *)image withColor:(NSColor *)newColor
{
	CGRect r = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	
	NSImage *tmpImage = [[NSImage alloc] initWithSize:r.size];
	
	[tmpImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[newColor setFill];
	NSRectFill(r);
	
	// Draw the scaled image centered with rotation applied
	[image drawInRect:r
			 fromRect:NSZeroRect
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[tmpImage unlockFocus];
	
	return tmpImage;
}

- (NSImage *)scaleAndRotateImage:(NSImage *)image
						  toSize:(NSSize)newSize
			 withBackgroundColor:(NSColor *)backgroundColor
						rotation:(CGFloat)rotationDegrees
						bInOrNot:(Boolean)bIn {
	
	NSCompositingOperation op = bIn ? NSCompositingOperationDestinationIn : NSCompositingOperationSourceOver;
	
	CGRect origRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
	CGRect rotRect = [self rotatedBoundsOfRect:origRect rot:rotationDegrees];
	
	NSImage *tmpImage = [[NSImage alloc] initWithSize:rotRect.size];
	
	[tmpImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[backgroundColor setFill];
	//NSRectFill(NSMakeRect(0, 0, rotRect.size.width, rotRect.size.height));
	
	// Calculate scale factor to maintain aspect ratio
	CGFloat scaleWidth = newSize.width / image.size.width;
	CGFloat scaleHeight = newSize.height / image.size.height;
	CGFloat scaleFactor = MIN(scaleWidth, scaleHeight);
	
	// Calculate the scaled image size
	NSSize scaledSize = NSMakeSize(image.size.width * scaleFactor, image.size.height * scaleFactor);
	
	// Calculate the origin point to center the scaled image
	NSPoint origin = NSMakePoint((rotRect.size.width - scaledSize.width) / 2.0,
								 (rotRect.size.height - scaledSize.height) / 2.0);
	
	// Apply transformations for rotation
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	// Move origin to the center for rotation
	[transform translateXBy:rotRect.size.width / 2.0 yBy:rotRect.size.height / 2.0];
	[transform rotateByDegrees:rotationDegrees];
	
	// Move back to top-left origin for drawing after rotation
	[transform translateXBy:-rotRect.size.width / 2.0 yBy:-rotRect.size.height / 2.0];
	[transform concat];

	// Fill the background color
	if (!bIn) {
		[NSColor.yellowColor setFill];
		NSRectFill(NSMakeRect(origin.x + 1, origin.y + 1, newSize.width - 2, newSize.height - 2));
	} else {
		[backgroundColor setFill];
		NSRectFill(NSMakeRect(origin.x + 1, origin.y + 1, newSize.width - 2, newSize.height - 2));
	}

	// Draw the scaled image centered with rotation applied
	[image drawInRect:NSMakeRect(origin.x, origin.y, scaledSize.width, scaledSize.height)
			 fromRect:NSZeroRect
	 operation:op
	 //operation:NSCompositingOperationSourceOver
	//		operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[tmpImage unlockFocus];

	NSImage *resImage = [[NSImage alloc] initWithSize:tmpImage.size];
	
	[resImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, tmpImage.size.width, tmpImage.size.height));
	
	[tmpImage drawInRect:NSMakeRect(0, 0, tmpImage.size.width, tmpImage.size.height)
			 fromRect:NSZeroRect
			   operation:op
//			operation:NSCompositingOperationSourceOver
//	 		operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[resImage unlockFocus];

	return resImage;
}


- (NSImage *)nscaleAndRotateImage:(NSImage *)image
						  toSize:(NSSize)newSize
			 withBackgroundColor:(NSColor *)backgroundColor
						rotation:(CGFloat)rotationDegrees {
	NSImage *resultImage = [[NSImage alloc] initWithSize:newSize];
	
	[resultImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, newSize.width, newSize.height));
	
	// Set up transformation for rotation and scaling
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	// Move origin to the center for rotation
	[transform translateXBy:newSize.width / 2.0 yBy:newSize.height / 2.0];
	[transform rotateByDegrees:rotationDegrees];
	
	// Scale down image by moving it back to its origin after rotation
	[transform translateXBy:-newSize.width / 2.0 yBy:-newSize.height / 2.0];
	[transform concat];
	
	// Draw the image centered with rotation applied
	[image drawInRect:NSMakeRect((newSize.width - image.size.width) / 2.0,
								 (newSize.height - image.size.height) / 2.0,
								 image.size.width,
								 image.size.height)
			 fromRect:NSZeroRect
			//operation:NSCompositingOperationSourceOver
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[resultImage unlockFocus];
	
	return resultImage;
}

- (NSImage *)ptscaleAndRotateImage:(NSImage *)image
						  toSize:(NSSize)newSize
			 withBackgroundColor:(NSColor *)backgroundColor
						rotation:(CGFloat)rotationDegrees {
	
	CGRect origRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
	CGRect rotRect = [self rotatedBoundsOfRect:origRect rot:rotationDegrees];
	
	NSImage *resultImage = [[NSImage alloc] initWithSize:rotRect.size];
	
	[resultImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, rotRect.size.width, rotRect.size.height));
	
	NSBezierPath *p = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, newSize.width, newSize.height)];
	
	// Calculate the center of the path's bounds for rotation
	NSPoint center = NSMakePoint(NSMidX(p.bounds), NSMidY(p.bounds));
	
	// Rotate the path by 45 degrees around its center
	NSBezierPath *rotatedPath = rotateBezierPath(p, rotationDegrees, center);

	
	[NSColor.greenColor setFill];
	[rotatedPath fill];

	// Calculate scale factor to maintain aspect ratio
	CGFloat scaleWidth = newSize.width / image.size.width;
	CGFloat scaleHeight = newSize.height / image.size.height;
	CGFloat scaleFactor = MIN(scaleWidth, scaleHeight);
	
	// Calculate the scaled image size
	NSSize scaledSize = NSMakeSize(image.size.width * scaleFactor, image.size.height * scaleFactor);
	
	// Calculate the origin point to center the scaled image
	NSPoint origin = NSMakePoint((rotRect.size.width - scaledSize.width) / 2.0,
								 (rotRect.size.height - scaledSize.height) / 2.0);
	
	// Apply transformations for rotation
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	// Move origin to the center for rotation
	[transform translateXBy:rotRect.size.width / 2.0 yBy:rotRect.size.height / 2.0];
	[transform rotateByDegrees:rotationDegrees];
	
	// Move back to top-left origin for drawing after rotation
	[transform translateXBy:-rotRect.size.width / 2.0 yBy:-rotRect.size.height / 2.0];
	[transform concat];
	
	// Draw the scaled image centered with rotation applied
	[image drawInRect:NSMakeRect(origin.x, origin.y, scaledSize.width, scaledSize.height)
			 fromRect:NSZeroRect
			//operation:NSCompositingOperationSourceOver
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[resultImage unlockFocus];
	
	return resultImage;
}
- (CGRect)rotatedBoundsOfRect:(CGRect)rect rot:(CGFloat)rotationDegrees {
	// Convert degrees to radians
	CGFloat radians = rotationDegrees * M_PI / 180.0;
	
	// Create a rotation transform
	CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
	
	// Apply the transform to the rectangle
	CGRect rotatedRect = CGRectApplyAffineTransform(rect, rotationTransform);
	
	// Get the bounding box of the rotated rectangle
	CGRect boundingBox = CGRectMake(0, 0, fabs(rotatedRect.size.width), fabs(rotatedRect.size.height));
	
	return boundingBox;
}
- (NSImage *)xscaleAndRotateImage:(NSImage *)image
						  toSize:(NSSize)newSize
			 withBackgroundColor:(NSColor *)backgroundColor
						rotation:(CGFloat)rotationDegrees
					   withColor:(NSColor *)color {
	NSImage *resultImage = [[NSImage alloc] initWithSize:newSize];
	
	[resultImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill the background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, newSize.width, newSize.height));
	
	// Set up transformation for rotation and scaling
	NSAffineTransform *transform = [NSAffineTransform transform];
	
	// Move origin to the center for rotation
	[transform translateXBy:newSize.width / 2.0 yBy:newSize.height / 2.0];
	[transform rotateByDegrees:rotationDegrees];
	
	// Scale down image by moving it back to its origin after rotation
	[transform translateXBy:-newSize.width / 2.0 yBy:-newSize.height / 2.0];
	[transform concat];
	
	// Fill background color
	[color setFill];
	NSRectFill(NSMakeRect(0, 0, newSize.width, newSize.height));
	
	// Draw the image centered with rotation applied
	//[image drawInRect:NSMakeRect((newSize.width - image.size.width) / 2.0,
	[image drawInRect:NSMakeRect(0.0, 0.0,
								 newSize.width,
								 newSize.height)
			 fromRect:NSMakeRect(0, 0, image.size.width, image.size.height)
			//operation:NSCompositingOperationSourceOver
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[resultImage unlockFocus];
	
	return resultImage;
}
- (NSImage *)scaleImage:(NSImage *)image toSize:(NSSize)newSize withBackgroundColor:(NSColor *)backgroundColor {
	NSImage *scaledImage = [[NSImage alloc] initWithSize:newSize];
	
	[scaledImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	// Fill background color
	[backgroundColor setFill];
	NSRectFill(NSMakeRect(0, 0, newSize.width, newSize.height));
	
	// Draw the original image scaled to the new size
	[image drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height)
			 fromRect:NSMakeRect(0, 0, image.size.width, image.size.height)
			//operation:NSCompositingOperationSourceOver
			//operation:NSCompositingOperationXOR
			operation:NSCompositingOperationDestinationIn
			 fraction:1.0];
	
	[scaledImage unlockFocus];
	
	return scaledImage;
}

- (void)rotateImageView:(NSImageView *)imageView byDegrees:(CGFloat)degrees {
	// Convert degrees to radians
	CGFloat radians = degrees; //* M_PI / 180.0;
	
	// Create a CGAffineTransform for rotation around the center of the view
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	// Translate to center, rotate, and translate back
	transform = CGAffineTransformTranslate(transform, imageView.bounds.size.width / 2, imageView.bounds.size.height / 2);
	transform = CGAffineTransformRotate(transform, radians);
	transform = CGAffineTransformTranslate(transform, -imageView.bounds.size.width / 2, -imageView.bounds.size.height / 2);
	
	// Apply the transform to the layer
	if (!imageView.wantsLayer) {
		imageView.wantsLayer = YES;
	}
	imageView.layer.affineTransform = transform;
}

@end
