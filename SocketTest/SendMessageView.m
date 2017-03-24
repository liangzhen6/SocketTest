//
//  SendMessageView.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/1.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SendMessageView.h"
#import "BottomToolView.h"

#define baseTag 18954
@interface SendMessageView ()<UITextViewDelegate>
@property(nonatomic,strong)UIButton * textSoundSwitchBtn;
@property(nonatomic,strong)UIButton * facialBtn;
@property(nonatomic,strong)UIButton * addBtn;
@property (nonatomic, assign) NSInteger textH;

@end
@implementation SendMessageView

+ (id)sendMessageViewWithSMBlaock:(void(^)(NSString *message))SMBlock {
    SendMessageView * sendMessage = [[SendMessageView alloc] init];
    sendMessage.SMBlock = SMBlock;
    sendMessage.backgroundColor = [UIColor grayColor];
    return sendMessage;
}


+ (id)sendMessageViewWithSMBlaock:(void(^)(NSString *message))SMBlock HBlock:(void(^)(NSInteger height))HBlock  {
    SendMessageView * sendMessage = [SendMessageView sendMessageViewWithSMBlaock:SMBlock];

    sendMessage.HBlock = HBlock;
    return sendMessage;
}


- (id)init {
    self = [super init];
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    _textSoundSwitchBtn = [[UIButton alloc] init];
    _textSoundSwitchBtn.tag = baseTag;
    [_textSoundSwitchBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textSoundSwitchBtn];
    
    [_textSoundSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.equalTo(self.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    
    
    _addBtn = [[UIButton alloc] init];
    _addBtn.tag = baseTag+2;
    _addBtn.backgroundColor = [UIColor redColor];
    [_addBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    
    
    _facialBtn = [[UIButton alloc] init];
    _facialBtn.backgroundColor = [UIColor greenColor ];

    _facialBtn.tag = baseTag+1;
    [_facialBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_facialBtn];
    [_facialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(_addBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    
    
    _textView = [[UITextView alloc] init];
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.scrollsToTop = NO;
    _textView.scrollEnabled = NO;

    
    _textView.enablesReturnKeyAutomatically = YES;
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textSoundSwitchBtn.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(_facialBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];

    _textH = 37;
//    [self createKeyBoardNotification];
    
}

- (void)allBtnAction:(UIButton *)btn {
    switch (btn.tag-baseTag) {
        case 0:
        {
            
            
            
        }
            break;
        case 1:
        {
            
            
            
        }
            break;
        case 2:
        {//弹出工具栏
//          self.openAdd = !self.openAdd;
//            [self.superview endEditing:YES];
//            
//            self.bottomToolView.hidden = NO;
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomToolView.bounds.size.height, 0);
//
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.superview.mas_bottom).offset(-self.bottomToolView.bounds.size.height);
//            }];
//
//            [UIView animateWithDuration:0.3 animations:^{
//                [self.superview layoutIfNeeded];
//            }];
            if (self.showBVBlock) {
                self.showBVBlock();
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark ================textViewdelegate=========================
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if (self.SMBlock && textView.text.length) {
            self.SMBlock(textView.text);
        }
//        [self endEditing:YES];
        textView.text = nil;
        [self changeTextHight];

        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self changeTextHight];
    
}


- (void)changeTextHight {
    
    NSInteger  _maxTextH = ceil(self.textView.font.lineHeight * 4 + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    
    NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);
    DBLog(@"%ld",(long)height);
    if (_textH != height) {
        // 最大高度，可以滚动
        self.textView.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        if (self.textView.scrollEnabled==NO) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                //        make.top.equalTo(self.superview).offset(60);
                make.height.mas_equalTo(height+10);
            }];
            
            if (self.HBlock) {
                self.HBlock(height-_textH);
            }
            _textH = height;

            [self layoutIfNeeded];
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
