//
//  XNFMProductDetailMode.h
//  FinancialManager
//
//  Created by xnkj on 1/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>
/*" buyIncreaseMoney	购买递增金额	number
 buyLinkUrl	产品购买链接	string
 buyMaxMoney	产品单笔购买最大额度	number
 buyMinMoney	产品单笔购买最小额度	number
 buyTotalMoney	产品总额度	number	产品募集要达到的总额度数不能为空作为募集完成时间确定条件之一
 buyedTotalMoney	产品被投资总额	number
 buyedTotalPeople	产品已投资人数	number
 cfpRecommend	是否理财师推荐	number	0-未推荐 其他-已推荐
 collectBeginTime	募集开始时间	string	格式yyyy-mm-ddhh:mm:ss
 collectEndTime	募集截止时间	string	可以为nul格式yyyy-mm-ddhh:mm:ss
 createTime	创建时间	string
 creator	创建者用户名	string
 deadLineType	期限类型	number	1=天数|2=自然月
 deadLineValue	产品期限天数或月数值	number
 detailOpenType	产品详情打开方式	number	0-原页打开 1-新页面打开
 detailOpenUrl	产品详情打开URL	string
 feeRatio	佣金率	number
 fixRate	固定利率	number
 flowFinalRate	浮动最后利率	number
 flowMaxRate	浮动最大利率	number
 flowMinRate	浮动最小利率	number
 id	产品表自增长主键	number
 interestWay	起息方式	number
 isCollect	是否需要募集开始及截止时间	number	1=不需要|2=需要
 isFlow	是否浮动利率	number	1=固定利率|2=浮动利率
 isQuota	是否限额产品	number	1-限额、2-不限额
 isRedemption	是否可赎回	number	1=不赎回|2=赎回
 isShow	是否要显示在前端	number	1= 显示在列表|2= 显示在首页和列表|3= 显示在首页|4= 隐藏
 moneyType	货币类型	number	1=rmb|2=港币|3=美元
 orgInfoResponse	平台信息	object
 capital	注册资金	string
 city	所在城市	string
 feeRateMax	年化收益-最大	number
 feeRateMin	年化收益-最小	number
 icp	ICP备案	string
 id	平台信息表id	number
 orgBack	平台背景	string
 orgLevel	平台级别	string
 orgLogo	平台logo	string
 orgName	平台名称	string
 orgNo	平台编码	string
 orgProfile	平台简介	string
 orgSecurity	安全保障	string
 orgUrl	机构官网的url	string
 proDaysMax	产品期限-最大	number
 proDaysMin	产品期限-最小	number
 teamInfos	团队信息	array<object>
 id	团队表id	number
 orgDescribe	团队介绍	string
 orgIcon	团队logo	string
 orgId	机构主键id	number
 orgMemberGrade	职位	string
 orgMemberName	姓名	string
 trusteeship	资金托管	string
 upTime	上线时间	string
 orgNumber	机构编码	string
 productDesc	产品描述	string
 productId	产品uuid	string	内部产品id
 productName	产品名称	string
 productTypeId	产品类型表tcim_product_type的主键	number
 remark	修改或审核操作的说明	string
 repaymentWay	还本付息方式	number	1=一次性到期|2=一次性按日|3=一次性按月|4=一次性按季|5=等额本息(按月)|6=等额本息(按季)
 repaymentWayName	还本付息方式名称	string
 riskControlType	风控类型	number	1=抵押|2=担保|3=信贷
 riskLevel	风险级别	number	1=一般|2=重要|3=紧急|4=非常紧急
 showIndex	移动端显示排序索引	number
 sourceWay	来源方式	number	1=公司内部产品|2=公司外部产品
 status	产品状态	number	1=待审核(数据初始化)|2=审核通过(预售)|3-在售|4-售罄|5-下架|7=已删除|8=驳回|说明状态是顺序的不能往回审核通过的也可以修改除状态外的其它字段|9-募集中|10-募集失败|11-募集成功'
 thirdProductId	外部产品id	string
 updateTime	最后一次修改时间	string
 updater	最后一次修改者用户名	string
 validBeginDate	产品起息日	string	格式yyyy-mm-dd
 validEndDate	产品到期日	string	格式yyyy-mm-dd
*/

