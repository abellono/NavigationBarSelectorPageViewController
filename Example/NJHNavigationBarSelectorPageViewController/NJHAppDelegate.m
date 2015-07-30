//
//  NJHAppDelegate.m
//  NJHNavigationBarSelectorPageViewController
//
//  Created by Hakon Hanesand on 07/29/2015.
//  Copyright (c) 2015 Hakon Hanesand. All rights reserved.
//

#import "NJHAppDelegate.h"

@import NJHNavigationBarSelectorPageViewController;

@implementation NJHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    UIViewController *demo = [[UIViewController alloc] init];
    UIViewController *demo2 = [[UIViewController alloc] init];
    UIViewController *demo3 = [[UIViewController alloc] init];
    
    demo.view.backgroundColor = [UIColor redColor];
    demo.title = @"1";
    demo2.view.backgroundColor = [UIColor whiteColor];
    demo2.title = @"2";
    demo3.view.backgroundColor = [UIColor greenColor];
    demo3.title = @"3";
    
    NJHNavigationBarSelectorPageViewController *navigationController = [[NJHNavigationBarSelectorPageViewController alloc] initWithRootViewController:pageController pageViewControllers:@[demo, demo2, demo3]];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
