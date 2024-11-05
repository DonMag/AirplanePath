//
//  PDFExtractor.m
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import "PDFExtractor.h"

@implementation PDFExtractor
/*
+ (NSArray<NSBezierPath *> *)oextractVectorPathsFromPDF:(NSURL *)pdfURL {
	PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:pdfURL];
	if (!pdfDocument) {
		NSLog(@"Unable to load PDF document.");
		return nil;
	}
	
	NSMutableArray<NSBezierPath *> *vectorPaths = [NSMutableArray array];
	
	// Iterate through all pages in the PDF document
	for (NSInteger pageIndex = 0; pageIndex < pdfDocument.pageCount; pageIndex++) {
		PDFPage *pdfPage = [pdfDocument pageAtIndex:pageIndex];
		if (!pdfPage) continue;
		
		CGPDFPageRef cgPage = pdfPage.pageRef;
		if (!cgPage) continue;
		
		// Get the page bounds
		CGRect rect = [pdfPage boundsForBox:kPDFDisplayBoxMediaBox];
		
		// Create a bitmap graphics context to render the paths
		NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc]
									   initWithBitmapDataPlanes:NULL
									   pixelsWide:rect.size.width
									   pixelsHigh:rect.size.height
									   bitsPerSample:8
									   samplesPerPixel:4
									   hasAlpha:YES
									   isPlanar:NO
									   colorSpaceName:NSDeviceRGBColorSpace
									   bytesPerRow:0
									   bitsPerPixel:0];
		
		NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmapRep];
		[NSGraphicsContext saveGraphicsState];
		[NSGraphicsContext setCurrentContext:graphicsContext];
		
		CGContextRef context = [graphicsContext CGContext];
		
		// Flip the context to match PDF coordinate system (bottom-left origin)
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		// Render the PDF page into the context
		CGContextDrawPDFPage(context, cgPage);
		
		// Extract the path from the context and convert it to NSBezierPath
		CGPathRef cgPath = CGContextCopyPath(context);
		if (cgPath) {
			NSBezierPath *bezierPath = [NSBezierPath bezierPathWithCGPath:cgPath];
			[vectorPaths addObject:bezierPath];
			CGPathRelease(cgPath);
		}
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	return [vectorPaths copy];
}

void ExtractPathsFromContent(CGPDFScannerRef scanner, void *info);

+ (NSArray<NSBezierPath *> *)bezextractVectorPathsFromPDF:(NSURL *)pdfURL {
	PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:pdfURL];
	if (!pdfDocument) {
		NSLog(@"Unable to load PDF document.");
		return nil;
	}
	
	NSMutableArray<NSBezierPath *> *vectorPaths = [NSMutableArray array];
	
	// Iterate through all pages in the PDF document
	for (NSInteger pageIndex = 0; pageIndex < pdfDocument.pageCount; pageIndex++) {
		PDFPage *pdfPage = [pdfDocument pageAtIndex:pageIndex];
		if (!pdfPage) continue;
		
		CGPDFPageRef cgPage = pdfPage.pageRef;
		if (!cgPage) continue;
		
		// Set up the scanner to process PDF content streams
		CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(cgPage);
		CGPDFOperatorTableRef operatorTable = CGPDFOperatorTableCreate();
		
		// Register custom operator for path extraction
		CGPDFOperatorTableSetCallback(operatorTable, "m", &ExtractPathsFromContent);  // move to
		CGPDFOperatorTableSetCallback(operatorTable, "l", &ExtractPathsFromContent);  // line to
		CGPDFOperatorTableSetCallback(operatorTable, "c", &ExtractPathsFromContent);  // curve to
		CGPDFOperatorTableSetCallback(operatorTable, "h", &ExtractPathsFromContent);  // close path
		
		CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, operatorTable, (__bridge void *)(vectorPaths));
		
		// Scan the PDF content
		CGPDFScannerScan(scanner);
		
		// Clean up
		CGPDFScannerRelease(scanner);
		CGPDFContentStreamRelease(contentStream);
		CGPDFOperatorTableRelease(operatorTable);
	}
	
	return [vectorPaths copy];
}

// PDF operator callback to extract paths
void ExtractPathsFromContent(CGPDFScannerRef scanner, void *info) {
	NSMutableArray<NSBezierPath *> *pathsArray = (__bridge NSMutableArray<NSBezierPath *> *)info;
	
	// Here we would interpret and build an NSBezierPath from the PDF operations (m, l, c, h)
	// This example simply initializes a new path to demonstrate.
	NSBezierPath *newPath = [NSBezierPath bezierPath];
	
	// Placeholder: Append the path with the points as they are scanned from PDF content
	// Add actual implementation of path building based on PDF drawing operators
	
	[pathsArray addObject:newPath];
}
*/

