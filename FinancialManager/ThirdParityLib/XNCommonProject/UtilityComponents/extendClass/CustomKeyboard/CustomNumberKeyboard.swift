//
//  CustomNumberKeyboard.swift
//  FinancialManager
//
//  Created by xnkj on 03/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

import UIKit

@objc(CustomNumberKeyboardProtocol)
protocol CustomNumberKeyboardProtocol : NSObjectProtocol {
    
    func CustomNumberKeyboardValueDidChange(changeStr:String, lastChar:String);
}

class CustomNumberKeyboard: UIView {
    
    open var keyBoardDelegate:CustomNumberKeyboardProtocol?;
    
    var value:String = "";
    
    class func defaultCustomNumberKeyboard()->CustomNumberKeyboard
    {
        return Bundle.main.loadNibNamed("CustomNumberKeyboard", owner: nil, options: nil)!.last as! CustomNumberKeyboard
    }
    
    override func awakeFromNib() {
    
        super.awakeFromNib();
    }
    
    @IBAction func selectedOne()
    {
        self.value.append("1");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"1");
    }
    
    @IBAction func selectedTwo()
    {
        self.value.append("2");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"2");
    }
    
    @IBAction func selectedThree()
    {
        self.value.append("3");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"3");
    }
    
    @IBAction func selectedFour(){
        self.value.append("4");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"4");
    }
    
    @IBAction func selectedFive(){
        self.value.append("5");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"5");
    }
    
    @IBAction func selectedSix(){
        self.value.append("6");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"6");
    }
    
    @IBAction func selectedSeven(){
        self.value.append("7");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"7");
    }
    
    @IBAction func selectedEight(){
        self.value.append("8");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"8");
    }
    
    @IBAction func selectedNight(){
        self.value.append("9");
        
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"9");
    }
    
    @IBAction func selectedZero(){
        self.value.append("0");
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:"0");
    }
    
    @IBAction func selectedDot(){
        self.value.append(".");
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:".");
    }
    
    @IBAction func selectedDele(){
        
        if self.value.isEmpty
        {
            return;
        }

        let charet:Character = self.value.remove(at: self.value.index(before: self.value.endIndex));
        self.keyBoardDelegate?.CustomNumberKeyboardValueDidChange(changeStr: self.value, lastChar:String(charet));
    }
}
