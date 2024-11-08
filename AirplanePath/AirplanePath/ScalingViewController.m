//
//  ScalingViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "ScalingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AirplaneView.h"
#import "CGPathTransformer.h"
#import "PDFExtractor.h"
#import "AirplaneCGPath.h"

@interface ScalingViewController ()

@end

@implementation ScalingViewController

CGRect scaleRectToFitTarget(CGRect sourceRect, CGRect targetRect) {
	// Calculate scale factors for width and height
	CGFloat widthScale = targetRect.size.width / sourceRect.size.width;
	CGFloat heightScale = targetRect.size.height / sourceRect.size.height;
	
	// Use the smaller scale factor to maintain aspect ratio
	CGFloat scaleFactor = MIN(widthScale, heightScale);
	
	// Calculate the new width and height with the chosen scale factor
	CGFloat newWidth = sourceRect.size.width * scaleFactor;
	CGFloat newHeight = sourceRect.size.height * scaleFactor;
	
	// Center the scaled rect within the target rect
	CGFloat newX = targetRect.origin.x + (targetRect.size.width - newWidth) / 2.0;
	CGFloat newY = targetRect.origin.y + (targetRect.size.height - newHeight) / 2.0;
	
	// Return the scaled and centered rect
	return CGRectMake(newX, newY, newWidth, newHeight);
}

// Structure to hold both the array and current path during traversal
typedef struct {
	NSMutableArray *array;
	CGMutablePathRef currentSubpath;
} PathSplitterContext;

// Helper function to add the current path to the array
void addCurrentPathToArray(NSMutableArray *array, CGMutablePathRef currentPath) {
	if (!CGPathIsEmpty(currentPath)) {
		[array addObject:(__bridge_transfer id)CGPathCreateMutableCopy(currentPath)];
		CGPathRelease(currentPath);
	}
}

// C function to handle each path element
void pathElementHandler(void *info, const CGPathElement *element) {
	PathSplitterContext *context = (PathSplitterContext *)info;
	NSMutableArray *array = context->array;
	CGMutablePathRef currentSubpath = context->currentSubpath;
	
	switch (element->type) {
		case kCGPathElementMoveToPoint:
			// Add the existing path to the array if it has content
			addCurrentPathToArray(array, currentSubpath);
			// Start a new subpath
			context->currentSubpath = CGPathCreateMutable();
			CGPathMoveToPoint(context->currentSubpath, NULL, element->points[0].x, element->points[0].y);
			break;
			
		case kCGPathElementAddLineToPoint:
			CGPathAddLineToPoint(context->currentSubpath, NULL, element->points[0].x, element->points[0].y);
			break;
			
		case kCGPathElementAddQuadCurveToPoint:
			CGPathAddQuadCurveToPoint(context->currentSubpath, NULL, element->points[0].x, element->points[0].y, element->points[1].x, element->points[1].y);
			break;
			
		case kCGPathElementAddCurveToPoint:
			CGPathAddCurveToPoint(context->currentSubpath, NULL, element->points[0].x, element->points[0].y, element->points[1].x, element->points[1].y, element->points[2].x, element->points[2].y);
			break;
			
		case kCGPathElementCloseSubpath:
			CGPathCloseSubpath(context->currentSubpath);
			// Add the closed subpath to the array and start a new subpath
			addCurrentPathToArray(array, context->currentSubpath);
			context->currentSubpath = CGPathCreateMutable();
			break;
	}
}

