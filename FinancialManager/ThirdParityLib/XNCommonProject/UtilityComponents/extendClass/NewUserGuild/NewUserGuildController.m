//
//  NewUserGuildController.m
//  XNCommonProject
//
//  Created by xnkj on 5/20/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "NewUserGuildController.h"

@interface NewUserGuildController ()

@property (nonatomic, assign) BOOL                  tapMaskArea;//是否只有点击指导页中的空白部分才算点击
@property (nonatomic, strong) NSString              * tagString;//标记哪个引导页
@property (nonatomic, assign) NSInteger                guildCount;
@property (nonatomic, strong) NSArray              * tapAreaArray;//可点击区域数组
@property (nonatomic, strong) NSArray                * masksPathArray;
@property (nonatomic, strong) NSArray               * guildDescriptionImageArray;
@property (nonatomic, strong) NSArray              * guildDescriptionImageLocationArray;
@property (nonatomic, strong) NSMutableArray      * guildDescriptionImageViewArray;

@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;
@property (nonatomic, strong) UIBezierPath           * userGuildBezierPath;
@property (nonatomic, strong) CAShapeLayer           * maskShapeLayer;
@end

@implementation NewUserGuildController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masksPathArray:(NSArray *)masksPathArray guildDescriptionImageArray:(NSArray *)guildDescriptionArray guildDescriptionImageLocationArray:(NSArray *)guildDescriptionImageLocationArray clickAreaArray:(NSArray *)clickAreaArray tapMaskArea:(BOOL)tapMaskArea
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tapMaskArea = tapMaskArea;
        self.tapAreaArray = clickAreaArray;
        self.masksPathArray = masksPathArray;
        self.guildDescriptionImageArray = guildDescriptionArray;
        self.guildDescriptionImageLocationArray = guildDescriptionImageLocationArray;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masksPathArray:(NSArray *)masksPathArray guildImagesArray:(NSArray *)guildImageArray guildImageLocationArray:(NSArray *)guildImageLocationArray
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.masksPathArray = masksPathArray;
        self.guildDescriptionImageArray = guildImageArray;
        self.guildDescriptionImageLocationArray = guildImageLocationArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////
#pragma mark -
/////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    
    self.guildCount = 0;
    
    [self.view.layer setMask:self.maskShapeLayer];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    //开始绘制第一个引导
    [self drawMaskView:self.guildCount];
}

#pragma mark - 
- (IBAction)tapUserGuild:(UITapGestureRecognizer *)gesture
{
    
    if (self.tapMaskArea) {
        
        CGPoint tapPoint = [gesture locationInView:self.view];
        
        CGRect guildArea = [[self.tapAreaArray objectAtIndex:self.guildCount] CGRectValue];
        
        if (!((guildArea.origin.x < tapPoint.x && guildArea.origin.y < tapPoint.y) && ((guildArea.origin.x + guildArea.size.width) > tapPoint.x && (guildArea.origin.y + guildArea.size.height) > tapPoint.y))) {
            
            return;
        }
    }
    
    self.guildCount ++;
    
    if (self.guildCount == self.masksPathArray.count) {
        
        [self.view removeFromSuperview];
        self.view = nil;
      
        if (self.block) {
            
            self.block();
        }
        
        return;
    }
    
    if (self.stepBlock) {
        
        self.stepBlock(self.guildCount);
    }
    //开始绘制下一个蒙图
    [self drawMaskView:self.guildCount];
}

#pragma mark - 绘制蒙图
- (void)drawMaskView:(NSInteger)index
{
    self.userGuildBezierPath = nil;
   
    for (UIImageView * subView in self.guildDescriptionImageViewArray) {
        
        [subView removeFromSuperview];
    }
    
    [self.userGuildBezierPath appendPath:[self.masksPathArray objectAtIndex:index]];
    
    [self.maskShapeLayer setPath:self.userGuildBezierPath.CGPath];
    
    
    UIImageView * tmpImageView = nil;
    CGRect rect = CGRectZero;
    weakSelf(weakSelf)
    if (self.guildDescriptionImageArray.count == self.masksPathArray.count) {
        
        tmpImageView = [[UIImageView alloc]init];
        [tmpImageView setImage:[self.guildDescriptionImageArray objectAtIndex:index]];
        [self.guildDescriptionImageViewArray addObject:tmpImageView];
        [self.view addSubview:tmpImageView];
        
        rect = [[self.guildDescriptionImageLocationArray objectAtIndex:index] CGRectValue];
        
        
        [tmpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(rect.origin.x);
            make.top.mas_equalTo(weakSelf.view.mas_top).offset(rect.origin.y);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(rect.size.height);
        }];
    }else
    {
        for (NSInteger i = 0 ; i < [self.guildDescriptionImageArray count]; i ++) {
            
            tmpImageView = [[UIImageView alloc]init];
            [tmpImageView setImage:[self.guildDescriptionImageArray objectAtIndex:i]];
            [self.guildDescriptionImageViewArray addObject:tmpImageView];
            [self.view addSubview:tmpImageView];
            
            rect = [[self.guildDescriptionImageLocationArray objectAtIndex:i] CGRectValue];
            
            
            [tmpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(rect.origin.x);
                make.top.mas_equalTo(weakSelf.view.mas_top).offset(rect.origin.y);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(rect.size.height);
            }];
        }
    }
}

#pragma mark - 设置完成block
- (void)setClickCompleteBlock:(completeBlock )block
{
    if (block) {
        
        self.block = nil;
        self.block = [block copy];
    }
}

#pragma makr - 下一步
- (void)setCliekStepBlock:(nextStepBlock)block
{
    if (block) {
        
        self.stepBlock = nil;
        self.stepBlock = [block copy];
    }
}

///////////////////////
#pragma mark - setter/getter
/////////////////////////////////////

#pragma mark - tapGestureRecognizer
- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserGuild:)];
    }
    return _tapGestureRecognizer;
}

#pragma mark - userGuildBezierPath
- (UIBezierPath *)userGuildBezierPath
{
    if (!_userGuildBezierPath) {
        
        _userGuildBezierPath = [UIBezierPath bezierPathWithRect:SCREEN_FRAME];
    }
    return _userGuildBezierPath;
}

#pragma mark - maskShapeLayer
- (CAShapeLayer *)maskShapeLayer
{
    if (!_maskShapeLayer) {
        
        _maskShapeLayer = [CAShapeLayer layer];
    }
    return _maskShapeLayer;
}

#pragma mark - guildDescriptionImageViewArray
- (NSMutableArray *)guildDescriptionImageViewArray
{
    if (!_guildDescriptionImageViewArray) {
        
        _guildDescriptionImageViewArray = [[NSMutableArray alloc]init];
    }
    return _guildDescriptionImageViewArray;
}

@end
