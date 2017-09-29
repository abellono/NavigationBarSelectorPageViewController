//
//  NJHNavigationBarBackgroundSelectionView.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//

@class NJHNavigationBarSelectionView;

@import UIKit;

/**
 *  The view that sits on the navigation bar containing the section labels and the section selection view
 */
@interface NJHNavigationBarBackgroundSelectionView : UIControl

+ (instancetype)instanceWithViewControllerTitles:(NSArray *)titles;

/**
 *  The view that slides around on top of this background view to signify what view controller is selected.
 */
@property (weak, nonatomic, readonly) IBOutlet UIView *selectorView;

/**
 *  The font for the title labels. Default font is system font of size 10. Can be changed at any time.
 */
@property (nonatomic) UIFont *labelFont;

/**
 *  The color to use as the text color on the title labels. Default color is black. Can be changed at any time.
 */
@property (nonatomic) UIColor *labelTextColor;

@end
