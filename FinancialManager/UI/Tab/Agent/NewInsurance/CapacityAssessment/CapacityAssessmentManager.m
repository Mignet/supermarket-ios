//
//  CapacityAssessmentManager.m
//  CapacityAssessment
//
//  Created by 张吉晴 on 2018/1/4.
//  Copyright © 2018年 张吉晴. All rights reserved.
//

#import "CapacityAssessmentManager.h"
#import "CapacityAssessmentModel.h"
#import "CapacityAssessmentPopView.h"
#import "CapacityAssessmentSinglePopView.h"
#import "CapacityAssessmentViewController.h"
#import "CapacityAssessmentViewController.h"

@interface CapacityAssessmentManager () <CapacityAssessmentSinglePopViewDelegate, CapacityAssessmentPopViewDelegate>

@property (nonatomic, strong) NSMutableArray *showContentArr;

@property (nonatomic, weak) CapacityAssessmentViewController *assessVC;


@property (nonatomic, strong) NSMutableArray *familyArr;

/*** 选择的参数 **/
@property (nonatomic, strong) NSMutableDictionary *parasDic;

@end

@implementation CapacityAssessmentManager

- (void)startCapacityAssessment:(CapacityAssessmentViewController *)assessmentVC
{
    self.isExecute = YES;
    
    self.assessmentVC = assessmentVC;
    
    // 1.前缀数据
    [self handlePrefixData];
}

// 获取日期数据
- (NSArray <CapacityAssessmentModel *> *)getShowContentArr
{
    return self.showContentArr;
}

- (NSDictionary *)getParasDic
{
    return self.parasDic;
}

- (void)setShowContentArr
{
    self.showContentArr = nil;
    self.parasDic = nil;
}

- (void)handlePrefixData
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    NSArray *prefixArr = @[
                           @"hi!我是小保,是你的家庭保障小助手,偷偷告诉你我可是人工智能机器人哦~~",
                           @"那么,首先让我来了解一下你的家庭吧。"
                           ];
    
    __weak typeof (self) weakSelf = self;
    
    [prefixArr enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CapacityAssessmentModel *assessmentModel = nil;
        
        if (idx == prefixArr.count - 1) {
            assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:content isSystem:YES isWait:YES issueNum:1];
        } else {
            assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:content isSystem:YES isWait:NO issueNum:0];
        }
        
        [weakSelf.showContentArr addObject:assessmentModel];
        
    }];
    
    // 发送通知
    [self postNotification];
    
    
    // 开始第四个问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self oneIssue];
        });
    });
}

// 发送通知
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_LoadData" object:nil];
}

/***************************** 测评问题开始 ***************************/

// 第一个问题
- (void)oneIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }

    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"请先告诉我你的性别吧。" isSystem:YES isWait:YES issueNum:0];
            
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    
    NSArray *optionArr = @[@"男", @"女"];
    [self.singlePopView show:optionArr withIssueNum:1 withView:self.assessmentVC.view];
}

// 第二个问题
- (void)twoIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"选择一下你的年龄段吧。" isSystem:YES isWait:YES issueNum:0];
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    NSArray *optionArr = @[@"18岁以下", @"18岁-40岁", @"40岁以上"];
    [self.singlePopView show:optionArr withIssueNum:2 withView:self.assessmentVC.view];
}

// 第三个问题
- (void)threeIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"你的家庭成员有哪些呢?" isSystem:YES isWait:YES issueNum:4];
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    NSArray *optionArr = @[@"本人", @"配偶", @"父亲", @"母亲", @"配偶父亲", @"配偶母亲", @"子女1", @"子女2"];
    [self.morePopView show:optionArr withIssueNum:3 withMustNum:0 + 100 withView:self.assessmentVC.view];
}

// 第四个问题
- (void)fourIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"家庭保障的规划,可不能少不了家庭合计年收入这一项哦!快来选择吧~" isSystem:YES isWait:YES issueNum:4];
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    NSArray *optionArr = @[@"20万以下", @"20-50万", @"50-100万", @"100万以上"];
    [self.singlePopView show:optionArr withIssueNum:4 withView:self.assessmentVC.view];
}

// 第五个问题
- (void)fiveIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    // 家庭是否有贷款呢？家庭合计贷款也是家庭保障规划很重要的因素之一哦~
    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"家庭是否有贷款呢?家庭合计贷款也是家庭保障规划很重要的因素之一哦~" isSystem:YES isWait:YES issueNum:5];
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    NSArray *optionArr = @[@"无债一身轻", @"50万以下", @"50~100万" , @"100~200万", @"200万以上"];
    [self.singlePopView show:optionArr withIssueNum:5 withView:self.assessmentVC.view];
}

