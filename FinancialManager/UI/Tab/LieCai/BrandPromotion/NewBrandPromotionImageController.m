//
//  NewBrandPromotionImageController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "NewBrandPromotionImageController.h"
#import "BrandPromotionImageItemCell.h"
#import "XNLeiCaiModule.h"
#import "XNLCBrandListItem.h"
#import "XNLCBrandListItemManager.h"
#import "BrandPromotionImageShareView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "WeChatManager.h"
#import "XNLCBrandPostersmModel.h"
#import "NewBrandPromotionEmptyCell.h"
#import "XNLCBrandTypeItem.h"


#define Item_Width ((SCREEN_FRAME.size.width - 40.f) / 3.f)
#define Item_Height ((177.f * Item_Width) / 100.f)

@interface NewBrandPromotionImageController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BrandPromotionImageShareViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *themeType;

@property (nonatomic, strong) NSMutableArray *itemArr;

@property (nonatomic, strong) BrandPromotionImageShareView *imageShareView;

@property (nonatomic, strong) NSMutableArray *optionArr;

/*** 大图路径数据源 **/
@property (nonatomic, strong) NSMutableArray *allPicsUrlArray;

@property (nonatomic, strong) XNLeiCaiModule *module;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation NewBrandPromotionImageController

/////////////////////////////
#pragma mark - system method
/////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isRequest = NO;
    
    [self initView];
    
    self.module = [[XNLeiCaiModule alloc] init];
    
    [self.module addObserver:self];
    
    // 氢气指定类型的推广海报
    [self.module request_Liecai_User_PostersType:self.themeType];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.frame = CGRectMake(SCREEN_FRAME.size.width * self.index, 0.f, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 109.f);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[XNLeiCaiModule defaultModule] removeObserver:self];
}

/////////////////////////////
#pragma mark - custom method
/////////////////////////////

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withIndex:(NSInteger)index withThemeType:(NSString *)themeType
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.index = index;
        self.themeType = themeType;
    }
    
    return self;
}

- (void)initView
{
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BrandPromotionImageItemCell class]) bundle:nil] forCellWithReuseIdentifier:@"BrandPromotionImageItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewBrandPromotionEmptyCell class]) bundle:nil] forCellWithReuseIdentifier:@"NewBrandPromotionEmptyCell"];
    
    // 设置滚动方向
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 写成单利（不然有五个）
    [self.view addSubview:self.imageShareView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView) name:@"NewBrandPromotionImageController_reloadCollectionView" object:nil];
}

- (void)reloadCollectionView
{
    [self.collectionView reloadData];
    
    if ([[XNLCBrandListItemManager shareInstance] getChooseBrandListItem]) {
        
        // 是否属于本对象的数据
        BOOL existHere = NO;
        
        for (XNLCBrandListItem *item in self.itemArr) {
            
            if (item == [[XNLCBrandListItemManager shareInstance] getChooseBrandListItem]) {
                existHere = YES;
            }
        }
        
        if (existHere) {
            [self.imageShareView show];
        } else {
            [self.imageShareView dismiss];
        }
        
        
    } else {
        [self.imageShareView dismiss];
    }
}

/////////////////////////////
#pragma mark - protocol method
/////////////////////////////

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isRequest == YES && self.itemArr.count == 0) {
        return 1;
    }
    
    return self.itemArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequest == YES && self.itemArr.count == 0) {
        
        NewBrandPromotionEmptyCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewBrandPromotionEmptyCell" forIndexPath:indexPath];
        XNLCBrandTypeItem *typeItem = self.optionArr[self.index];
        emptyCell.empLabel.text = [NSString stringWithFormat:@"当前没有%@海报", typeItem.name];
        return emptyCell;
        
    }
    
    
    BrandPromotionImageItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandPromotionImageItemCell" forIndexPath:indexPath];
    itemCell.brandItem = self.itemArr[indexPath.item];
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequest == YES && self.itemArr.count == 0) {
        return;
    }
    
    // 2.图片预览（放大）
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.isShowSaveButton = NO;  //显示保存按钮
    browser.currentPhotoIndex = indexPath.item;
    browser.photos = self.allPicsUrlArray; // 设置所有的图片
    [browser show];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequest && self.itemArr.count == 0) {
        
          return CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 150.f);
    }
    
    return CGSizeMake(Item_Width, Item_Height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.isRequest && self.itemArr.count == 0) {
        
        return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    }
    
    return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f); // {top, left, bottom, right};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.isRequest && self.itemArr.count == 0) {
        
        return 0.f;
    }
    
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

