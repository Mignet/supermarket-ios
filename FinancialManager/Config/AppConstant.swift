//
//  AppConstant.swift
//  FinancialManager_Swift
//
//  Created by xnkj on 26/10/2016.
//  Copyright © 2016 lhkj. All rights reserved.
//

import UIKit

//内核常量
let _CORE =  UIApplication.shared.delegate as! AppDelegate;
let _LOGIC = _CORE.objLogicLayer;
let _UI = _CORE.objUILayer;
let _KEYWINDOW = UIApplication.shared.keyWindow;

//比较系统版本
let IOS8_EARLIER = UIDevice.current.systemVersion < "8.0" ? true:false;
let IOS10_EARLIER = UIDevice.current.systemVersion < "10" ? true : false;

//屏幕的大小
let SCREEN_FRAME = UIScreen.main.bounds;
let IS_IPHONE4_SCREEN = Int(UIScreen.main.bounds.size.height) == 480 ? true: false;
let IS_IPHONE5_SCREEN =  (Int(UIScreen.main.bounds.size.height) <= 568 && Int(UIScreen.main.bounds.size.height) > 480 ) ? true: false;

//设置弹出框显示的时间
let ALERT_DISSMISS_TIME = 1.2;

//设置相关默认提示语言
let ALERT_REQUEST_FAILED = "网络不给力，请检查您的网络" ;
let ALERT_NO_NETWORK = "网络异常，拉取数据失败"

func UIColorFromHex(hex:String) ->UIColor
{
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = cString.substring(from: index)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.white;
    }
    
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = cString.substring(to: rIndex)
    let otherString = cString.substring(from: rIndex)
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = otherString.substring(to: gIndex)
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = cString.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor
{
    return UIColor(red: r, green: g, blue: b, alpha: a);
}

func RGBACOLOR(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor
{
     return UIColor(red: r, green: g, blue: b, alpha: 1.0);
}