// 第六个问题
- (void)sixIssue
{
    if (!self.isExecute) { // 页面消失
        [self.showContentArr removeAllObjects];
        self.showContentArr = nil;
        self.parasDic = nil;
        return;
    }
    
    CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"说到底,家庭保障计划最重要的当然还是保障啦!那么,快来告诉我家里的哪些人已经拥有保障了吧!" isSystem:YES isWait:YES issueNum:6];
    [self.showContentArr addObject:assessmentModel];
    [self postNotification];
            
    // 弹出第一个回答框
    // 更具回答情况来显示答案
            
    NSMutableArray *optionArr = [NSMutableArray arrayWithCapacity:0];
    [optionArr addObject:@"都没有"];
    // 弹出第一个回答框
    NSArray *aimArr = @[@"本人", @"配偶", @"父亲", @"母亲", @"配偶父亲", @"配偶母亲", @"子女1", @"子女2"];
    for (NSInteger i = 0; i < self.familyArr.count; i ++) {
        NSInteger num = [self.familyArr[i] integerValue];
        [optionArr addObject:aimArr[num]];
    }
            
    [self.morePopView show:optionArr withIssueNum:6 withMustNum:0 withView:self.assessmentVC.view];
    
}

//////////////////////////////
#pragma mark - custom protocol
//////////////////////////////

// 单选弹框
- (void)capacityAssessmentSinglePopViewDid:(CapacityAssessmentSinglePopView *)singlePopView withParamsKey:(NSString *)paramsKey withOptionStr:(NSString *)optionStr withOptionNum:(NSInteger)optionNum withIssueNum:(NSInteger)issueNum
{
    if (issueNum == 1) { // 第一个问题结束 执行第二个问题
        
        [self.parasDic setObject:[NSString stringWithFormat:@"%ld", optionNum] forKey:paramsKey];
        
        CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:optionStr isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:assessmentModel];
        [self postNotification];
        
        [self twoIssue];
    }
    
    else if (issueNum == 2) { // 第二个问题结束
        
        [self.parasDic setObject:[NSString stringWithFormat:@"%ld", optionNum] forKey:paramsKey];
        
        CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:optionStr isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:assessmentModel];
        
        [self postNotification];
        
        // 第二个问题有后缀
        NSArray *postfixArr = @[@"嘿,少年!人生路上布满荆棘,持剑上路时别忘了早早的为自己添加一份保障哦!", @"大好青年哎~~这个年纪的你应该已经肩负不少责任了呢,可以多添置一些保障来分散压力哦!", @"人到中年,希望你已学会去接受生活给予的压力,一份健康保障在这个阶段可是不可或缺的哦!"];
        NSString *postfixStr = postfixArr[optionNum];
        CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:postfixStr isSystem:YES isWait:YES issueNum:0];
        [self.showContentArr addObject:postfixModel];
        [self postNotification];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self threeIssue];
            });
        });
    }
    
    else if (issueNum == 4) { // 第四个问题结束
        
        [self.parasDic setObject:[NSString stringWithFormat:@"%ld", optionNum] forKey:paramsKey];
        
        CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:optionStr isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:assessmentModel];
        [self postNotification];
        
        // 第三个问题有后缀
        NSArray *postfixArr = @[@"点滴的收入都是我们劳动的成果,要努力工作加油赚钱哦!", @"嘿嘿~家庭收入很不错呢!", @"这样的家庭收入真的让小宝很是羡慕呀,只是可惜小保并木有工资!T^T", @"土豪,小保能和你做朋友么 (●ﾟωﾟ●)"];
        NSString *postfixStr = postfixArr[optionNum];
        CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:postfixStr isSystem:YES isWait:YES issueNum:0];
        [self.showContentArr addObject:postfixModel];
        [self postNotification];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [self fiveIssue];
                
            });
        });
    }
    
    else if (issueNum == 5) { // 第五个问题结束
        
        [self.parasDic setObject:[NSString stringWithFormat:@"%ld", optionNum] forKey:paramsKey];
        
        CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:optionStr isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:assessmentModel];
        [self postNotification];
        
        // 第五个问题有后缀
        NSArray *postfixArr = @[@"哈哈,身轻如燕才可一飞冲天呀。恭喜恭喜!", @"有压力才会有动力,捋起袖子加油干!努力还贷的同时,一定要做好相关的保障哦!", @"给我一个支点,我能翘起地球!利用好金融杠杆,让银行为你打工!但要记得分散风险哦", @"啧啧啧~压力有一丢丢大呀。要记得加油哦!为保障家庭资产,要针对贷款作相对应的保险规划才是哦!", @"肩负的压力不小哦! 此时的保障可是相当重要呢! 保一份与贷款等额的保险才是明智之选哦!"];
        NSString *postfixStr = postfixArr[optionNum];
        CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:postfixStr isSystem:YES isWait:YES issueNum:0];
        [self.showContentArr addObject:postfixModel];
        [self postNotification];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sixIssue];
            });
        });
    }
}

