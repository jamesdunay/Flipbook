//
//  JDMettaVideo.m
//  JDFlipBook
//
//  Created by James Dunay on 6/13/16.
//  Copyright © 2016 James Dunay. All rights reserved.
//

#import "JDMettaVideo.h"

@implementation JDMettaVideo

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self == [super init]) {
        
        if (data[@"title"] == (NSString *)[NSNull null]) self.title = @"";
        else self.title = data[@"title"];
    
        if (data[@"description"] == (NSString *)[NSNull null]) self.videoDescription = @"";
        else self.videoDescription = data[@"description"];

        self.previewImageURLString = data[@"previewSrc"];
        self.ownerName = data[@"owner_data"][@"name"];
        self.hdVideoData = data[@"copies"][@"original"];
    }
    return self;
}

@end
