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
    [_socket sentMessage:@"哈哈哈hha👌😆😂"];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
