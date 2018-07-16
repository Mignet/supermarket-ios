//
//  CSIMViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/12/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CSIMViewController.h"

#import "CSIMCustomerMsgCell.h"
#import "CSIMAdminMsgCell.h"

#import "MJRefresh.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "IMManager.h"

#import "XNUserInfo.h"
#import "XNUserModule.h"
#import "NSString+common.h"

#define DEFAULTMESSAGECOUNT 10

@interface CSIMViewController ()<UITableViewDataSource,UITableViewDelegate,IMManagerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGFloat  keyboardHeight;
@property (nonatomic, strong) NSString               * userName;
@property (nonatomic, strong) EMConversation         * conversation;
@property (nonatomic, strong) NSString               * SendMsgUserId;
@property (nonatomic, strong) NSString               * receiveMsgUserId;
@property (nonatomic, assign) BOOL isEnterService;  //是否是客服页面
@property (nonatomic, strong) NSString               * themeName; //
@property (nonatomic, strong) NSString               * customerPicUrl;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) NSMutableArray         * msgContentMutaArray;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) IBOutlet UITableView     * chatContentTableView;
@property (nonatomic, weak) IBOutlet UITextView      * themeInputTextView;
@property (nonatomic, weak) IBOutlet UILabel         * themeLabel;
@property (nonatomic, weak) IBOutlet UIView          * themeInputView;

@end

