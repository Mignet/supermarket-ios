//
//  CapacityAssessmentCell.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentCell.h"
#import "CapacityAssessmentModel.h"


#define Max_Content_Width (SCREEN_WIDTH - 70.f - 30.f)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface CapacityAssessmentCell ()

// 图像
@property (nonatomic, strong) UIImageView *iconImgView;

// 文本框
@property (nonatomic, strong) UITextView *textView;

// 文本背景图片
@property (nonatomic, strong) UIImageView *textBgImgView;

// 系统头像
@property (nonatomic, strong) UIImage *systemImg;

// 用户头像
@property (nonatomic, strong) UIImage *userImg;

@end


@implementation CapacityAssessmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

/////////////////////////////////
#pragma mark - custom method
/////////////////////////////////

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 头像
    self.iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"evaluation_app_icon"]];
    [self.contentView addSubview:self.iconImgView];
    
    // 文本背景图片
    self.textBgImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.textBgImgView];
    
    // 文本框
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15.f];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.textBgImgView addGestureRecognizer:tap];
    
}

- (void)setAssessmentModel:(CapacityAssessmentModel *)assessmentModel
{
    _assessmentModel = assessmentModel;
    
    if (assessmentModel.system) {
        
        self.iconImgView.image = [UIImage imageNamed:@"evaluation_app_icon"];
        self.textBgImgView.image = self.systemImg;
        
    } else {
        
        self.iconImgView.image = [UIImage imageNamed:@""];
        self.textBgImgView.image = self.userImg;
    }
    
    self.textView.text = assessmentModel.content;
    
    if (assessmentModel.numIssue == 100) {
        self.textBgImgView.userInteractionEnabled = YES;
        self.textView.textColor = UIColorFromHex(0X4E8CEF);
    } else {
        self.textBgImgView.userInteractionEnabled = NO;
        
        if (assessmentModel.system) {
            self.textView.textColor = UIColorFromHex(0X090909);
        } else {
            self.textView.textColor = [UIColor whiteColor];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize moreSize =  [self.assessmentModel.content boundingRectWithSize:CGSizeMake(Max_Content_Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil].size;
    
    if (self.assessmentModel.system == YES) { // 系统消息
        
        self.iconImgView.frame = CGRectMake(10.f, 25.f, 40.f, 40.f);
        self.textView.frame = CGRectMake(70.f, 20.f, moreSize.width + 10.f, moreSize.height + 20.f);
        self.textBgImgView.frame = CGRectMake((self.textView.frame.origin.x - 10.f), self.textView.frame.origin.y ,self.textView.frame.size.width + 20.f, self.textView.frame.size.height);
    
    } else { // 用户消息
        
        self.iconImgView.frame = CGRectZero;
        
        self.textView.frame = CGRectMake(SCREEN_WIDTH - (moreSize.width + 40.f), 20.f, moreSize.width + 10.f, moreSize.height + 20.f);
        
        self.textBgImgView.frame = CGRectMake((self.textView.frame.origin.x - 10.f), self.textView.frame.origin.y ,self.textView.frame.size.width + 20.f, self.textView.frame.size.height);
    }
}
 
- (void)tapClick
{
    if ([self.delegate respondsToSelector:@selector(capacityAssessmentCellDid:)]) {
        [self.delegate capacityAssessmentCellDid:self];
    }
}

//////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (UIImage *)systemImg
{
    if (!_systemImg) {
        UIImage *image = [UIImage imageNamed:@"evaluation_app_circle"];
        CGFloat top = 35; // 顶端盖高度
        CGFloat bottom = 20 ; // 底端盖高度
        CGFloat left = 15; // 左端盖宽度
        CGFloat right = 3; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _systemImg = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    
    return _systemImg;
}

- (UIImage *)userImg
{
    if (!_userImg) {
        UIImage *image = [UIImage imageNamed:@"evaluation_user_circle"];
        CGFloat top = 35; // 顶端盖高度
        CGFloat bottom = 20 ; // 底端盖高度
        CGFloat left = 3; // 左端盖宽度
        CGFloat right = 15; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _userImg = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _userImg;
}



@end
