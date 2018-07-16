//
//  FeedBackController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/27.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CSIMCreateConversationController.h"

#import "CSIMSelectUserController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "IMManager.h"

#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

@interface CSIMCreateConversationController ()<UITextViewDelegate,CSIMSelectUserControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) NSMutableArray         * selectedUserArray;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) IBOutlet UITextView     * themeInputTextView;
@property (nonatomic, weak) IBOutlet UILabel         * themeLabel;
@property (nonatomic, weak) IBOutlet UIView          * themeInputView;
@property (nonatomic, weak) IBOutlet UILabel         * selectUserLabel;
@property (nonatomic, weak) IBOutlet UIView          * selectUserView;
@end

@implementation CSIMCreateConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////
#pragma mark - Custom Method
////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"新建互动";
    self.keyboardHeight = 0.0f;
    
    [self.view addSubview:self.selectUserView];
    [self.view addSubview:self.themeInputView];
    
    self.themeInputTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    weakSelf(weakSelf)
    [self.selectUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(@(40));
    }];
    
    [self.themeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@(50));
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
        }
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 退出键盘
- (void)exitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 提交反馈内容
- (IBAction)clickNext:(UIButton *)sender
{
    if (self.selectUserLabel.text.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请选择会话客户"];
        return;
    }
    
    if (self.themeInputTextView.text.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请输入会话主题"];
        return;
    }
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0 ; i < self.selectedUserArray.count ; i ++ ) {
        
        EMConversation * conversation = [[IMManager defaultIMManager] imManagerConversationForChatter:[[self.selectedUserArray objectAtIndex:i] objectForKey:@"mobAccount"]       conversationType:EMConversationTypeChat];
        
        [[IMManager defaultIMManager] imManagerSendContent:self.themeInputTextView.text
                                            conversationId:conversation.conversationId
                                              fromReceiver:[[self.selectedUserArray objectAtIndex:i] objectForKey:@"mobAccount"]
                                                  chatType:EMChatTypeChat
                                                       ext:nil];
        [array addObject:conversation];
    }
    if (array.count > 0)
        [[IMManager defaultIMManager] imManagerInsertDBForConversation:array];
    
    self.themeInputTextView.text = @"";
    [self.themeInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50);
    }];

    [_UI popViewControllerFromRoot:YES ToNavigationCtrl:@"CSIMListController" comlite:nil];
}

#pragma mark - 进入相册
- (IBAction)photoAlbumAction
{
    if (self.selectUserLabel.text.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请选择会话客户"];
        return;
    }
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePickerController animated:YES completion:NULL];
}

#pragma mark - 选择用户
- (IBAction)clickSelectNewUser:(id)sender
{
    CSIMSelectUserController * selectedUserCtrl = [[CSIMSelectUserController alloc]initWithNibName:@"CSIMSelectUserController" bundle:nil selectedUser:self.selectedUserArray];
    selectedUserCtrl.delegate = self;
    
    [_UI pushViewControllerFromRoot:selectedUserCtrl animated:YES];
}

#pragma mark - 发送图片
-(void)sendImageMessage:(UIImage *)imageMessage
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0 ; i < self.selectedUserArray.count ; i ++ ) {
        
        EMConversation * conversation = [[IMManager defaultIMManager] imManagerConversationForChatter:[[self.selectedUserArray objectAtIndex:i] objectForKey:@"mobAccount"]  conversationType:EMConversationTypeChat];
        
        
        if (self.themeInputTextView.text.length > 0)
        {
            
            [[IMManager defaultIMManager] imManagerSendContent:self.themeInputTextView.text
                                            conversationId:conversation.conversationId
                                              fromReceiver:[[self.selectedUserArray objectAtIndex:i] objectForKey:@"mobAccount"]
                                                  chatType:EMChatTypeChat
                                                       ext:nil];
        }
        
        [[IMManager defaultIMManager] imManagerSendImage:imageMessage
                                               iMageName:@""
                                          conversationId:conversation.conversationId
                                            fromReceiver:[[self.selectedUserArray objectAtIndex:i] objectForKey:@"mobAccount"] chatType:EMChatTypeChat
                                                     ext:nil];
        
        [array addObject:conversation];
    }
    
    if (array.count > 0)
    {
         [[IMManager defaultIMManager] imManagerInsertDBForConversation:array];
    }
    
    [_UI popViewControllerFromRoot:YES ToNavigationCtrl:@"CSIMListController" comlite:nil];
}

#pragma mark - 更新用户显示
- (void)updateSelectedUserUI
{
    NSString * userStr = @"客户: ";
    
    for (int i = 0 ; i < self.selectedUserArray.count ; i ++ ) {
        
        if (i < self.selectedUserArray.count - 1)
            userStr = [userStr stringByAppendingFormat:@"%@、",[[self.selectedUserArray objectAtIndex:i] objectForKey:@"userName"]];
        else
            userStr = [userStr stringByAppendingFormat:@"%@",[[self.selectedUserArray objectAtIndex:i] objectForKey:@"userName"]];
    }
    
    [self.selectUserLabel setText:userStr];
    CGSize size = [self.selectUserLabel sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 92, 2000)];
    
    weakSelf(weakSelf)
    [self.selectUserView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(size.height + 22);
    }];
}

#pragma mark - 图片被点击(图片预览)
- (void)chatImageCellPressed:(EMMessage *)emMessage
{
    __weak CSIMCreateConversationController *weakController = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody *)emMessage.body;
    
    //如果缩略图下载成功
    if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed)
    {
        //开始加载大图
        [weakController showLoadingTarget:weakController.view withTitle:@"加载中……"];
        [[IMManager defaultIMManager] downloadMessageAttachment:emMessage
                                                       progress:nil
                                                     completion:^(EMMessage *message, EMError *error)
         {
             
             [self hideLoadingTarget:self.view];
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
        [[IMManager defaultIMManager] downloadMessageThumbnail:emMessage
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

///////////////////
#pragma mark - Protocal
/////////////////////////////////////////

#pragma mark - 选择用户协议
- (void)CSIMSelectUserController:(CSIMSelectUserController *)ctrl didSelectUser:(NSArray *)userArray
{
    [self.selectedUserArray removeAllObjects];
    [self.selectedUserArray addObjectsFromArray:userArray];
    
    //开始更新用户显示
    [self updateSelectedUserUI];
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
#pragma mark - Setter/getter
/////////////////////////////////////////

#pragma mark - selectedUserArray
- (NSMutableArray *)selectedUserArray
{
    if (!_selectedUserArray) {
        
        _selectedUserArray = [[NSMutableArray alloc]init];
    }
    return _selectedUserArray;
}

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

- (UIImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    
    return _imagePickerController;
}

@end
