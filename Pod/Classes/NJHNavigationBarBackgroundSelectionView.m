//
//  NJHNavigationBarBackgroundSelectionView.m
//  Pods
//
//  Created by Hakon Hanesand on 7/29/15.
//
//

#import "NJHNavigationBarBackgroundSelectionView.h"

@interface NJHNavigationBarBackgroundSelectionView ()
@property (nonatomic) NSUInteger sections;
@end

@implementation NJHNavigationBarBackgroundSelectionView

- (instancetype)initWithNumberOfSections:(NSUInteger)sections namesForSections:(NSArray *)names {
    if (self = [super init]) {
        self.sections = sections;
        [self createLabelViewsWithNames:names];
    }
    
    return self;
}

- (void)createLabelViewsWithNames:(NSArray *)names {
    [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = (NSString *)obj;
        label.font = self.fontForLabels;
        [label sizeToFit];
        
        [self.labels addObject:label];
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.backgroundColor = [UIColor blueColor];
    [self addSubview:self.selectionView];
    self.selectionView.backgroundColor = [UIColor greenColor];
    
    for (UILabel *label in self.labels) {
        [self addSubview:label];
    }
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
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
    
    self.selectionView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / (CGFloat)self.sections - 2.f, CGRectGetHeight(self.frame) - 2.f);
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
}

- (void)setOffsetForSelectionView:(CGFloat)offset {
    self.selectionView.frame = CGRectMake(offset + 1, CGRectGetMinY(self.selectionView.frame), CGRectGetWidth(self.selectionView.frame), CGRectGetHeight(self.selectionView.frame));
}

- (UIView *)selectionView {
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / self.sections, CGRectGetHeight(self.frame))];
        _selectionView.backgroundColor = [UIColor redColor];
    }
    
    return _selectionView;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray new];
    }
    
    return _labels;
}

- (UIFont *)fontForLabels {
    if (!_fontForLabels) {
        _fontForLabels = [UIFont systemFontOfSize:10];
    }
    
    return _fontForLabels;
}

@end
