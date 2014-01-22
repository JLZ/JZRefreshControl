//
//  JZRefreshControl.m
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "JZRefreshControl.h"

@interface JZRefreshControl()
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
+ (CGRect)frameForFrame:(CGRect)frame;
- (void)refresh;
@end

@implementation JZRefreshControl

#pragma mark - Class methods

+ (CGRect)frameForFrame:(CGRect)frame
{
	return CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height);
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:[[self class] frameForFrame:frame]];
    if (self) {
		self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
		[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - Private methods

- (void)refresh
{
	if (self.isRefreshing)
	{
		CGFloat diff = self.lastTime == 0 ? 0 : self.displayLink.timestamp - self.lastTime;
		[self refreshingWithDelta:diff];
		self.lastTime = self.displayLink.timestamp;
	}
}

#pragma mark - Getter/Setter overrides

- (void)setFrame:(CGRect)frame
{
	[super setFrame:[[self class] frameForFrame:frame]];
}

- (void)setTableView:(UITableView *)tableView
{
	_tableView = tableView;
	[self.tableView addSubview:self];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (!self.isRefreshing)
	{
		CGFloat offset = scrollView.contentOffset.y;
		CGFloat percent = CGFLOAT_MAX;
		if (offset == 0)
			percent = offset;
		else if (offset < 0)
			percent = MIN(ABS(offset) / self.frame.size.height, 1);
		
		if (percent < CGFLOAT_MAX)
			[self amountOfControlVisible:percent];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	CGFloat offset = scrollView.contentOffset.y;
	if (offset <= -self.frame.size.height)
	{
		[self beginRefreshing];
	}
}

#pragma mark - Override these methods

- (void)amountOfControlVisible:(CGFloat)visibility
{
	NSLog(@"Visible: %f", visibility);
}

- (void)refreshingWithDelta:(CGFloat)delta
{
	NSLog(@"Refreshing: %f", delta);
}

- (void)reset
{
	
}

- (void)beginRefreshing
{
	if (!self.isRefreshing)
	{
		_refreshing = YES;
		if (self.tableView)
			self.tableView.userInteractionEnabled = NO;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.2
							 animations:^{
								 [self.tableView setContentInset:UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0)];
								 [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
							 }
							 completion:^(BOOL finished) {
								 if (self.refreshBlock)
									 self.refreshBlock();
							 }];
		});
	}
}

- (void)endRefreshing
{
	[UIView animateWithDuration:0.2
					 animations:^{
						 self.tableView.contentInset = UIEdgeInsetsZero;
					 }
					 completion:^(BOOL finished) {
						 _refreshing = NO;
						 self.lastTime = 0;
						 [self reset];
						 
						 if (self.tableView)
							 self.tableView.userInteractionEnabled = YES;
					 }];
}

@end
