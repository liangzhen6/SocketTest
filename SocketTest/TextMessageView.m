//
//  TextMessageView.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/3.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "TextMessageView.h"

@implementation TextMessageView


+ (id)textMessageViewWithSuperview:(UIView *)superView {
    
    TextMessageView * textLabelView  = [[TextMessageView alloc] init];
    textLabelView.font = [UIFont systemFontOfSize:17];
    textLabelView.numberOfLines = 0;
    textLabelView.textColor = [UIColor blackColor];
    //    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    textLabelView.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:textLabelView];
    [textLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(5);
        make.left.equalTo(superView.mas_left).offset(10);
        make.right.equalTo(superView.mas_right).offset(-15);
        make.bottom.equalTo(superView.mas_bottom).offset(-5);
    }];


    return textLabelView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
