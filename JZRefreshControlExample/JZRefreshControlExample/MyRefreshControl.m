//
//  MyRefreshControl.m
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "MyRefreshControl.h"

static const CGFloat kPixelsPerSecond = 100;

@interface MyRefreshControl()
@property (nonatomic, strong) UIView *squareView;
@end

@implementation MyRefreshControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.squareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.squareView.backgroundColor = [UIColor whiteColor];
		[self addSubview:self.squareView];
		self.squareView.center = CGPointMake(self.squareView.center.x, frame.size.height / 2);
    }
    return self;
}

- (void)amountOfControlVisible:(CGFloat)visibility
{
	self.squareView.center = CGPointMake(MAX((1 - visibility) * (self.frame.size.width / 2), self.squareView.frame.size.width / 2), self.squareView.center.y);
}

- (void)refreshingWithDelta:(CGFloat)delta
{
	CGFloat x;
	if (self.squareView.frame.origin.x >= self.frame.size.width)
		x = 0;
	else
		x = self.squareView.frame.origin.x + (kPixelsPerSecond * delta);
	
	CGRect frame = self.squareView.frame;
	frame.origin.x = x;
	self.squareView.frame = frame;
}

- (void)reset
{
	self.squareView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

@end
