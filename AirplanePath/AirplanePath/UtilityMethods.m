//
//  UtilityMethods.m
//  AirplanePath
//
//  Created by Don Mag on 11/13/24.
//

#import "UtilityMethods.h"

@implementation UtilityMethods

+ (CGRect)scaleRect:(CGRect)sourceRect toFit:(CGRect)targetRect {
	CGFloat widthScale = targetRect.size.width / sourceRect.size.width;
	CGFloat heightScale = targetRect.size.height / sourceRect.size.height;
	CGFloat scaleFactor = MIN(widthScale, heightScale);
	CGFloat scaledWidth = sourceRect.size.width * scaleFactor;
	CGFloat scaledHeight = sourceRect.size.height * scaleFactor;
	CGFloat originX = targetRect.origin.x + (targetRect.size.width - scaledWidth) / 2.0;
	CGFloat originY = targetRect.origin.y + (targetRect.size.height - scaledHeight) / 2.0;
	return CGRectMake(originX, originY, scaledWidth, scaledHeight);;
}
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

// MARK: extrating CGPath(s) from PDF
void ExtractPathsFromContent(CGPDFScannerRef scanner, void *info);

void moveToCallback(CGPDFScannerRef scanner, void *info);
void lineToCallback(CGPDFScannerRef scanner, void *info);
void curveToCallback(CGPDFScannerRef scanner, void *info);
void closePathCallback(CGPDFScannerRef scanner, void *info);

CGMutablePathRef currentPath = NULL;

+ (NSArray<id> *)extractVectorPathsFromPDF:(NSURL *)pdfURL {
	PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:pdfURL];
	if (!pdfDocument) {
		NSLog(@"Unable to load PDF document.");
		return nil;
	}
	
	NSMutableArray<id> *vectorPaths = [NSMutableArray array];
	
	// Iterate through all pages in the PDF document
	for (NSInteger pageIndex = 0; pageIndex < pdfDocument.pageCount; pageIndex++) {
		PDFPage *pdfPage = [pdfDocument pageAtIndex:pageIndex];
		if (!pdfPage) continue;
		
		CGPDFPageRef cgPage = pdfPage.pageRef;
		if (!cgPage) continue;
		
		// Set up the scanner to process PDF content streams
		CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(cgPage);
		CGPDFOperatorTableRef operatorTable = CGPDFOperatorTableCreate();
		
		// Register custom callbacks for common operators for path extraction
		CGPDFOperatorTableSetCallback(operatorTable, "m", &moveToCallback);  // move to
		CGPDFOperatorTableSetCallback(operatorTable, "l", &lineToCallback);  // line to
		CGPDFOperatorTableSetCallback(operatorTable, "c", &curveToCallback); // curve to
		CGPDFOperatorTableSetCallback(operatorTable, "h", &closePathCallback); // close path
		
		CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, operatorTable, (__bridge void *)(vectorPaths));
		
		// Initialize a new path for the page
		currentPath = CGPathCreateMutable();
		
		// Scan the PDF content
		CGPDFScannerScan(scanner);
		
		// After scanning, add the current path to the paths array
		if (currentPath) {
			[vectorPaths addObject:(__bridge_transfer id)currentPath];
			currentPath = NULL;
		}
		
		// Clean up
		CGPDFScannerRelease(scanner);
		CGPDFContentStreamRelease(contentStream);
		CGPDFOperatorTableRelease(operatorTable);
	}
	
	return [vectorPaths copy];
}

// Callback for "move to" operator
void moveToCallback(CGPDFScannerRef scanner, void *info) {
	CGPDFReal x, y;
	if (CGPDFScannerPopNumber(scanner, &y) && CGPDFScannerPopNumber(scanner, &x)) {
		CGPathMoveToPoint(currentPath, NULL, x, y);
		//NSLog(@"CGPathMoveToPoint(currentPath, NULL, %f, %f);", x, y);
	}
}

// Callback for "line to" operator
void lineToCallback(CGPDFScannerRef scanner, void *info) {
	CGPDFReal x, y;
	if (CGPDFScannerPopNumber(scanner, &y) && CGPDFScannerPopNumber(scanner, &x)) {
		CGPathAddLineToPoint(currentPath, NULL, x, y);
		//NSLog(@"CGPathAddLineToPoint(currentPath, NULL, %f, %f);", x, y);
	}
}

// Callback for "curve to" operator
void curveToCallback(CGPDFScannerRef scanner, void *info) {
	CGPDFReal x1, y1, x2, y2, x3, y3;
	if (CGPDFScannerPopNumber(scanner, &y3) && CGPDFScannerPopNumber(scanner, &x3) &&
		CGPDFScannerPopNumber(scanner, &y2) && CGPDFScannerPopNumber(scanner, &x2) &&
		CGPDFScannerPopNumber(scanner, &y1) && CGPDFScannerPopNumber(scanner, &x1)) {
		CGPathAddCurveToPoint(currentPath, NULL, x1, y1, x2, y2, x3, y3);
		//NSLog(@"CGPathAddCurveToPoint(currentPath, NULL, %f, %f, %f, %f, %f, %f);", x1, y1, x2, y2, x3, y3);
	}
}

// Callback for "close path" operator
void closePathCallback(CGPDFScannerRef scanner, void *info) {
	CGPathCloseSubpath(currentPath);
	//NSLog(@"CGPathCloseSubpath(currentPath);");
}

// MARK: generating a scaled, rotated, colored NSImage from PDF

+ (NSImage *)imageFromPDFPage:(NSURL *)pdfURL pageNum:(NSInteger)pageNum targetSize:(CGSize)targetSize rotationRadians:(CGFloat)radians withColor:(NSColor *)withColor
{
	CFURLRef url = (CFURLRef)CFBridgingRetain(pdfURL);
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL (url);
	CGPDFPageRef pdfPage = CGPDFDocumentGetPage (pdf, pageNum);
	
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
