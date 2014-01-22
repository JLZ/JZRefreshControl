//
//  MyRefreshControl.m
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "MyRefreshControl.h"
#import "Pac.h"

static const CGFloat kPixelsPerSecond = 100;

@interface MyRefreshControl()
@property (nonatomic, strong) Pac *pac;
@end

@implementation MyRefreshControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.pac = [[Pac alloc] init];
		self.pac.center = CGPointMake(self.pac.center.x, frame.size.height / 2);
		[self addSubview:self.pac];
		NSLog(@"%@", NSStringFromCGRect(self.pac.frame));
    }
    return self;
}

- (void)amountOfControlVisible:(CGFloat)visibility
{
	self.pac.center = CGPointMake(MAX((1 - visibility) * (self.frame.size.width / 2), self.pac.frame.size.width / 2), self.pac.center.y);
}

- (void)refreshingWithDelta:(CGFloat)delta
{
	[self.pac tick:delta];
	
	CGFloat x;
	if (self.pac.frame.origin.x >= self.frame.size.width)
		x = 0;
	else
		x = self.pac.frame.origin.x + (kPixelsPerSecond * delta);
	
	CGRect frame = self.pac.frame;
	frame.origin.x = x;
	self.pac.frame = frame;
}

- (void)reset
{
	self.pac.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self.pac reset];
}

@end
