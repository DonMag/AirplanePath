//
//  EasiestViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/10/24.
//

#import "EasiestViewController.h"
#import "CheckerBoardView.h"
#import "AircraftImageView.h"
#import "RotatablePDFImageView.h"
#import "AircraftPathView.h"
#import "AircraftCGPath.h"
#import "UtilityMethods.h"

#import <Cocoa/Cocoa.h>

@interface EasiestViewController ()

@end

@implementation EasiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	CheckerBoardView *cv = [CheckerBoardView new];
	cv.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:cv];

	NSView *g = self.view;
	[NSLayoutConstraint activateConstraints:@[
		
		[cv.topAnchor constraintEqualToAnchor:g.topAnchor constant:0.0],
		[cv.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:0.0],
		[cv.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:0.0],
		[cv.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:0.0],
		
	]];
	
	CGRect r;
	
	r = CGRectMake(40, 40, 40, 40);
	AircraftImageView *v40 = [[AircraftImageView alloc] initWithFrame:r];

	r = CGRectMake(80, 40, 120, 120);
	AircraftImageView *v120 = [[AircraftImageView alloc] initWithFrame:r];

	r = CGRectMake(160, 160, 400, 400);
	AircraftImageView *v1200 = [[AircraftImageView alloc] initWithFrame:r];
	
	NSView *bgv = [NSView new];
	bgv.wantsLayer = YES;
	bgv.layer.backgroundColor = NSColor.orangeColor.CGColor;
	bgv.frame = r;
	//[self.view addSubview:bgv];
	[bgv rotateByAngle:30.0];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cpAW109" ofType:@"pdf"];
	//imagePath = [[NSBundle mainBundle] pathForResource:@"myairplane" ofType:@"pdf"];
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
	img.template = YES;
	

	NSImageView *bgImgA = [NSImageView new];
	NSImageView *bgImgB = [NSImageView new];
	NSImageView *bgImgC = [NSImageView new];
	NSImageView *bgImgD = [NSImageView new];

	r = CGRectMake(0, 0, 40, 40);

	for (NSImageView *v in @[bgImgA, bgImgB, bgImgC, bgImgD]) {
		v.wantsLayer = YES;
		v.imageScaling = NSImageScaleProportionallyUpOrDown;
		v.frame = r;
		v.image = img;
		[self.view addSubview:v];
		//v.layer.backgroundColor = [[NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5] CGColor];
	}

	CGRect newR;
	CGPoint c;
	CGFloat angleInDegrees;
	CGFloat rotationRadians;
	NSImageView *curView;

	angleInDegrees = 0.0;
	rotationRadians = angleInDegrees * (M_PI / 180.0);
	
	if (0) {
		r = CGRectMake(0, 0, 40, 40);
		c = CGPointMake(60, 600);
		
		curView = bgImgA;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		//bgImgA.frame = CGRectOffset(newR, (c.x - newR.size.width) * 0.5, (c.y - newR.size.height) * 0.5);
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemRedColor;
		
		r = CGRectMake(0, 0, 140, 140);
		c = CGPointMake(180, 600);
		
		curView = bgImgB;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemGreenColor;
		
		r = CGRectMake(0, 0, 240, 240);
		c = CGPointMake(380, 600);
		
		curView = bgImgC;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemBlueColor;
		
		r = CGRectMake(0, 0, 1200, 1200);
		c = CGPointMake(1000, 600);
		
		curView = bgImgD;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemYellowColor;
	}
	if (0) {
		r = CGRectMake(0, 0, 240, 240);
		c = CGPointMake(380, 600);

		curView = bgImgA;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemRedColor;

		angleInDegrees -= 30.0;
		rotationRadians = angleInDegrees * (M_PI / 180.0);

		curView = bgImgB;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemGreenColor;
		
		angleInDegrees -= 30.0;
		rotationRadians = angleInDegrees * (M_PI / 180.0);

		curView = bgImgC;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemBlueColor;
		
		angleInDegrees -= 30.0;
		rotationRadians = angleInDegrees * (M_PI / 180.0);

		curView = bgImgD;
		newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemYellowColor;

	}

	
	AircraftPathView *pthv = [AircraftPathView new];
	pthv.frame = CGRectMake(200.0, 100.0, 800.0, 800.0);
	//[pthv setThePath:[[AircraftCGPath new] airplanePath]];
	[pthv setThePath:[AircraftCGPath airplanePath]];
	[pthv setThePath:[AircraftCGPath copterPath]];
	// set the rotation
	
	// if image is pointing right instead of up
	//radians += M_PI * 0.5;
	
	[pthv rotateByDegrees:-45.0];
	
	pthv.strokeWidth = 1.0;
	
	pthv.fillColor = NSColor.purpleColor;
	pthv.strokeColor = pthv.fillColor;
	
	//[pthv setPath:[[AircraftCGPath new] airplanePath]];
	
	[self.view addSubview:pthv];
	return;

	
	RotatablePDFImageView *pv = [RotatablePDFImageView new];
	pv.frame = CGRectMake(200.0, 80.0, 1400.0, 1400.0);
	[pv setImage:img];
	[pv rotateByDegrees:-45.0];
	[pv setColor:NSColor.blueColor];
	[self.view addSubview:pv];
	
	NSView *cView = [NSView new];
	cView.wantsLayer = YES;
	cView.layer.backgroundColor = NSColor.systemGreenColor.CGColor;
	
//	NSView *iView = [NSView new];
//	iView.wantsLayer = YES;
//	iView.layer.backgroundColor = NSColor.systemOrangeColor.CGColor;
	
	NSImageView *iView = [NSImageView new];
	iView.image = img;
	iView.wantsLayer = YES;
	iView.layer.backgroundColor = NSColor.systemOrangeColor.CGColor;
	
	cView.frame = CGRectMake(80.0, 80.0, 100.0, 100.0);
	iView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
	[cView addSubview:iView];
	[self.view addSubview:cView];
	
	cView.clipsToBounds = NO;

	r = CGRectMake(0.0, 0.0, 100.0, 100.0);

	angleInDegrees -= -45.0;
	rotationRadians = angleInDegrees * (M_PI / 180.0);

	newR = [UtilityMethods boundsForRect:r withRotation:rotationRadians];
	NSLog(@"newR: %@", [NSValue valueWithRect:newR]);
	iView.frame = newR;
	//iView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
	[iView rotateByAngle:-30.0];
	
	return;
	
	for (NSImageView *v in @[bgImgA, bgImgB, bgImgC, bgImgD]) {
		v.hidden = YES;
	}
	
	r = CGRectMake(200, 200, 400, 400);
	AircraftImageView *v400 = [[AircraftImageView alloc] initWithFrame:r];
	[v400 setImage:img];
	[v400 rotateByDegrees:45.0];
	[v400 setFillColor:NSColor.redColor];
	[self.view addSubview:v400];
	
	r = CGRectMake(600, 200, 400, 400);
	AircraftImageView *v401 = [[AircraftImageView alloc] initWithFrame:r];
	[v401 setImage:img];
	//[v400 rotateByDegrees:45.0];
	[v401 setFillColor:NSColor.redColor];
	[self.view addSubview:v401];
	
//	for (AircraftImageView *v in @[v40, v120, v1200]) {
//		v.wantsLayer = YES;
//		[v setImage:img];
//		[v setFillColor:NSColor.redColor];
//		[v rotateByDegrees:45.0];
//		v.layer.backgroundColor = [[NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5] CGColor];
//		[self.view addSubview:v];
//	}

}

@end
