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

@property(nonatomic,strong)NSTimer * timer;


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
    
    self.timer.fireDate = [NSDate distantPast];
    
    self.messageLabel.text = mModel.textMessage;
    
   
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



//定时器，更新UI
- (NSTimer *)timer {
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self timerAction:timer];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        //        [_timer fire];//立即开始
        //        _timer.fireDate = [NSDate distantPast];//开始
        _timer.fireDate = [NSDate distantFuture];//暂停
    }
    
    return _timer;
}


- (void)timerAction:(NSTimer *)timer {
    
    if ([[NSThread currentThread] isMainThread]) {
        
        [self reloadProgressUI];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadProgressUI];
            
            
        });
        
    }
    
}

- (void)reloadProgressUI {
    
    if (self.mModel.sendProgress<1.0) {
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        
    }else{
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];
        self.timer.fireDate = [NSDate distantFuture];//暂停定时器
    }
    DBLog(@"%f",self.mModel.sendProgress);

}

- (void)dealloc {
    
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
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
