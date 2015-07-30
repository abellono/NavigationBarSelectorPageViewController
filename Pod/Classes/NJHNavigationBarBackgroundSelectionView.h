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

- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point;

@end

@interface NJHNavigationBarBackgroundSelectionView : UIControl

- (instancetype)initWithNumberOfSections:(NSUInteger)sections namesForSections:(NSArray *)names;

@property (nonatomic, weak) id <NJHNavigationBarBackgroundSelectionViewDelegate> delegate;

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
