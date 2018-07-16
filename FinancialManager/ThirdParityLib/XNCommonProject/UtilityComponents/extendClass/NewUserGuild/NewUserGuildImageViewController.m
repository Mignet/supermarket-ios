//
//  NewUserGuildImageViewController.m
//  FinancialManager
//
//  Created by xnkj on 27/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "NewUserGuildImageViewController.h"

#import "NewUserGuildController.h"


@interface NewUserGuildImageViewController ()

@property (nonatomic, strong) NSString            * bgImageName;
@property (nonatomic, assign) BOOL                  tapMaskArea;//是否只有点击指导页中的空白部分才算点击
@property (nonatomic, strong) NSArray              * tapAreaArray;//可点击区域数组
@property (nonatomic, strong) NSArray                * masksPathArray;
@property (nonatomic, strong) NSArray               * guildDescriptionImageArray;
@property (nonatomic, strong) NSArray              * guildDescriptionImageLocationArray;

@property (nonatomic, strong) NewUserGuildController * userGuildController;

@property (nonatomic, weak) IBOutlet UIImageView * bgImageView;
@end

@implementation NewUserGuildImageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                    bgImageName:(NSString *)imageName
                 masksPathArray:(NSArray *)masksPathArray
     guildDescriptionImageArray:(NSArray *)guildDescriptionArray
guildDescriptionImageLocationArray:(NSArray *)guildDescriptionImageLocationArray
                 clickAreaArray:(NSArray *)clickAreaArray
                    tapMaskArea:(BOOL)tapMaskArea
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.bgImageName = imageName;
        self.tapMaskArea = tapMaskArea;
        self.tapAreaArray = clickAreaArray;
        self.masksPathArray = masksPathArray;
        self.guildDescriptionImageArray = guildDescriptionArray;
        self.guildDescriptionImageLocationArray = guildDescriptionImageLocationArray;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                    bgImageName:(NSString *)imagName
                 masksPathArray:(NSArray *)masksPathArray
               guildImagesArray:(NSArray *)guildImageArray
        guildImageLocationArray:(NSArray *)guildImageLocationArray
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.bgImageName = imagName;
        self.masksPathArray = masksPathArray;
        self.guildDescriptionImageArray = guildImageArray;
        self.guildDescriptionImageLocationArray = guildImageLocationArray;
    }
    return self;
}

- (void)viewDidLoad
{
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
    [self.bgImageView setImage:[UIImage imageNamed:self.bgImageName]];
    
    self.userGuildController = [[NewUserGuildController alloc]initWithNibName:@"NewUserGuildController" bundle:nil masksPathArray:self.masksPathArray guildImagesArray:self.guildDescriptionImageArray guildImageLocationArray:self.guildDescriptionImageLocationArray];
    
    weakSelf(weakSelf)
    [self.userGuildController setClickCompleteBlock:^{
        
        weakSelf.block();
        
        [weakSelf.view removeFromSuperview];
        weakSelf.view = nil;
    }];
    
    [self.view addSubview:self.userGuildController.view];
    [self addChildViewController:self.userGuildController];
    
    [self.userGuildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - 设置完成block
- (void)setClickCompleteBlock:(completeBlock )block
{
    if (block) {
        
        self.block = nil;
        self.block = [block copy];
    }
}

@end

