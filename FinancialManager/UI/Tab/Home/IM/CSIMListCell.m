//
//  CSIMListCell.m
//  FinancialManager
//
//  Created by xnkj on 15/12/11.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CSIMListCell.h"
#import "IMManager.h"
#import "UIImageView+WebCache.h"

#import "XNIMUserInfoMode.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"

@interface CSIMListCell()

@property (nonatomic, weak) IBOutlet UIImageView *avatorImageView;
@property (nonatomic, weak) IBOutlet UILabel * userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * userPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel * chatDateLabel;
@property (nonatomic, weak) IBOutlet UILabel * chatContentLabel;
@property (nonatomic, weak) IBOutlet UILabel * unReadMsgCountLabel;
@property (nonatomic, weak) IBOutlet UIView  * unReadMsgCountView;
@property (nonatomic, weak) IBOutlet UILabel * bottomLineLabel;
@property (nonatomic, weak) IBOutlet UILabel * nextBottomLineLabel;
@end

@implementation CSIMListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 更新未读消息数
- (void)refreshIMInformationForConversation:(NSDictionary *)params
{
    EMConversation * conversation = (EMConversation *)[params objectForKey:@"conversation"];
    NSInteger msgCount = [[IMManager defaultIMManager] imManagerGetUnReadMessageForConversation:conversation];
    [self.unReadMsgCountView setHidden:NO];
    if (msgCount == 0) {
        
        [self.unReadMsgCountView setHidden:YES];
    }
    
    [self.unReadMsgCountLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:msgCount]]];
    
    EMMessage * message = [conversation lastReceivedMessage];
    EMMessageBody * msgBody = message.body;
    
    //文字
    if (msgBody.type == EMMessageBodyTypeText)
    {
        EMTextMessageBody * chatMsgBody = (EMTextMessageBody *)msgBody;
        [self.chatContentLabel setText:chatMsgBody.text];
    }
    else if(msgBody.type == EMMessageBodyTypeImage)
    {
        //图片
        //        EMImageMessageBody *imageBody = [message.messageBodies objectAtIndex:0];
        //        EMChatImage *chatImage = [imageBody chatObject];
        [self.chatContentLabel setText:@"［图片］"];
    }
    
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:(message.timestamp / 1000)];
    [self.chatDateLabel setText:[NSString stringFromDate:date formater:@"YYYY-MM-dd HH:mm:ss"]];
    
        
    XNIMUserInfoMode * mode = [params objectForKey:@"userInfo"];
    //对方头像
    NSString *serviceString = @"";
    if ([[[XNCommonModule defaultModule] configMode] kefuEasemobileName])
    {
        serviceString = [[[XNCommonModule defaultModule] configMode] kefuEasemobileName];
    }
    else
    {
        serviceString = [AppFramework getConfig].XN_SERVICE_EASEMOB_NAME;
    }
    //如果是客服
    if ([mode.easemobAccount isEqualToString:serviceString])
    {
        [self.avatorImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"XN_CS_IM_List_ServiceHeaderImg.png"]];
    }
    else
    {
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:mode.userPic]] placeholderImage:[UIImage imageNamed:@"XN_CS_IM_List_CustomerHeaderImg.png"]];
        
        [self.avatorImageView.layer setCornerRadius:20];
        [self.avatorImageView.layer setMasksToBounds:YES];
    }
    
        
    [self.userNameLabel setText:mode.userName];
    [self.userPhoneLabel setText:mode.mobile];
}

#pragma mark - 更新内容
- (void)refreshContent:(NSDictionary *)params AtLastIndex:(BOOL)isTrue
{
    [self.bottomLineLabel setHidden:NO];
    [self.nextBottomLineLabel setHidden:YES];
    if (isTrue) {
        
        [self.bottomLineLabel setHidden:YES];
        [self.nextBottomLineLabel setHidden:NO];
    }
}

@end
