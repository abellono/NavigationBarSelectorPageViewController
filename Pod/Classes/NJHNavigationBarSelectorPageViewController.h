//
//  NJHNavigationBarSelectorPageViewController.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

@import UIKit;

@class NJHNavigationBarBackgroundSelectionView;

#import "NJHNavigationBarBackgroundSelectionView.h"

/**
 *  A subclass of UIPageController that controlls a page view and syncs it with a view in the navigation bar that shows what page you are located on
 */
@interface NJHNavigationBarSelectorPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

/**
 *  Initialize a NJHNavigationBarSelectorPageViewController with the requried information
 *
 *  @param pageViewControllers The page view controllers to display in the UIPageViewController
 */
- (instancetype)initWithPageViewControllers:(NSArray *)pageViewControllers;

- (instancetype)initWithPageViewControllers:(NSArray *)pageViewControllers navigationItem:(UINavigationItem *)navigationItem;

/**
 *  The view that sits in the navigation bar and indicates what view controller is selected
 */
@property (nonatomic, readonly) NJHNavigationBarBackgroundSelectionView *navigationView;

/**
 *  The index of the current view controller we are displaying
 */
@property (nonatomic, readonly) NSInteger currentPageIndex;

/**
 *  Use this property to specify what percentage of the navigation bar's width the selection view should be. Default 0.6.
 */
@property (nonatomic) CGFloat navigationBarSelectionWidthProportion;

/**
 *  Use this property to specify what percentage of the navigation bar's height the selection view should be. Default 0.6.
 */
@property (nonatomic) CGFloat navigationBarSelectionHeightProportion;

/**
 *  Animates to the next view controller, if there is one
 */
- (void)transitionToNextViewController;

/**
 *  Animates to the previous view controller, if there is one
 */
- (void)transitionToPreviousViewController;

/**
 *  Transition to the view controller at index, if a view controller exists there
 *
 *  @param index The index to transition to
 */
- (void)transitionToViewControllerAtIndex:(NSInteger)index;

@end
