//
//  AppModeKeyConstant.h
//  FinancialManager
//
//  Created by xnkj on 1/29/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#ifndef AppModeKeyConstant
#define AppModeKeyConstant

#define XN_COMMON_CONSTRUCT_DATAS @"datas"

/*********************** 首页 Start ***********************/

//优质平台
#define XN_HOMEPAGE_PLATFORM_ORGLOGO @"orgLogo"
#define XN_HOMEPAGE_PLATFORM_ORGNAME @"orgName"
#define XN_HOMEPAGE_PLATFORM_ORGLINK @"orgLink"
#define XN_HOMEPAGE_PLATFORM_ORGNUMBER @"orgNumber"

#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_TIME @"time"
#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_CONTENT @"content"
#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_READSTATUS @"readFlag"
#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_CUSTOMERTYPE @"customertype"
#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_OPTYPE @"optype"
#define XN_HOMEPAGE_DYNAMIC_LIST_ITEM_CUSTOMERID @"userId"

//开机启动广告
#define XN_ADVERTISEMENT_OPENING_EXPIRETIME @"validEndDate"
#define XN_ADVERTISEMENT_OPENING_IMGURL @"imgUrl"
#define XN_ADVERTISEMENT_OPENING_LINKURL @"linkUrl"

//首页提示
#define XN_HOME_REMIND_POP_CFPLEVELCONTENT @"cfpLevelContent"
#define XN_HOME_REMIND_POP_CFPLEVELDETAIL @"cfpLevelDetail"
#define XN_HOME_REMIDN_POP_CFPLEVELTITLE @"cfpLevelTitle"
#define XN_HOME_REMIND_POP_NOW @"now"

/*********************** 首页 End   ***********************/

/*********************** 理财圈 Start ***********************/

//产品分享
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TITLE @"shareTitle"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_DESC @"shareDesc"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_IMGURL @"shareImgurl"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_URL @"shareLink"

//产品详情
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TYPE @"type";
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_TYPENAME @"typeName"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_PRODUCT_VALUE @"value"

//购买记录
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_CREATEDATE @"createDate"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_INVESTAMOUNT @"investAmount"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_MOBILE @"mobile"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_PRODUCTID @"productId"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_USERID @"userId"
#define XN_FINANCIALMANAGER_PRODUCTDETAIL_RECORD_LIST_USERNAME @"userName"

/*********************** 理财圈 End   ***********************/

/*********************** 客户服务 Start ***********************/

//投资统计-列表项数据
#define XN_CS_INVEST_STATISTIC_TIME @"date"
#define XN_CS_INVEST_STATISTIC_CUSTOMERNAME @"name"
#define XN_CS_INVEST_STATISTIC_CUSTOMERMOBILE @"mobile"
#define XN_CS_INVEST_STATISTIC_AMT @"investAmt"
#define XN_CS_INVEST_STATISTIC_PRODUCTNAME @"productName"
#define XN_CS_INVEST_STATISTIC_YEARRATE @"rate"
#define XN_CS_INVEST_STATISTIC_FEERATE @"feeRate"
#define XN_CS_INVEST_STATISTIC_INVESTCOUNT @"count"
#define XN_CS_INVEST_STATISTIC_IMAGE @"image"
#define XN_CS_INVEST_STATISTIC_CUSTOMER_ID @"uid"

//即将赎回
#define XN_CS_PAGE_INDEX @"pageIndex"
#define XN_CS_PAGE_SIZE @"pageSize"
#define XN_CS_PAGE_COUNT @"pageCount"
#define XN_CS_TOTAL_COUNT @"totalCount"
#define XN_CS_DATAS @"datas"
#define XN_CS_DATAS_CUSTOMER_IMG @"image"
#define XN_CS_DATAS_CUSTOMER_PHONE @"mobile"
#define XN_CS_DATAS_CUSTOMER_NAME @"name"
#define XN_CS_DATAS_BUY_DATE @"startDate"
#define XN_CS_DATAS_NEAR_ENDDATE @"endDate"
#define XN_CS_DATAS_PRODUCT_NAME @"productName"
#define XN_CS_DATAS_FIX_RATE @"rate"
#define XN_CS_DATAS_COMISSION_RATE @"feeRate"
#define XN_CS_DATAS_EARNINGS @"profit"
#define XN_CS_DATAS_COMISSION @"feeAmt"
#define XN_CS_DATAS_EXPI_REDEEMMONEY @"amt"
#define XN_CS_DATAS_PLATFORM @"platfrom"
#define XN_CS_DATAS_INVEST_STATE @"investState" //投资状态 0=到期|1=可赎回|2=可转让|3=可赎回且可转让

