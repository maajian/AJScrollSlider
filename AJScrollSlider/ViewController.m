//
//  ViewController.m
//  AJScrollSlider
//
//  Created by zhundao on 2017/8/22.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import "ViewController.h"
#import "AJSlideView.h"
#define  kWidth ([UIScreen mainScreen].bounds.size.width)
#define  kHeight ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()<sliderDeletege>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    NSArray *array = @[@"对我感兴趣",@"看过我",@"新职位",@"随机查看"];
    AJSlideView *sliderView = [[AJSlideView alloc]initWithFrame:CGRectMake(20, 64, kWidth-40, 50) titleArray:array];
    [self.view addSubview:sliderView];
    sliderView.sliderDeletege = self;
    
//    sliderView.isCanSlider = YES;
//    sliderView.sliderLengthChoose = 1;
//    sliderView.buttonIndex = 2 ;
//    sliderView.sliderStyle = averageStyle;
//    sliderView.isShowSlider = YES;
//    sliderView.fontNumber = 14 ;
//    sliderView.sliderColor = [UIColor yellowColor];
//    sliderView.defaultButtonColor = [UIColor lightGrayColor];
//    sliderView.selectButtonColor = [UIColor greenColor];
}

- (void)clickIndex:(NSInteger)index{
    /*! index 从 0 开始计数 */
    NSLog(@"点击了第%li个按钮",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
