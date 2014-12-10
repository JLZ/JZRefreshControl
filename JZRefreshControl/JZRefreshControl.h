//
//  JZRefreshControl.h
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

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)(void);

@interface JZRefreshControl : UIView <UIScrollViewDelegate>

/**
 A reference to the UITableView the refresh control will be added to
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 The block that will be called when a pull to refresh is detected
*/
@property (nonatomic, copy) VoidBlock refreshBlock;

/**
 Read-only property which can be used to check the state of the refresh control
 @discussion isRefreshing == YES if refresh is in progress.
 *** Note, the UITableView will have user interaction disabled during refresh.
 */
@property (nonatomic, assign, getter = isRefreshing, readonly) BOOL refreshing;

/**
 This method will be called repeatedly whenever the refresh control is visible on screen.
 @param visibility The vertical percentage of the refresh control that is currently visible (ranges from 0 - 1).
 The visibility value can be used to animate the positioning of elements in the refresh control to prepare them
 for the refresh animation.
 */
- (void)amountOfControlVisible:(CGFloat)visibility;

/**
 This method will be called at every display frame while the refresh is in progress.
 @param delta The amount of time in seconds that has passed since the last time this method was called. If the
 display is running at 60 fps, delta will be ~1/60 of a second every time the method is called.
 @discussion The refresh does not begin until the user releases the UITableView
 */
- (void)refreshingWithDelta:(CGFloat)delta;

/**
 Call this method if you would like to manually trigger a refresh.
 @discussion Upon calling this method, the UITableView will automatically scroll to reveal the refresh control.
 The refreshBlock will then be called and refreshingWithDelta: will begin firing.
 *** Note, amountOfControlVisible: will NOT be called when a manual refresh is triggered via this method.
 */
- (void)beginRefreshing;

/**
 Call this method once you have finished refreshing your content.
 @discussion Upon calling this method, the refresh control will hide itself and user interaction will be enabled
 on the UITableView.
 */
- (void)endRefreshing;

/**
 This method will be called once endRefreshing finishes. In your implementation of reset, you should reposition
 your views as they should be at the beginning of a refresh.
 */
- (void)reset;

@end
