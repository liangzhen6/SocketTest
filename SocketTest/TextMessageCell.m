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
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.headImage.mas_left).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 160, 40));
    }];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
    
}

- (void)setMModel:(MModel *)mModel {
    _mModel = mModel;
    self.messageLabel.text = mModel.textMessage;

    [_mModel addObserver:self forKeyPath:@"sendProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    CGSize titleSize = [mModel.textMessage sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:0.5]}];

    CGFloat titleW = titleSize.width;
    CGFloat MAXW = Screen_Width - 160;
    CGFloat MINW = 50;
    if (mModel.sendProgress<1.0) {
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
    }else{
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];

    }
    
    if (titleW<=MAXW && titleW>=MINW) {
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(titleW, 40));
        }];
    }else if (titleW>MAXW){
        CGRect frame = self.messageLabel.frame;
        frame.size.width = MAXW;
        self.messageLabel.frame = frame;
        [self.messageLabel sizeToFit];
        CGFloat H = self.messageLabel.frame.size.height;
        if (H<40) {
            H=40;
        }

        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAXW, H));
        }];
        
    }else{
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MINW, 40));
        }];
    }
    

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
