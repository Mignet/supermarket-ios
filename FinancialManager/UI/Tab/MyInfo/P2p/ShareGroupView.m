//
//  ShareGroupView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "ShareGroupView.h"
#import "PieChartView.h"
#import "XNMyInformationModule.h"
#import "XNInvestPlatformMode.h"
#import "XNInvestStatisticItem.h"
#import "PieChartModel.h"
#import "WeChatManager.h"

#define PIECHART_SIZE 75.f

@interface ShareGroupView () <WeChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *supView;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (nonatomic, weak) IBOutlet UIView  * chatView;

// 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *photoBtn; //保存到相册

@property (weak, nonatomic) IBOutlet UIButton *qqBtn; //QQ分享

@property (weak, nonatomic) IBOutlet UIButton *weCatBtn; //微信好友分享

@property (weak, nonatomic) IBOutlet UIButton *circleBtn; //微信朋友圈分享

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *investPlatformCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalProfitRateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHieght;

@property (nonatomic, strong) NSArray *platformColorArray;
@property (weak, nonatomic) IBOutlet UIView *platformListView;
@property (weak, nonatomic) IBOutlet UIView *downloadView;

@end

@implementation ShareGroupView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0];
    self.supView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
}

+ (instancetype)shareGroupView
{
    ShareGroupView *shareGroupView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShareGroupView class]) owner:nil options:nil] firstObject];
    return shareGroupView;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    self.frame = [UIScreen mainScreen].bounds;
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

#pragma mark - animations
- (void)fadeIn
{

    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide
{
    
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender == self.cancelBtn) {
        [self hide];
    }
    
    else {
        
             if (![self.delegate respondsToSelector:@selector(shareGroupViewDid:clickType: cutImg:)]) {
             return;
         }
        
             if (sender == self.photoBtn) {
                 
                 UIImage *image = [self convertViewToImage:self.showView];
                 UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            
                 [self.delegate shareGroupViewDid:self clickType:Share_Group_Photo cutImg:image];
         
                 [self hide];
             }
        
             if (sender == self.qqBtn) {
                 
                 UIImage *cutImg = [self convertViewToImage:self.showView];
                 
                 [self.delegate shareGroupViewDid:self clickType:Share_Group_QQ cutImg:cutImg];
                 
                 [self hide];
             }
        
             if (sender == self.weCatBtn) { // 微信好友
                 
                UIImage *cutImg = [self convertViewToImage:self.showView];
                [[WeChatManager sharedManager] sendImage:cutImg atScene:0];
         }
        
             if (sender == self.circleBtn) { // 微信朋友圈
                 
                 
                 UIImage *cutImg = [self convertViewToImage:self.showView];
                 [[WeChatManager sharedManager] sendImage:cutImg atScene:1];
                 
                 [self hide];
         }
     }
    
}

- (void)setInvestPlatformMode:(XNInvestPlatformMode *)investPlatformMode
{
    _investPlatformMode = investPlatformMode;
    
    NSArray *propertyArray = @[@{@"range": @"在投平台:",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": [NSString stringWithFormat:@"%@", investPlatformMode.investingPlatformNum],
                                 @"color": UIColorFromHex(0xfd6d6d),
                                 @"font": [UIFont systemFontOfSize:14]},
                               @{@"range": @"个",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.investPlatformCountLabel.attributedText = string;
    
    propertyArray = @[@{@"range": @"综合年化收益率:",
                        @"color": UIColorFromHex(0x999999),
                        @"font": [UIFont systemFontOfSize:14]},
                      @{@"range": [NSString stringWithFormat:@"%@%@",[[[XNMyInformationModule defaultModule] investPlatformMode] yearProfitRate],@"%"],
                        @"color": UIColorFromHex(0xfd6d6d),
                        @"font": [UIFont systemFontOfSize:14]}];
    
    string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.totalProfitRateLabel.attributedText = string;
    
    [self drawChatView];
    
    [self drawPlatformListView];
    
    // 计算整体视图的高度
    NSInteger row = 0;
    if (investPlatformMode.investStatisticList.count == 0) {
        row = 0;
    } else {
        
        if (investPlatformMode.investStatisticList.count % 2 == 0) {
            row = investPlatformMode.investStatisticList.count / 2;
        } else {
            row = investPlatformMode.investStatisticList.count / 2 + 1;
        }
    }
    
    self.showHieght.constant = 325.f + 30.f * row;
}

//绘制图表
- (void)drawChatView
{
    for (UIView * subView in self.chatView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSInteger index = 0;
    NSMutableArray *pecentArray = [NSMutableArray array];
    PieChartModel *model = nil;
    for (XNInvestStatisticItem * item in [[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList])
    {
        model = [[PieChartModel alloc] init];
        model.color = [self.platformColorArray objectAtIndex:index];
        model.fpercent = [item.totalPercent floatValue] / 100.0;
        
        [pecentArray addObject:model];
        index = index + 1;
    }
    
    PieChartView *pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(0, 0, PIECHART_SIZE, PIECHART_SIZE) withStrokeWidth:25.f bgColor:UIColorFromHex(0xd9e8ff) percentArray:pecentArray isAnimation:YES];
    
    [self.chatView addSubview:pieChartView];
    
    __weak UIView *weakPieChartView = self.chatView;
    [pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakPieChartView);
        make.width.height.mas_equalTo(PIECHART_SIZE);
    }];
}

//创建投资列表
- (void)drawPlatformListView
{
    for (UIView * subView in self.platformListView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    NSInteger index = 0;
    UIView * itemView = nil;
    __weak UIView * lastItemView = itemView;
    weakSelf(weakSelf)
    for (XNInvestStatisticItem * item in [[[XNMyInformationModule defaultModule] investPlatformMode] investStatisticList]) {
        
        itemView = [self createInvestItemWithPlatformColor:[self.platformColorArray objectAtIndex:index] orgName:item.orgName percent:item.totalPercent];
        [self.platformListView addSubview:itemView];
        
        if ([[[[XNMyInformationModule defaultModule] investPlatformMode] investingPlatformNum] integerValue] > 1)
        {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (index % 2 == 0) {
                    
                    make.leading.mas_equalTo(weakSelf.platformListView.mas_leading).offset(SCREEN_FRAME.size.width / 2 - 150.f);
                }else
                {
                    make.leading.mas_equalTo(weakSelf.platformListView.mas_centerX).offset(15);
                }
                
                make.top.mas_equalTo(weakSelf.platformListView.mas_top).offset(33 * (index / 2));
                make.height.mas_equalTo(@(41));
                make.width.mas_equalTo(@(150));
                
            }];
            lastItemView = itemView;
        }else
        {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(weakSelf.platformListView);
                make.top.mas_equalTo(weakSelf.platformListView.mas_top).offset(33 * (index / 2));
                make.height.mas_equalTo(@(41));
                make.width.mas_equalTo(@(150));
                
            }];
        }
        
        index = index + 1;
    }
}

