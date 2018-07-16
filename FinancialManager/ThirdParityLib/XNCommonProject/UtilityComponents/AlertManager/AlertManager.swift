//
//  AlertManager.swift
//  FinancialManager
//
//  Created by xnkj on 28/10/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

import Foundation

@objc enum AlertLevel:Int
{
    case RemindToUpgrade = 0
    case ForceToUpgrade = 1
}

typealias cancelBlock = ()->Void;
typealias okBlock = ()->Void;

class AlertManager:NSObject , UIAlertViewDelegate
{
    static let sharedInstance = AlertManager();
    
    private var title:String = "";
    private var content:String = "";
    private var level:AlertLevel = AlertLevel.RemindToUpgrade;
    private var cancelButtonTitle:String = "";
    private var otherButtonTitle:String = "";
    var cancelBlock:cancelBlock?;
    var okBlock:okBlock?;
    
    private lazy var alertView:UIAlertView? = {
        
        var alertView:UIAlertView?;
        
        if self.level == AlertLevel.RemindToUpgrade
        {
           alertView = UIAlertView(title: self.title, message: self.content, delegate: self, cancelButtonTitle: self.cancelButtonTitle, otherButtonTitles: self.otherButtonTitle);
        } else
        {
            alertView = UIAlertView(title: self.title, message: self.content, delegate: self, cancelButtonTitle: nil, otherButtonTitles: self.otherButtonTitle);
        }
        
        return alertView;
    }();
    private lazy var alertViewController:UIAlertController? = {
        
        var alertViewController:UIAlertController = UIAlertController(title: self.title, message: self.content, preferredStyle: UIAlertControllerStyle.alert
        );
        
        if self.level == AlertLevel.RemindToUpgrade
        {
            var cancelAlert = UIAlertAction(title: self.cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: { [unowned self] (UIAlertAction) in
                
                self.cancelBlock?();
            });
            
            var okAlert = UIAlertAction(title: self.otherButtonTitle, style: UIAlertActionStyle.destructive, handler: { [unowned self] (UIAlertAction) in
                
                self.okBlock?();
            });
            
            alertViewController.addAction(cancelAlert);
            alertViewController.addAction(okAlert);
        }else
        {
            var okAlert = UIAlertAction(title: self.otherButtonTitle, style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                
                
            });
            
            alertViewController.addAction(okAlert);
        }
        
        return alertViewController;
    }();
    
    private override init()
    {
        
    }
    
    /////////////////
    //MARK:- Custom Method
    ////////////////////////////////
    
    //MARK:- 显示
    open func showAlert(title:String, message:String, level:AlertLevel, cancelButtonTitle:String, otherButtonTitle:String) {
        
        self.title = title;
        self.content = message;
        self.level = level;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        
        if #available(iOS 8.0, *)
        {
            _UI?.presentNaviModalViewCtrl(self.alertViewController, animated: true);
        }else
        {
            self.alertView?.show();
        }
    }
    
    /////////////////
    //MARK:- Protocol
    ////////////////////////////////

    //MARK:- AlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
            if self.level == AlertLevel.ForceToUpgrade  {
                
                self.okBlock?();
                return;
            }
            
            self.cancelBlock?();
            return;
        }
        
        if buttonIndex == 1
        {
            self.okBlock?();
            return;
        }
    }
}
