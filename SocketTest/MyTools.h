//
//  MyTools.h
//  SocketTest
//
//  Created by liangzhen on 2017/2/25.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTools : NSObject

+ (NSString *)switchSexadecimalNumberStringWithData:(NSData *)data;

+ (NSData *)switchDataWithSexadecimalNumberString:(NSString *)string;

+ (void)updateFileToQiniuWithData:(NSData *)data progress:(void(^)(float progress))progressBlock resultBlck:(void(^)(NSString *url))resultBlock;

@end
