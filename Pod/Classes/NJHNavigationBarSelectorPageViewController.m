//
//  NJHNavigationBarSelectorPageViewController.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//

#import "NJHNavigationBarSelectorPageViewController.h"
#import "NJHNavigationBarBackgroundSelectionView.h"

@implementation NJHNavigationBarSelectorPageViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController pageViewControllers:(NSArray *)pageViewControllers {
    // Calling initWithRootViewController triggers viewDidLoad, so we have to set this variable before init because we need it in viewDidLoad
    [self.viewControllerArray addObjectsFromArray:pageViewControllers];
    
    self = [super initWithRootViewController:rootViewController];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.navigationBar.frame) * 0.65, CGRectGetHeight(self.navigationBar.frame) * 0.7);
    self.navigationView.center = CGPointMake(CGRectGetWidth(self.navigationBar.frame) / 2, CGRectGetHeight(self.navigationBar.frame) / 2);
    [self.navigationBar addSubview:self.navigationView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.navigationView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.navigationBar.frame) * 0.65, CGRectGetHeight(self.navigationBar.frame) * 0.7);
    self.navigationView.center = CGPointMake(CGRectGetWidth(self.navigationBar.frame) / 2, CGRectGetHeight(self.navigationBar.frame) / 2);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // The self.viewControllers array is not constructed until viewWillAppear, so we have to do some initialization here
    if (!self.hasInitialized) {
        self.pageController = (UIPageViewController*)self.viewControllers.firstObject;
        [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        // http://stackoverflow.com/a/28242857/4080860
        // The UIPageViewController does not expose the UIScrollView it uses to scroll between the view controllers it handles
        // so we have to get it ourselves
        
        for (UIScrollView *view in self.pageController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                self.pageScrollView = view;
                self.pageScrollView.delegate = self;
            }
        }
        
        self.initialized = YES;
    }
}

- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point {
    NSInteger section = point.x / CGRectGetWidth(self.navigationView.selectionView.frame);
    NSLog(@"%ld", (long) section);
    
    if (!self.pageScrolling) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        //%%% check to see if you're going left -> right or right -> left
        if (section > tempIndex) {
            
            //%%% scroll through all the objects between the two points
            for (int i = (int)tempIndex+1; i<= section; i++) {
                [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if (complete) {
                        weakSelf.currentPageIndex = i;
                    }
                }];
            }
        }
        
        //%%% this is the same thing but for going right -> left
        else if (section < tempIndex) {
            for (int i = (int)tempIndex-1; i >= section; i--) {
                [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        weakSelf.currentPageIndex = i;
                    }
                }];
            }
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

    CGFloat xFromCenter = self.view.frame.size.width - scrollView.contentOffset.x;
    
    NSLog(@"xFromCenter %f", xFromCenter);

    NSInteger xCoor = CGRectGetWidth(self.navigationBar.frame) * self.currentPageIndex;
    
    NSLog(@"xCoor %ld", (long)xCoor);
    NSLog(@" ");
    
    CGFloat offset = xCoor - xFromCenter;
    NSLog(@"Offset %ld", (long) offset);
    
    CGFloat OldValue = offset;
    
    CGFloat OldMax = CGRectGetWidth(self.navigationBar.frame);
    CGFloat OldMin = 0;
    CGFloat NewMax = CGRectGetWidth(self.navigationView.frame);
    CGFloat NewMin = 0;
    
    CGFloat OldRange = (OldMax - OldMin);
    CGFloat NewRange = (NewMax - NewMin);
    CGFloat NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin;
    
    [self.navigationView setOffsetForSelectionView:NewValue / [self.viewControllerArray count]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllerArray count]) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [self.viewControllerArray indexOfObject:[pageViewController.viewControllers lastObject]];
    }
}

- (NJHNavigationBarBackgroundSelectionView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[NJHNavigationBarBackgroundSelectionView alloc] initWithNumberOfSections:self.viewControllerArray.count namesForSections:[self generateButtonNamesFromViewControllers]];
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

- (void)setPageController:(UIPageViewController *)pageController {
    _pageController = pageController;
    _pageController.delegate = self;
    _pageController.dataSource = self;
}

@end
