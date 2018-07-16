//
//  AppEnumConstant.h
//  FinancialManager
//
//  Created by xnkj on 15/10/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//


#ifndef AppEnumConstant_h
#define AppEnumConstant_h

typedef NS_ENUM(NSInteger, InvitedListType) {
    
    InvitedCustomType = 0,
    InvitedManagerType,
    IInvitedListMax
};

typedef NS_ENUM(NSInteger, LoginSourceType){

    FirstLaunchLoginSource = 0,
    ForgetGesturePasswordSource,
    ILoginSourceMax
};

typedef NS_ENUM(NSInteger, VCodeType){
    
    UserRegisterVCode = 1,
    UserResetLoginPasswordVCode,
    UserResetPayPasswordVCode,
    IVCodeMax
};

typedef NS_ENUM(NSInteger, PayPwdOperationType){

    InitPayPwdOperation,
    ModifyPayPwdOperation,
    IPayPwdOperationMax
};

typedef NS_ENUM(NSInteger, InvitedType){
    
    SignNameInvited = 2,
    AnonymousInvited,
    IInvitedMax
};

/*("0",  "提现记录"),
 ("1",  "可以审核提现资金已冻结"),
 ("2",  "审核通过，要查询支付平台打款结果"),
 ("3",  "审核不通过，解冻"),
 ("4",  "冻结失败"),
 ("5",  "提现成功"),
 ("6",  "打款失败，需要解冻"),
 ("7",  "打款失败，已处理解冻")
*/
typedef NS_ENUM(NSInteger, WithDrawResultType)
{
    WithDrawRequestReceived,
    WithDrawResultFreezed,
    verifySuccessAndCheckResult,
    verifyFailedAndNeedUnFreeze,
    FreezeFailed,
    withDrawSuccess,
    RemittanceFailedAndNeedUnFreeze,
    RemittanceFailedAndFreezed
};

typedef NS_ENUM(NSInteger, TabSwitchType){
    
    homePageTab,
    financialManagerTab,
    leicaiTab,
    myInfoTab
};

/*升级(0不需要升级,1提示升级,2强制升级)*/
typedef NS_ENUM(NSInteger, UpgradeType){

    NoNeedUpgrade,
    RemindToUpgrade,
    ForceToUpgrade
};

typedef NS_ENUM(NSInteger, ContactInvitedType)
{
    InvitedCustomer=1,
    InvitedFM,
    InvitedIMax
};

//统计-投资记录与投资客户
typedef NS_ENUM(NSInteger, InvestType)
{
    InvestRecord = 0,
    InvestCustomer,
    InvestIMax
};

//活动类型
typedef NS_ENUM(NSInteger, ActivityType)
{
    CfgActivity,
    InvestActivity,
    ActivityIMax
};

typedef NS_ENUM(NSInteger, TimeType)
{
    YearTime = 1,
    QuartzTime,
    MonthTime,
    DayTime,
    HistoryTime,
    IMaxTime
};

typedef NS_ENUM(NSInteger, SwitchType)
{
    SwitchCustomerDetailType,
    SwitchTeamDetailType,
    SwitchProfitDetailType,
    SwitchIMax
};

typedef NS_ENUM(NSInteger, AddressOptionalType)
{
    BankNameType = 0,
    ProvinceOptionalType,
    CityOptionalType,
    IMaxType
};

typedef NS_ENUM(NSInteger, InvitedPopType){
    InvitedCustomerType = 0,
    InvitedCfgType,
    HelpCenterType,
//    DeclarationType,
//    ContactServerType,
//    QuestionType,
    IMaxPopType
};

//客户类型
typedef NS_ENUM(NSInteger, CustomerType)
{
    InvestCustomerType = 1,
    UnInvestCustomerType,
    ImportantCustomerType,
    IMaxCustomerType
};

//排序字段
typedef NS_ENUM(NSInteger, CustomerSortType)
{
    CustomerInvestSortType = 1,
    CustomerRegisterSortType,
    CustomerInvestTimeSortType,
    CustomerEndTimeSortType,
    CustomerNameSortType,
    IMaxSortType
};

/* 消息 */
typedef NS_ENUM(NSInteger, MyMessageType)
{
    NotificationMessage = 0, //通知
    AnnounceMessage //公告
};

//机构－根据类型显示
typedef NS_ENUM(NSInteger, FinancialInstitutionsType)
{
    SecurityRating = 1, //安全评级
    AnnualEarnings = 2, //年化收益
    ProductDeadline = 3 //产品期限
};

//机构详情
typedef NS_ENUM(NSInteger, UIButtonTag)
{
    PlatIntroductTag = 0, //平台简介
    InvestMsgTag, //投资相关
    ArchivesTag, //档案
    PlatDynamicTag, //平台动态
    IMaxTag
};

//账户余额（收益）
typedef NS_ENUM(NSInteger, IncomeType)
{
    SaleCommissionType = 1, //销售佣金
    RecommendRewardType = 2, //推荐津贴
    ActivityRewardType = 3, //活动奖励
    InvestRedPacketType = 5, //投资返现红包
    DirectManageRewardType = 7, //直接管理津贴
    TeamManageRewardType = 8 //团队管理津贴
};

//资金明细-收支明细
typedef NS_ENUM(NSInteger, AccountBalanceDetailType)
{
    TotalTag = 0, //全部
    IncomeTag, //收入
    outTag //支出
};

//时间类别
typedef NS_ENUM(NSInteger, DateType)
{
    YearType = 1, //年
    SeasonType, //季度
    MonthType, //月
    DayType, //日
    WeekType //周
};

//产品类型
typedef NS_ENUM(NSInteger, productCategoryType){
    NewerbieProductType = 2, //新手标
    ShortProductType, //短期产品
    HighProfitProductType, //高收益产品
    LongProductType //中长期产品
};

//职级计算器
typedef NS_ENUM(NSInteger, levelCalcType){
    TraineeCfgType = 10, //见习
    ConsultantCfgType = 20, //顾问
    ManagerCfgType = 30, //经理
    MajordomoCfgType = 40 //总监
};

//职级计算器-职级类型、年化佣金率
typedef NS_ENUM(NSInteger, selectedType){
    LevelSelectedType = 1, //选中职级类型
    AnnualCommisionSelectedType //选中年化佣金率

};

//个人品牌推广
typedef NS_ENUM(NSInteger, picType){
    HotPicType,
    RecommendPicType,
    MaxType
};

//首页按钮功能种类
typedef NS_ENUM(NSInteger, HomeOperationType)
{
    P2pProductType = 10001,
    BundProductType = 10002,
    InsureProductType = 10003,
    LoveProductTYpe = 10004,
    SignPrize = 10005,
    InviteHomeCfpType = 10006,
    AboutUsType = 10007,
    
};




#endif
