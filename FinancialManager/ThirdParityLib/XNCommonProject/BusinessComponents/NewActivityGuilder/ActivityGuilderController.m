//
//  ActivityGuilderController.m
//  FinancialManager
//
//  Created by xnkj on 08/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ActivityGuilderController.h"
#import "NewUserGuildController.h"

@interface ActivityGuilderController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSInteger activityCount;
@property (nonatomic, strong) NSString * titleName;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSMutableArray  * fingerImageArray;
@property (nonatomic, strong) NSArray  * fingerImageLocationArray;

@property (nonatomic, strong) UIButton       * backTaskListButton;
@property (nonatomic, strong) UIButton     * existButton;
@property (nonatomic, strong) UIImageView     * fingerImageView;
@property (nonatomic, weak) IBOutlet UIImageView * bgImageView;
@end

@implementation ActivityGuilderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil titleName:(NSString *)titleName bgImageName:(NSString *)imageName activityId:(NSInteger )activityId activityCount:(NSInteger)activityCount
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.imageName = imageName;
        self.titleName = titleName;
        self.activityId = activityId;
        self.activityCount = activityCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.activityId == self.activityCount - 1) {
    
        [self performSelector:@selector(backTaskList) withObject:nil afterDelay:1.0f];
    }

#pragma mark - 手势什么时候才起效
    //必须在这个位置
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_fingerImageView) {
        
        [_fingerImageView stopAnimating];
    }
}

/////////////////////////
#pragma mark - 自定义方法
/////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = self.titleName;
    
    [self.bgImageView setImage:[UIImage imageNamed:self.imageName]];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 设置蒙层
- (void)showGuilderMarkPathArray:(NSArray *)maskPathArray fingerImageName:(NSArray *)imageName fingerPoint:(NSArray *)fingerPointArray guildDescriptionImage:(NSArray *)guildDescriptionImageArray guildDescriptionLocationImage:(NSArray *)guildDescriptionLocationImageArray tapAreaArray:(NSArray *)tapAreaArray existButtonLocation:(CGRect)existBtnLocation
{
    
    self.fingerImageLocationArray = fingerPointArray;
    
    [self.fingerImageView removeFromSuperview];
    
    //设置图片说明
    NSMutableArray * guildDescriptionImageViewArray = [NSMutableArray array];

    UIImage * guildImage = nil;
    for(NSString * imageNameAy in guildDescriptionImageArray) {
            
        guildImage = [UIImage imageNamed:imageNameAy];
        
        [guildDescriptionImageViewArray addObject:guildImage];
    }
    
    NewUserGuildController * userGuildController = [[NewUserGuildController alloc]initWithNibName:@"NewUserGuildController" bundle:nil masksPathArray:maskPathArray guildDescriptionImageArray:guildDescriptionImageViewArray guildDescriptionImageLocationArray:guildDescriptionLocationImageArray clickAreaArray:tapAreaArray tapMaskArea:YES];
    
    //下一步操作
    weakSelf(weakSelf)
    [userGuildController setCliekStepBlock:^(NSInteger step) {
        
        CGRect rect = [[weakSelf.fingerImageLocationArray objectAtIndex:step] CGRectValue];
        
        [self.fingerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(rect.origin.x);
            make.top.mas_equalTo(weakSelf.view.mas_top).offset(rect.origin.y);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(rect.size.height);
        }];

        weakSelf.fingerImageView.animationImages = [self.fingerImageArray objectAtIndex:step];
        weakSelf.fingerImageView.animationDuration = 1.0f;
        weakSelf.fingerImageView.animationRepeatCount = 0;
        [weakSelf.fingerImageView startAnimating];
    }];
    
    
    [userGuildController setClickCompleteBlock:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(activityGuilderController:didFinishedActivitywithTag:)]) {
            
            weakSelf.activityId = weakSelf.activityId + 1;
            [weakSelf.delegate activityGuilderController:weakSelf didFinishedActivitywithTag:weakSelf.activityId];
        }
    }];
    
    [self.view addSubview:userGuildController.view];
    
    [self addChildViewController:userGuildController];
   
    [userGuildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    if (self.activityId == self.activityCount - 1) {
        
        [self.view addSubview:self.existButton];
        
        [self.existButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.view).offset(existBtnLocation.origin.y);
            make.leading.mas_equalTo(weakSelf.view).offset(existBtnLocation.origin.x);
            make.width.mas_equalTo(existBtnLocation.size.width);
            make.height.mas_equalTo(existBtnLocation.size.height);
        }];
        
        [self.backTaskListButton setHidden:YES];
        [self.view addSubview:self.backTaskListButton];
        
        [self.backTaskListButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.view).offset(((446 * SCREEN_FRAME.size.height) / 568));
            make.centerX.equalTo(weakSelf.view);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(48);
        }];
    }else
    {
        [self.view addSubview:self.existButton];
        
        [self.existButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.view).offset(existBtnLocation.origin.y);
            make.leading.mas_equalTo(weakSelf.view).offset(existBtnLocation.origin.x);
            make.width.mas_equalTo(existBtnLocation.size.width);
            make.height.mas_equalTo(existBtnLocation.size.height);
        }];
        
        //设置并开启动画
        [self.view addSubview:self.fingerImageView];
        
        CGRect rect = [[self.fingerImageLocationArray objectAtIndex:0] CGRectValue];
        
        [self.fingerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(rect.origin.x);
            make.top.mas_equalTo(weakSelf.view.mas_top).offset(rect.origin.y);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(rect.size.height);
        }];
        
        //设置手指的图片
        self.fingerImageArray = [NSMutableArray array];
        
        NSMutableArray * fingerItemArray = nil;
        UIImage * fingerImage = nil;
        for(NSArray * imageNameAy in imageName) {
            
            fingerItemArray = [NSMutableArray array];
            for (NSString * imageStr in imageNameAy) {
                
                fingerImage = [UIImage imageNamed:imageStr];
                [fingerItemArray addObject:fingerImage];
            }
            [self.fingerImageArray addObject:fingerItemArray];
        }
        
        self.fingerImageView.animationImages = [self.fingerImageArray objectAtIndex:0];
        self.fingerImageView.animationDuration = 1.0f;
        self.fingerImageView.animationRepeatCount = 0;
        [self.fingerImageView startAnimating];
    }
}

