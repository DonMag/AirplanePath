//
//  PDFCheckerViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/14/24.
//

#import "PDFCheckerViewController.h"
#import "CheckerBoardView.h"
#import "UtilityMethods.h"
#import "RotatablePDFImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFCheckerViewController ()
{
	NSImageView *imgView;
	RotatablePDFImageView *rimgView;
	NSView *pathOutlineView;
	NSView *pathFilledView;
	
	CGFloat d;
}
@end

@implementation PDFCheckerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	NSArray<NSString *> *pdfFiles = [self filesInBundleWithExtension:@"pdf"];
	if (pdfFiles.count == 0) {
		return;
	}
	
	NSPopUpButton *comboButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 30) pullsDown:NO];
	[comboButton addItemsWithTitles:pdfFiles];
	[comboButton setTarget:self];
	[comboButton setAction:@selector(comboButtonSelectionChanged:)];
	
	NSTextField *promptLabel = [NSTextField new];
	
	promptLabel.stringValue = @"Select a PDF from the Bundle to Validate";
	promptLabel.editable = NO;
	promptLabel.bezeled = NO;
	promptLabel.drawsBackground = NO;
	promptLabel.selectable = NO;
	promptLabel.font = [NSFont systemFontOfSize:15.0];

	
	NSImageView *imgView = [NSImageView new];
	imgView = [NSImageView new];
	imgView.wantsLayer = YES;
	imgView.imageScaling = NSImageScaleProportionallyUpOrDown;
	imgView.contentTintColor = NSColor.redColor;
	
	rimgView = [RotatablePDFImageView new];
	[rimgView setColor:NSColor.redColor];
	
	CAShapeLayer *c;
	
	pathOutlineView = [NSView new];
	pathOutlineView.wantsLayer = YES;
	c = [CAShapeLayer new];
	c.fillColor = NULL;
	c.strokeColor = NSColor.redColor.CGColor;
	c.lineWidth = 1.0;
	[pathOutlineView.layer addSublayer:c];
	
	pathFilledView = [NSView new];
	pathFilledView.wantsLayer = YES;
	c = [CAShapeLayer new];
	c.fillColor = NSColor.systemYellowColor.CGColor;
	c.strokeColor = NSColor.redColor.CGColor;
	c.lineWidth = 1.0;
	[pathFilledView.layer addSublayer:c];

//	imgView.layer.backgroundColor = NSColor.yellowColor.CGColor;
//	pathOutlineView.layer.backgroundColor = NSColor.greenColor.CGColor;
//	pathFilledView.layer.backgroundColor = NSColor.cyanColor.CGColor;
	
	NSStackView *bgstack = [NSStackView new];
	bgstack.spacing = 20.0;
	bgstack.distribution = NSStackViewDistributionFillEqually;
	
	NSStackView *stack = [NSStackView new];
	stack.spacing = 20.0;
	stack.distribution = NSStackViewDistributionFillEqually;

	for (NSView *v in @[rimgView, imgView, pathOutlineView, pathFilledView]) {
		v.translatesAutoresizingMaskIntoConstraints = NO;
		[stack addArrangedSubview:v];
		[v.heightAnchor constraintEqualToConstant:180.0].active = YES;
		[v.widthAnchor constraintEqualToConstant:180.0].active = YES;
		
		CheckerBoardView *cbv = [CheckerBoardView new];
		cbv.translatesAutoresizingMaskIntoConstraints = NO;
		[bgstack addArrangedSubview:cbv];
		[cbv.heightAnchor constraintEqualToConstant:180.0].active = YES;
		[cbv.widthAnchor constraintEqualToConstant:180.0].active = YES;
	}
//	rimgView.frame = CGRectMake(20.0, 20.0, 240.0, 240.0);
//	[self.view addSubview:rimgView];

	for (NSView *v in @[promptLabel, comboButton, bgstack, stack]) {
		v.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:v];
	}

	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[
		[promptLabel.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[promptLabel.topAnchor constraintEqualToAnchor:g.topAnchor constant:16.0],
		[comboButton.widthAnchor constraintEqualToConstant:240.0],
		[comboButton.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[comboButton.topAnchor constraintEqualToAnchor:promptLabel.bottomAnchor constant:8.0],
		
		[bgstack.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[bgstack.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
		[stack.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		[stack.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
	]];

	d = 0.0;
}

- (NSArray<NSString *> *)filesInBundleWithExtension:(NSString *)extension {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
	NSError *error = nil;
	
	// Get all files in the bundle's resource directory
	NSArray<NSString *> *allFiles = [fileManager contentsOfDirectoryAtPath:bundlePath error:&error];
	
	if (error) {
		NSLog(@"Error reading bundle contents: %@", error.localizedDescription);
		return @[];
	}
	
	// Filter files that have the specified extension
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH[c] %@", extension];
	NSArray<NSString *> *matchingFiles = [allFiles filteredArrayUsingPredicate:predicate];
	
	return matchingFiles;
}

- (void)viewDidAppear {
	[super viewDidAppear];
	
}

- (void)comboButtonSelectionChanged:(NSPopUpButton *)sender {
	NSString *selectedOption = sender.titleOfSelectedItem;
	NSLog(@"Selected option: %@", selectedOption);
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:selectedOption ofType:NULL];
	NSURL *pdfUrl = [NSURL fileURLWithPath:imagePath isDirectory:NO];
	
	NSImage *img = [[NSImage alloc] initWithContentsOfURL:pdfUrl];
	img.template = YES;
	imgView.image = img;
	[rimgView setImage:img];
	rimgView.layer.shadowColor = NSColor.redColor.CGColor;
	rimgView.layer.shadowOpacity = 1.0;
	rimgView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	rimgView.layer.shadowRadius = 1.0;
	[rimgView setColor:NSColor.systemYellowColor];
	[rimgView rotateByDegrees:d];
	d += 15.0;

	NSArray<id> *vectorPaths = [UtilityMethods extractVectorPathsFromPDF:pdfUrl];
	CGPathRef pth = (CGPathRef)CFBridgingRetain([vectorPaths firstObject]);
	
	// calculate target rect
	//	center and maintain aspect ratio
	CGRect pathRect = CGPathGetBoundingBox(pth);
	CGRect boundsRect = pathOutlineView.bounds;
	
	CGRect targRect = [UtilityMethods scaleRect:pathRect toFit:boundsRect];
	
	// transform airplane path to fit
	CGMutablePathRef cpth2 = [UtilityMethods pathInTargetRect:targRect withPath:pth];
	if (!cpth2) {
		return;
	}

	CAShapeLayer *c;
	
	c = (CAShapeLayer *)pathOutlineView.layer.sublayers.firstObject;
	c.path = cpth2;
	
	c = (CAShapeLayer *)pathFilledView.layer.sublayers.firstObject;
	c.path = cpth2;

	CGPathRelease(cpth2);
	CGPathRelease(pth);
}


@end