// Main function to split path into subpaths
NSArray *splitPathIntoSubpaths(CGPathRef path) {
	NSMutableArray *subpathsArray = [NSMutableArray array];
	PathSplitterContext context = {subpathsArray, CGPathCreateMutable()};
	
	// Apply pathElementHandler to each element in the path
	CGPathApply(path, &context, pathElementHandler);
	
	// Add the last subpath if it has remaining elements
	addCurrentPathToArray(subpathsArray, context.currentSubpath);
	
	return [subpathsArray copy];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	//self.view.layer.backgroundColor = [[NSColor systemYellowColor] CGColor];
	
}
- (void)mouseUp:(NSEvent *)event {
	//[self showEm];
	[self scaleFirst];
}
- (void)scaleFirst {

	NSArray<NSColor *> *layerColors = @[
		[NSColor redColor],
		[NSColor systemGreenColor],
		[NSColor blueColor],
		[NSColor yellowColor],
		[NSColor purpleColor],
	];
	
	NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];
	pdfURL = [[NSBundle mainBundle] URLForResource:@"zAW109" withExtension:@"pdf"];
	
	NSArray<id> *vectorPaths;

	CAShapeLayer *s;
	CGPathRef pth;
	NSRect pr;
	CGFloat fsz;
	CGRect scRect;
	CGPathRef spth;

	CGPathRef fullpth;
	NSArray *subpaths;
	NSInteger i;
	
	vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	pr = CGPathGetPathBoundingBox(pth);

	fsz = 400.0;
	scRect = scaleRectToFitTarget(pr, CGRectMake(0.0, 0.0, fsz, fsz));

	spth = [CGPathTransformer pathInTargetRect:scRect withPath:pth];

	subpaths = splitPathIntoSubpaths(spth);
	
	i = 0;
	
	for (id path in subpaths) {
		CGPathRef subpath = (__bridge CGPathRef)path;
		// Use subpath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		//v.layer.backgroundColor = NSColor.yellowColor.CGColor;
		v.frame = self.view.frame;
		[self.view addSubview:v];
		
		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		NSLog(@"sb: %@", [NSValue valueWithRect:CGPathGetPathBoundingBox(subpath)]);
		
		s.path = subpath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(20.0, 20.0);
		
		i++;
		
	}
	
	pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];

	vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	pr = CGPathGetPathBoundingBox(pth);
	
	fsz = 400.0;
	scRect = scaleRectToFitTarget(pr, CGRectMake(0.0, 0.0, fsz, fsz));
	
	spth = [CGPathTransformer pathInTargetRect:scRect withPath:pth];
	
	subpaths = splitPathIntoSubpaths(spth);
	
	i = 0;
	
	for (id path in subpaths) {
		CGPathRef subpath = (__bridge CGPathRef)path;
		// Use subpath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		//v.layer.backgroundColor = NSColor.yellowColor.CGColor;
		v.frame = self.view.frame;
		[self.view addSubview:v];
		
		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		NSLog(@"sb: %@", [NSValue valueWithRect:CGPathGetPathBoundingBox(subpath)]);
		
		s.path = subpath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(20.0, 20.0);
		
		i++;
		
	}

	return;
	
	s.path = spth;
	[self.view.layer addSublayer:s];
//	s.position = CGPointMake(100.0, 100.0);

}
- (void)showEm {

	NSArray<NSColor *> *layerColors = @[
		[NSColor redColor],
		[NSColor systemGreenColor],
		[NSColor blueColor],
		[NSColor yellowColor],
		[NSColor purpleColor],
	];
	
//bb: NSRect: {{19.326600000000003, 1.7585900000000001}, {89.738399999999999, 124.82041000000001}}

	CGRect fpr = CGRectMake(19.32, 1.76, 90.0, 125.0);
	CGFloat ffsz = 400.0;
	CGRect scfRect = scaleRectToFitTarget(fpr, CGRectMake(0.0, 0.0, ffsz, ffsz));

	NSArray *paths = [[AirplaneCGPath new] createArrayOfPaths];
	NSLog(@"count: %d", [paths count]);
	NSInteger i = 0;
	for (id path in paths) {
		CGPathRef cgPath = (__bridge CGPathRef)path;
		// Use cgPath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		//v.layer.backgroundColor = NSColor.yellowColor.CGColor;
		v.frame = self.view.frame;
		[self.view addSubview:v];
		
		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		NSLog(@"b: %@", [NSValue valueWithRect:CGPathGetPathBoundingBox(cgPath)]);
		
		//CGPathRef scPath = [CGPathTransformer pathInTargetRect:scfRect withPath:cgPath];
		
		
		s.path = cgPath;
		//s.path = scPath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(100.0, 200.0);
		
		i++;
	}
	
	//return;
	

	NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];
	pdfURL = [[NSBundle mainBundle] URLForResource:@"myairplane" withExtension:@"pdf"];
	pdfURL = [[NSBundle mainBundle] URLForResource:@"MyAW109" withExtension:@"pdf"];
	pdfURL = [[NSBundle mainBundle] URLForResource:@"zAW109" withExtension:@"pdf"];
	pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];
	