/*********************** 客户服务 End   ***********************/

/*********************** 我的 Start ***********************/

//我的职级
#define XN_MYINFO_MYLEVEL_LEVELS_NAME @"name"
#define XN_MYINFO_MYLEVEL_LEVELS_CODE @"code"

//我的消息中心
#define XN_MYINFO_MYMESSAGECENTER_UNREADMSG_BULLETIONMSGCOUNT @"bulletinMsgCount"
#define XN_MYINFO_MYMESSAGECENTER_UNREADMSG_PERSIONMSGCOUNT @"personMsgCount"

//公告消息详情
#define XN_MYINFO_MYMESSAGECENTER_ANNOUNCEDETAIL_CONTENT @"content"
#define XN_MYINFO_MYMESSAGECENTER_ANNOUNCEDETAIL_TITLE @"title"
#define XN_MYINFO_MYMESSAGECENTER_ANNOUNCEDETAIL_TIME @"time"
#define XN_MYINFO_MYMESSAGECENTER_ANNOUNCEDETAIL_MSGID @"msgId"

//推荐理财师
#define XN_MYINFO_RECOMMEND_URL @"url"
#define XN_MYINFO_RECOMMEND_ALLOWANCERULE @"allowanceRule"
#define XN_MYINFO_RECOMMEND_CHILDRENALLOWANCERULE @"childrenAllowanceRule"
#define XN_MYINFO_RECOMMEND_SHARCONTENT @"shareContent"
#define XN_MYINFO_RECOMMEND_SHARCONTENT_TITLE @"shareTitle"
#define XN_MYINFO_RECOMMEND_SHARCONTENT_DESC @"shareDesc"
#define XN_MYINFO_RECOMMEND_SHARCONTENT_LINK @"shareLink"
#define XN_MYINFO_RECOMMEND_SHARCONTENT_IMGURL @"shareImgurl"

//查询省份
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCECODE @"provinceCode"
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCEID   @"provinceId"
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCENAME @"provinceName"

//查询城市
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLCITY_CITYCODE @"cityCode"
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLCITY_CITYID   @"cityId"
#define XN_MYINFO_ACCOUNTCENTER_QUERYALLCITY_CITYNAME @"cityName"

//查询打款信息
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKCARD @"bankCard"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKNAME @"bankName"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_CITY @"city"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_PROVINCE @"province"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_KAIHUHANG @"kaiHuHang"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_FEE @"fee"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_HASFEE @"hasFee"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_LIMITTIMES @"limitTimes"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_MOBILE @"mobile"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_NEEDKAIHUHANG @"needkaiHuHang"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_TOTALAMOUNT @"totalAmount"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_USERNAME @"userName"
#define XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_PAYMENTDATE @"paymentDate"

//分享
#define XN_MI_INVITED_CUSTOMER_SHARED_TITLE @"title"
#define XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION @"desc"
#define XN_MI_INVITED_CUSTOMER_SHARED_LINK @"link"
#define XN_MI_INVITED_CUSTOMER_SHARED_IMGURL @"imgUrl"

//账户余额
#define XN_MYINFO_ACCOUNT_BALANCE_MODE_AMOUNT @"amount"
#define XN_MYINFO_ACCOUNT_BALANCE_MODE_PROFIX_TYPE @"profixType" //收益类型：1销售佣金，2推荐津贴，3活动奖励，4团队leader奖励,5投资返现红包
#define XN_MYINFO_ACCOUNT_BALANCE_MODE_PROFIX_TYPE_NAME @"profixTypeName"