#define XN_FM_PRODUCT_DETAIL_BUYINCREASE_MONEY  @"buyIncreaseMoney"
#define XN_FM_PRODUCT_DETAIL_BUYMAX_BUYLINK       @"buyLinkUrl"
#define XN_FM_PRODUCT_DETAIL_BUYMAX_MONEY       @"buyMaxMoney"
#define XN_FM_PRODUCT_DETAIL_BUYMIN_MONEY       @"buyMinMoney"
#define XN_FM_PRODUCT_DETAIL_BUYTOTAL_MONEY     @"buyTotalMoney"
#define XN_FM_PRODUCT_DETAIL_BUYEDTOTAL_MONEY   @"buyedTotalMoney"
#define XN_FM_PRODUCT_DETAIL_BUYEDTOTAL_PEOPLE  @"buyedTotalPeople"
#define XN_FM_PRODUCT_DETAIL_CFPRECOMMEND       @"cfpRecommend"
#define XN_FM_PRODUCT_DETAIL_COLLECTBEGINTIME      @"collectBeginTime"
#define XN_FM_PRODUCT_DETAIL_COLLECTENDTIME     @"collectEndTime"
#define XN_FM_PRODUCT_DETAIL_CREATETIE          @"createTime"
#define XN_FM_PRODUCT_DETAIL_CREATEER       @"creator"
#define XN_FM_PRODUCT_DETAIL_DEADLINETYPE       @"deadLineType"
#define XN_FM_PRODUCT_DETAIL_DEADLINEVALUE            @"deadLineValue"
#define XN_FM_PRODUCT_DETAIL_DETAILOPENTYPE      @"detailOpenType"
#define XN_FM_PRODUCT_DETAIL_DETAILOPENURL       @"detailOpenUrl"
#define XN_FM_PRODUCT_DETAIL_FEERATIO        @"feeRatio"
#define XN_FM_PRODUCT_DETAIL_FIXRATE  @"fixRate"
#define XN_FM_PRODUCT_DETAIL_FLOWFINALRATE       @"flowFinalRate"
#define XN_FM_PRODUCT_DETAIL_FLOWMAXRATE @"flowMaxRate"
#define XN_FM_PRODUCT_DETAIL_FLOWMINRATE   @"flowMinRate"
#define XN_FM_PRODUCT_DETAIL_INTERESTWAY @"interestWay"
#define XN_FM_PRODUCT_DETAIL_ISCOLLECT       @"isCollect"
#define XN_FM_PRDOCUT_DETAIL_ISFLOW             @"isFlow"
#define XN_FM_PRODUCT_DETAIL_ISQUOTA          @"isQuota"
#define XN_FM_PRODUCT_DETAIL_ISREDEMPTION                 @"isRedemption"
#define XN_FM_PRODUCT_DETAIL_ISSHOW              @"isShow"
#define XN_FM_PRODUCT_DETAIL_MONEYTYPE            @"moneyType"
#define XN_FM_PRODUCT_DETAIL_ORGINFORESPONSE        @"orgInfoResponse"
#define XN_FM_PRODUCT_DETAIL_ORGNUMBER          @"orgNumber"
#define XN_FM_PRODUCT_DETAIL_PRODUCTDESC              @"productDesc"
#define XN_FM_PRODUCT_DETAIL_PRODUCTID     @"productId"
#define XN_FM_PRODUCT_DETAIL_PRODUCTNAME            @"productName"
#define XN_FM_PRODUCT_DETAIL_STATUS           @"status"
#define XN_FM_PRODUCT_DETAIL_THIRDPRODUCTID           @"thirdProductId"


@interface XNFMProductDetailMode : NSObject

@property (nonatomic, assign) double     buyIncreaseMoney;
@property (nonatomic, strong) NSString * buyLinkUrl;
@property (nonatomic, assign) double     buyMaxMoney;
@property (nonatomic, assign) double     buyMinMoney;
@property (nonatomic, assign) double     buyTotalMoney;
@property (nonatomic, assign) double     buyedTotalMoney;
@property (nonatomic, assign) double     buyedTotalPeople;

@property (nonatomic, assign) NSInteger       cfpRecommend;
@property (nonatomic, strong) NSString * collectBeginTime;
@property (nonatomic, strong) NSString * collectEndTime;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * creator;
@property (nonatomic, assign) NSInteger  deadLineType;
@property (nonatomic, assign) NSInteger  deadLineValue;
@property (nonatomic, assign) NSInteger  detailOpenType;
@property (nonatomic, assign) NSInteger  detailOpenUrl;

@property (nonatomic, assign) double     feeRatio;
@property (nonatomic, assign) double     fixRate;
@property (nonatomic, assign) double     flowFinalRate;
@property (nonatomic, assign) double     flowMaxRate;
@property (nonatomic, assign) double     flowMinRate;
@property (nonatomic, assign) NSInteger  interestWay;
@property (nonatomic, assign) NSInteger  isCollect;
@property (nonatomic, assign) NSInteger  isFlow;

@property (nonatomic, assign) NSInteger  isQuota;
@property (nonatomic, assign) NSInteger  isRedemption;
@property (nonatomic, assign) NSInteger  isShow;
@property (nonatomic, assign) NSInteger  moneyType;
@property (nonatomic, strong) NSDictionary * orgInfoDictionary;
@property (nonatomic, strong) NSString  * orgNumber;
@property (nonatomic, strong) NSString  * productDesc;
@property (nonatomic, strong) NSString  * productId;
@property (nonatomic, strong) NSString  * productName;
@property (nonatomic, assign) NSInteger  saleStatus;
@property (nonatomic, strong) NSString  * thirdProductId;

+ (instancetype)initProductDetailWithParams:(NSDictionary *)params;
@end
