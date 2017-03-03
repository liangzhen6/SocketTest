//
//  ViewController.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/24.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "Socket.h"
#import "NetWorkIP.h"
#import <UIImageView+WebCache.h>
#import "MModel.h"
#import "TalkRoomVC.h"

@interface ViewController ()
@property(nonatomic,strong)Socket * socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSocket];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initSocket{
    NSString * ip = [NetWorkIP getIpAddresses];
    if (ip.length) {
       _socket = [Socket shareSocketWithHost:ip port:9800 messageBlack:^(NSData *message) {
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:message options:NSJSONReadingAllowFragments error:nil]);
        }];
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    MModel * model = [[MModel alloc] init];
//    model.modelType = modelTypeSend;
//    model.messageTpye = messageTypeText;
//    model.textMessage = @"hahah😁哈哈😁";
//    [model addObserver:self forKeyPath:@"sendProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [_socket sentMessage:model progress:^(float progress) {
//        model.sendProgress = progress;
//    }];
    TalkRoomVC * room = [[TalkRoomVC alloc] init];
    [self presentViewController:room animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
