//
//  MIUnlockPasswordContainerController.swift
//  FinancialManager
//
//  Created by xnkj on 31/10/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

import UIKit

class MIUnlockPasswordContainerController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////
    //MARK:- 自定义方法
    ////////////////////////////////////
    
    //MARK:- 初始化
    func initView()
    {
        self.view.backgroundColor = UIColor.clear;
        self.needNewSwitchViewAnimation = false;
        
        var unlockCtrl:UIViewController? = nil;
        
        if _LOGIC?.integer(forKey:XN_USER_FINGER_PASSWORD_SET) == 1
        {
            
            unlockCtrl = MIUnlockFingerPasswordController(nibName: "MIUnlockFingerPasswordController", bundle: nil);
        }else
        {
            unlockCtrl = XNUnlockByGestureViewController();
        }
        
        self.view.addSubview(unlockCtrl!.view);
        self.addChildViewController(unlockCtrl!);
        
        unlockCtrl!.view.mas_makeConstraints({ (make:MASConstraintMaker?) in
            
            make!.edges.equalTo()(self.view);
        });
    }
}
