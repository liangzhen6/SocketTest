//
//  Socket.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/24.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject

@property(nonatomic,copy)void(^messageBlack)(NSData *message);

+ (id)shareSocket;

+ (id)shareSocketWithHost:(NSString *)host port:(int)port messageBlack:(void(^)(NSData *message))messageBlack;


- (void)sentMessage:(NSString *)string;

@end
