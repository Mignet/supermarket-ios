//
//  CustomSelectOptionView.swift
//  FinancialManager
//
//  Created by xnkj on 23/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

import UIKit

@objc(CustomSelectOptionViewDelegate)
protocol CustomSelectOptionViewDelegate: NSObjectProtocol {
    
    func customSelectOptionViewDidSelect(yearRate:String,deadLine:String,type:String);
    func exitView();
}

class CustomSelectOptionView: UIView, XNFinancialProductModuleObserver{
    
    var selectedYearRateButton:UIButton?;
    var selectedDeadLineButton:UIButton?;
    var selectedTypeButton:UIButton?;
    var yearRateConditionStr = "fRa";
    var deadLineConditionStr = "dLa";
    var typeConditionStr = "0";
    weak var conditionOptions:CustomSelectOptionViewDelegate?;
    
    @IBOutlet var noLimitYearRate:UIButton?
    @IBOutlet var oneLimitYearRate:UIButton?
    @IBOutlet var twoLimitYearRate:UIButton?
    @IBOutlet var threeLimitYearRate:UIButton?
    @IBOutlet var noDeadLine:UIButton?
    @IBOutlet var oneDeadLine:UIButton?
    @IBOutlet var twoDeadLine:UIButton?
    @IBOutlet var threeDeadLine:UIButton?
    @IBOutlet var fourDeadLine:UIButton?
    @IBOutlet var fiveDeadLine:UIButton?
    @IBOutlet var noType:UIButton?
    @IBOutlet var oneType:UIButton?
    @IBOutlet var selectProductCountLabel:UILabel?
    
    
    lazy var yearRateArray:Array<UIButton> = {
        
        var yearRateArray = Array<UIButton>();
        yearRateArray.append(self.noLimitYearRate!);
        yearRateArray.append(self.oneLimitYearRate!);
        yearRateArray.append(self.twoLimitYearRate!);
        yearRateArray.append(self.threeLimitYearRate!);
        
        return yearRateArray;
    }();
    
    lazy var deadLineArray:Array<UIButton> = {
        
        var deadLineArray = Array<UIButton>();
        
        deadLineArray.append(self.noDeadLine!);
        deadLineArray.append(self.oneDeadLine!);
        deadLineArray.append(self.twoDeadLine!);
        deadLineArray.append(self.threeDeadLine!);
        deadLineArray.append(self.fourDeadLine!);
        deadLineArray.append(self.fiveDeadLine!);
        
        return deadLineArray;
    }();
    
    lazy var typeArray:Array<UIButton> = {
        
        var typeArray = Array<UIButton>();
        
        typeArray.append(self.noType!);
        typeArray.append(self.oneType!);
        
        return typeArray;
    }();
    
    var yearRateValueArray:Array<String> = {
       
        var yearRateValueArray = Array<String>();
        
        yearRateValueArray.append("fRa");
        yearRateValueArray.append("fRb");
        yearRateValueArray.append("fRc");
        yearRateValueArray.append("fRd");
        
        return yearRateValueArray;
    }();
    
    var deadLineValueArray:Array<String> = {
        
        var deadLineValueArray = Array<String>();
        
        deadLineValueArray.append("dLa");
        deadLineValueArray.append("dLb");
        deadLineValueArray.append("dLc");
        deadLineValueArray.append("dLd");
        deadLineValueArray.append("dLe");
        deadLineValueArray.append("dLf");
        
        return deadLineValueArray;
    }();
    
