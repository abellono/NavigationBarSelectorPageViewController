//
//  NJHNavigationBarBackgroundSelectionView+Private.h
//  NJHNavigationBarSelectorPageViewController
//
//  Created by Hakon Hanesand on 9/28/17.
//

@protocol NJHNavigationBarBackgroundSelectionViewDelegate <NSObject>

- (void)userDidTapBackgroundSelectionViewAtLocation:(CGPoint)point;

@end

@interface NJHNavigationBarBackgroundSelectionView (Private)

@property (nonatomic, weak) id <NJHNavigationBarBackgroundSelectionViewDelegate> delegate;

- (void)setDragCompletionRatio:(CGFloat)ratio;
+ (instancetype)instanceWithViewControllerTitles:(NSArray *)titles;

@end
