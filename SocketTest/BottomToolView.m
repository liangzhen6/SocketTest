//
//  BottomToolView.m
//  SocketTest
//
//  Created by shenzhenshihua on 2017/3/22.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "BottomToolView.h"

#define allCount  1

@interface BottomToolView ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl * pageControl;

@end

@implementation BottomToolView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.scrollView.backgroundColor = [UIColor yellowColor];
//    h =  (Screen_Width-40)/2+20+50
    CGFloat W = (Screen_Width-40)/4;
    
    for (NSInteger i = 0; i<allCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i%4 *W+20, i/2 *W+20, W, W)];
        view.tag = 1000+i;
        view.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [self.scrollView addSubview:view];
    }
    
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"hahahahh");

}
- (UIPageControl *)pageControl {
    if (_pageControl==nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 1;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        CGSize size = [_pageControl sizeForNumberOfPages:2];
        _pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, self.bounds.size.height-size.height-20, size.width, size.height);
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] init];

    }
    return _scrollView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
