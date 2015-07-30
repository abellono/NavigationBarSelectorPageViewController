//
//  NJHNavigationBarBackgroundSelectionView.h
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

@class NJHNavigationBarSelectionView;

@import UIKit;

@interface NJHNavigationBarBackgroundSelectionView : UIView

- (instancetype)initWithNumberOfSections:(NSUInteger)sections namesForSections:(NSArray *)names;

/**
 *  The view that slides around on top of this background view to signify what view controller is selected
 */
@property (nonatomic) UIView *selectionView;

/**
 *  One for each section on the background
 */
@property (nonatomic) NSMutableArray *labels;

@property (nonatomic) UIFont *fontForLabels;

- (void)setOffsetForSelectionView:(CGFloat)offset;

@end
