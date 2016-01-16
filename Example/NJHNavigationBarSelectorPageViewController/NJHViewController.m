//
//  NJHViewController.m
//  NJHNavigationBarSelectorPageViewController
//
//  Created by Hakon Hanesand on 07/29/2015.
//  Copyright (c) 2015 Hakon Hanesand. All rights reserved.
//

@import NJHNavigationBarSelectorPageViewController;

#import "NJHViewController.h"

@interface NJHViewController ()
@property (nonatomic) NJHNavigationBarSelectorPageViewController *swipeController;
@end

@implementation NJHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *one = [[UIViewController alloc] init];
    UIViewController *two = [[UIViewController alloc] init];
    UIViewController *three = [[UIViewController alloc] init];
    UIViewController *four = [[UIViewController alloc] init];
    
    one.view.backgroundColor = [UIColor redColor];
    one.title = @"1";
    two.view.backgroundColor = [UIColor whiteColor];
    two.title = @"2";
    three.view.backgroundColor = [UIColor greenColor];
    three.title = @"3";
    four.view.backgroundColor = [UIColor blueColor];
    four.title = @"4";
    
    self.swipeController = [[NJHNavigationBarSelectorPageViewController alloc] initWithPageViewControllers:@[one, two, three, four] navigationItem:self.navigationItem];
    
    self.swipeController.navigationBarSelectionWidthProportion = 0.9;
    
    self.swipeController.view.backgroundColor = [UIColor blackColor];
    
    [self addChildViewController:self.swipeController];
    [self.view addSubview:self.swipeController.view];
    [self.swipeController didMoveToParentViewController:self];
}

@end
