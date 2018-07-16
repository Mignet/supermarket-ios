//
//  MyCustomerRegisteredPlatformCell.m
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerRegisteredPlatformCell.h"

#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGICO @"orgLogo"
#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGNAME @"orgName"
@interface MyCustomerRegisteredPlatformCell()

@property (nonatomic, assign) BOOL expandStatus;
@property (nonatomic, assign) CGFloat platformHeight;

@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView * directionImageView;
@property (nonatomic, weak) IBOutlet UIView * platformContainerView;
@end

@implementation MyCustomerRegisteredPlatformCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.expandStatus = NO;
    self.platformHeight = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//扩展操作
- (IBAction)clickExpandOperation:(id)sender
{
    if (self.expandBlock) {
        
        self.expandBlock(!self.expandStatus, self.platformHeight);
    }
}

//设置扩展处理
- (void)setClickExpandRegisteredPlatformOperation:(ExpandRegisteredPlatformOperation)block
{
    if (block) {
        
        self.expandBlock = block;
    }
}

//填充已注册的平台
- (void)setRegistedPlatform:(NSArray *)platformArray expandStatus:(BOOL)status
{
    for (UIView * subView in self.platformContainerView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    [self.titleLabel setText:[NSString stringWithFormat:@"已注册平台(%@个)",[NSNumber numberWithInteger:platformArray.count]]];
    
    [self loadAgentFromAgentArray:platformArray];
   
    self.expandStatus = status;
    if (self.expandStatus) {
        
        [self.directionImageView setImage:[UIImage imageNamed:@"XN_Customer_up_icon.png"]];
    }else
    {
        [self.directionImageView setImage:[UIImage imageNamed:@"XN_Customer_down_icon.png"]];
    }
}

//加载机构
- (void)loadAgentFromAgentArray:(NSArray *)platformArray
{
    NSInteger everyRowCount = (int)((SCREEN_FRAME.size.width - 30 + 12) / 88);
    CGFloat interval = (SCREEN_FRAME.size.width - 30 - everyRowCount * 76) / (everyRowCount - 1);
    
    NSInteger totalCol = 0;
    NSInteger countInLastCol = 0;
    if (platformArray.count > 0) {
        
        totalCol = platformArray.count / everyRowCount;
        if (platformArray.count % everyRowCount != 0) {
            
            totalCol = totalCol + 1;
        }
        
        countInLastCol = platformArray.count - everyRowCount * (totalCol - 1);
        
        self.platformHeight =  totalCol*47 + 12;
    }
    
    //开始设置机构
    UIView * agentView = nil;
    UIView * lastViewInRow  = nil;
    UIView * firstViewInCol = nil;
    NSDictionary * agentMode = nil;
    __weak UIView       * tmpLastView = lastViewInRow;
    __weak UIView       * tmpFirstView = firstViewInCol;
    __weak UIView       * tmpContainerView = self.platformContainerView;
    for (NSInteger col = 0 ; col < totalCol; col ++ ) {
        
        for (NSInteger row = 0 ; row < ((col == totalCol - 1)?countInLastCol:everyRowCount); row ++) {
            
            agentMode = [platformArray objectAtIndex:row + col * everyRowCount];
            agentView = [self createAgentViewWithPlantImageView:[agentMode objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGICO] titleName:[agentMode objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGNAME]];
            [self.platformContainerView addSubview:agentView];
            
            if (row == 0 && row < (((col == totalCol - 1)?countInLastCol:everyRowCount) - 1)) {
                
                tmpFirstView = firstViewInCol;
                [agentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.leading.mas_equalTo(tmpContainerView.mas_leading).offset(15);
                    make.top.mas_equalTo(tmpFirstView?tmpFirstView.mas_bottom:tmpContainerView.mas_top).offset(1);
                    make.height.mas_equalTo(47);
                    make.width.mas_equalTo(76);
                }];
                
            }else if(row < (((col == totalCol - 1)?countInLastCol:everyRowCount) - 1))
            {
                tmpLastView = lastViewInRow;
                [agentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.leading.mas_equalTo(tmpLastView.mas_trailing).offset(interval);
                    make.top.mas_equalTo(tmpLastView.mas_top);
                    make.height.mas_equalTo(47);
                    make.width.mas_equalTo(76);
                }];
            }else
            {
                tmpLastView = lastViewInRow;
                
                if (col == totalCol - 1) {
                    
                    [agentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        if (row == 0) {
                            
                            make.leading.mas_equalTo(tmpContainerView.mas_leading).offset(interval);
                            make.top.mas_equalTo(tmpLastView?tmpLastView.mas_bottom:tmpContainerView.mas_top);
                        }else
                        {
                            make.leading.mas_equalTo(tmpLastView.mas_trailing).offset(interval);
                            make.top.mas_equalTo(tmpLastView.mas_top);
                        }
                        
                        make.height.mas_equalTo(47);
                        make.width.mas_equalTo(76);
                    }];
                    
                }else
                {
                    [agentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.leading.mas_equalTo(tmpLastView.mas_trailing).offset(interval);
                        make.top.mas_equalTo(tmpLastView.mas_top);
                        make.height.mas_equalTo(47);
                        make.width.mas_equalTo(76);
                    }];
                }
            }
            lastViewInRow = agentView;
        }
        firstViewInCol = lastViewInRow;
    }
}

#pragma mark - 计算机构
- (UIView *)createAgentViewWithPlantImageView:(NSString *)imagePath titleName:(NSString *)titleName
{
    UIView * plantView = [[UIView alloc]init];
    
    //添加图片
    UIImageView * plantImageView = [[UIImageView alloc]init];
    [plantImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?f=png",imagePath]] placeholderImage:nil];
    
    [plantView addSubview:plantImageView];
    
    __weak UIView * tmpPlantView = plantView;
    [plantImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpPlantView.mas_leading);
        make.top.mas_equalTo(tmpPlantView.mas_top);
        make.trailing.mas_equalTo(tmpPlantView.mas_trailing);
        make.height.mas_equalTo(35);
    }];
    
    return plantView;
}

//没有注册的平台显示
- (void)showNoRegisterPlatformView
{
    UILabel * label = [[UILabel alloc]init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:UIColorFromHex(0x666666)];
    [label setText:@"当前没有已注册平台"];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [self.platformContainerView addSubview:label];
    
    __weak UIView * tmpView = self.platformContainerView;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(tmpView);
    }];
}

@end
