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

#import <Cocoa/Cocoa.h>

@interface RotatableImageView : NSView
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic) CGFloat rotationAngle;
- (void)setImage:(NSImage *)image;
- (void)setRotationAngle:(CGFloat)angle;
@end

@implementation RotatableImageView

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_imageView = [[NSImageView alloc] initWithFrame:self.bounds];
		_imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
		_imageView.wantsLayer = YES;
		_imageView.layer.backgroundColor = [[NSColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.5] CGColor];
		[self addSubview:_imageView];
	}
	return self;
}

- (void)setImage:(NSImage *)image {
	self.imageView.image = image;
	[self updateLayout];
}

- (void)setRotationAngle:(CGFloat)angle {
	_rotationAngle = angle;
	[self updateLayout];
}
- (void)layout {
	[self updateLayout];
}
- (void)updateLayout {
	// Get the size of the image
	NSSize imageSize = self.imageView.image.size;
	NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
	
	// Calculate rotated bounds
	NSRect rotatedBounds = [self rotatedBoundsForRect:imageRect angle:self.rotationAngle];
	
	// Adjust the frame of the container to fit the rotated image
	self.bounds = rotatedBounds;
	self.imageView.frame = NSMakeRect(0, 0, imageSize.width, imageSize.height);
	
	// Apply rotation to imageView's layer
	CATransform3D rotation = CATransform3DMakeRotation(self.rotationAngle * (M_PI / 180.0), 0, 0, 1);
	self.imageView.layer.transform = rotation;
	
	// Center the imageView in the container view
	self.imageView.frame = NSMakeRect(
									  (rotatedBounds.size.width - imageSize.width) / 2,
									  (rotatedBounds.size.height - imageSize.height) / 2,
									  imageSize.width,
									  imageSize.height
									  );
}

- (NSRect)rotatedBoundsForRect:(NSRect)rect angle:(CGFloat)angle {
	// Convert angle to radians
	CGFloat radians = angle * (M_PI / 180.0);
	
	// Define the four corners of the rect
	NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
	NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
	NSPoint bottomLeft = NSMakePoint(NSMinX(rect), NSMinY(rect));
	NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
	
	// Rotate each corner
	topLeft = [self rotatedPoint:topLeft aroundCenter:rect.origin byRadians:radians];
	topRight = [self rotatedPoint:topRight aroundCenter:rect.origin byRadians:radians];
	bottomLeft = [self rotatedPoint:bottomLeft aroundCenter:rect.origin byRadians:radians];
	bottomRight = [self rotatedPoint:bottomRight aroundCenter:rect.origin byRadians:radians];
	
	// Calculate the bounding rect of the rotated points
	CGFloat minX = fmin(fmin(topLeft.x, topRight.x), fmin(bottomLeft.x, bottomRight.x));
	CGFloat maxX = fmax(fmax(topLeft.x, topRight.x), fmax(bottomLeft.x, bottomRight.x));
	CGFloat minY = fmin(fmin(topLeft.y, topRight.y), fmin(bottomLeft.y, bottomRight.y));
	CGFloat maxY = fmax(fmax(topLeft.y, topRight.y), fmax(bottomLeft.y, bottomRight.y));
	
	return NSMakeRect(minX, minY, maxX - minX, maxY - minY);
}

- (NSPoint)rotatedPoint:(NSPoint)point aroundCenter:(NSPoint)center byRadians:(CGFloat)radians {
	CGFloat translatedX = point.x - center.x;
	CGFloat translatedY = point.y - center.y;
	CGFloat rotatedX = translatedX * cos(radians) - translatedY * sin(radians);
	CGFloat rotatedY = translatedX * sin(radians) + translatedY * cos(radians);
	return NSMakePoint(rotatedX + center.x, rotatedY + center.y);
}

@end

@interface EasiestViewController ()

@end

@implementation EasiestViewController