#pragma mark - 返回消息列表
- (void)backTaskList
{
    [self.backTaskListButton setHidden:NO];
}

#pragma mark - 完成任务，返回消息列表
- (void)finishedTask
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityGuilderController:didFinishedActivitywithTag:)]) {
        
        self.activityId = self.activityId + 1;
        [self.delegate activityGuilderController:self didFinishedActivitywithTag:self.activityId];
        [self.delegate activityGuilderControllerDidExistActivity];
    }
}

#pragma mark - 退出
- (void)clickExist:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityGuilderControllerDidExistActivity)]) {
        
        [self.delegate activityGuilderControllerDidExistActivity];
    }
}

//////////////
#pragma mark - protocol
//////////////////////////////////

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

////////////////////////
#pragma mark -setter/getter
///////////////////////////////////

#pragma mark - existButton
- (UIButton *)existButton
{
    if (!_existButton) {
        
        _existButton = [[UIButton alloc]init];
        [_existButton setBackgroundImage:[UIImage imageNamed:@"xn_activity_exit.png"] forState:UIControlStateNormal];
        [_existButton addTarget:self action:@selector(clickExist:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _existButton;
}

#pragma mark - backTaskListButton
- (UIButton *)backTaskListButton
{
    if (!_backTaskListButton) {
        
        _backTaskListButton = [[UIButton alloc]init];
        [_backTaskListButton setBackgroundImage:[UIImage imageNamed:@"back_task_list.png"] forState:UIControlStateNormal];
        [_backTaskListButton addTarget:self action:@selector(finishedTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTaskListButton;
}

#pragma mark - guildImageView
- (UIImageView *)fingerImageView
{
    if (!_fingerImageView) {
        
        _fingerImageView = [[UIImageView alloc]init];
    }
    return _fingerImageView;
}

@end
