//
//  ScalingViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "PDFExtractViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "CGPathTransformer.h"
#import "PDFExtractor.h"
#import "AircraftCGPath.h"

@interface PDFExtractViewController ()
{
	NSView *goodView;
	NSView *badView;
}
@end

@implementation PDFExtractViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	
}
- (void)mouseUp:(NSEvent *)event {
	if (self.view.subviews.count < 2) {
		[self scaleFirst];
	}
	goodView.hidden = !goodView.hidden;
	badView.hidden = !goodView.hidden;
}
- (void)scaleFirst {

	NSArray<NSColor *> *layerColors = @[
		[NSColor redColor],
		[NSColor systemGreenColor],
		[NSColor blueColor],
		[NSColor yellowColor],
		[NSColor purpleColor],
	];
	
	NSURL *pdfURL;
	
	NSArray<id> *vectorPaths;

	CGPathRef pth;
	NSRect pr;
	CGFloat targSize;
	CGRect targRect;
	CGRect scaledRect;
	CGPathRef spth;

	NSArray *subpaths;
	NSInteger i;
	
	goodView = [NSView new];
	badView = [NSView new];
	goodView.wantsLayer = YES;
	badView.wantsLayer = YES;
	
	goodView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:goodView];

	badView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:badView];
	
	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[

		[goodView.topAnchor constraintEqualToAnchor:g.topAnchor constant:0.0],
		[goodView.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:0.0],
		[goodView.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:0.0],
		[goodView.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:0.0],
		
		[badView.topAnchor constraintEqualToAnchor:g.topAnchor constant:0.0],
		[badView.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:0.0],
		[badView.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:0.0],
		[badView.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:0.0],

	]];

	targSize = 400.0;
	targRect = CGRectMake(0.0, 0.0, targSize, targSize);

	// fixed PDF - does not generate errors
	pdfURL = [[NSBundle mainBundle] URLForResource:@"zAW109" withExtension:@"pdf"];

	vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	pr = CGPathGetPathBoundingBox(pth);
	scaledRect = scaleRectToFitTarget(pr, targRect);

	spth = [CGPathTransformer pathInTargetRect:scaledRect withPath:pth];

	subpaths = splitPathIntoSubpaths(spth);
	
	i = 0;
	
	for (id path in subpaths) {
		CGPathRef subpath = (__bridge CGPathRef)path;
		// Use subpath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		v.translatesAutoresizingMaskIntoConstraints = NO;
		[goodView addSubview:v];

		NSView *g = goodView;
		[NSLayoutConstraint activateConstraints:@[
			[v.topAnchor constraintEqualToAnchor:g.topAnchor constant:0.0],
			[v.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:0.0],
			[v.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:0.0],
			[v.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:0.0],
		]];

		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		s.path = subpath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(20.0, 20.0);
		
		//i++;
		
	}
	
	// original PDF - generates errors and bad path
	pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];

	vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	pr = CGPathGetPathBoundingBox(pth);
	
	scaledRect = scaleRectToFitTarget(pr, targRect);
	
	spth = [CGPathTransformer pathInTargetRect:scaledRect withPath:pth];
	
	subpaths = splitPathIntoSubpaths(spth);
	
	i = 0;
	
	for (id path in subpaths) {
		CGPathRef subpath = (__bridge CGPathRef)path;
		// Use subpath as needed
		
		NSView *v = [NSView new];
		v.wantsLayer = YES;
		v.translatesAutoresizingMaskIntoConstraints = NO;
		[badView addSubview:v];

		NSView *g = badView;
		[NSLayoutConstraint activateConstraints:@[
			[v.topAnchor constraintEqualToAnchor:g.topAnchor constant:0.0],
			[v.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:0.0],
			[v.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:0.0],
			[v.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:0.0],
		]];

		CAShapeLayer *s = [CAShapeLayer new];
		NSColor *c = [layerColors objectAtIndex:i % layerColors.count];
		s.strokeColor = c.CGColor; //NSColor.blueColor.CGColor;
		s.fillColor = c.CGColor; //NSColor.redColor.CGColor;
		//s.fillColor = NULL;
		s.lineWidth = 1.0;
		
		s.path = subpath;
		
		[v.layer addSublayer:s];
		s.position = CGPointMake(20.0, 20.0);
		
		//i++;
		
	}

}

@end