// Function to calculate a scaled rotation transformation for CGRect
CGAffineTransform scaledRotationTransformForRect(CGRect rect, CGFloat angleInRadians) {
	// Calculate the cosine and sine of the rotation angle
	CGFloat cosAngle = cos(angleInRadians);
	CGFloat sinAngle = sin(angleInRadians);
	
	// Calculate the scaling factors needed to maintain the bounding box size
	CGFloat scaleX = 1.0 / (fabs(cosAngle) + fabs(sinAngle));
	CGFloat scaleY = 1.0 / (fabs(cosAngle) + fabs(sinAngle));
	
	// Apply the scaled rotation transformation
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	transform = CGAffineTransformScale(transform, scaleX, scaleY);
	
	return transform;
}
// Function to apply the scaled rotation transformation to a CGRect
CGRect rotatedRectWithOriginalBoundingBox(CGRect rect, CGFloat angleInRadians) {
	// Get the transformation matrix
	CGAffineTransform transform = scaledRotationTransformForRect(rect, angleInRadians);
	
	// Apply the transformation to the rectangle and return the result
	CGRect rotatedRect = CGRectApplyAffineTransform(rect, transform);
	
	// Adjust the origin if necessary (keeps rect centered at original location)
	rotatedRect.origin.x = rect.origin.x + (rect.size.width - rotatedRect.size.width) / 2;
	rotatedRect.origin.y = rect.origin.y + (rect.size.height - rotatedRect.size.height) / 2;
	
	return rotatedRect;
}
CGRect fitRectTo(CGRect origR, CGRect targR, CGFloat rotationAngle) {

	CGRect mediaBox = origR;
	CGSize targetSize = targR.size;
	
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

	return CGRectMake(0, 0, adjustedSize.width, adjustedSize.height);
}
// Function to calculate the size of a rectangle that, when rotated, fits within a target CGRect
CGSize sizeForRectToFitTargetRectWithRotation(CGSize targetSize, CGFloat angleInRadians) {
	// Calculate the cosine and sine of the rotation angle
	CGFloat cosAngle = cos(angleInRadians);
	CGFloat sinAngle = sin(angleInRadians);
	
	// Solve for the original width and height that fit within the target size when rotated
	CGFloat requiredWidth = (targetSize.width * fabs(cosAngle)) + (targetSize.height * fabs(sinAngle));
	CGFloat requiredHeight = (targetSize.width * fabs(sinAngle)) + (targetSize.height * fabs(cosAngle));
	
	return CGSizeMake(requiredWidth, requiredHeight);
}
// Function to calculate the size of a rectangle that, when rotated, will fit within a target CGRect
CGSize sizeToFitWithinTargetRectWhenRotated(CGSize targetSize, CGFloat angleInRadians) {
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	// Calculate the cosine and sine of the angle
	CGFloat cosAngle = fabs(cos(angleInRadians));
	CGFloat sinAngle = fabs(sin(angleInRadians));
	
	// Calculate the maximum width and height that will fit within the target size when rotated
	CGFloat fittedWidth = (targetWidth * cosAngle + targetHeight * sinAngle) / (cosAngle * cosAngle + sinAngle * sinAngle);
	CGFloat fittedHeight = (targetHeight * cosAngle + targetWidth * sinAngle) / (cosAngle * cosAngle + sinAngle * sinAngle);
	
	return CGSizeMake(fittedWidth, fittedHeight);
}
- (CGRect)adjustedRect:(CGRect)origR withRotation:(CGFloat)angleInDegrees {
	CGFloat angleInRadians = angleInDegrees * (M_PI / 180.0);

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
	RotatableImageView *rv40 = [[RotatableImageView alloc] initWithFrame:r];

	r = CGRectMake(80, 40, 120, 120);
	AircraftImageView *v120 = [[AircraftImageView alloc] initWithFrame:r];
	RotatableImageView *rv120 = [[RotatableImageView alloc] initWithFrame:r];

	r = CGRectMake(160, 160, 400, 400);
	AircraftImageView *v1200 = [[AircraftImageView alloc] initWithFrame:r];
	RotatableImageView *rv1200 = [[RotatableImageView alloc] initWithFrame:r];
	
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
	NSImageView *curView;

	angleInDegrees = 0.0;
	
	if (0) {
		r = CGRectMake(0, 0, 40, 40);
		c = CGPointMake(60, 600);
		
		curView = bgImgA;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		//bgImgA.frame = CGRectOffset(newR, (c.x - newR.size.width) * 0.5, (c.y - newR.size.height) * 0.5);
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemRedColor;
		
		r = CGRectMake(0, 0, 140, 140);
		c = CGPointMake(180, 600);
		
		curView = bgImgB;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemGreenColor;
		
		r = CGRectMake(0, 0, 240, 240);
		c = CGPointMake(380, 600);
		
		curView = bgImgC;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemBlueColor;
		
		r = CGRectMake(0, 0, 1200, 1200);
		c = CGPointMake(1000, 600);
		
		curView = bgImgD;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemYellowColor;
	}
	if (0) {
		r = CGRectMake(0, 0, 240, 240);
		c = CGPointMake(380, 600);

		curView = bgImgA;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemRedColor;

		angleInDegrees -= 30.0;
		
		curView = bgImgB;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemGreenColor;
		
		angleInDegrees -= 30.0;

		curView = bgImgC;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemBlueColor;
		
		angleInDegrees -= 30.0;

		curView = bgImgD;
		newR = [self adjustedRect:r withRotation:angleInDegrees];
		curView.frame = CGRectOffset(newR, c.x - (r.size.width * 0.5), c.y - (r.size.height * 0.5));
		[curView rotateByAngle:angleInDegrees];
		curView.contentTintColor = NSColor.systemYellowColor;

	}

	
	AircraftPathView *pthv = [AircraftPathView new];
	pthv.frame = CGRectMake(200.0, 100.0, 800.0, 800.0);
	[pthv setThePath:[[AircraftCGPath new] airplanePath]];
	[pthv setThePath:[[AircraftCGPath new] copterPath]];
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
	newR = [self adjustedRect:r withRotation:-45.0];
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

//	for (RotatableImageView *v in @[rv40, rv120, rv1200]) {
//		v.wantsLayer = YES;
//		[v setImage:img];
//		[v setRotationAngle:45.0];
//		//[v setFillColor:NSColor.redColor];
//		//[v rotateByDegrees:45.0];
//		v.layer.backgroundColor = [[NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.5] CGColor];
//		[self.view addSubview:v];
//	}
	
//	RotatableImageView *rotatableImageView = [[RotatableImageView alloc] initWithFrame:NSMakeRect(0, 0, 200, 200)];
//	[rotatableImageView setImage:[NSImage imageNamed:@"AW109"]];
//	[rotatableImageView setRotationAngle:45.0]; // Rotate by 45 degrees
//	[self.view addSubview:rotatableImageView];
	
}

@end
