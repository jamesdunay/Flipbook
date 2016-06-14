//
//  JDFlipBookCollectionView.h
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMettaVideo.h"


typedef void(^SelectedVideo)(JDMettaVideo *);

@interface JDFlipBookCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *videos;
@property (nonatomic, copy) SelectedVideo selectedVideo;

@end
