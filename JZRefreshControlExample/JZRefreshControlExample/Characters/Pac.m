//
//  Pac.m
//  JZRefreshControlExample
//
//  Created by Jeremy Zedell on 1/21/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "Pac.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

typedef enum {
	PacStateOpening,
	PacStateClosing
} PacState;

static const CGFloat kStateTransitionTime = 0.15;
static const CGFloat kMaxRotation = 60;

@interface Pac()
@property (nonatomic, strong) UIImageView *top;
@property (nonatomic, strong) UIImageView *bottom;
@property (nonatomic, assign) PacState state;
@property (nonatomic, assign) CGFloat time;

- (void)changeState;
@end

@implementation Pac

- (id)init
{
	return [self initWithFrame:CGRectMake(0, 0, 64, 64)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.top = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pac-top"]];
		self.bottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pac-bottom"]];
		self.top.frame = self.frame;
		self.bottom.frame = self.frame;
		[self addSubview:self.top];
		[self addSubview:self.bottom];
		self.state = PacStateOpening;
    }
	
    return self;
}

- (void)tick:(CGFloat)delta
{
	self.time += delta;
	if (self.time > kStateTransitionTime)
	{
		self.time -= kStateTransitionTime;
		[self changeState];
	}
	
	switch (self.state)
	{
		case PacStateOpening:
		{
			CGFloat degrees = (self.time / kStateTransitionTime) * kMaxRotation;
			self.top.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-degrees));
			self.bottom.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
			break;
		}
		case PacStateClosing:
		{
			CGFloat degrees = ((kStateTransitionTime - self.time) / kStateTransitionTime) * kMaxRotation;
			self.top.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-degrees));
			self.bottom.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
			break;
		}
	}
}

- (void)changeState
{
	self.state = self.state == PacStateOpening ? PacStateClosing : PacStateOpening;
}

- (void)reset
{
	self.top.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-kMaxRotation));
	self.bottom.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(kMaxRotation));
}

@end
