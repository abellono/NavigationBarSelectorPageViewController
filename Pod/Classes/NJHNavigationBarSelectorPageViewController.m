//
//  NJHNavigationBarSelectorPageViewController.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//

#import "NJHNavigationBarSelectorPageViewController.h"
#import "NJHNavigationBarBackgroundSelectionView.h"

/**
 *  The ratio of the background selection view's height to its super view height
 */
static double const kNJHBackgroundSelectionViewVerticalRatio = 0.7;

/**
 *  The ratio of the background selection view's width to its super view width
 */
static double const kNJHBackgroundSelectionViewHorizontalRatio = 0.65;

@interface NJHNavigationBarSelectorPageViewController ()
@property (nonatomic) UINavigationItem *targetNavigationItem;
@property (nonatomic) NSMutableArray *viewControllerArray;
@property (nonatomic, getter=isPageScrolling) BOOL pageScrolling;
@property (nonatomic, getter=isInitialized) BOOL initialized;
@property (nonatomic, readwrite) NSInteger currentPageIndex;
@end

@implementation NJHNavigationBarSelectorPageViewController

- (instancetype)initWithPageViewControllers:(NSArray *)pageViewControllers navigationItem:(UINavigationItem *)navigationItem {
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]) {
        if (!navigationItem) {
            self.targetNavigationItem = self.navigationItem;
        } else {
            self.targetNavigationItem = navigationItem;
        }
        
        [self.viewControllerArray addObjectsFromArray:pageViewControllers];
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.frame) * kNJHBackgroundSelectionViewHorizontalRatio, CGRectGetHeight(self.navigationController.navigationBar.frame) * kNJHBackgroundSelectionViewVerticalRatio);
    self.navigationView.center = CGPointMake(CGRectGetWidth(self.navigationController.navigationBar.frame) / 2, CGRectGetHeight(self.navigationController.navigationBar.frame) / 2);
    
    self.targetNavigationItem.titleView = self.navigationView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // The self.viewControllers array is not constructed until viewWillAppear, so we have to do some initialization here
    if (!self.isInitialized) {
        
        [self setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        // http://stackoverflow.com/a/28242857/4080860
        // The UIPageViewController does not expose the UIScrollView it uses to scroll between the view controllers it handles
        // so we have to get it ourselves
        
        for (UIScrollView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                self.pageScrollView = view;
                self.pageScrollView.delegate = self;
            }
        }
        
        self.initialized = YES;
    }
}

- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point {
    NSInteger section = point.x / CGRectGetWidth(self.navigationView.selectorView.frame);
    
    if (!self.pageScrolling) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        if (section > tempIndex) {
            for (int i = (int)tempIndex+1; i<= section; i++) {
                [self setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    if (complete) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.currentPageIndex = i;
                    }
                }];
            }
        } else if (section < tempIndex) {
            for (int i = (int)tempIndex-1; i >= section; i--) {
                [self setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.currentPageIndex = i;
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
    // The x content offset on a UIScrollView in a UIPageController behaves a tad wierdly.
    
    // When the scroll view is in a resting position displaying any of the view controllers in the page view controller (ie not being scrolled), its x content offset is equal to the
    // width of the page being displayed. Then, as you scroll to the right by moving your finger left across the view, the content offset increases to double that of the the page width,
    // and when you arrive at the next page, resets to the width of the page. When scrolling (moving finger right), the content offset decreases to 0 from the width of the page and when
    // the you arrive at the previous page, resets to the width of the page.
    
    // Because of the behavior explained above, here we subtract the width of the page view from the x content offset of the scroll view in order to obtain a number that describes the
    // current offset from the page that is being displayed. As you swipe left to the next page, this number increases from 0 to the with of the page, and as you swipe right to the previous
    // page, this number decreses from 0 to the negative width of the page
    CGFloat adjustedContentOffset = scrollView.contentOffset.x - CGRectGetWidth(self.view.frame);
    
    // This value represents the total x distance from the very left side of the first view controller being displayed by the page view controller to the left side of the view
    // controller that is currently being displayed. This value stays constant as the user scrolls side to side and serves to differentiate (for example) between a left scroll
    // from the first page to the second page and a left scroll from the second page to the third page, as in both of these cases, the adjustedContentOffset will go from 0 to the
    // width of the page, making it impossible to tell them apart without some secondary number
    NSInteger currentPageOffset = CGRectGetWidth(self.view.frame) * self.currentPageIndex;
    
    // For example, if the user was on the very last page of the view controller array, and we imagine the scroll view is set up as below, and the user starts swiping to the right,
    // the currentPageOffset is the distance from the left side (marked LEFT) and the left side of the last view controller (marked CRT OFFSET). As the user swipes right, the adjustedContentOffset
    // decreases from 0 to the negative width of the page. The finalOffset value calculated below effectively tracks the left side of the user's iphone screen's distance to the location marked
    // LEFT below, allowing us to calculate how much to offset the selection view in the navigation bar
    //
    //
    //                        |-------|  <--- This is the value of the adjusted offset (in this case it is a negative number)
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
    // describes how far the user has scrolled from side to side by dividing by the total length of the scroll view. Once we have this fraction, we multiply by the length
    // of the bacground selection view to figure out how far we should offset the selection view to properly represent the scrolling that has happened on screen
    CGFloat convertedValue = finalOffset / (CGRectGetWidth(self.navigationController.navigationBar.frame) * self.viewControllerArray.count) * CGRectGetWidth(self.navigationView.frame);
    
    [self.navigationView setOffsetForSelectionView:convertedValue];
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
