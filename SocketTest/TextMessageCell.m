//
//  TextMessageCell.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/28.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "TextMessageCell.h"
#import "MModel.h"

@interface TextMessageCell ()
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *headImage;

@property (nonatomic, strong) UIImageView * backImageView;

@end

@implementation TextMessageCell

+ (id)textMessageCellWithTableView:(UITableView *)tableView {

    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

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
    
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textColor = [UIColor blackColor];
//    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backImageView.mas_top).offset(5);
        make.left.equalTo(_backImageView.mas_left).offset(10);
        make.right.equalTo(_backImageView.mas_right).offset(-15);
        make.bottom.equalTo(_backImageView.mas_bottom).offset(-5);
    }];

    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backImageView.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
    
}

- (void)setMModel:(MModel *)mModel {
    _mModel = mModel;
    self.messageLabel.text = mModel.textMessage;

     if (mModel.sendProgress<1.0) {
         self.activityView.hidden = NO;
         [self.activityView startAnimating];
     }else{
         self.activityView.hidden = YES;
         [self.activityView stopAnimating];
 
     }
    
    [_mModel addObserver:self forKeyPath:@"sendProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
//    CGSize titleSize = [mModel.textMessage sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:0.5]}];
    
    CGFloat MAXW = ((NSInteger)Screen_Width/17-8)*17 + 8;
    
    NSInteger width = ceilf([self.messageLabel sizeThatFits:CGSizeMake(MAXFLOAT, 40)].width);
    
    if (width<=MAXW) {
        [_backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((width>17?width:17)+25, 40));
        }];
        
    }else{
     NSInteger height = ceilf([self.messageLabel sizeThatFits:CGSizeMake(MAXW, MAXFLOAT)].height);
        
        [_backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAXW+25, height+10));
        }];

    }
    
    [self.contentView layoutIfNeeded];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sendProgress"]) {
        if (self.mModel.sendProgress==1.0) {
            [_activityView stopAnimating];
            _activityView.hidden = YES;
            [self.mModel removeObserver:self forKeyPath:@"sendProgress"];
        }
    }

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
