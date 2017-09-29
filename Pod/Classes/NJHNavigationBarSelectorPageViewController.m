//
//  NJHNavigationBarSelectorPageViewController.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//

#import "NJHNavigationBarSelectorPageViewController.h"
#import "NJHNavigationBarBackgroundSelectionView.h"

#import "NJHNavigationBarBackgroundSelectionView+Private.h"

@interface NJHNavigationBarSelectorPageViewController () <NJHNavigationBarBackgroundSelectionViewDelegate>

@property (nonatomic) NJHNavigationBarBackgroundSelectionView *navigationView;

@property (nonatomic) NSInteger currentPageIndex;

@property (nonatomic) NSMutableArray *viewControllerArray;
@property (nonatomic, getter=isPageScrolling) BOOL pageScrolling;
@property (nonatomic, getter=isInitialized) BOOL initialized;

@property (nonatomic, weak) UIScrollView *pageScrollView;
@end

@implementation NJHNavigationBarSelectorPageViewController

- (instancetype)initWithPageViewControllers:(NSArray *)pageViewControllers {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    if (self) {
        _viewControllerArray = pageViewControllers.mutableCopy;
        _navigationBarSelectionWidthProportion = 0.6;
        _navigationBarSelectionHeightProportion = 0.6;

        self.delegate = self;
        self.dataSource = self;
    }

    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateSelectorViewWithScrollView:self.pageScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSAssert(self.navigationController, @"%@ must be contained inside a UINavigationController.", NSStringFromClass([NJHNavigationBarSelectorPageViewController class]));
    self.navigationItem.titleView = self.navigationView;

    // The self.viewControllers array is not constructed until viewWillAppear, so we have to do some initialization here
    if (!self.isInitialized) {

        [self.navigationController.navigationBar addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationView attribute:NSLayoutAttributeWidth
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeWidth
                                                                                           multiplier:self.navigationBarSelectionWidthProportion constant:0]];

        [self.navigationController.navigationBar addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationView attribute:NSLayoutAttributeHeight
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeHeight
                                                                                           multiplier:self.navigationBarSelectionHeightProportion constant:0]];
        
        [self setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        // http://stackoverflow.com/a/28242857/4080860
        // The UIPageViewController does not expose the UIScrollView it uses to scroll between the view controllers it handles so we have to get it ourselves
        for (UIScrollView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                self.pageScrollView = view;
                self.pageScrollView.delegate = self;
            }
        }
        
        self.initialized = YES;
    }

    NSAssert(self.initialized, @"Must be inititalized here");
}

- (void)transitionToNextViewController {
    [self transitionToViewControllerAtIndex:self.currentPageIndex + 1];
}

- (void)transitionToPreviousViewController {
    [self transitionToViewControllerAtIndex:self.currentPageIndex - 1];
}

- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point {
    NSInteger section = point.x / CGRectGetWidth(self.navigationView.selectorView.frame);
    [self transitionToViewControllerAtIndex:section];
}

