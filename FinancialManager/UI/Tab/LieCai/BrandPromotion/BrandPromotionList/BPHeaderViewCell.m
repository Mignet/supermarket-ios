//
//  BPHeaderViewCell.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BPHeaderViewCell.h"
#import "CustomTextView.h"

@interface BPHeaderViewCell()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIView *titleView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIView *txtView;
@property (nonatomic, weak) IBOutlet CustomTextView *textView;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL isNotshowCloseIcon;

@end

@implementation BPHeaderViewCell

- (void)showDatas:(NSString *)content
{
    self.txtView.layer.masksToBounds = YES;
    self.txtView.layer.cornerRadius = 3;
    self.txtView.layer.borderColor = UIColorFromHex(0xefefef).CGColor;
    self.txtView.layer.borderWidth = 0.5f;
    self.content = content;
    self.textView.delegate = self;
    if (IOS9_OR_LATER)
    {
        self.textView.placeHolderTextFont = [UIFont fontWithName:@"PingFang SC" size:12];
    }
    else
    {
        self.textView.placeHolderTextFont = [UIFont systemFontOfSize:12];
    }
    
    self.textView.placeHolderTextColor = UIColorFromHex(0x999999);
    self.textView.placeHolderStr = [NSString stringWithFormat:@" %@",content];
}

- (IBAction)textAction:(id)sender
{
    self.isNotshowCloseIcon = !self.isNotshowCloseIcon;
    NSString *imageString = @"";
    self.textView.text = @"";
    if (!self.isNotshowCloseIcon)
    {
        imageString = @"XN_LieCai_Brand_Promotion_close_icon@2x.png";
        self.txtView.hidden = NO;
    }
    else
    {
        imageString = @"XN_LieCai_Brand_Promotion_arrow_down_icon@2x.png";
        self.txtView.hidden = YES;
    }
    
    self.iconImageView.image = [UIImage imageNamed:imageString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPHeaderViewCellDidChangeHeight:)])
    {
        [self.delegate BPHeaderViewCellDidChangeHeight:self.isNotshowCloseIcon];
    }
    
}

#pragma mark - UITextViewDelegate

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if([textView.text isEqualToString:self.content])
//    {
//        textView.text = @"";
//    }
//
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
//        self.textView.text = self.content;
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BPHeaderViewCellDidInputContent:)])
    {
        [self.delegate BPHeaderViewCellDidInputContent:self.textView.text];
    }
}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if(textView.text.length < 1)
//    {
//        textView.text = self.content;
//    }
//}

@end
