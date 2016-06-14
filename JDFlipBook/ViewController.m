//
//  ViewController.m
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import "ViewController.h"
#import "JDMettaVideo.h"
#import "JDFlipBookCollectionView.h"
#import "HTY360PlayerVC.h"

@import AVKit;
@import AVFoundation;

@interface ViewController ()
@property (nonatomic, strong) JDFlipBookCollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *payload = [self jsonFromURL:[NSURL URLWithString:@"http://www.mettavr.com/api/codingChallengeData"]];
    
    UICollectionViewFlowLayout *dummyLayout = [UICollectionViewFlowLayout new];
    dummyLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[JDFlipBookCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:dummyLayout];
    self.collectionView.videos = [self videoObjectsFromPayload:payload];
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView setSelectedVideo:^(JDMettaVideo *video) {
        
    }];
}

- (void)playVideo:(JDMettaVideo *)video
{
    
    
//    []
//    
//    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
//    [self.player setPlayerItem:playerItem];
//    [self.player play];
    
}

- (NSArray *)jsonFromURL:(NSURL *)url
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return json;
}

- (NSArray *)videoObjectsFromPayload:(NSArray *)payload
{
    NSMutableArray *videos = [NSMutableArray new];
    [payload each:^(NSDictionary *data) {
        JDMettaVideo *mettaVideo = [[JDMettaVideo alloc] initWithData:data];
        [videos addObject:mettaVideo];
    }];
    
    return [videos copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
