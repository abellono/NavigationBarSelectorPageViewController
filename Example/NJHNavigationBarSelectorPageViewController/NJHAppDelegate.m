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
    
    UIViewController *one = [[UIViewController alloc] init];
    UIViewController *two = [[UIViewController alloc] init];
    UIViewController *three = [[UIViewController alloc] init];
    
    one.view.backgroundColor = [UIColor redColor];
    one.title = @"1";
    two.view.backgroundColor = [UIColor whiteColor];
    two.title = @"2";
    three.view.backgroundColor = [UIColor greenColor];
    three.title = @"3";
    
    NJHNavigationBarSelectorPageViewController *pageController = [[NJHNavigationBarSelectorPageViewController alloc] initWithPageViewControllers:@[one, two, three] navigationItem:nil];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pageController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