@implementation CSIMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            titleName:(NSString *)title
         conversation:(EMConversation *)conversation
         enterService:(BOOL)isEnterService
          chatAccount:(NSString *)chatAccount
            themeName:(NSString *)themeName
     customerImageUrl:(NSString *)imageUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.userName = title;
        self.receiveMsgUserId = chatAccount;
        self.conversation = conversation;
        self.isEnterService = isEnterService;
        self.themeName = themeName;
        self.customerPicUrl = imageUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMManager defaultIMManager] setDelegate:self];
    [self.msgContentMutaArray removeAllObjects];
    
    self.SendMsgUserId = [[[XNUserModule defaultModule] userMode] easemobAccount];

    [[IMManager defaultIMManager] imManagerMaskMesasgeReadedForConversation:self.conversation];
    
    [[IMManager defaultIMManager] imManagerGetMessageCount:DEFAULTMESSAGECOUNT
                                          FromConversation:self.conversation
                                             FromMessageId:self.conversation.latestMessage.messageId
                                                completion:^(NSArray *aMessages, EMError *aError)
    {
        if ([NSObject isValidateObj:aMessages]) {
           
            for (NSInteger index = 0 ; index < aMessages.count; index ++) {
                
                if ([NSObject isValidateObj:aMessages])
                   [self.msgContentMutaArray addObject:[aMessages objectAtIndex:index]];
            }
            
            if ([NSObject isValidateObj:self.conversation.lastReceivedMessage]) {
                
                [self.msgContentMutaArray addObject:self.conversation.latestMessage];
            }
            
            if (self.msgContentMutaArray.count > 0) {
                
                [self.chatContentTableView reloadData];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.msgContentMutaArray.count - 1 inSection:0];
                [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[IMManager defaultIMManager] setDelegate:nil];
    
    //发送通知，改变导航栏图标
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_SERVICE_MSG object:@"0"];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////
#pragma mark - 自定义方法汇总
//////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = self.userName;
    self.keyboardHeight = 0.0f;
    
    //进入客服页面
    if (self.isEnterService)
    {
        self.themeLabel.textColor = UIColorFromHex(0x969696);
        self.themeLabel.text = self.themeName;
        if (IOS_IPHONE4_SCREEN)
        {
            self.themeLabel.font = [UIFont systemFontOfSize:12.0f];
        }
        else
        {
            self.themeLabel.font = [UIFont systemFontOfSize:14.0f];
        }

    }
    else
    {
        self.themeLabel.textColor = [UIColor clearColor];
        self.themeLabel.text = @"";
        self.themeInputTextView.text = [NSObject isValidateInitString:self.themeName]?[NSString stringWithFormat:@"#%@# ",self.themeName]:@"";
    }
    
    [self.chatContentTableView registerNib:[UINib nibWithNibName:@"CSIMCustomerMsgCell" bundle:nil] forCellReuseIdentifier:@"CSIMCustomerMsgCell"];
    [self.chatContentTableView registerNib:[UINib nibWithNibName:@"CSIMAdminMsgCell" bundle:nil] forCellReuseIdentifier:@"CSIMAdminMsgCell"];
    [self.chatContentTableView setSeparatorColor:[UIColor clearColor]];
    
    weakSelf(weakSelf)
    self.chatContentTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.msgContentMutaArray.count > 0) {
            
            EMMessage * msg = [weakSelf.msgContentMutaArray firstObject];
            
            [[IMManager defaultIMManager] imManagerGetMessageCount:DEFAULTMESSAGECOUNT
                                                  FromConversation:self.conversation
                                                     FromMessageId:msg.messageId
                                                        completion:^(NSArray *aMessages, EMError *aError)
             {
                 if (aMessages.count > 0) {
                     
                     NSIndexPath * indexPath = [NSIndexPath indexPathForRow:aMessages.count - 1 inSection:0];
                     [self insertMsgToMsgArrayHeader:aMessages];
                     [self.chatContentTableView reloadData];
                     [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                 }else
                 {
                     [self.chatContentTableView.mj_header setHidden:YES];
                 }
                 
                 [self.chatContentTableView.mj_header endRefreshing];
             }];
        }
    }];

    [self.view addSubview:self.chatContentTableView];
    [self.view addSubview:self.themeInputView];
    
    [self.themeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(50);
    }];
    
    __weak UIView * tmpView = self.themeInputView;
    [self.chatContentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.bottom.mas_equalTo(tmpView.mas_top);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (weakSelf.themeInputTextView.text.length > 0) {
            
            [weakSelf.themeLabel setText:weakSelf.themeInputTextView.text];
            
            CGSize size = [weakSelf.themeLabel sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 138, 2000)];
            if (size.height > 70) {
                
                size.height =70;
                [weakSelf.themeInputTextView setContentOffset:CGPointMake(0, weakSelf.themeInputTextView.contentSize.height - 80)];
            }
            
            if ((int)size.height > 24) {
                
                [weakSelf.view layoutIfNeeded];
                [weakSelf.themeInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.height.mas_equalTo(size.height + 16 + 10);
                }];
                [weakSelf.view layoutIfNeeded];
            }
            weakSelf.themeLabel.text = @"";
        }
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 发送消息
- (IBAction)clickSendMsg:(id)sender
{
    if ((![[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] isLoginingStatus]) || ([[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] imManagerConnectStatus])) {

        //如果账号和密码为空，重新拉取一遍
        if (![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobAccount]] || ![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobPassword]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERHXNILNOTIFICATION object:nil];
            
            return;
        }
        
        [self.view showGifLoading];
        
        @try {
            
            [[IMManager defaultIMManager] imManagerLogout];
            [[IMManager defaultIMManager] imManagerLoginWithAccount:[[[XNUserModule defaultModule] userMode] easemobAccount] password:[[[XNUserModule defaultModule] userMode] easemobPassword]];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
       
        return;
    }
    
    //禁止发送纯空格
    self.themeInputTextView.text = [NSString trimString:self.themeInputTextView.text];
    if (self.themeInputTextView.text.length <= 0)
    {
        return;
    }
    
    EMMessage * message = [[IMManager defaultIMManager] imManagerSendContent:self.themeInputTextView.text
                                        conversationId:self.conversation.conversationId
                                          fromReceiver:self.receiveMsgUserId
                                              chatType:EMChatTypeChat
                                                   ext:[self getUserInfoAttribute]];
    
    [self.msgContentMutaArray addObject:message];
    
    [self.chatContentTableView reloadData];
    
    [self.themeInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50);
    }];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.msgContentMutaArray.count - 1 inSection:0];
    [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    self.themeInputTextView.text = @"";
}

