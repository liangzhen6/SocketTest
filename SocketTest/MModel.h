//
//  MModel.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/28.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger,messageType){
    
     messageTypeText = 0,
    
     messageTypeImage,
    
     messageTypeVoice
    
};
typedef  NS_ENUM(NSInteger,modelType){
    
    modelTypeSend = 0,
    
    modelTypeReceive,
    
};


@interface MModel : NSObject

@property(nonatomic)modelType modelType;
@property(nonatomic)messageType messageTpye;
@property(nonatomic,copy)NSString * sourceUrl;
@property(nonatomic,copy)NSString * textMessage;
@property(nonatomic,assign)float sendProgress;
@property(nonatomic,strong)NSData * imageData;

@property(nonatomic)NSInteger tag;


@end
