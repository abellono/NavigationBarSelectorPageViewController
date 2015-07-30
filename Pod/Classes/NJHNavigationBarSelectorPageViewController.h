//
//  NJHNavigationBarSelectorPageViewController.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

@import UIKit;

@class NJHNavigationBarBackgroundSelectionView;

@protocol NJHNavigationBarSelectorPageViewControllerDelegate <NSObject>

@end

@interface NJHNavigationBarSelectorPageViewController : UINavigationController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController pageViewControllers:(NSArray *)pageViewControllers;

@property (nonatomic) NSMutableArray *viewControllerArray;
@property (nonatomic) NJHNavigationBarBackgroundSelectionView *navigationView;

@property (nonatomic, weak) id<NJHNavigationBarSelectorPageViewControllerDelegate> navDelegate;


@property (nonatomic) UIPageViewController *pageController;

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;

@property (nonatomic, getter=isPageScrolling) BOOL pageScrolling;
@property (nonatomic, getter=hasInitialized) BOOL initialized;

////%%% customizeable button attributes
//@property (nonatomic) CGFloat X_BUFFER; //%%% the number of pixels on either side of the segment
//@property (nonatomic) CGFloat Y_BUFFER; //%%% number of pixels on top of the segment
//@property (nonatomic) CGFloat HEIGHT; //%%% height of the segment
//
////%%% customizeable selector bar attributes (the black bar under the buttons)
//@property (nonatomic) CGFloat BOUNCE_BUFFER ; //%%% adds bounce to the selection bar when you scroll
//@property (nonatomic) CGFloat ANIMATION_SPEED; //%%% the number of seconds it takes to complete the animation
//@property (nonatomic) CGFloat SELECTOR_Y_BUFFER; //%%% the y-value of the bar that shows what page you are on (0 is the top)
//@property (nonatomic) CGFloat SELECTOR_HEIGHT; //%%% thickness of the selector bar
//
//@property (nonatomic) CGFloat X_OFFSET; //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@end
