//
//  ScalingViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "ScalingViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "CGPathTransformer.h"
#import "PDFExtractor.h"
#import "AirplaneCGPath.h"

@interface ScalingViewController ()

@end

@implementation ScalingViewController

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
	
}
- (void)mouseUp:(NSEvent *)event {
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
	scRect = CGRectMake(0.0, 0.0, fsz, fsz);

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
	scRect = CGRectMake(0.0, 0.0, fsz, fsz);

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

}

@end