-(void)sendImageMessage:(UIImage *)imageMessage
{
    if ((![[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] isLoginingStatus]) || ([[IMManager defaultIMManager] imManagerLoginStatus] && ![[IMManager defaultIMManager] imManagerConnectStatus])) {
        
        //如果账号和密码为空，重新拉取一遍
        if (![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobAccount]] || ![NSObject isValidateInitString:[[[XNUserModule defaultModule] userMode] easemobPassword]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERHXNILNOTIFICATION object:nil];
            return;
        }
        
        [self.view showGifLoading];
        
        @try {
            
            [[IMManager defaultIMManager] imManagerLogout];
            [[IMManager defaultIMManager] imManagerLoginWithAccount:[[[XNUserModule defaultModule] userMode] easemobAccount] password:[[[XNUserModule defaultModule] userMode] easemobPassword]];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        [self.view hideLoading];
        return;
    }
    
    //发送图片
    EMMessage * emMessage = [[IMManager defaultIMManager] imManagerSendImage:imageMessage
                                                                   iMageName:@""
                                                              conversationId:self.conversation.conversationId
                                                                fromReceiver:self.receiveMsgUserId
                                                                    chatType:EMChatTypeChat
                                                                         ext:[self getUserInfoAttribute]];
    //显示出来
    [self.msgContentMutaArray addObject:emMessage];
    [self.chatContentTableView reloadData];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.msgContentMutaArray.count - 1 inSection:0];
    [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    
    NSDictionary * notifDic = [notif userInfo];
    
    NSValue * endValue = [notifDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [endValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    
    NSValue * animationDurationValue = [notifDic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self.view layoutIfNeeded];
    weakSelf(weakSelf)
    [self.themeInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-keyboardRect.size.height);
    }];
    
    [self.chatContentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.height.mas_equalTo(SCREEN_FRAME.size.height - keyboardRect.size.height - 44 - 64);
    }];
    
    [self.chatContentTableView setContentOffset:CGPointMake(0 , self.chatContentTableView.contentSize.height)];
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
    
    self.keyboardHeight = 0.0f;
    
    NSDictionary * notifDic = [notif userInfo];
    NSValue * animationDurationValue = [notifDic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self.view layoutIfNeeded];
    weakSelf(weakSelf)
    [self.themeInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.chatContentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.height.mas_equalTo(SCREEN_FRAME.size.height - self.keyboardHeight - 44 - 64);
    }];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 退出键盘
- (void)exitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 消息体转化为字典
- (NSDictionary *)messageConvertToDictionary:(EMMessage *)message
{
    EMTextMessageBody * msgBody = (EMTextMessageBody *)message.body;
    
    NSData * data = [msgBody.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return dic;
}

#pragma mark - 数组中插入数组到数组头
- (void)insertMsgToMsgArrayHeader:(NSArray *)array
{
    for (NSInteger i = (array.count - 1) ; i >= 0; i -- ) {
        
        [self.msgContentMutaArray insertObject:[array objectAtIndex:i] atIndex:0];
    }
}

#pragma mark - 进入相册
- (IBAction)photoAlbumAction
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePickerController animated:YES completion:NULL];
}

#pragma mark - 图片被点击
- (void)chatImageCellPressed:(EMMessage *)emMessage
{
    __weak CSIMViewController *weakController = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody *)emMessage.body;
    
    //如果缩略图下载成功
    if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed)
    {
        //开始加载大图
        [[IMManager defaultIMManager] downloadIMMessage:emMessage
                                                       progress:nil
                                                     completion:^(EMMessage *message, EMError *error)
         {
         
             if (!error)
             {
                 EMFileMessageBody * fileMessage = (EMFileMessageBody *)message.body;
                 
                 NSString *localPath = message == nil ? imageBody.localPath : [fileMessage localPath];
                 if (localPath && localPath.length > 0)
                 {
                     NSURL *url = [NSURL fileURLWithPath:localPath];
                     //查看头像大图
                     NSMutableArray *photos = [NSMutableArray arrayWithCapacity:5];
                     
                     // 替换为中等尺寸图片
                     MJPhoto *photo = [[MJPhoto alloc] init];
                     photo.url = url;
                     [photos addObject:photo];
                     
                     // 2.图片预览（放大）
                     MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                     browser.isShowSaveButton = NO;  //显示保存按钮
                     browser.photos = photos; // 设置所有的图片
                     [browser show];
                 }
             }

         }];
    }
    else
    {
        //获取缩略图
        [[IMManager defaultIMManager] downloadIMMessage:emMessage
                                        progress:nil
                                       completion:^(EMMessage * message, EMError * error)
        {
            if (!error)
            {
                //                [weakController reloadTableViewDataWithMessage:emMessage];
            }
            else
            {
                [weakController showCustomWarnViewWithContent:@"获取图片失败！"];
            }
        }];
    }
    
}

