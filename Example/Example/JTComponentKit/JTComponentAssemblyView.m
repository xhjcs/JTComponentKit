//
//  JTComponentAssemblyView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponentAssemblyView.h"
#import "JTComponent.h"
#import "JTComponentCell.h"

@interface JTComponentAssemblyView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) NSArray<JTComponent *> *components;

@end

@implementation JTComponentAssemblyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)assembleComponents:(NSArray<JTComponent *> *)components {
    self.components = [components copy];
}

- (JTComponentCell *)findCellFromRenderView:(UIView *)renderView {
    UIView *currentView = renderView.superview;
    while (![currentView isMemberOfClass:[JTComponentCell class]]) {
        currentView = currentView.superview;
    }
    return (JTComponentCell *)currentView;
}

#pragma mark - Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.components.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];
    return [component collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

@end
