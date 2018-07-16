//
//  NSUserDefaultTagDefine.h
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#ifndef NSUSERDEFAULTAGDEFINE
#define NSUSERDEFAULTAGDEFINE

/*=========app的公共信息===============*/
#define COMMON_APP_OLD_VERISON_TAG  @"COMMON_APP_OLD_VERSION_TAG"
#define COMMON_APP_FIRST_LAUNCH_TAG @"COMMON_APP_FIRST_LAUNCH_TAG"
#define COMMON_JFZ_APP_UUID_TAG     @"COMMON_JFZ_APP_UUID_TAG"
#define COMMON_JFZ_LAUNCH_INFO_TAG  @"COMMON_JFZ_LAUNCH_INFO_TAG"
#define COMMON_APP_PUSH_NOTIFICATION_DISTURBED_TAG @"COMMON_APP_PUSH_NOTIFICATION_DISTURBED_TAG"
#define COMMON_APP_LOGIN_SATTUS @"COMMON_APP_LOGIN_SATTUS"  //1表示通过直接进入注册／激活登录，0表示通过登陆界面登录

/**=============== 手势密码 START==============*/

#define XN_GESTURE_PASSWORD_TAG     [@"XN_GESTURE_PASSWORD_TAG" md5]

/**===============END================*/

/**=============== 用户相关信息 =======================*/

#define XN_USER_MOBILE_TAG          [@"XN_USER_MOBILE_TAG" md5]
#define XN_USER_TOKEN_TAG           [@"XN_USER_TOKEN_TAG" md5]
#define XN_DEVICE_TOKEN_TAG         [@"XN_DEVICE_TOKEN_TAG" md5]

#define XN_USER_INIT_PAY_PASSWORD_CONTROLLER   @"XN_USER_INIT_PAY_PASSWORD_CONTROLLER"

#define XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG @"XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG"

#define XN_USER_ENTER_MAIN_INTERFACE @"XN_USER_ENTER_MAIN_INTERFACE"
#define XN_USER_USER_TOKEN_EXPIRED @"XN_USER_USER_TOKEN_EXPIRED"
#define XN_USER_SERVICE_NEW_MESSAGE @"XN_USER_SERVICE_NEW_MESSAGE"

#define XN_USER_FINGER_PASSWORD_SET @"XN_USER_FINGER_PASSWORD_SET"

#define XN_USER_FIRST_ENTER_APP @"XN_USER_FIRST_ENTER_APP"
#define XN_USER_


#define App_sysConfig_config_configValue @"APP_SYSCONFIG_CONFIG_CONFIGVALUE"

/**=============== END ==============================*/

/**=============== 新手指引相关信息 =======================*/

#define XN_USER_INSURANCE_NEWUSER_TAG @"XN_USER_INSURANCE_NEWUSER_TAG"
#define XN_USER_HOME_NEWUSER_KNOW_US_TAG @"XN_USER_HOME_NEWUSER_KNOW_US_TAG"
#define XN_USER_SEEK_TREASURE_ACTIVITY @"XN_USER_SEEK_TREASURE_ACTIVITY"
#define XN_USER_AGENT_CONTAINER_INSURANCE @"XN_USER_AGENT_CONTAINER_INSURANCE"


/**=============== END ==============================*/

/**=============== 月度收益 START==============*/

#define XN_IS_CLOSE_BALANCE_MONTH_INCOME_DESC_TAG     @"XN_IS_CLOSE_BALANCE_MONTH_INCOME_DESC_TAG"

/**===============END================*/

/**=============== 团队leader 奖励 ==============*/

#define XN_IS_CLOSE_NON_LEADER_REWARD_DESC_TAG @"XN_IS_CLOSE_NON_LEADER_REWARD_DESC_TAG"

/**===============END================*/

/**=============== 平台详情 START ==============*/

#define XN_IS_CLOSE_AGENT_DETAIL_BUY_POP_TAG @"XN_IS_CLOSE_AGENT_DETAIL_BUY_POP_TAG"

/**===============END================*/

/**=============== 首页 ==============*/

#define XN_IS_SHOW_HOME_POP_ADV_TAG @"XN_IS_SHOW_HOME_POP_ADV_TAG"
#define XN_IS_SHOW_HOME_REMIND_TAG @"XN_IS_SHOW_HOME_REMIND_TAG"
#define XN_IS_SHOW_HOME_NEW_REDPACKET_TAG @"XN_IS_SHOW_HOME_NEW_REDPACKET_TAG"
#define XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG @"XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG"
#define XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG @"XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG"
#define XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG @"XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG"
#define XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG @"XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG"

/**===============END================*/

/**=============== 投资-基金列表 ==============*/

#define XN_IS_DEFAULT_TYPE_FUND_LIST_TAG @"XN_IS_DEFAULT_TYPE_FUND_LIST_TAG"

/**===============END================*/

/**=============== 奖励 ==============*/

#define XN_MY_PROFIT_WARNING_TAG @"XN_MY_PROFIT_WARNING_TAG"
#define XN_MY_LEADER_WARNING_TAG @"XN_MY_LEADER_WARNING_TAG"

/**===============END================*/

/**=============== 我的投资记录 已读／未读 ==============*/

#define XN_MY_INVEST_RECORD_INVESTING_PRODUCT_UNREAD_TAG @"XN_MY_INVEST_RECORD_INVESTING_PRODUCT_UNREAD_TAG"
#define XN_MY_INVEST_RECORD_EXPIRED_PRODUCT_UNREAD_TAG @"XN_MY_INVEST_RECORD_EXPIRED_PRODUCT_UNREAD_TAG"

/**===============END================*/













#endif
