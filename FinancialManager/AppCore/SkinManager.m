//
//  SkinManager.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/26.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "SkinManager.h"

@interface SkinManager ()

@end

@implementation SkinManager

- (NSString *)getHomeItemIcon:(SkinType)skinType
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    if ([configValue isEqualToString:@"1"]) { // 节日
        return (skinType == SkinType_normal) ? @"festival_btn_homePage_unselected" : @"festival_btn_homePage_selected";
    } else {
        return (skinType == SkinType_normal) ? @"btn_homePage_unselected": @"btn_homePage_selected";
    }
}

- (NSString *)getAgentItemIcon:(SkinType)skinType
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    if ([configValue isEqualToString:@"1"]) { // 节日
        return (skinType == SkinType_normal) ? @"festival_btn_platform_unselected" : @"festival_btn_platform_selected";
    } else {
        return (skinType == SkinType_normal) ? @"btn_platform_unselected": @"btn_platform_selected";
    }
}

- (NSString *)getLeiCaiItemIcon:(SkinType)skinType
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    if ([configValue isEqualToString:@"1"]) { // 节日
        return (skinType == SkinType_normal) ? @"festival_btn_lc_unselected" : @"festival_btn_lc_selected";
    } else {
        return (skinType == SkinType_normal) ? @"btn_lc_unselected": @"btn_lc_selected";
    }
}

- (NSString *)getMyInfoItemIcon:(SkinType)skinType
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    if ([configValue isEqualToString:@"1"]) { // 节日
        return (skinType == SkinType_normal) ? @"festival_btn_mine_unselected" : @"festival_btn_mine_selected";
    } else {
        return (skinType == SkinType_normal) ? @"btn_mine_unselected": @"btn_mine_selected";
    }
}

- (NSString *)getproImgIcon
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    return [configValue isEqualToString:@"1"] ? @"festival_xn_home_p2p_icon" : @"xn_home_p2p_icon";
}
- (NSString *)getfundImgIcon
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    return [configValue isEqualToString:@"1"] ? @"festival_xn_home_bund_icon" : @"xn_home_bund_icon";
}

- (NSString *)getinsuranceImgIcon
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    return [configValue isEqualToString:@"1"] ? @"festival_xn_home_insure_icon" : @"xn_home_insure_icon";
}

- (NSString *)getpublicImgIcon
{
    NSString *configValue = [_LOGIC getValueForKey:App_sysConfig_config_configValue];
    return [configValue isEqualToString:@"1"] ? @"festival_xn_home_love_icon" : @"xn_home_love_icon";
}











@end
