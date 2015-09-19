//
//  NJHNavigationBarBackgroundSelectionView.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

#import "NJHNavigationBarBackgroundSelectionView.h"

/**
 *  This is the path to the framework bundle generated by Cocoapods that our xib is contained in. See the instance method for usage
 */
static NSString * const kNJHFrameworkBundleName = @"/Frameworks/NJHNavigationBarSelectorPageViewController.framework/";

/**
 *  The space that is inserted between the selection view and the background view on all sides
 */
static CGFloat const kNJHSelectionViewSpacerSize = 1.f;

static CGFloat const kNJHLabelSpacingSize = 40.f;

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

/**
 *  The constraint that controls the right to left placement of the selector view. This constraint is anchored to the left side of this view and to
 *  the center x of the selectorView. It is the constraint we manipulate to get the view to move right to left
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateableConstraint;

/**
 *  The number of sections this selection view should display, calculated from the labelTitles array
 */
@property (nonatomic) NSUInteger sections;

/**
 *  One for each section we are displaying
 */
@property (nonatomic) NSMutableArray *labels;

/**
 *  The titles for the labels on the navigation bar
 */
@property (nonatomic) NSArray *labelTitles;

@end

@implementation NJHNavigationBarBackgroundSelectionView

/**
 *  Since we are overriding both the setter and the getter for the following properties, we must synthesize these properties
 */
@synthesize labelFont = _labelFont;
@synthesize labelTextColor = _labelTextColor;

+ (instancetype)instanceWithViewControllerTitles:(NSArray *)titles {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle].bundlePath stringByAppendingString:kNJHFrameworkBundleName]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:resourceBundle];
    NJHNavigationBarBackgroundSelectionView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
    [view setLabelTitles:titles];
    return view;
}

/**
 *  Set the selection view's width to be the width of this view times the inverse of the
 *  number of sections, minus 2 pixels total for space on left and right sides
 */
- (void)setupWidthConstraint {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.selectorView attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.f / (CGFloat)self.sections
                                                                   constant:-2 * kNJHSelectionViewSpacerSize];
    
    // Let the system break this constraint when we are compressed against the sides of the background view
    constraint.priority = UILayoutPriorityRequired - 1;
    [self addConstraint:constraint];
}

/**
 *  Align the labels evenly along the center y axis of their superview (this class) with equal spacing between them
 */
- (void)setupLabelConstraints {
    CGFloat min = 1.f / self.labels.count;
    CGFloat max = 2.f - min;
    CGFloat delta = (max - min) / (self.labels.count - 1);
    
    [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:(CGFloat)idx * delta + min constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterY
                                                        multiplier:1 constant:0]];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.selectorView];
    
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addTarget:self action:@selector(viewTapped:event:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectorView.layer.cornerRadius = CGRectGetHeight(self.selectorView.frame) / 2;
}

- (void)configureView {
    self.sections = [self.labelTitles count];
    [self createLabelViews];
    
    [self setupWidthConstraint];
    [self setupLabelConstraints];
}

- (void)resetView {
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
}

- (void)createLabelViews {
    [self.labelTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = (NSString *)obj;
        label.font = self.labelFont;
        label.textColor = self.labelTextColor;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.labels addObject:label];
        [self addSubview:label];
    }];
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
    return CGRectGetWidth(self.frame) / (CGFloat)self.sections - 2.f * kNJHSelectionViewSpacerSize; // 2x because there is space on the right and left sides
}

- (void)setFrame:(CGRect)frame {
    CGFloat oldWidth = CGRectGetWidth(self.frame);
    
    [super setFrame:frame];
    
    if (CGRectGetWidth(frame) != oldWidth) {
        // If we have been set to a new width, make sure to allign the selector view correctly
        [self setDragCompletionRatio:0];
    }
}

- (void)setLabelTitles:(NSArray *)titles {
    _labelTitles = titles;
    [self resetView];
    [self configureView];
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray new];
    }
    
    return _labels;
}

- (void)setLabelTextColor:(UIColor *)colorForLabels {
    _labelTextColor = colorForLabels;
    
    for (UILabel *label in self.labels) {
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
    
    for (UILabel *label in self.labels) {
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
