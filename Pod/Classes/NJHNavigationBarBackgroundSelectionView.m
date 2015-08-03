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
 *  One for each section on the
 */
@property (nonatomic) NSMutableArray *labels;
@end

@implementation NJHNavigationBarBackgroundSelectionView

/**
 *  Since we are overriding both the setter and the getter for the following properties, we must synthesize them
 */
@synthesize fontForLabels = _fontForLabels;
@synthesize colorForLabels = _colorForLabels;

+ (instancetype)instance {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle].bundlePath stringByAppendingString:kNJHFrameworkBundleName]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:resourceBundle];
    return [[nib instantiateWithOwner:nil options:nil] firstObject];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.sections = [self.labelTitles count];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.selectorView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.f / (CGFloat)self.sections
                                                                   constant:0];
    
    constraint.priority = 999;
    [self addConstraint:constraint];
    
    [self createLabelViews];
    
    [self addTarget:self action:@selector(viewTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectorView.layer.cornerRadius = CGRectGetHeight(self.selectorView.frame) / 2;
}

- (void)createLabelViews {
    [self.labelTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = (NSString *)obj;
        label.font = self.fontForLabels;
        [label sizeToFit];
        
        [self.labels addObject:label];
        [self addSubview:label];
    }];
}

- (void)viewTapped:(NJHNavigationBarBackgroundSelectionView *)view event:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:view] anyObject];
    [self.delegate userDidTapBackgroundSelectionViewAtLocation:[touch locationInView:view]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat sectionWidth = CGRectGetWidth(self.frame) / self.labels.count;
    
    // Position as many labels as we need on this navigation background view
    //
    // Assuming names.count is 2, then sw represents the sectionWidth, and we have to calculate the
    // frames for the two labels
    //
    // /--------------------------------------------\
    // |                    |                       |
    // |     Label Here     sw      Label Here      |
    // |                    |                       |
    // \--------------------------------------------/
    [self.labels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = (UILabel *)obj;
        label.center = CGPointMake(idx * sectionWidth + sectionWidth / 2, CGRectGetHeight(self.frame) / 2);
    }];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectorView.layer.cornerRadius = CGRectGetHeight(self.selectorView.frame) / 2;
}

- (void)setOffsetForSelectionView:(CGFloat)offset {
    self.animateableConstraint.constant = [self widthForSelectionView] / 2 + offset;
}

- (CGFloat)widthForSelectionView {
    return CGRectGetWidth(self.frame) / (CGFloat)self.sections - 2.f;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray new];
    }
    
    return _labels;
}

- (void)setColorForLabels:(UIColor *)colorForLabels {
    _colorForLabels = colorForLabels;
    
    for (UILabel *label in self.labels) {
        label.textColor = colorForLabels;
    }
}

- (UIColor *)colorForLabels {
    if (!_colorForLabels) {
        _colorForLabels = [UIColor blackColor];
    }
    
    return _colorForLabels;
}

- (void)setFontForLabels:(UIFont *)fontForLabels {
    _fontForLabels = fontForLabels;
    
    for (UILabel *label in self.labels) {
        label.font = fontForLabels  ;
    }
}

- (UIFont *)fontForLabels {
    if (!_fontForLabels) {
        _fontForLabels = [UIFont systemFontOfSize:10];
    }
    
    return _fontForLabels;
}

@end
