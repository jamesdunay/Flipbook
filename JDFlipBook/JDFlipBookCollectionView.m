//
//  JDFlipBookCollectionView.m
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import "JDFlipBookCollectionView.h"
#import "JDFlipBookPageCell.h"

static NSString *kFlipPageCellIdentifier = @"FlipPageCellIdentifier";
static CGFloat kDragVelocityDampener = .24;
static CGFloat kCellWidth = 80.;

@interface JDFlipBookCollectionView()

@property (nonatomic, strong) NSArray *colors;

@end


@implementation JDFlipBookCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceHorizontal = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.frame) - kCellWidth);
        
        [self registerClass:[JDFlipBookPageCell class] forCellWithReuseIdentifier:kFlipPageCellIdentifier];
        
        self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor blueColor], [UIColor blackColor], [UIColor yellowColor]];
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDFlipBookPageCell *cell = (JDFlipBookPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kFlipPageCellIdentifier forIndexPath:indexPath];
    cell.container.frame = CGRectMake(10, 50, CGRectGetWidth(self.frame) - 80, CGRectGetHeight(self.frame) - 100);
    [cell startingTransformForIndex:indexPath];
    [cell setVideo:self.videos[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedVideo(self.videos[[self currentItemIndex]]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth, CGRectGetHeight(self.frame));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // can add dampeners here depending on touch location to better match iOS functionality

    [self.indexPathsForVisibleItems each:^(NSIndexPath *indexPath) {
        JDFlipBookPageCell* cell = (JDFlipBookPageCell *)[self cellForItemAtIndexPath:indexPath];
        if (cell.frame.origin.x < self.contentOffset.x) {
            CGFloat percentScrolledOffScreen = fabs(cell.frame.origin.x - self.contentOffset.x) / kCellWidth;
            [cell updateCellWithOutGoingPercent:percentScrolledOffScreen];
        } else {
            CGFloat zeroPoint = cell.frame.origin.x - scrollView.contentOffset.x;
            CGFloat percentForCell = zeroPoint / CGRectGetWidth(self.frame);
            [cell updateCellWithIncomingPercent:percentForCell];
        }
    }];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger nextIndex;
    CGFloat currentX = scrollView.contentOffset.x;
    CGFloat xDiff = fabs(targetContentOffset->x - currentX);
    CGFloat pagingWidth = kCellWidth;
    
    if (velocity.y == 0.f) {
        nextIndex = roundf(targetContentOffset->x / pagingWidth);
        *targetContentOffset = CGPointMake(0, nextIndex * pagingWidth * kDragVelocityDampener);
    } else if (velocity.y > 0.f) {
        nextIndex = ceil((targetContentOffset->x - xDiff * kDragVelocityDampener) / pagingWidth);
    } else {
        nextIndex = floor((targetContentOffset->x + xDiff * kDragVelocityDampener) / pagingWidth);
    }
    
    *targetContentOffset = CGPointMake(MAX(nextIndex * pagingWidth , 0), 0);
}


- (void)setVideos:(NSArray *)videos
{
    _videos = videos;
    [self reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidScroll:self];
    });
}

- (NSInteger)currentItemIndex
{
    return self.contentOffset.x / kCellWidth;
}

@end