    var typeValueArray:Array<String> = {
        
        var typeValueArray = Array<String>();
        
        typeValueArray.append("0");
        typeValueArray.append("1");
        
        return typeValueArray;
    }();
    
    
    override func awakeFromNib() {
        
        XNFinancialProductModule.default().addObserver(self);
        
        self.selectedTypeButton = self.noType!;
        self.selectedDeadLineButton = self.noDeadLine!;
        self.selectedYearRateButton = self.noLimitYearRate!;
        XNFinancialProductModule.default().fmProductSelectedCount(withYearFlowRate: self.yearRateConditionStr, deadLine: self.deadLineConditionStr, ifRookie: self.typeConditionStr);
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    deinit {
        
        XNFinancialProductModule.default().removeObserver(self);
    }

    
    //TODO:- 年化收益筛选
    @IBAction func selectYearRateOption(sender:UIButton){
        
        for btn in self.yearRateArray {
            
            if btn == sender {
                
                self.yearRateConditionStr = self.yearRateValueArray[sender.tag];
                
                sender.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_selected.png"), for: UIControlState.normal);
                sender.setTitleColor(UIColorFromHex(hex: "#4e8cef"), for: UIControlState.normal);
                
                XNFinancialProductModule.default().fmProductSelectedCount(withYearFlowRate: self.yearRateConditionStr, deadLine: self.deadLineConditionStr, ifRookie: self.typeConditionStr);
            }else
            {
                btn.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_normal.png"), for: UIControlState.normal);
                btn.setTitleColor(UIColorFromHex(hex: "#999999"), for: UIControlState.normal)
            }
        }
    }
    
    //TODO:- 期限筛选
    @IBAction func selectDeadLineOption(sender:UIButton){
        
        for btn in self.deadLineArray {
            
            if btn == sender {
                
                self.deadLineConditionStr = self.deadLineValueArray[sender.tag];
                
                sender.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_selected.png"), for: UIControlState.normal);
                sender.setTitleColor(UIColorFromHex(hex: "#4e8cef"), for: UIControlState.normal);
                
                XNFinancialProductModule.default().fmProductSelectedCount(withYearFlowRate: self.yearRateConditionStr, deadLine: self.deadLineConditionStr, ifRookie: self.typeConditionStr);
            }else
            {
                btn.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_normal.png"), for: UIControlState.normal);
                btn.setTitleColor(UIColorFromHex(hex: "#999999"), for: UIControlState.normal)
            }
        }
    }
    
    //TODO:- 类型筛选
    @IBAction func selectTypeOption(sender:UIButton){
        
        for btn in self.typeArray {
            
            if btn == sender {
                
                self.typeConditionStr = self.typeValueArray[sender.tag];
                
                sender.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_selected.png"), for: UIControlState.normal);
                sender.setTitleColor(UIColorFromHex(hex: "#4e8cef"), for: UIControlState.normal);
                
                XNFinancialProductModule.default().fmProductSelectedCount(withYearFlowRate: self.yearRateConditionStr, deadLine: self.deadLineConditionStr, ifRookie: self.typeConditionStr);
            }else
            {
                btn.setBackgroundImage(UIImage.init(named: "xn_FinancialManager_product_option_item_normal.png"), for: UIControlState.normal);
                btn.setTitleColor(UIColorFromHex(hex: "#999999"), for: UIControlState.normal)
            }
        }
    }
    
    //TODO:- 重置
    @IBAction func resetAction()
    {
        self.selectedYearRateButton = self.noLimitYearRate!;
        self.selectedDeadLineButton = self.noDeadLine!;
        self.selectedTypeButton = self.noType!;
        
        self.selectYearRateOption(sender: self.noLimitYearRate!);
        self.selectDeadLineOption(sender: self.noDeadLine!);
        self.selectTypeOption(sender: self.noType!);
        
        self.startUpdate();
    }
    
    //TODO:- 完成
    @IBAction func startUpdate(){
        XNUMengHelper.umengEvent("T_2_4");
        var index = self.typeValueArray.index(of: self.typeConditionStr)!;
        self.selectedTypeButton = self.typeArray[index];
        
        index = self.deadLineValueArray.index(of: self.deadLineConditionStr)!;
        self.selectedDeadLineButton = self.deadLineArray[index];
        
        index = self.yearRateValueArray.index(of: self.yearRateConditionStr)!;
        self.selectedYearRateButton = self.yearRateArray[index];
        
        self.conditionOptions?.customSelectOptionViewDidSelect(yearRate: self.yearRateConditionStr, deadLine: self.deadLineConditionStr, type: self.typeConditionStr);
    }
    
    //TODO:- 退出
    @IBAction func exitAction()
    {
        
        self.conditionOptions?.exitView();
        
        //更新button状态
        self.selectYearRateOption(sender: self.selectedYearRateButton!);
        self.selectDeadLineOption(sender: self.selectedDeadLineButton!);
        self.selectTypeOption(sender: self.selectedTypeButton!);
    }
    
    //MARK:- 协议
    func xnFinancialManagerModuleConditionProductCountDidReceive(_ module: XNFinancialProductModule!) {
        
        let firstDic:NSMutableDictionary = NSMutableDictionary();
        firstDic.setValue("符合筛选条件的结果共", forKey: "range");
        firstDic.setValue(UIColorFromHex(hex: "#4f5920"), forKey: "color");
        firstDic.setValue(UIFont.systemFont(ofSize: 15), forKey: "font");
        let secondDic:NSMutableDictionary = NSMutableDictionary();
        secondDic.setValue(module.selectedConditionProductCount, forKey: "range");
        secondDic.setValue(UIColorFromHex(hex: "#4e8cef"), forKey: "color");
        secondDic.setValue(UIFont.init(name:"DINOT" , size: 15), forKey: "font");
        let threeDic:NSMutableDictionary = NSMutableDictionary();
        threeDic.setValue("个", forKey: "range");
        threeDic.setValue(UIColorFromHex(hex: "#4f5920"), forKey: "color");
        threeDic.setValue(UIFont.systemFont(ofSize: 15), forKey: "font");
        
        self.selectProductCountLabel?.attributedText = NSString.getAttributeString(withAttributeArray: [firstDic,secondDic,threeDic]);
    }
    
    func xnFinancialManagerModuleConditionSelectedProductCountDidFailed(_ module: XNFinancialProductModule!) {
    }
}
