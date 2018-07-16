//
//  MyCustomerHeaderCell.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyCustomerHeaderCell.h"

@interface MyCustomerHeaderCell()

@property (nonatomic, strong) NSString * phoneNumber;

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * phoneLabel;
@property (nonatomic, weak) IBOutlet UIImageView * headImageView;
@property (nonatomic, weak) IBOutlet UIButton    * caredButton;
@property (nonatomic, weak) IBOutlet UIButton    * cancelCaredButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * phoneButtonTraining;
@end

@implementation MyCustomerHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//更新信息
- (void)refreshCustomHeaderImage:(NSString *)imageName customName:(NSString *)name phoneNumber:(NSString *)number caredStatus:(BOOL)status
{
    self.phoneNumber = number;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?f=png",[_LOGIC getImagePathUrlWithBaseUrl:imageName]]] placeholderImage:nil];
    [self.headImageView.layer setCornerRadius:25];
    [self.headImageView.layer setMasksToBounds:YES];
    
    self.nameLabel.text = name;
    self.phoneLabel.text = number;
    
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
