//
//  PDFDrawVC.m
//  AirplanePath
//
//  Created by Don Mag on 11/7/24.
//

#import "PDFDrawVC.h"
#import <QuartzCore/QuartzCore.h>
#import "LineSegObj.h"

#define FatalError(msg) { NSLog(@"Fatal error: %@", msg); assert(false); }

@interface PDFDrawVC ()
{
	NSImage *radarImg;
	NSImageView *radarImgView;
}
@end

@implementation PDFDrawVC

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];

	// values for this example
	//	adjust as desired

	// size of airplane views (1:1 ratio)
	//	the airplane path shape will be scaled maintaining proportion
	CGFloat airplaneSize = 40.0;
	
	// color of the "flight path" line
	NSColor *linePathColor = NSColor.blackColor;

	// make sure we can load the images
	// "background" radar image
	radarImg = [NSImage imageNamed:@"Radar"];
	if (!radarImg) {
		FatalError(@"Could not load Radar image !!");
	}
	
	radarImgView = [NSImageView new];

	// load the PDF
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AW109" ofType:@"pdf"];
//	imagePath = [[NSBundle mainBundle] pathForResource:@"myairplane" ofType:@"pdf"];
//	imagePath = [[NSBundle mainBundle] pathForResource:@"AC130" ofType:@"pdf"];
	if (!imagePath) {
		FatalError(@"Could not find AW109.pdf !!");
	}

	NSTextField *label = [NSTextField new];
	
	label.stringValue = @"Click anywhere to toggle the background map visibility...";
	label.editable = NO;
	label.bezeled = NO;
	label.drawsBackground = NO;
	label.selectable = NO;
	label.alignment = NSTextAlignmentCenter;
	label.font = [NSFont systemFontOfSize:16.0];
	
	label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:label];
	
	// add image view to view
	radarImgView.wantsLayer = YES;
	radarImgView.image = radarImg;
	radarImgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:radarImgView];
	
	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[
		[label.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:40.0],
		[label.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-40.0],
		[label.bottomAnchor constraintEqualToAnchor:radarImgView.topAnchor constant:-8.0],

		[radarImgView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[radarImgView.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
		[radarImgView.widthAnchor constraintEqualToConstant:radarImg.size.width],
		[radarImgView.heightAnchor constraintEqualToConstant:radarImg.size.height],
	]];
	
	// get pdf page
	NSURL *nsurl = [NSURL fileURLWithPath:imagePath isDirectory:NO];
	CFURLRef url = (CFURLRef)CFBridgingRetain(nsurl);
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL (url);
	CGPDFPageRef page = CGPDFDocumentGetPage (pdf, 1);
	
	if (!page) {
		FatalError(@"Could not load AW109.pdf !!");
	}
	
	// Create and add a CAShapeLayer to the radar image view for the "line path"
	CAShapeLayer *cLine = [CAShapeLayer layer];
	
	CGPoint pt1, pt2;
	
	// Create a mutable array to hold LineSeg structures
	NSMutableArray<NSValue *> *lineSegmentsArray = [NSMutableArray array];

	// create some example line segments
	
	pt1 = CGPointMake( 20.0,  20.0);
	pt2 = CGPointMake( 60.0, 160.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(160.0, 280.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(340.0, 280.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(400.0, 100.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(250.0,  50.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(170.0, 150.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	pt1 = pt2;
	pt2 = CGPointMake(240.0, 220.0);
	[lineSegmentsArray addObject:LineSegToNSValue(LineSegMake(pt1, pt2))];
	
	CGMutablePathRef linePath = CGPathCreateMutable();
	
	NSArray<NSColor *> *airplaneColors = @[
		NSColor.redColor,
		NSColor.systemGreenColor,
		NSColor.blueColor,
		NSColor.systemCyanColor,
		NSColor.systemYellowColor,
		[NSColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0],
	];
	

	// array to hold airplane layers
	NSMutableArray <CALayer *> *planes = [NSMutableArray array];
	
	// airplane size
	NSSize sz = NSMakeSize(airplaneSize, airplaneSize);
	
	for (NSInteger i = 0; i < lineSegmentsArray.count; i++) {
		
		LineSeg lineSeg;
		[lineSegmentsArray[i] getValue:&lineSeg];
		
		// add segment to line path
		CGPathMoveToPoint(linePath, NULL, lineSeg.pt1.x, lineSeg.pt1.y);
		CGPathAddLineToPoint(linePath, NULL, lineSeg.pt2.x, lineSeg.pt2.y);
		
		// create a scaled, rotated, color image from PDF
		// CGContextRotateCTM goes counter-clockwise
		CGFloat radians = -lineSeg.radians;
		
		// if image is pointing right instead of up
		//radians += M_PI * 0.5;
		
		NSImage *pdfImg = [self imageFromPDFPage:page targetSize:sz rotationRadians:radians withColor:[airplaneColors objectAtIndex:i % airplaneColors.count]];
		
		// rect for generated airplane image
		//	put center AirplaneView at midpoint of line segment
		CGRect r = CGRectMake(lineSeg.cp.x - (pdfImg.size.width * 0.5), lineSeg.cp.y - (pdfImg.size.height * 0.5), pdfImg.size.width, pdfImg.size.height);
		CALayer *c = [CALayer new];
		c.frame = r;
		c.contents = pdfImg;
		[planes addObject:c];
	}

	[radarImgView.layer addSublayer:cLine];
	[cLine setZPosition:10];
	for (NSInteger i = 0; i < planes.count; i++) {
		CALayer *c = [planes objectAtIndex:i];
		[radarImgView.layer addSublayer:c];
		[c setZPosition:10 + i];
	}

	// set the line path properties
	cLine.path = linePath;
	cLine.fillColor = NULL;
	cLine.strokeColor = [linePathColor CGColor];
	cLine.lineWidth = 1;
	
	CGPathRelease(linePath);
}

- (NSImage *)imageFromPDFPage:(CGPDFPageRef)pdfPage targetSize:(CGSize)targetSize rotationRadians:(CGFloat)radians withColor:(NSColor *)withColor
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

- (void)mouseUp:(NSEvent *)event {
	if (!radarImgView.image) {
		radarImgView.image = radarImg;
		((CAShapeLayer *)radarImgView.layer.sublayers.firstObject).strokeColor = NSColor.blackColor.CGColor;
	} else {
		radarImgView.image = NULL;
		((CAShapeLayer *)radarImgView.layer.sublayers.firstObject).strokeColor = NSColor.lightGrayColor.CGColor;
	}
	
}
@end
