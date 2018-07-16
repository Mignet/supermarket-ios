//
//  MyCustomerHeaderCell.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCfgHeaderCell.h"
#import "XNLCLevelPrivilegeMode.h"

@interface MyCfgHeaderCell()

@property (nonatomic, strong) NSString * phoneNumber;

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * levelLabel;
@property (nonatomic, weak) IBOutlet UIImageView * headImageView;
@property (nonatomic, weak) IBOutlet UIButton    * caredButton;
@property (nonatomic, weak) IBOutlet UIButton    * cancelCaredButton;
@property (nonatomic, weak) IBOutlet UILabel     * directRecomandCfgLabel;
@property (nonatomic, weak) IBOutlet UILabel     * secondRecommandCfgLabel;


@property (nonatomic, weak) IBOutlet UILabel *nextLevelTitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *yearProgressBgImageView;
@property (nonatomic, weak) IBOutlet UIProgressView *yearProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *yearProgressPointImageView;
@property (nonatomic, weak) IBOutlet UILabel *yearActualAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearAmountLabel;

@property (nonatomic, weak) IBOutlet UIView *levelCfpView;
@property (nonatomic, weak) IBOutlet UIImageView *levelCfpProgressBgImageView;
@property (nonatomic, weak) IBOutlet UIProgressView *levelCfpProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *levelCfpProgressPointImageView;
@property (nonatomic, weak) IBOutlet UILabel *levelCfpActualCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *levelCfpCountLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * phoneButtonTraining;
@end