#pragma mark - 扩展信息（用户信息）
- (NSDictionary *)getUserInfoAttribute
{
    NSDictionary *ext = nil;
    NSMutableDictionary *visitor = [NSMutableDictionary dictionary];
    
    if ([[[XNUserModule defaultModule] userMode] userName] && [[[XNUserModule defaultModule] userMode] userName].length > 0)
    {
        [visitor setObject:[[[XNUserModule defaultModule] userMode] userName] forKey:@"userNickname"];
    }
    else
    {
        [visitor setObject:[[[XNUserModule defaultModule] userMode] mobile] forKey:@"userNickname"];
    }
    [visitor setObject:[[[XNUserModule defaultModule] userMode] userName] forKey:@"trueName"];
    [visitor setObject:[[[XNUserModule defaultModule] userMode] mobile] forKey:@"phone"];
    
    NSString *descString = [NSString stringWithFormat:@"来源IOS猎财大师%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [visitor setObject:descString forKey:@"description"];
    
    [visitor setObject:@"" forKey:@"companyName"];
    [visitor setObject:@"" forKey:@"qq"];
    [visitor setObject:@"" forKey:@"email"];
    //queueName:用于技能组分组用的
    NSDictionary *weichatDic = @{@"visitor":visitor,@"queueName":@"toobei"};
    ext = @{@"weichat":weichatDic};

    return ext;
}

//////////////////////
#pragma mark - UIResponder actions
//////////////////////////////////////

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    EMMessage *emMessage = [userInfo objectForKey:XN_INTERACTION_MESSAGE];
    //图片
    if ([eventName isEqualToString:XN_ROUTER_EVENT_CHAT_PICTURE_TAP])
    {
        [self chatImageCellPressed:emMessage];
    }
}


//////////////////////
#pragma mark - 协议实现汇总
//////////////////////////////////////

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgContentMutaArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.msgContentMutaArray.count <=  indexPath.row)
    {
        return 0;
    }
    
    CSIMAdminMsgCell * cell = (CSIMAdminMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMAdminMsgCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell refreshMsgContent:[self.msgContentMutaArray objectAtIndex:indexPath.row] avatorImageString:@""];
    
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.msgContentMutaArray.count <=  indexPath.row)
    {
        CSIMCustomerMsgCell *cell = (CSIMCustomerMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMCustomerMsgCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    EMMessage * message = [self.msgContentMutaArray objectAtIndex:indexPath.row];
    
    if ([message.from isEqualToString:self.SendMsgUserId]) {
        
        CSIMAdminMsgCell * cell = (CSIMAdminMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMAdminMsgCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell refreshMsgContent:message avatorImageString:@""];
        
        return cell;
    }else
    {
        CSIMCustomerMsgCell *cell = (CSIMCustomerMsgCell *)[tableView dequeueReusableCellWithIdentifier:@"CSIMCustomerMsgCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell refreshMsgContent:message avatorImageString:self.customerPicUrl isService:_isEnterService];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - 接收到消息回调
- (void)iMManager:(IMManager *)manager didReceiveTextContent:(EMMessage *)content
{
    [[IMManager defaultIMManager] imManagerMaskMesasgeReadedForConversation:self.conversation];
    
    [self.msgContentMutaArray addObject:content];
    
        
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.msgContentMutaArray.count - 1 inSection:0];
    [self.chatContentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 接收到图片消息回调
- (void)iMManager:(IMManager *)manager didReceiveImageUrl:(EMMessage *)contentUrl
{
     [[IMManager defaultIMManager] imManagerMaskMesasgeReadedForConversation:self.conversation];
    
    [self.msgContentMutaArray addObject:contentUrl];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.msgContentMutaArray.count - 1 inSection:0];
    [self.chatContentTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.chatContentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 登入状态
- (void)iMManagerDidLoginStatus:(BOOL)success
{
    if (!success) {
        
        [self showCustomWarnViewWithContent:@"账户登入失败"];
        return;
    }
    
    [self.view hideLoading];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //发送图片
    [self sendImageMessage:orgImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

///////////////////
#pragma mark - setter/getter
//////////////////////////////////////

- (UIImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    
    return _imagePickerController;
}


#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

#pragma mark - msgContentMutaArray
- (NSMutableArray *)msgContentMutaArray
{
    if (!_msgContentMutaArray) {
        
        _msgContentMutaArray = [[NSMutableArray alloc]init];
    }
    return _msgContentMutaArray;
}
@end
