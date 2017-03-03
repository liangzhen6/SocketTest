//
//  SenderBaseMessageCell.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/3.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SenderBaseMessageCell.h"
#import "MModel.h"

@implementation SenderBaseMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView {
    _headImage = [[UIImageView alloc] init];
    _headImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _backImageView = [[UIImageView alloc] init];
    [_backImageView setUserInteractionEnabled:YES];
    UIImage * image = [UIImage imageNamed:@"IM_Chat_sender_bg"];
    NSInteger leftCapWidth = 15;
    NSInteger topCapHeight = 18;
    
    NSInteger bottomCapHeight = image.size.height - topCapHeight - 1;
    NSInteger rightCapWidth = image.size.width - leftCapWidth - 1;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(topCapHeight, leftCapWidth, bottomCapHeight, rightCapWidth)];
    _backImageView.image = image;
    [self.contentView addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.headImage.mas_left).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backImageView.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
    
    [self setBackImageSubView];

   
    
}

- (void)setBackImageSubView {

}

- (void)setMModel:(MModel *)mModel {
    _mModel = mModel;
       
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