/*********************** 我的 End   ***********************/

/*********************** IM模块 Start ***********************/

//传递消息（用于点击图片）
#define XN_INTERACTION_MESSAGE @"message"
#define XN_ROUTER_EVENT_CHAT_PICTURE_TAP @"kRouterEventChatPictureTap"

/*********************** IM模块 End   ***********************/

/*********************** 机构模块 Start ***********************/

//机构动态
#define XN_PLATFORM_DYNAMIC_ID @"id" //机构动态id
#define XN_PLATFORM_DYNAMIC_URL @"orgDynamicUrl" //机构动态链接
#define XN_PLATFORM_DYNAMIC_TITLE @"orgTitle" //机构动态标题
#define XN_PLATFORM_NUMBER @"orgNumber" //机构编码
#define XN_PLATFORM_DYNAMIC_TIME @"createTime" //发布时间

#define XN_PLATFORM_PICTURE @"orgPicture" //平台相关图片

/*********************** 机构模块 End   ***********************/


/*********************** 新手任务 Start ***********************/

//获取新手任务
#define XN_NEW_USER_TASK_FINISH_ALL_TASK @"finishAll" //是否完成所有任务
#define XN_NEW_USER_TASK_DISPATCH_RED_PACKET_STATUS @"grantHongbaoStatus" //派发红包任务
#define XN_NEW_USER_TASK_INVITEDCFPLANNERSTATUS  @"inviteCfplannerStatus" //邀请理财师任务
#define XN_NEW_USER_TASK_INVITEDCUSTOMER_STATUS @"inviteCustomerStatus" //邀请客户任务
#define XN_NEW_USER_TASK_BUY @"buyProductStatus" //自己购买
#define XN_NEW_USER_TASK_RECOMMENDPRODUCT_STATUS @"recommendProductStatus"//推荐产品任务
#define XN_NEW_USER_TASK_SEEPROFIT_STATUS @"seeProfitStatus" //查看收益任务
/*********************** 机构模块 End   ***********************/

/********************** 新手福利 start ***********************/

#define XN_WEFLARE_INFO_BINDCARDAMOUNT @"bindCardAmount"//绑定银行卡金额
#define XN_WEFLARE_INFO_BINDCARDSTATUS @"bindCardStatus"//绑定银行卡状态
#define XN_WEFLARE_INFO_FIRSTINVESTAMOUNT @"inviteCfplannerAmount"//邀请理财师红包金额
#define XN_WEFLARE_INFO_FIRSTINVESTAMOUNTSTATUS @"inviteCfplannerStatus"//邀请理财师状态
#define XN_WEFLARE_INFO_INVITEDCUSTOMERAMOUNT @"inviteCustomerAmount"//邀请客户红包金额
#define XN_WEFLARE_INFO_INVITEDCUSTOMERAMOUNTSTATUS @"inviteCustomerStatus"//邀请客户状态
#define XN_WEFLARE_INFO_REGISTERAMOUNT @"uploadHeadImageAmount"//上传头像红包金额
#define XN_WEFLARE_INFO_REGISTERAMOUNTSTATUS @"uploadHeadImageStatus"//上传头像状态
#define XN_WELFARE_INFO_FINISHALL @"finishAll" //是否完成新手任务

/********************** end *******************************/

/********************** 奖励明细 start ***********************/
#define XN_MYINFO_MYTEAM_DETAIL_LIST_ITEM_ALLOWANCE_LIST_AMOUNT @"amount" //	金额
#define XN_MYINFO_MYTEAM_DETAIL_LIST_ITEM_ALLOWANCE_LIST_TYPE @"type" //类型； 1推荐奖励，2直接管理，3团队管理
#define XN_MYINFO_MYTEAM_DETAIL_LIST_ITEM_ALLOWANCE_LIST_TYPE_DESC @"typeDesc"  //	类型描述；例：推荐奖励

/********************** end *******************************/

#endif