// 分享视图协议方法
- (void)brandPromotionImageShareViewDid:(BrandPromotionImageShareView *)shareView withShareType:(BrandPromotionImageShareViewShareType)shareType
{
    if (![[XNLCBrandListItemManager shareInstance] getChooseBrandListItem]) {
        return;
    }
    
    XNLCBrandListItem *brandListItem = [[XNLCBrandListItemManager shareInstance] getChooseBrandListItem];
    
    // 合成图片
    NSString *urlString = [_LOGIC getImagePathUrlWithBaseUrl:self.module.brandPostersmModel.qrcode];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *qrcodeImage = [UIImage imageWithData:data];
    
    
        CGFloat fWidth = 145.f;//CGImageGetWidth(imgRef) * 2 / 5;
        CGFloat fHeight = 145;//CGImageGetHeight(imgRef) * 2 / 5;
        
        //底部图片
        NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:brandListItem.image]]];
    
        UIImage *backImage = [UIImage imageWithData:datas];
        CGImageRef backImgRef = backImage.CGImage;
        CGFloat fBackImgWidth = CGImageGetWidth(backImgRef);
        CGFloat fBackImgHeigh = CGImageGetHeight(backImgRef);
        
        UIGraphicsBeginImageContext(CGSizeMake(fBackImgWidth, fBackImgHeigh));
        [backImage drawInRect:CGRectMake(0, 0, fBackImgWidth, fBackImgHeigh)];
        
        CGFloat fYPoint = fBackImgHeigh - (fBackImgHeigh * 73 / 667) - fWidth;
        
        [qrcodeImage drawInRect:CGRectMake((fBackImgWidth - fWidth)/2, fYPoint, fWidth, fHeight)];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);
    
    // 调起分享
    if (resultImage) {
        
        if (shareType == Brand_Promotion_Image_Share_WeCat_Friend) { // 微信好友
            [[WeChatManager sharedManager] sendImage:resultImage atScene:0];
        }
        
        if (shareType == Brand_Promotion_Image_Share_WeCat_Circle) { // 微信朋友圈
            [[WeChatManager sharedManager] sendImage:resultImage atScene:1];
        }
    }
}

///////////////////////////////
#pragma mark - 网络请求回调
///////////////////////////////

/**** 4.5.3指定类型的推广海报 ***/
- (void)insurance_Liecai_User_BrandPostersDidReceive:(XNLeiCaiModule *)module
{
    self.isRequest = YES;
    
    [self.itemArr removeAllObjects];
    
    [self.itemArr addObjectsFromArray:self.module.brandPostersmModel.posterList];
    
    [self.collectionView reloadData];
}

- (void)insurance_Liecai_User_BrandPostersDidFailed:(XNLeiCaiModule *)module
{
    self.isRequest = YES;
    
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////////////////////
#pragma mark - setter / getter
//////////////////////////////////

- (NSMutableArray *)itemArr
{
    if (!_itemArr) {
        _itemArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemArr;
}

- (BrandPromotionImageShareView *)imageShareView
{
    if (!_imageShareView) {
        _imageShareView = [BrandPromotionImageShareView brandPromotionImageShareView];
        _imageShareView.delegate = self;
    }
    return _imageShareView;
}

- (NSMutableArray *)allPicsUrlArray
{
    if (!_allPicsUrlArray) {
        _allPicsUrlArray = [NSMutableArray arrayWithCapacity:0];
        //查看大图
        for (int i = 0; i < self.itemArr.count; i++) {
    
            XNLCBrandListItem *brandItem = [self.itemArr objectAtIndex:i];
            NSURL *url = [NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:brandItem.image]];
            // 替换为中等尺寸图片
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = url;
            [_allPicsUrlArray addObject:photo];
        }
    }
    return _allPicsUrlArray;
}

- (NSMutableArray *)optionArr
{
    if (!_optionArr) {
        
        _optionArr = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *typeListArr = [_LOGIC readDataFromFileName:@"Liecai_User_PostersType.plist"];
        
        for (NSInteger i = 0; i < typeListArr.count; i ++) {
            
            XNLCBrandTypeItem *item = [XNLCBrandTypeItem brandTypeItem:typeListArr[i]];
            
            
            [_optionArr addObject:item];
        }
    }
    
    return _optionArr;
}

@end
