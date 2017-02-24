//
//  Socket.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/24.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject

@property(nonatomic,copy)void(^messageBlack)(NSDictionary *message);

+ (id)shareSocket;

+ (id)shareSocketWithHost:(NSString *)host port:(int)port messageBlack:(void(^)(NSDictionary *message))messageBlack;

@end
