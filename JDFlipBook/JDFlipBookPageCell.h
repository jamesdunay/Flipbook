//
//  JDFlipBookPageCell.h
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMettaVideo.h"

@interface JDFlipBookPageCell : UICollectionViewCell

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) JDMettaVideo *video;


- (void)updateCellWithOutGoingPercent:(CGFloat)percent;
- (void)updateCellWithIncomingPercent:(CGFloat)percent;
- (void)startingTransformForIndex:(NSIndexPath *)indexPath;

@end
