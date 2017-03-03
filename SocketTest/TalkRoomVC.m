//
//  TalkRoomVC.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/28.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "TalkRoomVC.h"
#import "TextMessageCell.h"
#import "MModel.h"
#import "SendMessageView.h"
#import "Socket.h"

@interface TalkRoomVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,strong)SendMessageView * sendMessageView;
@property(nonatomic,assign)NSInteger keyBoardFrameH;
@property(nonatomic,assign)NSInteger lastH;

@end

@implementation TalkRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initView];
    
    // Do any additional setup after loading the view.
}



- (void)initView {
//WithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64-47) style:UITableViewStylePlain
    self.tableView = [[UITableView alloc] init];
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 50;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tableView addGestureRecognizer:tap];
    [self.view addSubview:self.tableView];


//    SendMessageView * sendMessage = [SendMessageView sendMessageViewWithSMBlaock:^(NSString *message) {
//        [self sendMessage:message];
//    }];
    
     SendMessageView * sendMessage = [SendMessageView sendMessageViewWithSMBlaock:^(NSString *message) {
         [self sendMessage:message];
     } HBlock:^(NSInteger height) {
         CGFloat H = self.tableView.contentInset.bottom;
         NSLog(@"=====%ld=====%f",(long)height,H);
         self.tableView.contentInset = UIEdgeInsetsMake(0, 0, H + height, 0);
         _lastH = H + height - _keyBoardFrameH;
         [self scrollToLastPath];
         
     }];

    [self.view addSubview:sendMessage];
    
    self.sendMessageView = sendMessage;
    
    [sendMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_equalTo(47);
        //        make.size.mas_equalTo(CGSizeMake(Screen_Width, 50));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
//        make.bottom.equalTo(self.sendMessageView.mas_top).offset(0);
        make.height.mas_equalTo(Screen_Height-64-47);
    }];
    
    [self createKeyBoardNotification];


}



- (void)tapAction:(UITapGestureRecognizer *)tap {

    [self.view endEditing:YES];

}

- (void)sendMessage:(NSString *)message {

    MModel * model = [[MModel alloc] init];
    model.modelType = modelTypeSend;
    model.messageTpye = messageTypeText;
    model.textMessage = message;
    
    [[Socket shareSocket] sentMessage:model progress:^(float progress) {
        model.sendProgress = progress;
    }];//sock通信
    
    [self.dataSource addObject:model];
    
    [self.tableView reloadData];
   
    [self scrollToLastPath];
}


#pragma mark ======================tabledelagte=============================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuserId = @"cell";
    TextMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell==nil) {
        cell = [[TextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    
    cell.mModel = self.dataSource[indexPath.row];
    
    return cell;

}

//tableView被滑动的时候，停止编辑
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

  [self tapAction:nil];
    
}


//跳到最后面一个cell
- (void)scrollToLastPath {
    
    if (self.dataSource.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark =================关于键盘的监听===========================
- (void)createKeyBoardNotification {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // 获取键盘弹出时长
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.sendMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardFrame.size.height);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height + _lastH, 0);
    
    _keyBoardFrameH = keyBoardFrame.size.height;

    [self scrollToLastPath];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    // 获取键盘弹出时长
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.sendMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0+_lastH, 0);
    
    [self scrollToLastPath];

    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (NSMutableArray *)dataSource {
    if (_dataSource==nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