//创建投资项
- (UIView *)createInvestItemWithPlatformColor:(UIColor *)color orgName:(NSString *)orgName percent:(NSString *)pencent
{
    UIView * investContainer = [[UIView alloc]init];
    
    UILabel * colorBlock = [[UILabel alloc]init];
    [colorBlock setBackgroundColor:color];
    
    UILabel * orgNameLabel = [[UILabel alloc]init];
    [orgNameLabel setFont:[UIFont systemFontOfSize:13]];
    [orgNameLabel setTextColor:UIColorFromHex(0x999999)];
    orgNameLabel.text = [NSString stringWithFormat:@"%@ %@%@",orgName,pencent,@"%"];
    
    [investContainer addSubview:colorBlock];
    [investContainer addSubview:orgNameLabel];
    
    __weak UIView * tmpView = investContainer;
    [colorBlock mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(24);
        make.leading.mas_equalTo(tmpView.mas_leading);
        make.width.mas_equalTo(@(7));
        make.height.mas_equalTo(@(7));
    }];
    
    __weak UILabel * tmpLabel = colorBlock;
    [orgNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpLabel.mas_trailing).offset(11);
        make.top.mas_equalTo(tmpView.mas_top).offset(18);
        make.height.mas_equalTo(@(21));
    }];
    
    return investContainer;
}

#pragma mark - 剪切图片
- (UIImage *)cutPicture
{
    UIImage * image = [self.showView screenSnapWithRect:self.showView.frame.size captureSize:self.showView.bounds];
    UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
    return image;
}

- (void)doWechatShare:(int)shareType Img:(UIImage *)img
{
    if ([WeChatManager isWeChatInstall])
    {
            //UIImage *image = [self.sharedDictionary objectForKey:XN_WEIBO_PUBLIC_ICON];
        
        [[WeChatManager sharedManager] setDelegate:self];
        [[WeChatManager sharedManager] sendImage:img atScene:shareType];
        
    }
    else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还没有安装微信,是否去App Store下载" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"马上去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *strUrl = [WeChatManager weChatUrl];
            NSURL *url = [NSURL URLWithString:strUrl];
            [[UIApplication sharedApplication] openURL:url];
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [_UI dismissNaviModalViewCtrlAnimated:YES];
        }]];
        
        [_UI presentNaviModalViewCtrl:alertController animated:YES];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - setter/getter
///////////////////////////////

- (NSArray *)platformColorArray
{
    if (!_platformColorArray) {
        
        _platformColorArray = [[NSArray alloc]initWithObjects:UIColorFromHex(0xec7962),UIColorFromHex(0xefaa4a),UIColorFromHex(0xf7e65e),UIColorFromHex(0x68d5e2),UIColorFromHex(0x6493f7),UIColorFromHex(0x4375c1),UIColorFromHex(0x655cd9),UIColorFromHex(0xcf7cd9),UIColorFromHex(0x4375c1),UIColorFromHex(0x655cd9),UIColorFromHex(0xcf7cd9), nil];
    }
    return _platformColorArray;
}


-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// invite_btn_weixin_normal.png 微信好友
// invite_btn_friends_normal.png 微信朋友圈
// invite_btn_qq_normal.png QQ好友


@end
