//
//  MIUnlockFingerPasswordController.swift
//  FinancialManager
//
//  Created by xnkj on 27/10/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

import UIKit

class MIUnlockFingerPasswordController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        
        showFingerPassword();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        _LOGIC?.cancelFinger();
        NotificationCenter.default.removeObserver(self);
    }
    
    ////////////////
    //MARK:- 自定义方法
    ////////////////////////////
    
    //MARK:- 初始化
    func initView()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(MIUnlockFingerPasswordController.showFingerPassword), name: NSNotification.Name(rawValue: XN_SHOW_FINGER_PASSWORD_NOTIFICATION), object: nil);
    
//        showFingerPassword();
    }
    
    //MARK:- 判断显示指纹密码
    func showFingerPassword()
    {
        if _LOGIC!.integer(forKey: XN_USER_FINGER_PASSWORD_SET) == 1 && AppFramework.getGlobalHandler().frontStatus{
            
            authenticateFingerPassword();
        }
    }
    
    //MARK:- 显示指纹密码
    func authenticateFingerPassword()
    {
        //检测是否可以使用指纹解锁
        _LOGIC!.evaluatePolicy(success: { [unowned self] in
            
            self.performSelector(onMainThread: #selector(MIUnlockFingerPasswordController.fingerPasswordSuccess), with: nil, waitUntilDone: false);
            
            }, failed: {[unowned self] (error:Error?) in
                
            self.performSelector(onMainThread: #selector(MIUnlockFingerPasswordController.showFingerGestureFailed), with: error, waitUntilDone: false);
        });
    }
    
    //MARK:- 指纹解锁失败
    func showFingerGestureFailed(error:Error)
    {
        if error.localizedDescription == "User interaction is required."
        {
            return;
        }
        
        if error.localizedDescription == "Application retry limit exceeded." || error.localizedDescription == "Biometry is locked out."
        {
            _LOGIC?.save(0, key: XN_USER_FINGER_PASSWORD_SET);
            self.showFMRecommandView(withTitle: "解锁失败", subTitle: "指纹解锁已失败三次，系统已将该功能关闭，如需开启，可以在\"我的\"-\"密码管理\"里面再次开启～", subTitleLeftPadding: 12.0, otherSubTitle: "", okTitle: "知道了", okComplete: {
                
                _LOGIC?.save(0, key: XN_USER_FINGER_PASSWORD_SET);
                
                let setGestureCtrl = XNUnlockByGestureViewController();
                
                _UI?.pushViewController(fromRoot: setGestureCtrl, animated: true);
                
            }, cancelTitle: nil, cancelComplete: nil);
            
            return;
        }
        
        if (error.localizedDescription == "Canceled by user.")
        {
         
            let setGestureCtrl = XNUnlockByGestureViewController();
            
            _UI?.pushViewController(fromRoot: setGestureCtrl, hideNavigationBar: true, animated: true);
            
            return;
        }
        
        if !(error.localizedDescription == "Canceled by another authentication.")
        {
            self.showFMRecommandView(withTitle: "指纹解锁失败", subTitle: "指纹解锁失败，请通过手势密码解锁或使用其他账号登录", otherSubTitle: "", okTitle: "知道了", okComplete:{
                
                let setGestureCtrl = XNUnlockByGestureViewController();
                
                _UI?.pushViewController(fromRoot: setGestureCtrl, hideNavigationBar: true, animated: true);
                
            }, cancelTitle: "", cancelComplete: nil);
        }
    }
    
    //MARK:- 指纹解码成功
    func fingerPasswordSuccess()
    {
        //更新token
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: XN_UPDATE_TOKEN_NOTIFICATION), object:nil);
        
        //发送通知进入对应的页面（接收到远程推送时）
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: XN_REMOTE_NOTIFICATION), object:nil);
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XN_USER_LOGIN_SUCCESS_NOTIFICATINO), object: nil);
        
        hideFingerPassword();
    }
    
    //MARK:- 显示
    func show(){
        
        _UI?.presentNaviModalViewCtrl(self, animated: false, completion: { 
            
        });
    }
    
    //MARK:- 隐藏
    func hideFingerPassword() {
        
        _UI?.dismissNaviModalViewCtrl(animated: false);
    }
}
