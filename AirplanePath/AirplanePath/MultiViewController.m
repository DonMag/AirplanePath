//
//  MultiViewController.m
//  AirplanePath
//
//  Created by Don Mag on 11/10/24.
//

#import "MultiViewController.h"

#define FatalError(msg) { NSLog(@"Fatal error: %@", msg); assert(false); }

@interface MultiViewController ()
{
	NSImage *radarImg;
	NSMutableArray<NSImageView *> *radarViews;
	NSMutableArray<NSTextField *> *labelViews;
}

@end

@implementation MultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// "background" radar image
	radarImg = [NSImage imageNamed:@"Radar"];
	if (!radarImg) {
		FatalError(@"Could not load Radar image !!");
	}
	
	radarViews = [NSMutableArray array];
	labelViews = [NSMutableArray array];

	for (int i = 0; i < 4; i++) {

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
		[labelViews addObject:label];
		
		NSImageView *rv = [NSImageView new];
		
		rv.wantsLayer = YES;
		rv.image = radarImg;
		rv.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:rv];
		[radarViews addObject:rv];
		
		NSView *g = self.view;
		[NSLayoutConstraint activateConstraints:@[
			[label.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:40.0],
			[label.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-40.0],
			[label.bottomAnchor constraintEqualToAnchor:rv.topAnchor constant:-8.0],
			
			[rv.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
			[rv.centerYAnchor constraintEqualToAnchor:g.centerYAnchor],
			[rv.widthAnchor constraintEqualToConstant:radarImg.size.width],
			[rv.heightAnchor constraintEqualToConstant:radarImg.size.height],
		]];

	}

}

@end
