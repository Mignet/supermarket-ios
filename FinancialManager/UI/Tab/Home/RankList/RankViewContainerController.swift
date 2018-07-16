//
//  RankViewContainerController.swift
//  FinancialManager
//
//  Created by xnkj on 23/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

import UIKit

class RankViewContainerController: BaseViewController,UIScrollViewDelegate {
    
    @IBOutlet var scrollContainerView:UIScrollView?;
    @IBOutlet var profitButton:UIButton?;
    @IBOutlet var leaderButton:UIButton?;
    
    lazy var scrollExitView:ScrollViewExitView? = {
    
        var scrollExitView = ScrollViewExitView();
        
        return scrollExitView;
    }();
    
    lazy var buttonArray:Array<UIButton> = {
        
        var array = Array<UIButton>();
        
        array.append(self.profitButton!);
        array.append(self.leaderButton!);
        
        return array;
    }();
    
    lazy var buttonNormalImageArray:Array<String> = {
    
        var array = Array<String>();
        
        array.append("xn_home_rank_left_button_normal.png");
        array.append("xn_home_rank_right_button_normal.png");
        
        return array;
    }();
    
    lazy var buttonSelImageArray:Array<String> = {
        
        var array = Array<String>();
        
        array.append("xn_home_rank_left_button_selected.png");
        array.append("xn_home_rank_right_button_selected.png");
        
        return array;
    }();

    
    var rankCtrlArray:Array<UIViewController> = Array<UIViewController>();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 自定义方法
    
    //初始化
    func initView()
    {
        self.title = "猎财排行榜";
        
        self.scrollExitView?.scroll(self.scrollContainerView, didLeftScroll: self.navigationController);
        
        createRankView();
    }

    //构建滑动容器
    func createRankView()
    {
        
        var rankCtrl:UIViewController?;
        var firstRankCtrl:UIViewController?;
        for index in 1...self.buttonArray.count
        {
            
            if index == 1 {
                
                rankCtrl = ProfitRankViewController(nibName: "ProfitRankViewController", bundle: nil, profitMonth: XNCustomerServerModule.default().homePageMode.feeMonth);
                
                self.scrollContainerView?.addSubview((rankCtrl?.view)!);
                self.rankCtrlArray.append(rankCtrl!);
                
                rankCtrl!.view.mas_makeConstraints({[weak tmpScrollContainerView = self.scrollContainerView] (make:MASConstraintMaker?)in
                    
                    make!.leading.mas_equalTo()(tmpScrollContainerView?.mas_leading);
                    make!.top.mas_equalTo()(tmpScrollContainerView?.mas_top);
                    make!.bottom.mas_equalTo()(tmpScrollContainerView?.mas_bottom);
                    make!.height.mas_equalTo()(tmpScrollContainerView?.mas_height);
                    make!.width.mas_equalTo()(SCREEN_FRAME.size.width);
                })
                
                firstRankCtrl = rankCtrl;
            }else
            {
                rankCtrl = LeaderRankViewController(nibName: "LeaderRankViewController", bundle: nil);
                
                self.scrollContainerView?.addSubview((rankCtrl?.view)!);
                self.rankCtrlArray.append(rankCtrl!);
                
                rankCtrl!.view.mas_makeConstraints({[weak tmpScrollContainerView = self.scrollContainerView,weak tmpCtrl = firstRankCtrl] (make:MASConstraintMaker?)in
                    
                    make!.leading.mas_equalTo()(tmpCtrl?.view?.mas_trailing);
                    make!.top.mas_equalTo()(tmpScrollContainerView?.mas_top);
                    make!.bottom.mas_equalTo()(tmpScrollContainerView?.mas_bottom);
                    make!.height.mas_equalTo()(tmpScrollContainerView?.mas_height);
                    make!.width.mas_equalTo()(SCREEN_FRAME.size.width);
                    make!.trailing.mas_equalTo()(tmpScrollContainerView?.mas_trailing);
                })
            }
            
        }
    }
    
    @IBAction func clickRankButton(sender:UIButton){
        
        var index = 0;
        for button in self.buttonArray
        {
            if button == sender {
                
                sender.setBackgroundImage(UIImage.init(named:self.buttonSelImageArray[index]), for: UIControlState.normal);
                sender.setTitleColor(UIColorFromHex(hex:"#02a0f2"), for: UIControlState.normal);
                
                self.scrollContainerView?.setContentOffset(CGPoint.init(x: Int(SCREEN_FRAME.size.width) * index, y: 0), animated: true);
            }else
            {
                button.setBackgroundImage(UIImage.init(named: self.buttonNormalImageArray[index]), for: UIControlState.normal);
                button.setTitleColor(UIColorFromHex(hex:"#00000"), for: UIControlState.normal);
            }
            
            index += 1;
        }
    }
    
    //MARK:- 协议回调
    
    //scrollviewdelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollExitView?.scrollViewDidScrollOffSet(CGPoint.init(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y));
        
        let pageIndex = Int(scrollView.contentOffset.x / SCREEN_FRAME.size.width);
        
        clickRankButton(sender: self.buttonArray[pageIndex]);
    }
}