@implementation MyCfgHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新信息
- (void)refreshCustomHeaderImage:(NSString *)imageName customName:(NSString *)name phoneNumber:(NSString *)number level:(NSString *)level caredStatus:(BOOL)status directRecommandCfgCount:(NSString *)directRecommandCfg secondRecommandCfgCount:(NSString *)secondRecommandCfg  levelMode:(XNLCLevelPrivilegeMode *)levelMode
{
    self.phoneNumber = number;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?f=png",[_LOGIC getImagePathUrlWithBaseUrl:imageName]]] placeholderImage:nil];
    [self.headImageView.layer setCornerRadius:25];
    [self.headImageView.layer setMasksToBounds:YES];
    
    self.nameLabel.text = name;
    self.levelLabel.text = level;
    self.phoneLabel.text = number;
    self.directRecomandCfgLabel.text = [NSString stringWithFormat:@"Ta的直推理财师：%@人",directRecommandCfg];
    self.secondRecommandCfgLabel.text = [NSString stringWithFormat:@"Ta的二级理财师：%@人",secondRecommandCfg];

    
    if (status) {
        
        [self.cancelCaredButton setHidden:NO];
        [self.caredButton setHidden:YES];
        self.phoneButtonTraining.active = NO;
    }else
    {
        [self.cancelCaredButton setHidden:YES];
        [self.caredButton setHidden:NO];
        self.phoneButtonTraining.active = YES;
    }
    
    //更新进度
    self.nextLevelTitleLabel.text = levelMode.cfpLevelTitleNew;
    self.yearActualAmountLabel.text = levelMode.yearpurAmountActualNew;
    
    UIImage *progressImage = [UIImage imageNamed:@"XN_LieCai_Level_progress.png"];
    UIImage *trackImage = [UIImage imageNamed:@"XN_LieCai_Level_track_progress.png"];
    UIImageView *yearTrackImageView = [self.yearProgressView.subviews firstObject];
    yearTrackImageView.image = progressImage;
    UIImageView *yearProgressImageView = [self.yearProgressView.subviews lastObject];
    yearProgressImageView.image = trackImage;
    
    UIImageView *levelTrackImageView = [self.levelCfpProgressView.subviews firstObject];
    levelTrackImageView.image = progressImage;
    UIImageView *levelProgressImageView = [self.levelCfpProgressView.subviews lastObject];
    levelProgressImageView.image = trackImage;
    
    //动态更新进度
    if ([NSObject isValidateInitString:levelMode.yearpurAmountMaxNew]) {
        
        NSArray *propertyArray = @[@{@"range": levelMode.yearpurAmountMaxNew,
                                     @"color": UIColorFromHex(0x666666),
                                     @"font": [UIFont fontWithName:@"DINOT" size:14]},
                                   @{@"range": @"元",
                                     @"color": UIColorFromHex(0x666666),
                                     @"font": [UIFont systemFontOfSize:10]}];
        
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        
        self.yearAmountLabel.attributedText = string;
    }else
        self.yearAmountLabel.attributedText = nil;
    
    float fYearAmountPercent = 0.0f;
    if ([NSObject isValidateInitString:levelMode.yearpurAmountMaxNew]) {
        
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame) {
            
            fYearAmountPercent = 1.0f;
        }else
        {
            fYearAmountPercent = [levelMode.yearpurAmountActualNew floatValue] / [levelMode.yearpurAmountMaxNew floatValue];
        }
    }
    self.yearProgressView.progress = fYearAmountPercent;
    
    [self.yearProgressPointImageView setHidden:NO];
    if ([levelMode.yearpurAmountMaxNew isEqualToString:@""]) {
        
        [self.yearProgressPointImageView setHidden:YES];
    }
    
    float fLeft = fYearAmountPercent * (SCREEN_FRAME.size.width - 210);
    
    __weak UIImageView *weakYearProgressBgImageView = self.yearProgressBgImageView;
    __weak UIProgressView *weakYearProgressView = self.yearProgressView;
    [self.yearProgressPointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakYearProgressView.mas_centerY);
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakYearProgressView.mas_right).offset(5);
        }
        else if([levelMode.yearpurAmountActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(fLeft);
        }
        
        make.width.mas_equalTo(@(21.5));
        make.height.mas_equalTo(@(21.5));
    }];
    
    [self.yearActualAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakYearProgressBgImageView.mas_top);
        if ([levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.yearpurAmountActualNew compare:levelMode.yearpurAmountMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakYearProgressView.mas_right);
        }
        else if([levelMode.yearpurAmountActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakYearProgressView.mas_left).offset(5);
        }else
        {
            make.left.mas_equalTo(weakYearProgressView.mas_left).offset(fLeft - 2);
        }
    }];
    
    self.levelCfpView.hidden = NO;
    if ([levelMode.lowerLevelCfpMaxNew integerValue] == 0)
    {
        self.levelCfpView.hidden = YES;
        
        return;
    }
    
    self.levelCfpActualCountLabel.text = levelMode.lowerLevelCfpActualNew;
    
    if ([NSObject isValidateInitString:levelMode.lowerLevelCfpActualNew]) {
        
        NSArray *propertyArray2 = @[@{@"range": levelMode.lowerLevelCfpMaxNew,
                                      @"color": UIColorFromHex(0x666666),
                                      @"font": [UIFont fontWithName:@"DINOT" size:14]},
                                    @{@"range": [NSString stringWithFormat:@"名%@", levelMode.lowerLevelCfp],
                                      @"color": UIColorFromHex(0x666666),
                                      @"font": [UIFont systemFontOfSize:10]}];
        
        NSAttributedString *string2 = [NSString getAttributeStringWithAttributeArray:propertyArray2];
        
        self.levelCfpCountLabel.attributedText = string2;
    }else
    {
        self.levelCfpCountLabel.attributedText = nil;
    }
    
    float fLevelCfpPercent = 0.0f;
    if ([NSObject isValidateInitString:levelMode.lowerLevelCfpMaxNew]) {
        
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame) {
            
            fLevelCfpPercent = 1.0f;
        }else
        {
            fLevelCfpPercent = [levelMode.lowerLevelCfpActualNew floatValue] / [levelMode.lowerLevelCfpMaxNew floatValue];
        }
    }
    self.levelCfpProgressView.progress = fLevelCfpPercent;
    
    float fLevelLeft = fLevelCfpPercent * (SCREEN_FRAME.size.width - 210);
    
    [self.levelCfpProgressPointImageView setHidden:NO];
    if ([levelMode.lowerLevelCfpMaxNew isEqualToString:@""]) {
        
        [self.levelCfpProgressPointImageView setHidden:YES];
    }
    
    __weak UIImageView *weakLevelCfpProgressBgImageView = self.levelCfpProgressBgImageView;
    __weak UIProgressView *weakLevelCfpProgressView = self.levelCfpProgressView;
    [self.levelCfpProgressPointImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakLevelCfpProgressView.mas_centerY);
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakLevelCfpProgressView.mas_right).offset(5);
        }
        else if([levelMode.lowerLevelCfpActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(fLevelLeft);
        }
        
        make.width.mas_equalTo(@(21.5));
        make.height.mas_equalTo(@(21.5));
    }];
    
    [self.levelCfpActualCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakLevelCfpProgressBgImageView.mas_top);
        if ([levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedDescending || [levelMode.lowerLevelCfpActualNew compare:levelMode.lowerLevelCfpMaxNew options:NSNumericSearch] == NSOrderedSame)
        {
            make.right.mas_equalTo(weakLevelCfpProgressView.mas_right).offset(-2);
        }
        else if([levelMode.lowerLevelCfpActualNew integerValue] <= 0)
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(5);
        }else
        {
            make.centerX.mas_equalTo(weakLevelCfpProgressView.mas_left).offset(fLevelLeft);
        }
    }];
}

//设置电话回调
- (void)setClickCustomerPhone:(ClickPhone)block
{
    if (block) {
        
        self.phoneBlock = block;
    }
}

//设置电话回调
- (void)setClickCustomerCared:(ClickCared)block
{
    if (block) {
        
        self.caredBlock = block;
    }
}

//设置电话回调
- (void)setClickCustomerCancelCared:(ClickCancelCared)block
{
    if (block) {
        
        self.cancelCaredBlock = block;
    }
}

//打电话
- (IBAction)clickPhone:(id)sender
{
    if (self.phoneBlock) {
        
        self.phoneBlock(self.phoneNumber);
    }
}

//关注
- (IBAction)clickCared:(id)sender
{
    if (self.caredBlock) {
        
        self.caredBlock();
    }
}

//取消关注
- (IBAction)clickCancelCared:(id)sender
{
    if (self.cancelCaredBlock) {
        
        self.cancelCaredBlock();
    }
}
@end
