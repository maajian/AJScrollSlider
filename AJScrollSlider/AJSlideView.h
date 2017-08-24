//
//  AJSlideView.h
//  AJScrollSlider
//
//  Created by zhundao on 2017/8/23.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    wordLength = 0,  //和文字一样长度
    equalLength,    //相同长度 ，平分宽度
} sliderLengthChoose;

typedef enum : NSUInteger {
    defaultStyle = 0,  //滑动运动直接到达位置，没有动画，类似boss直聘互动页面分段
    averageStyle,    //均匀分布，平缓滑动
    bigSmallBigStyle,   //变小再变大的样式
} sliderStyle;

@protocol sliderDeletege <NSObject>

- (void)clickIndex :(NSInteger )index ;

@end
@interface AJSlideView : UIView

/*! 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame
                  titleArray :(NSArray *)titleArray ;


/*! 代理传值 */
@property(nonatomic,weak) id<sliderDeletege>  sliderDeletege;
/*! 选择滑块的长度 */
@property(nonatomic,assign)sliderLengthChoose sliderLengthChoose;
/*! 是否显示滑块 */
@property(nonatomic,assign)BOOL isShowSlider ;
/*! 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanSlider ;
/*! 字体的大小 */
@property(nonatomic,assign)NSInteger fontNumber ;
/*! 设置刚开始button的选中位置 */
@property(nonatomic,assign)NSInteger buttonIndex ;
/*! 默认按钮的颜色 ，默认为黑色 */
@property(nonatomic,strong)UIColor *defaultButtonColor ;
/*! 选中按钮的颜色  默认为红色 */
@property(nonatomic,strong)UIColor *selectButtonColor ;
/*! 滑块的颜色  默认和选择颜色一样为红色 */
@property(nonatomic,strong)UIColor *sliderColor ;
/*! 滑动样式选择 */
@property(nonatomic,assign)sliderStyle sliderStyle;

@end
