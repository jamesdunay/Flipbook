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
    self.collectionView.backgroundColor = [UIColor colorWithWhite:.88 alpha:1];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView setSelectedVideo:^(JDMettaVideo *video) {
        [weakSelf playVideo:video];
    }];
}

- (void)playVideo:(JDMettaVideo *)video
{
    NSURL *videoUrl = [NSURL URLWithString:video.hdVideoString];
    HTY360PlayerVC *playerVC = [[HTY360PlayerVC alloc] initWithNibName:@"HTY360PlayerVC" bundle:nil url:videoUrl];
    [self.navigationController presentViewController:playerVC animated:YES completion:nil];
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
