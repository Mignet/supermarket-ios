//
//  XNInvitedPopView.m
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "XNInvitedPopView.h"
#import "XNInvitedPopCell.h"

@interface XNInvitedPopView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL          exit;
@property (nonatomic, strong) NSArray     * invitedTitleList;
@property (nonatomic, strong) NSArray     * invitedIconList;
@property (nonatomic, strong) UITableView * listTableView;
@end

@implementation XNInvitedPopView

- (id)initWithFrame:(CGRect)frame titleDataSource:(NSArray *)invitedTitleList iconDataSource:(NSArray *)invitedIconList
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.invitedTitleList = invitedTitleList;
        self.invitedIconList = invitedIconList;
        
        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:frame];
        [bgImageView setImage:[UIImage imageNamed:@"invitedPopImageView@2x.png"]];
        [self addSubview:bgImageView];
        
        weakSelf(weakSelf)
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(weakSelf);
        }];
        
        [self addSubview:self.listTableView];
        
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.mas_top).offset(7);
            make.trailing.mas_equalTo(weakSelf.mas_trailing);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];
    }
    return self;
}

- (void)refreshTableView
{
    [self.listTableView reloadData];
}

////////////
#pragma mark - Protocal
////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.invitedTitleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNInvitedPopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XNInvitedPopCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BOOL isReadMsg = YES;
    if ([[_LOGIC getValueForKey:XN_USER_SERVICE_NEW_MESSAGE] boolValue] && indexPath.row == 2)
    {
        isReadMsg = NO;
    }
    
    [cell updateIcon:[self.invitedIconList objectAtIndex:indexPath.row] title:[self.invitedTitleList objectAtIndex:indexPath.row] isLastCell:self.invitedIconList.count - 1 == indexPath.row isHiddenRedPoint:isReadMsg];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(XNInvitedPopViewDidSelectedAtIndex:)]) {
        
        [self.delegate XNInvitedPopViewDidSelectedAtIndex:indexPath.row];
    }
}

////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - invitedlist
- (NSArray *)invitedTitleList
{
    if (!_invitedTitleList) {
        
        _invitedTitleList = [[NSArray alloc]init];
    }
    return _invitedTitleList;
}

#pragma mark - invitedIconList
- (NSArray *)invitedIconList
{
    if (!_invitedIconList) {
        
        _invitedIconList = [[NSArray alloc]init];
    }
    return _invitedIconList;
}

#pragma mark - uitableview
- (UITableView *)listTableView
{
    if (!_listTableView) {
        
        _listTableView = [[UITableView alloc]init];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        
        [_listTableView setScrollEnabled:NO];
        [_listTableView setSeparatorColor:[UIColor clearColor]];
        [_listTableView setBackgroundColor:[UIColor clearColor]];
        
        [_listTableView registerNib:[UINib nibWithNibName:@"XNInvitedPopCell" bundle:nil] forCellReuseIdentifier:@"XNInvitedPopCell"];
    }
    return _listTableView;
}
@end