void ExtractPathsFromContent(CGPDFScannerRef scanner, void *info);

+ (NSArray<NSBezierPath *> *)bezextractVectorPathsFromPDF:(NSURL *)pdfURL {
	PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:pdfURL];
	if (!pdfDocument) {
		NSLog(@"Unable to load PDF document.");
		return nil;
	}
	
	NSMutableArray<NSBezierPath *> *vectorPaths = [NSMutableArray array];
	
	// Iterate through all pages in the PDF document
	for (NSInteger pageIndex = 0; pageIndex < pdfDocument.pageCount; pageIndex++) {
		PDFPage *pdfPage = [pdfDocument pageAtIndex:pageIndex];
		if (!pdfPage) continue;
		
		CGPDFPageRef cgPage = pdfPage.pageRef;
		if (!cgPage) continue;
		
		// Set up the scanner to process PDF content streams
		CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(cgPage);
		CGPDFOperatorTableRef operatorTable = CGPDFOperatorTableCreate();
		
		// Register custom operator for path extraction
		CGPDFOperatorTableSetCallback(operatorTable, "m", &ExtractPathsFromContent);  // move to
		CGPDFOperatorTableSetCallback(operatorTable, "l", &ExtractPathsFromContent);  // line to
		CGPDFOperatorTableSetCallback(operatorTable, "c", &ExtractPathsFromContent);  // curve to
		CGPDFOperatorTableSetCallback(operatorTable, "h", &ExtractPathsFromContent);  // close path
		
		CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, operatorTable, (__bridge void *)(vectorPaths));
		
		// Scan the PDF content
		CGPDFScannerScan(scanner);
		
		// Clean up
		CGPDFScannerRelease(scanner);
		CGPDFContentStreamRelease(contentStream);
		CGPDFOperatorTableRelease(operatorTable);
	}
	
	return [vectorPaths copy];
}

// PDF operator callback to extract paths
void ExtractPathsFromContent(CGPDFScannerRef scanner, void *info) {
	NSMutableArray<NSBezierPath *> *pathsArray = (__bridge NSMutableArray<NSBezierPath *> *)info;
	
	// Here we would interpret and build an NSBezierPath from the PDF operations (m, l, c, h)
	// This example simply initializes a new path to demonstrate.
	NSBezierPath *newPath = [NSBezierPath bezierPath];
	
	// Placeholder: Append the path with the points as they are scanned from PDF content
	// Add actual implementation of path building based on PDF drawing operators
	
	[pathsArray addObject:newPath];
}

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
		
		// Register custom operator callbacks for path extraction
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
	}
}

// Callback for "line to" operator
void lineToCallback(CGPDFScannerRef scanner, void *info) {
	CGPDFReal x, y;
	if (CGPDFScannerPopNumber(scanner, &y) && CGPDFScannerPopNumber(scanner, &x)) {
		CGPathAddLineToPoint(currentPath, NULL, x, y);
	}
}

// Callback for "curve to" operator
void curveToCallback(CGPDFScannerRef scanner, void *info) {
	CGPDFReal x1, y1, x2, y2, x3, y3;
	if (CGPDFScannerPopNumber(scanner, &y3) && CGPDFScannerPopNumber(scanner, &x3) &&
		CGPDFScannerPopNumber(scanner, &y2) && CGPDFScannerPopNumber(scanner, &x2) &&
		CGPDFScannerPopNumber(scanner, &y1) && CGPDFScannerPopNumber(scanner, &x1)) {
		CGPathAddCurveToPoint(currentPath, NULL, x1, y1, x2, y2, x3, y3);
	}
}

// Callback for "close path" operator
void closePathCallback(CGPDFScannerRef scanner, void *info) {
	CGPathCloseSubpath(currentPath);
}

@end
