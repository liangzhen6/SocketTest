//
//  MyTools.m
//  SocketTest
//
//  Created by liangzhen on 2017/2/25.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "MyTools.h"

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

@end
