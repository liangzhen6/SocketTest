//
//  Socket.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/24.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "Socket.h"
#import <GCDAsyncSocket.h>
#import "MyTools.h"
#import <UIKit/UIKit.h>

@interface Socket ()<GCDAsyncSocketDelegate>
@property(nonatomic,strong)GCDAsyncSocket *asyncSocket;
@property(nonatomic,strong)GCDAsyncSocket *serverSocket;
@property(nonatomic,strong)NSMutableArray * socketArray;
@property(nonatomic,copy)NSString * host;
@property(nonatomic)int port;
@end


@implementation Socket

+ (id)shareSocket {
    static Socket * socket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[Socket alloc] init];
    });
    return socket;
}

+ (id)shareSocketWithHost:(NSString *)host port:(int)port messageBlack:(void(^)(NSData *message))messageBlack {
    Socket * socket = [Socket shareSocket];
    socket.host = host;
    socket.port = port;
    socket.messageBlack = messageBlack;
    NSError *error = nil;
    [socket.asyncSocket connectToHost:host onPort:port error:&error];
    [socket.serverSocket acceptOnPort:port error:nil];
    if (error) {
        NSLog(@"%@",error);
    }
    return socket;
}
- (id)init {
    self = [super init];
    if (self) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _serverSocket =  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}


- (void)sentMessage:(NSString *)string {
//    NSData * idata = [string dataUsingEncoding:NSUTF8StringEncoding];
    UIImage * image = [UIImage imageNamed:@"tu.png"];
    NSData * idata = UIImagePNGRepresentation(image);
    
    [MyTools updateFileToQiniuWithData:idata resultBlck:^(NSString *url) {
        
    }];
//    NSString *hexStr = [MyTools switchSexadecimalNumberStringWithData:idata];
    
//    NSDictionary * dict = @{@"hah":@"sb",@"message":hexStr};
//    NSMutableDictionary * mudict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//    [mudict setObject:data forKey:@"message"];
//    NSData * data1 = [NSJSONSerialization dataWithJSONObject:mudict options:NSJSONWritingPrettyPrinted error:nil];
    [_asyncSocket writeData:idata withTimeout:-1 tag:100];
}


#pragma mark =============GCDAsyncSocket delegate=================
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"已经连接到host=%@=========port=%d",host,port);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"%@----已经接收消息---%@",sock,_serverSocket);
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dict);
    
    
    //接收端
    
//    1.NSData 转字符串
    NSString *s= [dict objectForKey:@"message"];
//    NSString *s=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *datas = [MyTools switchDataWithSexadecimalNumberString:s];
    
    NSString * string = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    
//    UIImage *i=[UIImage imageWithData:datas]//以图片为例转换后获得真正的图片
    
    

    if (data) {
        if (self.messageBlack) {
            self.messageBlack(data);
        }
    }

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"%@----已经发送消息---%@",sock,_asyncSocket);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {

}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {

    [self.socketArray addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:100];
}



- (NSMutableArray *)socketArray {
    if (_socketArray==nil) {
        _socketArray = [[NSMutableArray alloc] init];
    }
   return _socketArray;
}

@end
