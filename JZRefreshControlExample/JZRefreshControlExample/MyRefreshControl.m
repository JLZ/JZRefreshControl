//
//  MyRefreshControl.m
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "MyRefreshControl.h"
#import "Pac.h"

static const CGFloat kViewHeight = 100;
static const CGFloat kPixelsPerSecond = 150;
static const NSInteger kStartingNumberOfDots = 5;

@interface MyRefreshControl()

@property (nonatomic, strong) Pac *pac;
@property (nonatomic, strong) UIView *dotsView;
@property (nonatomic, strong) NSMutableArray *dots;
@property (nonatomic, assign) CGFloat dotSpacing;

- (CGFloat)xPositionDotAtIndex:(NSUInteger)index withPercentage:(CGFloat)percentage;

@end

@implementation MyRefreshControl

+ (CGFloat)height
{
	return kViewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		
		self.dotsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:self.dotsView];
		
		self.pac = [[Pac alloc] init];
		self.pac.center = CGPointMake(-(self.pac.frame.size.width / 2), frame.size.height / 2);
		[self addSubview:self.pac];
		NSLog(@"%@", NSStringFromCGRect(self.pac.frame));
		
		self.dots = [[NSMutableArray alloc] initWithCapacity:kStartingNumberOfDots];
		for (int i = 0; i < kStartingNumberOfDots; ++i)
		{
			UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
			[self.dots addObject:iv];
			iv.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
			[self.dotsView addSubview:iv];
		}
		
		self.dotSpacing = frame.size.width / kStartingNumberOfDots;
		[self reset];
    }
    return self;
}

- (void)amountOfControlVisible:(CGFloat)visibility
{
	[self.dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIImageView *dot = (UIImageView*)obj;
		CGFloat x = ((self.dotSpacing * (idx + 1) - (self.dotSpacing / 2)) * visibility) + ((1 - visibility) * (self.frame.size.width / 2));
		dot.center = CGPointMake(x, dot.center.y);
		dot.transform = CGAffineTransformMakeScale(visibility, visibility);
	}];
	self.dotsView.transform = CGAffineTransformMakeRotation(M_PI * ((1 - visibility) * 90) / 180.0);
//	CGFloat x = (self.pac.frame.size.width / 2) + 5;
//	CGFloat y = (self.frame.size.height / 2) + ((0.5 - (visibility / 2)) * self.frame.size.height);
//	self.pac.center = CGPointMake(x, y);
//	self.pac.transform = CGAffineTransformMakeRotation(M_PI * (visibility * 720) / 180.0);
//	self.pac.center = CGPointMake(MAX((1 - visibility) * (self.frame.size.width / 2), self.pac.frame.size.width / 2), self.pac.center.y);
}

- (void)refreshingWithDelta:(CGFloat)delta
{
	[self.pac tick:delta];
	
	if (self.pac.center.x < self.frame.size.width / 2)
	{
		for (UIImageView *dot in self.dots)
		{
			if (self.pac.center.x >= dot.center.x)
				dot.hidden = YES;
		}
		
		CGFloat x = self.pac.frame.origin.x + (kPixelsPerSecond * delta);
		
		CGRect frame = self.pac.frame;
		frame.origin.x = x;
		self.pac.frame = frame;
	}
	else
	{
		self.pac.center = CGPointMake(self.frame.size.width / 2, self.pac.center.y);
		
		for (UIImageView *dot in self.dots)
		{
			if (!dot.hidden)
			{
				if (dot.center.x <= self.pac.center.x)
					dot.center = CGPointMake(self.dotsView.frame.size.width + (self.dotSpacing / 2), dot.center.y);
				
				dot.center = CGPointMake(dot.center.x - (kPixelsPerSecond * delta), dot.center.y);
			}
		}
	}
}

- (void)reset
{
	self.pac.center = CGPointMake(-(self.pac.frame.size.width / 2), self.frame.size.height / 2);
	[self.pac reset];
	[self.dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIImageView *dot = (UIImageView*)obj;
		dot.hidden = NO;
		CGFloat x = [self xPositionDotAtIndex:idx withPercentage:1];
		dot.center = CGPointMake(x, dot.center.y);
		dot.transform = CGAffineTransformMakeScale(1, 1);
	}];
	self.dotsView.transform = CGAffineTransformMakeRotation(0);
}

- (CGFloat)xPositionDotAtIndex:(NSUInteger)index withPercentage:(CGFloat)percentage
{
	return ((self.dotSpacing * (index + 1) - (self.dotSpacing / 2)) * percentage) + ((1 - percentage) * (self.frame.size.width / 2));
}

@end
