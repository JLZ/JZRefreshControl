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
	self.refreshControl = [[MyRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
	self.refreshControl.tableView = self.tableView;
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDelegate + UITableViewDataSource methods

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"StandardCell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.refreshControl scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
