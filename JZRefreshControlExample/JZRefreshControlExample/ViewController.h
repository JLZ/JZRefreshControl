//
//  ViewController.h
//  JZRefreshControlExample1
//
//  Created by Jeremy Zedell on 1/20/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyRefreshControl;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MyRefreshControl *refreshControl;

@end
