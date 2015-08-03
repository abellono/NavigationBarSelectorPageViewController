//
//  NJHNavigationBarBackgroundSelectionView.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

@class NJHNavigationBarSelectionView;

@import UIKit;

@protocol NJHNavigationBarBackgroundSelectionViewDelegate <NSObject>

/**
 *  Called when the user presses the NJHNavigationBarBackgroundSelectionView
 *
 *  @param point The point the user pressed
 */
- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point;

@end

@interface NJHNavigationBarBackgroundSelectionView : UIControl

/**
 *  Encapsulates the process of instantiating this view from it nib
 *
 *  @return An instance of this view with its views loaded from the appropriate nib
 */
+ (instancetype)instance;

/**
 *  The delegate of this view that is notified if the user taps the navigation bar at a certain position, usually
 *  to indicate that the user wishes to navigate to that section
 */
@property (nonatomic, weak) id <NJHNavigationBarBackgroundSelectionViewDelegate> delegate;

/**
 *  The view that slides around on top of this background view to signify what view controller is selected
 */
@property (weak, nonatomic) IBOutlet UIView *selectorView;

/**
 *  The titles for the labels displayed under the selection view, normally the titles of the view controllers
 *  that can be selected
 */
@property (nonatomic) NSArray *labelTitles;

/**
 *  The font for the title labels. Default font is system font of size 10
 */
@property (nonatomic) UIFont *fontForLabels;

/**
 *  The color to use as the text color on the title labels. Default color is black
 */
@property (nonatomic) UIColor *colorForLabels;

/**
 *  The method that controls the offset of the selection view, usually hooked up to a scroll view delegate
 *
 *  @param offset The distance to offset the selection view on the x axis
 */
- (void)setOffsetForSelectionView:(CGFloat)offset;

@end
