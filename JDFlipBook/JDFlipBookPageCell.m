//
//  JDFlipBookPageCell.m
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

static CGFloat startingZDepth = -80;
static CGFloat startingXPos = 220;

static CGFloat kBaseMargin = 20.;

#import "JDFlipBookPageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JDFlipBookPageCell()

@property (nonatomic, strong) UIImageView *previewImage;
@property (nonatomic, strong) UIView *innerContainer;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *videoDescription;
@property (nonatomic, strong) UILabel *ownerName;

@end

@implementation JDFlipBookPageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = NO;
        self.container = [UIView new];
        self.innerContainer = [UIView new];
        self.previewImage = [UIImageView new];

        self.title = [self semiBoldLabelWithSize:20];
        self.title.backgroundColor = [UIColor redColor];
        
        self.videoDescription = [self lightLabelWithSize:15];
        
        self.ownerName = [self semiBoldLabelWithSize:12];
        self.ownerName.textAlignment = NSTextAlignmentRight;

        self.innerContainer.layer.cornerRadius = 10;
        self.innerContainer.clipsToBounds = YES;
        
        self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
        
        self.container.clipsToBounds = NO;
        

        [self.contentView addSubview:self.container];
        [self.container addSubview:self.innerContainer];
        
        [self.innerContainer addSubview:self.previewImage];
        [self.innerContainer addSubview:self.title];
        [self.innerContainer addSubview:self.videoDescription];
        [self.innerContainer addSubview:self.ownerName];
        
        [self defaultConstraints];
    }
    
    return self;
}

- (void)defaultConstraints
{
    [self.innerContainer autoPinEdgesToSuperviewEdges];
    [self.previewImage autoPinEdgesToSuperviewEdges];
    
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBaseMargin];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBaseMargin];
    [self.title autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.videoDescription autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.title];
    [self.videoDescription autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBaseMargin];
    [self.videoDescription autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBaseMargin];
    
    [self.ownerName autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, kBaseMargin, 0, kBaseMargin) excludingEdge:ALEdgeBottom];
}

- (void)layoutSubviews
{
    self.container.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.container.bounds] CGPath];
    self.container.layer.shadowRadius = 25;
    self.container.layer.shadowOffset = CGSizeMake(35, 0);
    self.container.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.container.layer.shadowOpacity = .6;

    [super layoutSubviews];
}

- (void)setVideo:(JDMettaVideo *)video
{
    _video = video;
    
    [self.previewImage sd_setImageWithURL:[NSURL URLWithString:video.previewImageURLString]];
    self.title.text = video.title;
    self.videoDescription.text = video.videoDescription;
    self.ownerName.text = video.ownerName;
}

- (void)updateCellWithOutGoingPercent:(CGFloat)percent
{
    CGFloat easedOutPercent = percent * percent;
    
    CATransform3D imageTransform = CATransform3DIdentity;
    imageTransform.m34 = -1.0 / 1400;
    imageTransform = CATransform3DTranslate(imageTransform,
                                            -easedOutPercent * ((CGRectGetWidth(self.container.frame) - 30)),
                                            0,
                                            easedOutPercent * 10);
//    imageTransform = CATransform3DRotate(imageTransform, (easedOutPercent * -20) * M_PI / 180., 0., 1., 0.);

    self.contentView.layer.transform = imageTransform;
    self.contentView.alpha = 1;
}

- (void)updateCellWithIncomingPercent:(CGFloat)percent
{
    CATransform3D imageTransform = CATransform3DIdentity;
    imageTransform.m34 = -1.0 / 1400;
    imageTransform = CATransform3DTranslate(imageTransform, -percent * startingXPos, 0, percent * startingZDepth);
//    imageTransform = CATransform3DRotate(imageTransform, (reversedPercent * kStartingRotation) * M_PI / 180., -1., 0., 0.);
    self.contentView.layer.transform = imageTransform;
    
    CGFloat alpha = MAX(1, 1 - percent * 2);
    self.contentView.alpha = alpha;
}

- (void)startingTransformForIndex:(NSIndexPath *)indexPath
{
    CATransform3D imageTransform = CATransform3DIdentity;
//    imageTransform.m34 = -1.0 / 1400;
    imageTransform = CATransform3DTranslate(imageTransform, 0, 0, -indexPath.item);
    self.layer.transform = imageTransform;
    
    // this is dumb but it's working for the short term, takes care of some nasty flickering when scrolling
    self.contentView.alpha = 0;
}


// these should be in a category
- (UILabel *)semiBoldLabelWithSize:(CGFloat)size
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)lightLabelWithSize:(CGFloat)size
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    return label;
}

@end
