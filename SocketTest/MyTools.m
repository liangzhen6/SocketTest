//
//  MyTools.m
//  SocketTest
//
//  Created by liangzhen on 2017/2/25.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "MyTools.h"
#import <QiniuSDK.h>

#import <GTMBase64.h>
#include <CommonCrypto/CommonCrypto.h>
//#import <JSONKit.h>

@interface MyTools ()
@property (nonatomic , assign) int expires;

@end

@implementation MyTools

+ (NSString *)switchSexadecimalNumberStringWithData:(NSData *)data {

    Byte *byte=(Byte*)[data bytes];//NSdata->Byte
    // 2.把二进制数据转16进制字符串
    
    //byte->16进制
    
    NSString *hexStr=@"";
    
    for(int i=0;i<[data length];i++){
        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",byte[i]&0xff]; ///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        
    }
    
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}


+ (NSData *)switchDataWithSexadecimalNumberString:(NSString *)string {

    Byte bytes[1];
    
    NSMutableData *datas=[NSMutableData data];
    
    for(int i=0;i<[string length];i++)//s为图片数据16进制字符串
        
    {
        
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        
        unichar hex_char1 = [string characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        
        int int_ch1;
        
        if(hex_char1 >= '0' && hex_char1 <='9')
            
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        
        else
            
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        
        i++;
        
        
        unichar hex_char2 = [string characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9')
            
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        
        else
            
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        
        int_ch = int_ch1+int_ch2;
        
        NSLog(@"int_ch=%d",int_ch);
        
        bytes[0] = int_ch;  ///将转化后的数放入Byte数组里
        
        
        
        [datas appendBytes:bytes length:1];
        
        
    }
    
    return datas;

}

+ (void)updateFileToQiniuWithData:(NSData *)data resultBlck:(void(^)(NSString *url))resultBlock {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
     NSLog(@"percent == %.2f", percent);
 } params:nil checkCrc:NO cancellationSignal:nil];
    MyTools * myTools = [[MyTools alloc] init];
    NSString * token = [myTools makeToken:@"XpD4Uc-iXMYGYDu6pY9MDjm6VZTeJxubN2pvdKEX" secretKey:@"Uu8bZ9OvY-jTEXuCzroTmzj0YWr7ryWqKsG2jnu_"];
    
    [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    } option:uploadOption];



}


- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}
- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += (self.expires > 0) ? self.expires : 3600; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //users是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传users:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    [dic setObject:@"users:aaa" forKey:@"scope"];//根据
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSData * data1 = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    
    return json;
}


@end
