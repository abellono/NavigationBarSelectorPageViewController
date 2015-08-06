//
//  NJHNavigationBarBackgroundSelectionView.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

@class NJHNavigationBarSelectionView;

@import UIKit;

/**
 *  A protocol that defines a method for touch recognizing on the background selection view in order allow the user to
 *  tap a section and subsequently scroll there
 */
@protocol NJHNavigationBarBackgroundSelectionViewDelegate <NSObject>

/**
 *  Called when the user presses the NJHNavigationBarBackgroundSelectionView
 *
 *  @param point The point the user pressed
 */
- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point;

@end

/**
 *  The view that sits on the navigation bar containing the section labels and the section selection view
 */
@interface NJHNavigationBarBackgroundSelectionView : UIControl

/**
 *  Encapsulates the process of instantiating this view from it nib
 *
 *  @param titles The titles of the sections to display on the navigation bar (the length of this array determines the number of sections shown)
 *
 *  @return An instance of this view with its views loaded from the appropriate nib
 */
+ (instancetype)instanceWithViewControllerTitles:(NSArray *)titles;

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
 *  The font for the title labels. Default font is system font of size 10. Can be changed at any time
 */
@property (nonatomic) UIFont *labelFont;

/**
 *  The color to use as the text color on the title labels. Default color is black. Can be changed at any time
 */
@property (nonatomic) UIColor *labelTextColor;

/**
 *  Use this method to inform the view of how far along the scrol view is in its scrolling progress
 *
 *  @param offset A decimal in the range of [0, # of sections - 1 / # of sections] that describes how much the user has scrolled in the scroll view
 */
- (void)setDragCompletionRatio:(CGFloat)ratio;

/**
 *  Sets the label titles that are displayed on the background to indicate what the sections are called. Can be called dynamically to adjust the sections displayed
 */
- (void)setLabelTitles:(NSArray *)titles;

@end
