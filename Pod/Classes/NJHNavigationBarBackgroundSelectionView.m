//
//  NJHNavigationBarBackgroundSelectionView.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

#import "NJHNavigationBarBackgroundSelectionView.h"
#import "NJHNavigationBarBackgroundSelectionView+Private.h"

/**
 *  This is the path to the framework bundle generated by Cocoapods that our xib is contained in. See the instance method for usage
 */
static NSString * const kNJHFrameworkBundleName = @"NJHNavigationBarSelectorPageViewController.bundle";

/**
 *  The space that is inserted between the selection view and the background view on all sides
 */
static CGFloat const kNJHSelectionViewSpacerSize = 1.f;

/**
 *  Default font size for labels
 */
static int const kNJHDefaultFontSize = 10;

/**
 *  Methods that deal with constraints
 */
@interface NJHNavigationBarBackgroundSelectionView (Constraints)

- (void)setupWidthConstraint;
- (void)setupLabelConstraints;

@end

@interface NJHNavigationBarBackgroundSelectionView ()

@property (weak, nonatomic) IBOutlet UIView *selectorView;

/**
 *  The constraint that controls the right to left placement of the selector view. This constraint is anchored to the left side of this view and to
 *  the center x of the selectorView. It is the constraint we manipulate to get the view to move right to left
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateableConstraint;

@property (weak, nonatomic) IBOutlet UIStackView *horizontalLabelStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingStackViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingStackViewConstraint;

@property (nonatomic, weak) id <NJHNavigationBarBackgroundSelectionViewDelegate> delegate;
@property (nonatomic) CGFloat navigationBarSelectionWidthProportion;
@property (nonatomic) CGFloat navigationBarSelectionHeightProportion;

@end

@implementation NJHNavigationBarBackgroundSelectionView

/**
 *  Since we are overriding both the setter and the getter for the following properties, we must synthesize these properties
 */
@synthesize labelFont = _labelFont;
@synthesize labelTextColor = _labelTextColor;

+ (instancetype)instanceWithViewControllerTitles:(NSArray *)titles {
    NSURL *currentBundleURL = [NSBundle bundleForClass:[self class]].bundleURL;
    NSBundle *resourceBundle = [NSBundle bundleWithURL:[currentBundleURL URLByAppendingPathComponent:kNJHFrameworkBundleName]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:resourceBundle];
    NJHNavigationBarBackgroundSelectionView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
    [view createLabelViewsForTitles:titles];
    return view;
}

- (void)createLabelViewsForTitles:(NSArray<NSString *> *)titles {

    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];

        if (!obj) {
#ifdef DEBUG
            NSLog(@"WARNING: view controller at index %@ has no title, using default...", @(idx));
#endif
            obj = @"title";
        }

        label.text = obj;
        label.font = self.labelFont;
        label.textColor = self.labelTextColor;

        [self.horizontalLabelStackView addArrangedSubview:label];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(viewTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionViewWidthConstraint.priority = UILayoutPriorityRequired - 2;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (@available(iOS 11.0, *)) {
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview attribute:NSLayoutAttributeWidth
                                                                  multiplier:self.navigationBarSelectionWidthProportion constant:0]];

        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview attribute:NSLayoutAttributeHeight
                                                                  multiplier:self.navigationBarSelectionHeightProportion constant:0]];
    }

    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectorView.layer.cornerRadius = CGRectGetHeight(self.selectorView.frame) / 2;
}

- (void)layoutSubviews {
    CGFloat selectorViewWidth = [self widthForSelectionView];
    self.selectionViewWidthConstraint.constant = selectorViewWidth;

    CGFloat firstLabelWidth = CGRectGetWidth(self.horizontalLabelStackView.arrangedSubviews.firstObject.frame);
    self.leadingStackViewConstraint.constant = selectorViewWidth / 2 - firstLabelWidth / 2;

    CGFloat lastLabelWidth = CGRectGetWidth(self.horizontalLabelStackView.arrangedSubviews.lastObject.frame);
    self.trailingStackViewConstraint.constant = selectorViewWidth / 2 - lastLabelWidth / 2;

    [super layoutSubviews];

    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectorView.layer.cornerRadius = CGRectGetHeight(self.selectorView.frame) / 2;
}

- (void)viewTapped:(NJHNavigationBarBackgroundSelectionView *)view event:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:view] anyObject];
    [self.delegate userDidTapBackgroundSelectionViewAtLocation:[touch locationInView:view]];
}

- (void)setDragCompletionRatio:(CGFloat)ratio {
    self.animateableConstraint.constant = [self widthForSelectionView] / 2.f + [self calculateOffsetWithCompletionRatio:ratio];
}

- (CGFloat)calculateOffsetWithCompletionRatio:(CGFloat)ratio {
    // If the ratio is 0, we want our output to be 1, which is why we add the spacer size at the very end
    return ratio * CGRectGetWidth(self.frame) + kNJHSelectionViewSpacerSize;
}

- (CGFloat)widthForSelectionView {
    CGFloat width = CGRectGetWidth(self.frame) / (CGFloat)self.horizontalLabelStackView.arrangedSubviews.count;
    return width - 2 * kNJHSelectionViewSpacerSize;
}

- (void)setFrame:(CGRect)frame {
    CGFloat oldWidth = CGRectGetWidth(self.frame);
    
    [super setFrame:frame];
    
    if (CGRectGetWidth(frame) != oldWidth) {
        // If we have been set to a new width, make sure to allign the selector view correctly
        [self setDragCompletionRatio:0];
    }
}

- (void)setLabelTextColor:(UIColor *)colorForLabels {
    _labelTextColor = colorForLabels;
    
    for (UILabel *label in self.horizontalLabelStackView.arrangedSubviews) {
        label.textColor = colorForLabels;
    }
}

- (UIColor *)labelTextColor {
    if (!_labelTextColor) {
        _labelTextColor = [UIColor blackColor];
    }
    
    return _labelTextColor;
}

- (void)setLabelFont:(UIFont *)fontForLabels {
    _labelFont = fontForLabels;
    
    for (UILabel *label in self.horizontalLabelStackView.arrangedSubviews) {
        label.font = fontForLabels;
    }
}

- (UIFont *)labelFont {
    if (!_labelFont) {
        _labelFont = [UIFont systemFontOfSize:kNJHDefaultFontSize];
    }
    
    return _labelFont;
}

@end
