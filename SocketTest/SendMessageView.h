//
//  SendMessageView.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/1.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageView : UIView

@property(nonatomic,copy)void(^SMBlock)(NSString *message);

@property(nonatomic,copy)void(^HBlock)(NSInteger height);


+ (id)sendMessageViewWithSMBlaock:(void(^)(NSString *message))SMBlock;

+ (id)sendMessageViewWithSMBlaock:(void(^)(NSString *message))SMBlock HBlock:(void(^)(NSInteger height))HBlock;

@end
