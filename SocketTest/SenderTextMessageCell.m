//
//  SenderTextMessageCell.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/3.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SenderTextMessageCell.h"
#import "MModel.h"

@interface SenderTextMessageCell ()

@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation SenderTextMessageCell

- (void)setBackImageSubView {
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor blackColor];
    //    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_top).offset(5);
        make.left.equalTo(self.backImageView.mas_left).offset(10);
        make.right.equalTo(self.backImageView.mas_right).offset(-15);
        make.bottom.equalTo(self.backImageView.mas_bottom).offset(-5);
    }];

}


- (void)setMModel:(MModel *)mModel {
    [super setMModel:mModel];
    
    self.messageLabel.text = mModel.textMessage;
    
    [mModel addObserver:self forKeyPath:@"sendProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    if (mModel.sendProgress<1.0) {
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
    }else{
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];
    }

   
    //    CGSize titleSize = [mModel.textMessage sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:0.5]}];
    
    CGFloat MAXW = ((NSInteger)Screen_Width/17-8)*17 + 8;
    
    NSInteger width = ceilf([self.messageLabel sizeThatFits:CGSizeMake(MAXFLOAT, 40)].width);
    
    if (width<=MAXW) {
        [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((width>17?width:17)+25, 40));
        }];
        
    }else{
        NSInteger height = ceilf([self.messageLabel sizeThatFits:CGSizeMake(MAXW, MAXFLOAT)].height);
        
        [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAXW+25, height+10));
        }];
        
    }
    
    [self.contentView layoutIfNeeded];
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sendProgress"]) {
        if (self.mModel.sendProgress==1.0) {
            [self.activityView stopAnimating];
            self.activityView.hidden = YES;
            [self.mModel removeObserver:self forKeyPath:@"sendProgress"];
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
