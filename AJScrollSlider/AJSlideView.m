//
//  AJSlideView.m
//  AJScrollSlider
//
//  Created by zhundao on 2017/8/23.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import "AJSlideView.h"

/*! 滑块的高度 */
static CGFloat sliderHeight = 2 ;

static CGFloat buttonMargin = 20 ;

@interface AJSlideView()

/*! 内容视图为UIScrollView */
@property(nonatomic,strong)UIScrollView  *scrollView ;
/*! 传值的数组 */
@property(nonatomic,strong)NSArray *titleArray ;
/*! 下面的滑块 */
@property(nonatomic,strong)UIView *sliderView;
/*! 存储按钮的数组 */
@property(nonatomic,strong)NSMutableArray *buttonArray;
/*! 文字宽度的数组 */
@property(nonatomic,strong)NSMutableArray *wordWidthArray ;
/*! 选中的button，用于覆盖 */
@property(nonatomic,strong)UIButton    *selectButton ;
/*! 当前选择的按钮index */
@property(nonatomic,assign)NSInteger currentIndex;
/*! 存储可以左右滑动时，button的x */
@property(nonatomic,strong)NSMutableArray  *canSliderXArray ;
@end
@implementation AJSlideView

- (instancetype)initWithFrame:(CGRect)frame titleArray :(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleArray = titleArray;
        [self initViewData];
        [self initSubView];
    }
    return self;
}

- (void)initViewData {
    /*! 默认和文字一样大小 */
    _sliderLengthChoose = wordLength;
    /*! 默认显示滑块 */
    _isShowSlider = YES;
    /*! 默认字体大小为17 */
    _fontNumber = 14 ;
    /*! 默认不能滑动 */
    _isCanSlider = NO;
    /*! 当前选中的index 默认为0 */
    _currentIndex = 0 ;
    /*! 默认的滑动样式 */
    _sliderStyle = 0 ;
}


- (void)initSubView {
    /*! 添加scrollView */
    [self addSubview:self.scrollView];
    /*! 创建按钮 */
    [self initButton];
    /*! 创建滑块 */
    [self initSlider];
}



#pragma mark ----------初始化懒加载

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        /*! 尺寸和父视图一样 */
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        /*! 不显示滑动条 */
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]init];
        _sliderView.backgroundColor = [UIColor redColor];
    }
    return _sliderView;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)wordWidthArray{
    if (!_wordWidthArray) {
        _wordWidthArray = [NSMutableArray array];
    }
    return _wordWidthArray;
}

- (NSMutableArray *)canSliderXArray{
    if (!_canSliderXArray) {
        _canSliderXArray = [NSMutableArray array];
    }
    return _canSliderXArray;
}
#pragma mark ---------添加按钮数组

- (void)initButton {
    /*! 计算按钮的高度 */
   __block CGFloat buttonHeight ;
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size =   [obj boundingRectWithSize:CGSizeMake(1000,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_fontNumber]} context:nil].size;
        /*! 遍历获取按钮的宽度 */
        [self.wordWidthArray addObject:[NSNumber numberWithFloat:size.width]];
        buttonHeight = size.height;
    }];
    [self setButtonFrame];
}

