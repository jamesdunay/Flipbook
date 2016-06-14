//
//  MDModeStrategy.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark IMDModeStrategy
@protocol IMDModeStrategy <NSObject>
@optional
-(void) on;
-(void) off;
@end

#pragma mark MDModeManager
@interface MDModeManager : NSObject<IMDModeStrategy>
@property(nonatomic,readonly) int mMode;
- (instancetype)initWithDefault:(int)mode;
- (void) prepare;
- (void) switchMode:(int)mode;
- (void) switchMode;
- (id<IMDModeStrategy>) createStrategy:(int)mode;
@end
