//
//  CustomAdScrollView.m
//  CFGApp
//
//  Created by 王希朋 on 14-7-22.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "CustomAdScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Common.h"


#define HEIGHT self.customAdScrollView.frame.size.height

#define DEFAULTCOUNT 1

@interface CustomAdScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray        * adObjectArr;
@property (nonatomic, strong) NSArray        * adUrlArr;

@property (strong, nonatomic) UIScrollView   * customAdScrollView;
@property (nonatomic, strong) CustomPageControl  * pageControl;
@property (nonatomic, strong) NSMutableArray * adImageControlArray;
@property (nonatomic, strong) NSMutableArray * adImageViewArray;
@property (nonatomic, strong) NSTimer        * timer;
@property (nonatomic, copy)   NSMutableDictionary * adDataDictionary;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) float fPageControlAlignBottom;

@end

@implementation CustomAdScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fPageControlAlignBottom = 10.0f;
        self.alignment = 2;
        [self preInitView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pageAlignBottom:(float)fBottom pageAlignment:(NSInteger)alignment
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.fPageControlAlignBottom = fBottom;
        self.alignment = alignment;
        [self preInitView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.alignment = 2;
    [self preInitView];
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)dealloc
{
    [_timer invalidate];
}

//////////////////////////////////////////////////////////////
#pragma mark - 自定义方法汇总
//////////////////////////////////////////////////////////////////////////////

#pragma mark - 添加广告视图
-(void)preInitView{
    
    self.currentPage = 1;
    self.autoPlay = NO;
    self.interminal = 0.3f;
    self.scrollDirection = CustomAdScrollRightDirection;
    [self setBackgroundColor:[UIColor clearColor]];
    [self.customAdScrollView setBackgroundColor:[UIColor clearColor]];
    
    self.customAdScrollView.contentSize = CGSizeMake(self.frame.size.width* DEFAULTCOUNT, 0);
    self.customAdScrollView.contentOffset = CGPointMake(0, 0);
    self.customAdScrollView.pagingEnabled = YES;
    self.customAdScrollView.showsHorizontalScrollIndicator = NO;
    self.customAdScrollView.showsVerticalScrollIndicator = NO;
    self.customAdScrollView.bounces = NO;
    self.customAdScrollView.delegate = self;
    [self addSubview:self.customAdScrollView];
    
    weakSelf(weakSelf)
    [self.customAdScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.mas_leading);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.width.mas_equalTo(weakSelf.size.width);
        make.height.mas_equalTo(weakSelf.size.height);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, HEIGHT)];
    [imageView setImage:[UIImage imageNamed:@"hot_commend_bannner_default"]];
    [self.adImageViewArray addObject:imageView];
    [self.customAdScrollView addSubview:imageView];
    
    __weak UIScrollView * tmpScrollView = self.customAdScrollView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpScrollView.mas_top);
        make.height.mas_equalTo(tmpScrollView.height);
        make.width.mas_equalTo(tmpScrollView.width);
    }];
    
    UIControl *control=[[UIControl alloc]initWithFrame:imageView.frame];
    [self.adImageControlArray addObject:control];
    [self.customAdScrollView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpScrollView);
    }];
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(weakSelf.mas_trailing);
//        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-10);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-weakSelf.fPageControlAlignBottom);
        make.width.mas_equalTo(weakSelf.frame.size.width);
        make.height.mas_equalTo(@(15));
    }];
}


#pragma mark - 刷新内容
- (void)refreshAdScrollViewWithAdUrlObjectArray:(NSArray*)adUrlObjectArr {
    
    [self refreshAdScrollViewWithAdObjectArray:nil urlArray:adUrlObjectArr];
}

