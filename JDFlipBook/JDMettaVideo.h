//
//  JDMettaVideo.h
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDMettaVideo : NSObject

@property (nonatomic, strong) NSString *videoDescription;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *previewImageURLString;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *likesCount;
@property (nonatomic, strong) NSString *hdVideoString;

- (instancetype)initWithData:(NSDictionary *)data;

@end