//	NSArray<NSBezierPath *> *bezvectorPaths = [PDFExtractor bezextractVectorPathsFromPDF:pdfURL];
//
//	NSLog(@"Extracted %lu vector paths.", (unsigned long)bezvectorPaths.count);

	NSArray<id> *vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	NSLog(@"Extracted %lu vector paths.", (unsigned long)vectorPaths.count);

	CGPathRef fullpth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	NSArray *subpaths = splitPathIntoSubpaths(fullpth);
	
	i = 0;

	for (id path in subpaths) {
		CGPathRef subpath = (__bridge CGPathRef)path;
		// Use subpath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		//v.layer.backgroundColor = NSColor.yellowColor.CGColor;
		v.frame = self.view.frame;
		[self.view addSubview:v];
		
		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		NSLog(@"sb: %@", [NSValue valueWithRect:CGPathGetPathBoundingBox(subpath)]);
		
		//CGPathRef scPath = [CGPathTransformer pathInTargetRect:scfRect withPath:cgPath];
		
		
		s.path = subpath;
		//s.path = scPath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(100.0, 300.0);
		
		i++;

	}

	return;
	
	CAShapeLayer *s = [CAShapeLayer new];
	s.strokeColor = NSColor.redColor.CGColor;
	s.fillColor = NSColor.redColor.CGColor;
	s.fillColor = NULL;
	s.lineWidth = 1.0;
	
//	s.path = [[bezvectorPaths objectAtIndex:12] CGPath];
//	CGRect rr = CGPathGetBoundingBox(s.path);
//	NSLog(@"%@", [NSValue valueWithRect:rr]);
	CGRect tr = CGRectMake(50, 50, 300, 300);
	CGPathRef pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	NSRect pr = CGPathGetPathBoundingBox(pth);
	NSRect ppr = CGPathGetBoundingBox(pth);
	NSLog(@"bb: %@", [NSValue valueWithRect:pr]);
	NSLog(@"pb: %@", [NSValue valueWithRect:ppr]);

	CGFloat fsz = 400.0;
	CGRect scRect = scaleRectToFitTarget(pr, CGRectMake(0.0, 0.0, fsz, fsz));
	
	
	pr.size.width *= 3.0;
	pr.size.height *= 3.0;
	pr.origin.x = 100.0;
	pr.origin.y = 100.0;
	
	CGPathRef spth = [CGPathTransformer pathInTargetRect:scRect withPath:pth];
	//s.path = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	
//	CGMutablePathRef hpth = [[AirplaneCGPath new] copterPath];
//	//hpth = [[AirplaneCGPath new] badcopterPath];
//	pr = CGPathGetPathBoundingBox(hpth);
//	pr.size.width *= 3.0;
//	pr.size.height *= 3.0;
//	pr.origin.x = 100.0;
//	pr.origin.y = 100.0;
//	
//	spth = [CGPathTransformer pathInTargetRect:scRect withPath:hpth];

	s.path = spth;
	[self.view.layer addSublayer:s];
	s.position = CGPointMake(100.0, 100.0);
	return;
	
	
	NSArray<NSColor *> *fillColors = @[
		[NSColor colorWithRed:1.00 green:0.75 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:0.75 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.75 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.75 green:1.00 blue:1.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0],
	];
	
	NSArray<NSColor *> *strokeColors = @[
		[NSColor redColor],
		[NSColor systemGreenColor],
		[NSColor blueColor],
		[NSColor systemYellowColor],
		
		[NSColor colorWithRed:0.50 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.50 blue:0.50 alpha:1.0],
		[NSColor colorWithRed:0.75 green:0.00 blue:0.00 alpha:1.0],
		[NSColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],
	];
	
	CGFloat sz = 40.0;
	CGFloat x = 20.0;

	CGFloat y = self.view.bounds.size.height - 50.0;
	
	for (int i = 0; i < 4; i++) {
		CGRect r = CGRectMake(x, y, sz, sz);
		// create AirplaneView and add to airplanesView
		AirplaneView *v = [[AirplaneView alloc] initWithFrame:r];
		[self.view addSubview:v];
		
		v.fillColor = [fillColors objectAtIndex:i % fillColors.count];
		v.strokeColor = [strokeColors objectAtIndex:i % strokeColors.count];
		v.strokeWidth = 1.0;

		v.fillColor = [fillColors objectAtIndex:i % fillColors.count];
		v.fillColor = [strokeColors objectAtIndex:i % strokeColors.count];
		v.strokeWidth = 1.0;
		
		x += sz * 0.5 + 8.0;
		y -= (sz + 20.0);
		sz *= 2.0;
	}
	
}

@end
