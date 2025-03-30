//
//  JTCollectionView.m
//  JTComponentKit
//
//  Created by xinghanjie on 2025/3/30.
//

#import "JTCollectionView.h"
#import "JTComponentCell.h"
#import "JTComponentReusableView.h"

@implementation JTCollectionView {
    NSMutableSet<NSString *> *_registeredItemReuseIds;
    NSMutableDictionary<NSString *, NSMutableSet<NSString *> *> *_registeredSupplementaryReuseIdsMap;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _registeredItemReuseIds = [NSMutableSet new];
        _registeredSupplementaryReuseIdsMap = [NSMutableDictionary new];
    }

    return self;
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    if (![_registeredItemReuseIds containsObject:identifier]) {
        [self registerClass:[JTComponentCell class] forCellWithReuseIdentifier:identifier];
        [_registeredItemReuseIds addObject:identifier];
    }

    return [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    if (elementKind != UICollectionElementKindSectionHeader) {
        NSMutableSet<NSString *> *registeredSupplementaryReuseIds = _registeredSupplementaryReuseIdsMap[elementKind];

        if (!registeredSupplementaryReuseIds) {
            registeredSupplementaryReuseIds = [NSMutableSet new];
            _registeredSupplementaryReuseIdsMap[elementKind] = registeredSupplementaryReuseIds;
        }

        if (![registeredSupplementaryReuseIds containsObject:identifier]) {
            [self registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
            [registeredSupplementaryReuseIds addObject:identifier];
        }
    }

    return [super dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
}

@end
