//
//  AddressBookController.h
//  FinancialManager
//
//  Created by xnkj on 15/12/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/CNContact.h>
#import <AddressBook/AddressBook.h>

#define ADDRESSBOOK_CONTRACT_NAME @"AddressBook_Contract_Name"
#define ADDRESSBOOK_CONTRACT_TEL  @"AddressBook_Contract_Tel"

@protocol AddressBookDelegate <NSObject>
@optional

- (void)AddressBookControllerDidSendContact:(NSArray *)contact;
@end

@interface AddressBookController : BaseViewController

@property (nonatomic, assign) id<AddressBookDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)titleName btnTitle:(NSString *)btnName remindDesc:(NSString *)desc;
@end