- (void)setButtonFrame{
    if (_isCanSlider) {   //如果可以滑动
        /*! 创建按钮 */
        CGFloat buttonX = 0;
        CGFloat buttonH =  self.frame.size.height - sliderHeight  ;
        @autoreleasepool {
            for (NSInteger i = 0; i <self.titleArray.count; i ++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(buttonX, 0, ([_wordWidthArray[i] floatValue]+buttonMargin), buttonH);
                buttonX = buttonX + ([_wordWidthArray[i] floatValue]+buttonMargin);
                [self.canSliderXArray addObject:@(buttonX)];
                button.tag =i ;
                button.titleLabel.font = [UIFont systemFontOfSize:_fontNumber];
                /*! 按钮设置名称 */
                [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
                /*! 按钮设置按钮默认颜色 */
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                /*! 按钮设置按钮选中颜色 */
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                /*! 按钮点击事件 */
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                /*! 将按钮加入数组，方便以后对按钮进行操作 */
                [self.buttonArray addObject:button];
                /*! 按钮加入滑动视图 */
                [self.scrollView addSubview:button];
            }
            CGFloat scrollWidth =CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
            /*! scrollView的内容视图为父视图 */
            self.scrollView.contentSize = CGSizeMake(scrollWidth, self.frame.size.height);
        }
    }else{   //不能滑动
        /*! scrollView的内容视图为父视图 */
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
         self.scrollView.scrollEnabled = NO;
        /*! 创建按钮 */
        CGFloat buttonH =  self.frame.size.height - sliderHeight  ;
        CGFloat buttonW =  self.frame.size.width/ self.titleArray.count;
        @autoreleasepool {
            for (NSInteger i = 0; i <self.titleArray.count; i ++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(i *buttonW, 0, buttonW, buttonH);
                button.tag = i ;
                button.titleLabel.font = [UIFont systemFontOfSize:_fontNumber];
                /*! 按钮设置名称 */
                [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
                /*! 按钮设置按钮默认颜色 */
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                /*! 按钮设置按钮选中颜色 */
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                /*! 按钮点击事件 */
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                /*! 将按钮加入数组，方便以后对按钮进行操作 */
                [self.buttonArray addObject:button];
                /*! 按钮加入滑动视图 */
                [self.scrollView addSubview:button];
            }
        }
    }
    /*! 根据当前的选择index 设置选择的位置 ，默认第一个 */
    [self changeButtonToSelect:self.buttonArray[_currentIndex]];
}



#pragma mark --------添加指示器数组

- (void)initSlider {
    [self.scrollView addSubview:self.sliderView];
     /*! 根据当前的选择index 设置选择的按钮位置 ，默认第一个 */
    UIButton *button = self.buttonArray[_currentIndex];
    CGFloat sliderH = sliderHeight;
    CGFloat sliderW = [self getWidth];
    CGFloat sliderX = button.frame.origin.x +[self getSliderX];
    CGFloat sliderY = button.frame.size.height;
    self.sliderView.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
}

- (CGFloat)getWidth{
    switch (_sliderLengthChoose) {
        case wordLength:
        {
            /*! 长度和文字一样 */
            return [self.wordWidthArray[_currentIndex] integerValue];
        }
            break;
        case equalLength:
        {
            /*! 每个滑动长度一样 */
         return self.scrollView.frame.size.width/self.buttonArray.count;
            
        }
            break;
    }
}

- (CGFloat)getSliderX {
    if (_isCanSlider) {
        switch (_sliderLengthChoose) {
            case wordLength:
                return buttonMargin/2;
                break;
            case equalLength:
            {
                return 0;
                
            }
            default:
                break;
        }
    }else{
        switch (_sliderLengthChoose) {
            case wordLength:
            {
                return (self.scrollView.frame.size.width/self.buttonArray.count - [self.wordWidthArray[_currentIndex] integerValue])/2;
            }
                break;
            case equalLength:
            {
                return 0;
                
            }
                break;
        }
    }
    
}

#pragma mark 按钮点击事件

- (void)buttonAction:(UIButton *)button
{
    /*! 记录之前一个按钮的index */
    NSInteger oriIndex = _currentIndex;
    _currentIndex = button.tag;
    [self changeButtonToSelect:button];
    
    [self changeSliderToSelect:self.buttonArray[oriIndex]];
    /*! 记录当前选择的index */
    if ([self.sliderDeletege respondsToSelector:@selector(clickIndex:)]) {
        [self.sliderDeletege clickIndex:_currentIndex];
    }
}


- (void)changeButtonToSelect :(UIButton *)button {
    if (self.selectButton ==nil) {
        //        if (_buttonIndex >= self.buttonArray.count ) {
        button.selected = YES;
        _selectButton = button;
    }else if (self.selectButton!=nil && self.selectButton == button){
        button.selected = YES;
    }else{
        self.selectButton.selected = NO;
        button.selected = YES;
        self.selectButton = button;
    }
}

- (void)changeSliderToSelect:(UIButton *)button {
    NSLog(@"[self getSliderX] = %f",[self getSliderX]);
    switch (_sliderStyle) {
        case defaultStyle:{
            self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x + [self getSliderX], _selectButton.frame.size.height , [self getWidth], sliderHeight);
        }
            break;
        case averageStyle:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x + [self getSliderX], _selectButton.frame.size.height , [self getWidth], sliderHeight);
            } completion:nil];
        }
            break;
        case bigSmallBigStyle:
            [UIView animateWithDuration:0.25 animations:^{
                self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x/2 + button.frame.origin.x/2, _selectButton.frame.size.height - sliderHeight, _selectButton.frame.size.width/4, sliderHeight);
            } completion:^(BOOL finished) {
                 self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x + [self getSliderX], _selectButton.frame.size.height , [self getWidth], sliderHeight);
            }];
            break;
    }
    
}


#pragma mark ---------- 存取器

- (void)setButtonIndex:(NSInteger)buttonIndex{
    self.selectButton.selected = NO;
    _currentIndex = buttonIndex;
    _selectButton = self.buttonArray[_currentIndex];
    [self changeButtonToSelect:_selectButton];
    self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x + [self getSliderX], _selectButton.frame.size.height , [self getWidth], sliderHeight);
}

- (void)setIsShowSlider:(BOOL)isShowSlider{
    if (!isShowSlider) {
        _isShowSlider = isShowSlider;
        self.sliderView.hidden = YES;
    }
}

- (void)setIsCanSlider:(BOOL)isCanSlider{
     _isCanSlider = isCanSlider;
    if (!_isCanSlider) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }];
         [self.buttonArray removeAllObjects];
        [self setButtonFrame];
        self.sliderView.frame = CGRectMake(_selectButton.frame.origin.x + [self getSliderX], _selectButton.frame.size.height , [self getWidth], sliderHeight);
    }
}

- (void)setFontNumber:(NSInteger)fontNumber{
    if (fontNumber != 14) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }];
         [self.buttonArray removeAllObjects];
        _fontNumber = fontNumber;
        [self initButton];
    }
}

- (void)setDefaultButtonColor:(UIColor *)defaultButtonColor{
    _defaultButtonColor =defaultButtonColor;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:_defaultButtonColor forState:UIControlStateNormal];
    }];
}

- (void)setSelectButtonColor:(UIColor *)selectButtonColor{
    _selectButtonColor = selectButtonColor;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:_selectButtonColor forState:UIControlStateSelected];
    }];
}

- (void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
