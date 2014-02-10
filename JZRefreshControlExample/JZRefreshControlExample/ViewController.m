//
//  ViewController.m
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import "ViewController.h"
#import "MyRefreshControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.refreshControl = [[MyRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [MyRefreshControl height])];
	self.refreshControl.tableView = self.tableView;
	__weak ViewController *weakSelf = self;
	self.refreshControl.refreshBlock = ^{
		double delayInSeconds = 3;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[weakSelf.refreshControl endRefreshing];
		});
	};
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.refreshControl beginRefreshing];
}

#pragma mark - UITableViewDelegate + UITableViewDataSource methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"StandardCell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell #%ld", (long)indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.refreshControl beginRefreshing];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 20;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.refreshControl scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	[self.refreshControl scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

@end
