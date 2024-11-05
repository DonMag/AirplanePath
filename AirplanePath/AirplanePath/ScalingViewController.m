//
//  ScalingViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/4/24.
//

#import "ScalingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AirplaneView.h"

#import "PDFExtractor.h"

@interface ScalingViewController ()

@end

@implementation ScalingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Set background color of the view
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [[NSColor colorWithWhite:0.95 alpha:1.0] CGColor];
	self.view.layer.backgroundColor = [[NSColor systemYellowColor] CGColor];
	
}
- (void)viewDidAppear {
	[super viewDidAppear];
	
	NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"AW109" withExtension:@"pdf"];
	
	NSArray<NSBezierPath *> *bezvectorPaths = [PDFExtractor bezextractVectorPathsFromPDF:pdfURL];

	NSLog(@"Extracted %lu vector paths.", (unsigned long)bezvectorPaths.count);

	NSArray<id> *vectorPaths = [PDFExtractor extractVectorPathsFromPDF:pdfURL];
	
	NSLog(@"Extracted %lu vector paths.", (unsigned long)vectorPaths.count);
	
	CAShapeLayer *s = [CAShapeLayer new];
	s.strokeColor = NSColor.redColor.CGColor;
	s.fillColor = NSColor.yellowColor.CGColor;
	s.lineWidth = 2.0;
	
//	s.path = [[bezvectorPaths objectAtIndex:12] CGPath];
//	CGRect rr = CGPathGetBoundingBox(s.path);
//	NSLog(@"%@", [NSValue valueWithRect:rr]);
	
	s.path = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	[self.view.layer addSublayer:s];
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
