//
//  SenderBaseMessageCell.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/3.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MModel;
@interface SenderBaseMessageCell : UITableViewCell

@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIImageView *headImage;
@property (nonatomic, strong) UIImageView * backImageView;

@property(nonatomic,strong)MModel * mModel;

- (void)initView;


- (void)setBackImageSubView;

@end
