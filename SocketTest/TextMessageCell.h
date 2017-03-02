//
//  TextMessageCell.h
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/28.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MModel;
@interface TextMessageCell : UITableViewCell
@property(nonatomic,strong)MModel * mModel;

+ (id)textMessageCellWithTableView:(UITableView *)tableView;


@end
