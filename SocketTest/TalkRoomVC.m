//
//  TalkRoomVC.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/2/28.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "TalkRoomVC.h"
//#import "TextMessageCell.h"
#import "SenderTextMessageCell.h"
#import "SenderImageMessageCell.h"
#import "MModel.h"
#import "SendMessageView.h"
#import "Socket.h"
#import "BottomToolView.h"
#import "TZImagePickerController.h"


@interface TalkRoomVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,strong)SendMessageView * sendMessageView;
@property(nonatomic,strong)BottomToolView * bottomToolView;
@property(nonatomic,strong)UIButton *maskView;
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
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [self.tableView addGestureRecognizer:tap];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(Screen_Height-64-47);
    }];


    
     SendMessageView * sendMessage = [SendMessageView sendMessageViewWithSMBlaock:^(NSString *message) {
         [self sendMessage:message];
     } HBlock:^(NSInteger height) {
         CGFloat H = self.tableView.contentInset.bottom;
         DBLog(@"=====%ld=====%f",(long)height,H);
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
    }];
    

//    /WithFrame:CGRectMake(0, 47, Screen_Width, (Screen_Width-40)/2+20+50)
    BottomToolView * bottomToolView = [[BottomToolView alloc] init];
    bottomToolView.hidden = YES;
    [self.view addSubview:bottomToolView];
    [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendMessage.mas_bottom).offset(0);
        make.left.equalTo(sendMessage.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(Screen_Width, (Screen_Width-40)/2+20+50));
    }];

    self.bottomToolView = bottomToolView;
    
    //那个遮罩
    UIButton * maskView = [[UIButton alloc] init];
    [self.view addSubview:maskView];
    maskView.backgroundColor = [UIColor clearColor];
    [maskView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchDown];
    [maskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(sendMessage.mas_top);
    }];
    
    self.maskView = maskView;
    
    
    //点击了出bottom的按钮
    [sendMessage setShowBVBlock:^{
        self.maskView.hidden = NO;
        if (self.bottomToolView.isHidden) {
            [self.view endEditing:YES];
            self.bottomToolView.hidden = NO;
            [self.sendMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-self.bottomToolView.bounds.size.height);
            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomToolView.bounds.size.height+_lastH, 0);
                [self scrollToLastPath];
            }];
        }else{
            self.bottomToolView.hidden = YES;
            [self.sendMessageView.textView becomeFirstResponder];
            
       }
     
    }];
    
    //底部来的事件
    [bottomToolView setBottomBlock:^(NSInteger number) {
    
        switch (number) {
            case 0:
            {//选择图片
            
                [self packImage];
            
            }
                break;
                
            default:
                break;
        }
        
    }];
    

    [self createKeyBoardNotification];


}

#pragma mark======发送图片=====
- (void)packImage {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    imagePickerVc.circleCropRadius = 100;

    __weak typeof (self) weekSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage * image in photos) {
            [weekSelf sendImageMessageWithImage:image];
        }
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    

}



- (void)tapAction:(UIButton *)btn {
     btn.hidden = YES;
    
   if (CGRectGetMaxY(self.sendMessageView.frame)<Screen_Height) {

         [self.view endEditing:YES];
    
         [self.sendMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.view.mas_bottom).offset(0);
         }];
        self.bottomToolView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0+_lastH, 0);
            [self scrollToLastPath];
        }];

    }
    

//    [self sendImageMessage];
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

- (void)sendImageMessageWithImage:(UIImage *)Image {
    MModel * model = [[MModel alloc] init];
    model.modelType = modelTypeSend;
    model.messageTpye = messageTypeImage;
    
    NSData * idata = UIImagePNGRepresentation(Image);
    model.imageData = idata;
    
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
    static NSString * reuserTextId = @"textCell";
    static NSString * reuserImageId = @"imageCell";
    MModel * model = self.dataSource[indexPath.row];
    SenderBaseMessageCell * cell;
    switch (model.messageTpye) {
        case 0:
        {//文字
            cell = [tableView dequeueReusableCellWithIdentifier:reuserTextId];
            if (cell==nil) {
                cell = [[SenderTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserTextId];
            }

        }
            break;
        case 1:
        {//图片
            cell = [tableView dequeueReusableCellWithIdentifier:reuserImageId];
            if (cell==nil) {
                cell = [[SenderImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserImageId];
            }
        
        }
            break;
        default:
            break;
    }
    
    cell.mModel = model;

    return cell;


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
//    //注册键盘消失的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWillBeHidden:)
//     
//                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // 获取键盘弹出时长
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomToolView.hidden = YES;
    self.maskView.hidden = NO;
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



//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    // 获取键盘弹出时长
//    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
////    
////    [self.sendMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.bottom.equalTo(self.view.mas_bottom).offset(0);
////    }];
////    
////    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0+_lastH, 0);
////    
////    [self scrollToLastPath];
////
////    [UIView animateWithDuration:duration animations:^{
////        [self.view layoutIfNeeded];
////    }];
//}

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
