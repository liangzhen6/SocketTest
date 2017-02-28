//
//  Socket.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/24.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MModel;
@interface Socket : NSObject

@property(nonatomic,copy)void(^messageBlack)(NSData *message);
@property(nonatomic,copy)void(^progressBlock)(float progress);


+ (id)shareSocket;

+ (id)shareSocketWithHost:(NSString *)host port:(int)port messageBlack:(void(^)(NSData *message))messageBlack;


- (void)sentMessage:(MModel *)model progress:(void(^)(float progress))progressBlock;

@end