// 多选弹框
- (void)capacityAssessmentPopViewDid:(CapacityAssessmentPopView *)popView withOptionNum:(NSArray *)optionArr withIssueNum:(NSInteger)issueNum withUIShowStr:(NSString *)str
{
    if (issueNum == 3) {
        
        NSString *familyMember = [NSString new];
        NSString *familyMemberShow = [NSString string];
        NSArray *familyArr = @[@"本人", @"配偶", @"父亲", @"母亲", @"配偶父亲", @"配偶母亲", @"子女1", @"子女2"];
        
        for (NSInteger i = 0; i < optionArr.count; i ++) {
            NSString *str = optionArr[i];
            if (i == 0) {
                familyMember = [NSString stringWithFormat:@"%@", str];
                NSString *who = [familyArr objectAtIndex:[str integerValue]];
                familyMemberShow = [NSString stringWithFormat:@"%@", who];
            } else {
                familyMember = [familyMember stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
                NSString *who = [familyArr objectAtIndex:[str integerValue]];
                familyMemberShow = [familyMemberShow stringByAppendingString:[NSString stringWithFormat:@" %@", who]];
            }
        }
        
        [self.parasDic setObject:familyMember forKey:@"familyMember"];
        
        // 添加第三个问题的答案
        CapacityAssessmentModel *assessmentModel = [CapacityAssessmentModel capacityAssessmentModelContent:familyMemberShow isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:assessmentModel];
        [self postNotification];
        
        
        // 添加牛逼的第四个问题的后缀语
        
        [self.familyArr removeAllObjects];
        [self.familyArr addObjectsFromArray:optionArr];
        
        if (optionArr.count == 1) { // 单身未选择父母
            
            CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"哇哈哈,看来你还是单身果呢。不过也很好呀,跟小保一样啦,一人吃饱全家不饿,哈哈哈。" isSystem:YES isWait:YES issueNum:0];
            [self.showContentArr addObject:postfixModel];
            [self postNotification];
            
            
            // 开始第四个问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
            
                    [self fourIssue];
                });
            });
            
        } else if (optionArr.count > 1) { // 单身选择父母
            
            // 有配偶
            BOOL a = [optionArr containsObject:@"1"];
            
            // 有父母
            BOOL b = ([optionArr containsObject:@"2"] || [optionArr containsObject:@"3"] || [optionArr containsObject:@"4"] || [optionArr containsObject:@"5"]);
            
            // 有小孩
            BOOL c = ([optionArr containsObject:@"6"] || [optionArr containsObject:@"7"]);
            
            
            if (!a && !b && !c) { // 未选配偶 未选父母 未选孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"哇哈哈,看来你还是单身果呢。不过也很好呀,跟小保一样啦。一人吃饱全家不饿,哈哈哈。" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
            }
            
            else if (!a && !b && c) { // 无配偶, 无父母，有孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"孩子是家庭的未来,小小的他们需要大大的呵护与保障哦!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
                
            }
            
            else if (!a && b && !c) { // 无配偶, 有父母，无孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"嘿嘿,看来你跟小保一样,也还是个宝宝呀!俗话说“父母在,人生尚有来处“,为他们添置一份保障让亲情永驻" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
                
            }
            
            else if (a && !b && !c) { // 有配偶 无父母，无孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"哇塞!二人世界诶~好羡慕(✿◡‿◡)。有了彼此的你们,也有了更多的责任,要做好双方的保障哦,毕竟此时彼此便是全世界呢!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
            }
            
            else if (!a && b && c) { // 无配偶 有父母，有孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"哇塞。还真是一大家子呢,上有老下有小,肩负的责任可不少哦!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
                
            }
            
            else if (a && !b && c) { // 有配偶 无父母，有孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"有宝宝的你们,真的好幸福呀。对于宝宝,家长才是他们最好的保障，所以就科学的保险规划而言,记住先保大人,后保小孩哦!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
            }
            
            else if (a && b && !c) { // 有配偶 有父母，无孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"自己成了家,也忘不了父母的养育之恩,给自己添加保障之余也要为我们年纪渐长的父母一份养老依靠哦!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
            }
            
            else if (a && b && c) { // 有配偶 有父母，有孩子
                
                CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:@"哇塞。还真是一大家子呢,上有老下有小,肩负的责任可不少哦!" isSystem:YES isWait:YES issueNum:0];
                [self.showContentArr addObject:postfixModel];
                [self postNotification];
            }
            
            // 开始第四个问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fourIssue];
                });
            });
        }
    }
    
    else if (issueNum == 6) { // 第六个问题
        
        // 存储数据
        NSString *familyEnsure = [NSString string];
        
        for (NSInteger i = 0; i < optionArr.count; i ++) {
            
            if (i == 0) {
                familyEnsure = [NSString stringWithFormat:@"%@",optionArr[i]];
            } else {
                familyEnsure = [familyEnsure stringByAppendingString:[NSString stringWithFormat:@",%@", optionArr[i]]];
            }
        }
        [self.parasDic setObject:familyEnsure forKey:@"familyEnsure"]; // 存储
        
        CapacityAssessmentModel *postfixModel = [CapacityAssessmentModel capacityAssessmentModelContent:str isSystem:NO isWait:NO issueNum:0];
        [self.showContentArr addObject:postfixModel];
        [self postNotification];
        
        
        if ([familyEnsure integerValue] == 0) {
            CapacityAssessmentModel *model = [CapacityAssessmentModel capacityAssessmentModelContent:@"家庭保障欠缺哦!不过幸好你在茫茫人海中遇到了小保老师我,我会帮你建立起一套完整的家庭保障方案,为你降低风险,提高保障. 这也是我存在的意义。" isSystem:YES isWait:YES issueNum:0];
            
            [self addObjc:model];
            
        } else {
            
            if (familyEnsure.length == 1) {
                
                CapacityAssessmentModel *model = [CapacityAssessmentModel capacityAssessmentModelContent:@"哎呦,不错哦!看来还是很有家庭保障的意识呢,不过仅有一人还是有些欠缺哦,稍后让小保来教你吧。" isSystem:YES isWait:YES issueNum:0];
                
                [self addObjc:model];
            
            } else {
            
                CapacityAssessmentModel *model = [CapacityAssessmentModel capacityAssessmentModelContent:@"干的漂亮!家庭保障的意识真的很强呢,不过还是需要小保我来帮你把把关哦,毕竟专业的人做专业的事嘛!" isSystem:YES isWait:YES issueNum:0];
                
                [self addObjc:model];
                
            }
        }
        
       [self postNotification];
        
        // 告诉测评页面测评完成（请求接口）
       [self postRequestNotification];
        
    }
}


