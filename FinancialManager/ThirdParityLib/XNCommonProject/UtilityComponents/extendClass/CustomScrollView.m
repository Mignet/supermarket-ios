#import "CustomScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Common.h"

#define HEIGHT self.customAdScrollView.frame.size.height

#define DEFAULTCOUNT 1

@interface CustomScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView   * customAdScrollView;
@property (nonatomic, strong) UIPageControl  * pageControl;
@property (nonatomic, strong) NSMutableArray * adImageViewArray;

@end

@implementation CustomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self preInitView];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self preInitView];
}

//////////////////////////////////////////////////////////////
#pragma mark - 自定义方法汇总
//////////////////////////////////////////////////////////////////////////////

#pragma mark - 添加广告视图
-(void)preInitView{
    
    self.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageIndicatorTintColor = [UIColor grayColor];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.customAdScrollView setBackgroundColor:[UIColor clearColor]];
    
    self.customAdScrollView.contentOffset = CGPointMake(0, 0);
    self.customAdScrollView.pagingEnabled = YES;
    self.customAdScrollView.showsHorizontalScrollIndicator = NO;
    self.customAdScrollView.showsVerticalScrollIndicator = NO;
    self.customAdScrollView.bounces = NO;
    self.customAdScrollView.delegate = self;
    [self addSubview:self.customAdScrollView];
    
    weakSelf(weakSelf)
    [self.customAdScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, HEIGHT)];
    [imageView setImage:[UIImage imageNamed:@"hot_commend_bannner_default"]];
    [self.adImageViewArray addObject:imageView];
    [self.customAdScrollView addSubview:imageView];
    
    __weak UIScrollView * tmpScrollView = self.customAdScrollView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpScrollView);
    }];
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.mas_leading);
        make.trailing.mas_equalTo(weakSelf.mas_trailing);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(10);
        make.height.mas_equalTo(@(15));
    }];
}


#pragma mark - 刷新内容
- (void)refreshAdScrollViewWithAdUrlObjectArray:(NSArray*)adUrlObjectArr {
    
    for(UIImageView * imv in self.adImageViewArray){
        
        [imv removeFromSuperview];
    }
    [self.adImageViewArray removeAllObjects];
    self.customAdScrollView.contentSize = CGSizeMake(0, 0);
    
    __weak UIScrollView * tmpScrollView = self.customAdScrollView;
    UIImageView * tmpImageView = nil;
    for (int i = 0; i < adUrlObjectArr.count; ++i) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[adUrlObjectArr objectAtIndex:i]]];
        
        [self.adImageViewArray addObject:imageView];
        [self.customAdScrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                
                make.leading.mas_equalTo(tmpScrollView.mas_leading);
            }else
                make.leading.mas_equalTo(tmpImageView.mas_trailing);
            
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.width.mas_equalTo(tmpScrollView.mas_width);
            make.height.mas_equalTo(tmpScrollView.mas_width);
            
            if (i == adUrlObjectArr.count - 1) {
                
                make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            }
        }];
        
        tmpImageView = imageView;
    }
    
    self.pageControl.numberOfPages = adUrlObjectArr.count;
    [self.pageControl setHidden:NO];
}

#pragma mark - 获取当前显示的图片
- (UIImage *)getCurrentShowImage
{
    UIImageView * tmpImageView = [self.adImageViewArray objectAtIndex:self.pageControl.currentPage];
    
    return tmpImageView.image;
}

/////////////////////////////////
#pragma mark - 代理实现
////////////////////////////////////////////////////////////////////

#pragma mark UIScrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x/(scrollView.size.width - 1);
    
    self.pageControl.currentPage = page;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomScrollViewDidScrollToIndex:)]) {
        
        [self.delegate CustomScrollViewDidScrollToIndex:page];
    }
}

/////////////////////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////////////////////

#pragma mark - customAdScrollView
- (UIScrollView *)customAdScrollView
{
    if (!_customAdScrollView) {
        
        _customAdScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width, self.frame.size.height)];
        [_customAdScrollView setBackgroundColor:[UIColor clearColor]];
    }
    return _customAdScrollView;
}

#pragma mark - pageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((150.0 / 320) * SCREEN_FRAME.size.width, HEIGHT - 20, 20, 15)];
        _pageControl.numberOfPages = 0;
        _pageControl.hidden = YES;
        
        if (IOS6_OR_LATER) {
            _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
            _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        }
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

@end