- (void)transitionToViewControllerAtIndex:(NSInteger)destinationIndex {
    if (destinationIndex >= self.viewControllerArray.count || destinationIndex < 0) {
        NSLog(@"Can not tranisition to view controller at index %ld.", (long)destinationIndex);
        return;
    }
    
    if (!self.pageScrolling) {
        self.pageScrolling = YES;
        int currentStartIndex = (int)self.currentPageIndex;
        __weak typeof(self) __weak_self = self;

        BOOL forwards = destinationIndex > currentStartIndex;
        UIPageViewControllerNavigationDirection direction = forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        // Scrolls through the pages between currentPageIndex and destination to show the user where we are transitioning to
        for (int i = forwards ? currentStartIndex + 1 : currentStartIndex - 1; forwards ? i <= destinationIndex : i >= destinationIndex; forwards ? i++ : i--) {
            [self setViewControllers:@[self.viewControllerArray[i]] direction:direction animated:YES completion:^(BOOL finished) {
                if (finished) {
                    __strong typeof(__weak_self) __strong_self = __weak_self;
                    __strong_self.currentPageIndex = i;
                    __strong_self.pageScrolling = i != destinationIndex;
                }
            }];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageScrolling = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageScrolling = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSelectorViewWithScrollView:scrollView];
}

- (void)updateSelectorViewWithScrollView:(UIScrollView *)scrollView {
    if (CGRectGetWidth(self.navigationController.navigationBar.frame) < 0.00001) {
        // This can happen if the user pops the view controller while the scroll view is moving
        // Continuing would cause division by 0
        return;
    }
    
    // When the scroll view is not being scrolled, its x content offset is equal to the width of the page being displayed. Then, as you scroll to the
    // right by moving your finger left across the view, the content offset increases to double that of the the page width, and when you arrive at the
    // next page, the content offset resets to the width of the page. When scrolling to the left (moving finger right), the content offset decreases
    // to 0 from the width of the page and when the you arrive at the previous page, resets to the width of the page.
    
    // `adjustedContentOffset` describes the current offset from the page that is being displayed. As you swipe left to the next page, this number
    // increases from 0 to the with of the page, and as you swipe right to the previous page, this number decreses from 0 to the negative width of the page.
    CGFloat adjustedContentOffset = scrollView.contentOffset.x - CGRectGetWidth(self.view.frame);
    
    // Imagine you put all the view controllers in the view controllers array side by side. This value is the total x distance from the left edge
    // of the first view controller to the left edge of the currently displayed view controller.
    NSInteger currentPageOffset = CGRectGetWidth(self.view.frame) * self.currentPageIndex;

    //                   adjustedContentOffset
    //                            ^
    //                        <-------|
    //
    //                        /-IPHONE SCREEN-\
    // /-------------\ /------|------\ /------|------\
    // |             | |      F      |C|      |      |
    // |             | |      I      |R|      |      |
    // |L            | |      N      |T|      |      |
    // |E            | |      |      | |  PAGE CURR  |
    // |F            | |      O      |O|  DISPLAYED  |
    // |T            | |      F      |F|      |      |
    // |             | |      S      |S|      |      |
    // |             | |      E      |E|      |      |
    // |             | |      T      |T|      |      |
    // \-------------/ \------|------/ \------|------/
    //                        \---------------/
    CGFloat finalOffset = currentPageOffset + adjustedContentOffset;
    
    // Since the final offset is the distance from the "left" most view in the diagram above to the left side of the screen, it can be converted into a fraction that
    // describes how far the user has scrolled from side to side by dividing by the total length of the scroll view. We pass this decimal (range [0, # of vc - 1 / # of vc]) to the view.
    CGFloat completionRatio = finalOffset / (CGRectGetWidth(self.navigationController.navigationBar.frame) * self.viewControllerArray.count);
    
    [self.navigationView setDragCompletionRatio:completionRatio];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return [self.viewControllerArray objectAtIndex:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    
    if (index == NSNotFound || index == [self.viewControllerArray count] - 1) {
        return nil;
    }
    
    return [self.viewControllerArray objectAtIndex:++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [self.viewControllerArray indexOfObject:[pageViewController.viewControllers lastObject]];
    }
}

- (NJHNavigationBarBackgroundSelectionView *)navigationView {
    if (!_navigationView) {
        _navigationView = [NJHNavigationBarBackgroundSelectionView instanceWithViewControllerTitles:[self generateButtonNamesFromViewControllers]];
        _navigationView.delegate = self;
    }
    
    return _navigationView;
}

- (NSArray *)generateButtonNamesFromViewControllers {
    NSMutableArray *viewControllerTitles = [NSMutableArray new];
    
    for (UIViewController *pageViewController in self.viewControllerArray) {
        [viewControllerTitles addObject:pageViewController.title];
    }
    
    return viewControllerTitles;
}

- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray new];
    }
    
    return _viewControllerArray;
}

@end
