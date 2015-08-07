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
@interface NJHNavigationBarSelectorPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, NJHNavigationBarBackgroundSelectionViewDelegate>

/**
 *  Initialize a NJHNavigationBarSelectorPageViewController with the requried information
 *
 *  @param pageViewControllers The page view controllers to display on in the UIPageViewController
 *  @param navigationItem      The navigation item that is currently sitting on top of the navigation item stack. If you are pushing this view controller onto the stack
 *                             by itself, you may pass in nil to this argument and the view controller will simply use self.navigationItem. However, if you are embedding this
 *                             view controller inside another view controller that is then pushed on a navigation controller, you must pass in the navigation item for the view
 *                             controller who's navigationItem is being displayed in the navigation bar
 */
- (instancetype)initWithPageViewControllers:(NSArray *)pageViewControllers navigationItem:(UINavigationItem *)navigationItem;

/**
 *  The view that sits in the navigation bar and indicates what view controller is selected
 */
@property (nonatomic) NJHNavigationBarBackgroundSelectionView *navigationView;

/**
 *  The index of the current view controller we are displaying
 */
@property (nonatomic, readonly) NSInteger currentPageIndex;

/**
 *  The color that is set to the scroll view's background color
 */
@property (nonatomic) UIColor *scrollViewBackgroundColor;

/**
 *  Animates to the next view controller, if there is one
 */
- (void)transitionToNextViewController;

/**
 *  Animates to the previous view controller, if there is one
 */
- (void)transitionToPreviousViewController;

/**
 *  Transition to the view controller at index
 *
 *  @param index The index to transition to, if a view controller exists there
 */
- (void)transitionToViewControllerAtIndex:(NSInteger)index;

@end