#pragma mark - 刷新内容（包含跳转url/）
- (void)refreshAdScrollViewWithAdObjectArray:(NSArray *)adObjectArr urlArray:(NSArray *)adUrlArr
{
//    if ([self.adObjectArr isEqualToArray:adObjectArr]) {
//        
//        return;
//    }
    
    self.adObjectArr = adObjectArr;
    self.adUrlArr = adUrlArr;
    
    if (self.adUrlArr.count <= 0) {
        
        return;
    }
    
    for (UIControl * control in self.adImageControlArray) {
        
        [control removeFromSuperview];
    }
    [self.adImageControlArray removeAllObjects];
    
    
    for(UIImageView * imv in self.adImageViewArray){
        
        [imv removeFromSuperview];
    }
    [self.adImageViewArray removeAllObjects];
    self.customAdScrollView.contentSize = CGSizeMake(0, 0);
    
    weakSelf(weakSelf)
    __weak UIScrollView * tmpScrollView = self.customAdScrollView;
    UIImageView * tmpImageView = nil;
    UIControl   * tmpControl = nil;
    //内容大小
    id obj = @"";
    if (self.adUrlArr.count == 1) {
        
        self.pageControl.hidden = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.customAdScrollView.contentSize = CGSizeMake(self.frame.size.width*(self.adUrlArr.count), 0);
        self.customAdScrollView.scrollEnabled = NO;
        
        obj = self.adObjectArr[0];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, self.frame.size.width, self.frame.size.height)];
       
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adUrlArr[0]] placeholderImage:[UIImage imageNamed:@"hot_commend_bannner_default"]];

        
        [self.adImageViewArray addObject:imageView];
        [self.customAdScrollView addSubview:imageView];
            
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.width.mas_equalTo(weakSelf.frame.size.width);
            make.height.mas_equalTo(tmpScrollView.mas_height);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        }];
        
        UIControl *control=[[UIControl alloc]initWithFrame:imageView.frame];
        [control addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.adDataDictionary setObject:obj forKey:control.layer.description];
        [self.adImageControlArray addObject:control];
        [self.customAdScrollView addSubview:control];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.width.mas_equalTo(weakSelf.frame.size.width);
            make.height.mas_equalTo(tmpScrollView.mas_height);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        }];
    }else{
        
        self.customAdScrollView.scrollEnabled = YES;
        self.customAdScrollView.contentSize = CGSizeMake(self.frame.size.width*(self.adUrlArr.count+2), 0);
        self.pageControl.numberOfPages = self.adUrlArr.count;
        self.customAdScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.currentPage = 1;
        
        NSString * strUrl = @"";
        for (int i = 0; i < self.adUrlArr.count + 2; ++i) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            if (i == 0) {
                
                strUrl = self.adUrlArr[self.adUrlArr.count-1];
                
                if (self.adObjectArr.count >= (self.adUrlArr.count - 1))
                    obj = self.adObjectArr[self.adUrlArr.count-1];
                
            }else if(i == self.adUrlArr.count + 1){
                
                strUrl = self.adUrlArr[0];
                if (self.adObjectArr.count >= 1)
                    obj = self.adObjectArr[0];
                
            }else{
                
                strUrl = self.adUrlArr[i-1];
                
                if (self.adObjectArr.count >= (self.adUrlArr.count - 1))
                    obj = self.adObjectArr[i-1];
            }
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"hot_commend_bannner_default"]];
            
            [self.adImageViewArray addObject:imageView];
            [self.customAdScrollView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (i == 0) {
                    
                    make.leading.mas_equalTo(tmpScrollView.mas_leading);
                }else
                    make.leading.mas_equalTo(tmpImageView.mas_trailing);
                make.top.mas_equalTo(tmpScrollView.mas_top);
                make.width.mas_equalTo(weakSelf.frame.size.width);
                make.height.mas_equalTo(tmpScrollView.mas_height);
                
                if (i == weakSelf.adUrlArr.count + 1) {
                    
                    make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
                }
            }];

            
            UIControl *control=[[UIControl alloc]initWithFrame:imageView.frame];
            [control addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.adDataDictionary setObject:obj forKey:control.layer.description];
            [self.adImageControlArray addObject:control];
            [self.customAdScrollView addSubview:control];
            
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (i == 0) {
                    
                    make.leading.mas_equalTo(tmpScrollView.mas_leading);
                }else
                    make.leading.mas_equalTo(tmpControl.mas_trailing);
                make.top.mas_equalTo(tmpScrollView.mas_top);
                make.width.mas_equalTo(weakSelf.frame.size.width);
                make.height.mas_equalTo(tmpScrollView.mas_height);
                
                if (i == weakSelf.adUrlArr.count + 1) {
                    
                    make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
                }
            }];
            
            tmpImageView = imageView;
            tmpControl = control;
        }
        
        self.pageControl.hidden = NO;
        self.autoPlay?[self.timer setFireDate:[NSDate distantPast]]:[self.timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - 定时处理
-(void)onTimer{
    weakSelf(weakSelf)
    if (self.currentPage - 1 < 0)
        
        self.pageControl.currentPage = self.adImageViewArray.count - 2;
    else if(self.currentPage -1 > self.adImageViewArray.count - 3)
        
        self.pageControl.currentPage = 0;
    else
        self.pageControl.currentPage = self.currentPage - 1;
    
    [UIView animateWithDuration:self.interminal animations:^{
        
        weakSelf.customAdScrollView.contentOffset = CGPointMake(weakSelf.frame.size.width*weakSelf.currentPage, 0);
    } completion:^(BOOL finished) {
        
        if (weakSelf.scrollDirection == CustomAdScrollLeftDirection) {
            
            if (--weakSelf.currentPage == -1){
                
                weakSelf.currentPage = weakSelf.adImageViewArray.count - 2;
                weakSelf.customAdScrollView.contentOffset = CGPointMake(weakSelf.frame.size.width*weakSelf.currentPage, 0);
                weakSelf.currentPage = weakSelf.adImageViewArray.count - 3;
            }
        }else
        {
            if (++weakSelf.currentPage == weakSelf.adImageViewArray.count){
                
                weakSelf.currentPage = 1;
                weakSelf.customAdScrollView.contentOffset = CGPointMake(weakSelf.frame.size.width*weakSelf.currentPage, 0);
                weakSelf.currentPage = 2;
            }
        }
    }];
}

/////////////////////////////////
#pragma mark - 代理实现
////////////////////////////////////////////////////////////////////

#pragma mark UIScrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (page == self.adImageViewArray.count-1) {
        
        page = 1;
        self.customAdScrollView.contentOffset = CGPointMake(page*self.frame.size.width, 0);
    }else if (page == 0) {
        
        page = (int)self.adImageViewArray.count - 2;
        self.customAdScrollView.contentOffset = CGPointMake(page*self.frame.size.width, 0);
    }
    
    self.pageControl.currentPage = page-1;
    self.currentPage = page;
    
    self.autoPlay?[self.timer setFireDate:[NSDate distantPast]]:[self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - imageView点击响应
-(void)imageClick:(UIControl *)control{
    
    self.imgClickedBlock([self.adDataDictionary objectForKey:control.layer.description]);
}

#pragma mark - imageView点击回调
-(void)setClickedImgBlock:(ImgClickedBlock)imgClickedBlock{
    
    if (imgClickedBlock) {
        
        self.imgClickedBlock = nil;
        self.imgClickedBlock = imgClickedBlock;
    }
}

/////////////////////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////////////////////

#pragma mark - adObjectArr
- (NSArray *)adObjectArr
{
    if (!_adObjectArr) {
        
        _adObjectArr = [[NSArray alloc]init];
    }
    return _adObjectArr;
}

#pragma mark - adUrlArr
- (NSArray *)adUrlArr
{
    if (!_adUrlArr) {
        
        _adUrlArr = [[NSArray alloc]init];
    }
    return _adUrlArr;
}

#pragma mark - customAdScrollView
- (UIScrollView *)customAdScrollView
{
    if (!_customAdScrollView) {
        
        _customAdScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0 , 0, self.frame.size.width, self.frame.size.height)];
        [_customAdScrollView setBackgroundColor:[UIColor clearColor]];
    }
    return _customAdScrollView;
}

#pragma mark - pageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[CustomPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT - 20, self.frame.size.width, 15) activeImageName:@"custom_page_control_active_icon" inActiveImageName:@"custom_page_control_inactive_icon"
                                                 alignmentType:self.alignment];
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = self.currentPage;
        _pageControl.hidden = YES;
    }
    return _pageControl;
}

#pragma mark -adImageViewArray
- (NSMutableArray *)adImageViewArray
{
    if (!_adImageViewArray) {
        
        _adImageViewArray = [[NSMutableArray alloc]init];
    }
    return _adImageViewArray;
}

#pragma mark - adImageControlArray
- (NSMutableArray *)adImageControlArray
{
    if (!_adImageControlArray) {
        
        _adImageControlArray = [[NSMutableArray alloc]init];
    }
    return _adImageControlArray;
}

#pragma mark - timer
- (NSTimer *)timer
{
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:3
                                         target:self
                                       selector:@selector(onTimer)
                                       userInfo:nil
                                        repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

#pragma mark - adDataDictionary
- (NSMutableDictionary *)adDataDictionary
{
    if (!_adDataDictionary) {
        
        _adDataDictionary = [[NSMutableDictionary alloc]init];
    }
    return _adDataDictionary;
}

@end
