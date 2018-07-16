//
//  XNFMAgentTeamDetailMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENT_DETAIL_ORG_DESCRIBE @"orgDescribe"
#define XN_FM_AGENT_DETAIL_ORG_MEMBER_GRADE @"orgMemberGrade"
#define XN_FM_AGENT_DETAIL_ORG_MEMBER_NAME @"orgMemberName"
#define XN_FM_AGENT_DETAIL_ORG_Icon @"orgIcon"

@interface XNFMAgentTeamDetailMode : NSObject

@property (nonatomic, strong) NSString *orgDescribe; //描述
@property (nonatomic, strong) NSString *orgMemberGrade; //职位
@property (nonatomic, strong) NSString *orgMemberName; //姓名
@property (nonatomic, strong) NSString *orgIcon;  //头像

+ (instancetype)initAgentTeamDetailWithObject:(NSDictionary *)params;

@end
