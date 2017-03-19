//
//  SenderImageMessageCell.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/3.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SenderImageMessageCell.h"
#import "MModel.h"

@interface SenderImageMessageCell ()

@property(nonatomic,strong)UIImageView * ImageView;

@property(nonatomic,strong)UILabel *maskLabel;

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation SenderImageMessageCell

- (void)setBackImageSubView {

    _ImageView = [[UIImageView alloc] init];
    _ImageView.layer.cornerRadius = 10;
    _ImageView.layer.masksToBounds = YES;
    [self.backImageView addSubview:_ImageView];
    [_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_top).offset(2);
        make.left.equalTo(self.backImageView.mas_left).offset(2);
        make.right.equalTo(self.backImageView.mas_right).offset(-9);
        make.bottom.equalTo(self.backImageView.mas_bottom).offset(-2);

    }];
    
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    maskView.layer.cornerRadius = 10;
    maskView.layer.masksToBounds = YES;
    [self.backImageView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView.mas_top).offset(2);
        make.left.equalTo(self.backImageView.mas_left).offset(2);
        make.right.equalTo(self.backImageView.mas_right).offset(-9);
        make.bottom.equalTo(self.backImageView.mas_bottom).offset(-2);
    }];
    
    _maskLabel = [[UILabel alloc] init];
    _maskLabel.font = [UIFont systemFontOfSize:17];
    _maskLabel.textColor = [UIColor whiteColor];
    _maskLabel.textAlignment = NSTextAlignmentCenter;
    [maskView addSubview:_maskLabel];
    [_maskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(maskView.center);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    

}

- (void)setMModel:(MModel *)mModel {
    [super setMModel:mModel];
    
    
    self.timer.fireDate = [NSDate distantPast];
    
    UIImage * image = [UIImage imageWithData:mModel.imageData];
    CGFloat MAXWH = 160.0;
    CGFloat W = image.size.width;
    CGFloat H = image.size.height;
    
    CGFloat LastW;
    CGFloat LastH;
    
    if (W>=H) {
    //宽图
//        w/h = LastW/LastH
        LastW = MAXWH;
        LastH = LastW * H / W;
        LastH = LastH>MAXWH?MAXWH:LastH;
        
    }else{
    //长图
        LastH = MAXWH;
        LastW = LastH * W / H;
        LastW = LastW>MAXWH?MAXWH:LastW;
    }
    _ImageView.image = image;
    
    [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LastW+11, LastH+4));
    }];

    DBLog(@"%@",image);
    

}


//定时器，更新UI
- (NSTimer *)timer {
    if (_timer==nil) {
        __weak typeof (self)ws = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [ws timerAction:timer];
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
        _maskLabel.superview.hidden = NO;
        _maskLabel.text = [NSString stringWithFormat:@"%.f%%",self.mModel.sendProgress*100];
        DBLog(@"%f",self.mModel.sendProgress);
        
    }else{
        self.activityView.hidden = YES;
        _maskLabel.superview.hidden = YES;
        [self.activityView stopAnimating];
        self.timer.fireDate = [NSDate distantFuture];//暂停定时器
    }
    
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