- (void)postRequestNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Capacity_Assessment_ViewController_RequestData" object:nil];
}

- (void)addObjc:(CapacityAssessmentModel *)model
{
    [self.showContentArr addObject:model];
}

//////////////////////////////
#pragma mark - setter / getter
//////////////////////////////

- (NSMutableArray *)showContentArr
{
    if (!_showContentArr) {
        _showContentArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _showContentArr;
}

- (CapacityAssessmentSinglePopView *)singlePopView
{
    if (!_singlePopView) {
        _singlePopView = [CapacityAssessmentSinglePopView capacityAssessmentSinglePopView];
        _singlePopView.delegate = self;
        [self.assessmentVC.view addSubview:_singlePopView];
    }
    return _singlePopView;
}

- (CapacityAssessmentPopView *)morePopView
{
    if (!_morePopView) {
        _morePopView = [CapacityAssessmentPopView capacityAssessmentPopView];
        _morePopView.delegate = self;
        [self.assessmentVC.view addSubview:_morePopView];
    }
    return _morePopView;
}

- (NSMutableDictionary *)parasDic
{
    if (!_parasDic) {
        _parasDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _parasDic;
}

- (NSMutableArray *)familyArr
{
    if (!_familyArr) {
        _familyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _familyArr;
}


@end
