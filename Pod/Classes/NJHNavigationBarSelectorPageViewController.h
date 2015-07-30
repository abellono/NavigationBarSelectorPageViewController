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

@interface NJHNavigationBarSelectorPageViewController : UINavigationController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, NJHNavigationBarBackgroundSelectionViewDelegate>

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController pageViewControllers:(NSArray *)pageViewControllers;

@property (nonatomic) NSMutableArray *viewControllerArray;
@property (nonatomic) NJHNavigationBarBackgroundSelectionView *navigationView;


@property (nonatomic) UIPageViewController *pageController;

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;

@property (nonatomic, getter=isPageScrolling) BOOL pageScrolling;
@property (nonatomic, getter=hasInitialized) BOOL initialized;

@end
