//
//  JZRefreshControl.m
//
// Copyright (C) 2014 Jeremy Zedell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "JZRefreshControl.h"

@interface JZRefreshControl()
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL processingEnd;
+ (CGRect)frameForFrame:(CGRect)frame;
- (void)refresh;
- (void)beginRefreshingWithTargetContentOffset:(inout CGPoint *)targetContentOffset;
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
		self.displayLink.paused = YES;
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
	[self.tableView insertSubview:self atIndex:0];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (!self.isRefreshing)
	{
		CGFloat offset = scrollView.contentOffset.y + self.tableView.contentInset.top;
		CGFloat percent = CGFLOAT_MAX;
		if (offset == 0)
			percent = offset;
		else if (offset < 0)
			percent = MIN(ABS(offset) / self.frame.size.height, 1);
		
		if (percent < CGFLOAT_MAX)
			[self amountOfControlVisible:percent];
	}
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	CGFloat offset = scrollView.contentOffset.y + self.tableView.contentInset.top;
	if (offset <= -self.frame.size.height)
		[self beginRefreshingWithTargetContentOffset:targetContentOffset];
}

#pragma mark - Override these methods

- (void)amountOfControlVisible:(CGFloat)visibility
{
	
}

- (void)refreshingWithDelta:(CGFloat)delta
{
	
}

- (void)reset
{
	
}

#pragma mark - Refreshing methods

- (void)beginRefreshingWithTargetContentOffset:(inout CGPoint *)targetContentOffset
{
	if (!self.isRefreshing)
	{
		_refreshing = YES;
		self.displayLink.paused = NO;
		if (self.tableView)
			self.tableView.userInteractionEnabled = NO;
		
		CGFloat newInset = self.tableView.contentInset.top + self.frame.size.height;
		// If positive targetContentOffset.y, it means the scrollview was scrolled
		// upward on release. In this case, we need to change the targetContentOffset
		// so the scrollview does not scroll past the refresh control, causing it to
		// not be visible.
		if (targetContentOffset->y > 0 && targetContentOffset->y < CGFLOAT_MAX)
		{
			targetContentOffset->y = -self.frame.size.height;
			[self.tableView setContentInset:UIEdgeInsetsMake(newInset, 0, 0, 0)];
			if (self.refreshBlock)
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					self.refreshBlock();
				});
			}
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				[UIView animateWithDuration:0.2
								 animations:^{
								 [self.tableView setContentInset:UIEdgeInsetsMake(newInset, 0, 0, 0)];
								 [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
								 }
								 completion:^(BOOL finished) {
									 if (self.refreshBlock)
									 {
										 dispatch_async(dispatch_get_main_queue(), ^{
											 self.refreshBlock();
										 });
									 }
								 }];
			});
		}
	}
}

- (void)beginRefreshing
{
	CGPoint point = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
	[self beginRefreshingWithTargetContentOffset:&point];
}

- (void)endRefreshing
{
	if (self.isRefreshing && !self.processingEnd)
	{
		self.processingEnd = YES;
		[UIView animateWithDuration:0.2
						 animations:^{
							 self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top - self.frame.size.height, 0, 0, 0);
						 }
						 completion:^(BOOL finished) {
							 self.lastTime = 0;
							 [self reset];
							 
							 if (self.tableView)
								 self.tableView.userInteractionEnabled = YES;
							 
							 _refreshing = NO;
							 self.processingEnd = NO;
							 self.displayLink.paused = YES;
						 }];
	}
}

@end
