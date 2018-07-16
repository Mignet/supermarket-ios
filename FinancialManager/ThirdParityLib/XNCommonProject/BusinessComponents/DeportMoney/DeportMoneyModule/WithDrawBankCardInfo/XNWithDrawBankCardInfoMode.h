//
//  XNWithDrawBankCardInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA @"userCardData"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_BANKCODE @"bank_no"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_BANKNAME @"bank_name"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_BUYERUID @"buyer_uid"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_BUYERUIN @"buyer_uin"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_IDENTIFYCARD @"identity_card"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_PARTNER_ID @"partner_id"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_PROVIDER @"provider"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_PROVIDER_PARTNER_NO @"provider_partner_no"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_REMARK @"remark"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_STATUS @"status"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_USER_CARD_NO @"user_card_no"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_USER_ID @"user_id"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_USER_NAME @"user_name"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USERCARDDATA_USER_PHONE_NO @"user_phone_no"

#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_IS_NEEDBRANCH @"isNeedBranch"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USEROUTFEE    @"userOutFee"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USEROUTFEE_FEE @"fee"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USEROUTFEE_HASFEE @"hasFee"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_USEROUTFEE_LIMITTIMES @"limitTimes"

#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA @"bankCodeData"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_ATTACH @"attach"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_DAYLIMITAMOUNT @"day_limit_amount"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_MONTHLIMITAMOUNT @"month_limit_amount"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_PROVIDER_BANK_CODE @"provider_bank_code"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_PROVIDER_NAME @"provider_name"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_RECORD_LIMIT_AMOUNT @"record_limit_amount"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_REMARK @"remark"
#define XN_ACCOUNT_MYACCONT_WITHDRAW_BANKCARD_BANKCODEDATA_SERVICE_PHONE @"service_phone"

@interface XNWithDrawBankCardInfoMode : NSObject

@property (nonatomic, strong) NSString * bankCode;
@property (nonatomic, strong) NSString * bankName;
@property (nonatomic, strong) NSString * buyerUid;
@property (nonatomic, strong) NSString * buyerUin;
@property (nonatomic, strong) NSString * userIdentity;
@property (nonatomic, strong) NSString * partnerId;
@property (nonatomic, strong) NSString * provider;
@property (nonatomic, strong) NSString * providerPartnerNo;
@property (nonatomic, strong) NSString * userCardRemark;
@property (nonatomic, strong) NSString * userCardStatus;
@property (nonatomic, strong) NSString * userCardNumber;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userPhoneNumber;
@property (nonatomic, strong) NSString * isNeedBranch;
@property (nonatomic, strong) NSString * fee;
@property (nonatomic, strong) NSString * hasFee;
@property (nonatomic, strong) NSString * limitTime;
@property (nonatomic, strong) NSString * bankCodeAttach;
@property (nonatomic, strong) NSString * dayLimitAmount;
@property (nonatomic, strong) NSString * monthLimitAmount;
@property (nonatomic, strong) NSString * providerBankCode;
@property (nonatomic, strong) NSString * providerName;
@property (nonatomic, strong) NSString * recordLimitAmount;
@property (nonatomic, strong) NSString * bankCodeRemark;
@property (nonatomic, strong) NSString * servicePhone;

+ (instancetype )initWithDrawBankCardWithObject:(NSDictionary *)params;
@end
