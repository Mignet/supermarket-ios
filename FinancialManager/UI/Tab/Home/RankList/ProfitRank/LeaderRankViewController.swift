//
//  LeaderRankViewController.swift
//  FinancialManager
//
//  Created by xnkj on 01/03/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

import UIKit

class LeaderRankViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,RankListModuleObserver {
    
    @IBOutlet var profitTableView:UITableView?;
    @IBOutlet var middleLabel:UILabel?;
    @IBOutlet var warningView:UIView?;
    
    var warningSection:Bool = false;
    var headerSection:Bool = true;
    var sectionCount = 1;
    var finishMyLeadingAwardLoading:Bool = false;
    var finishLeaderAwardListLoading:Bool = false;
    var rankListArray:Array<MyRankMode> = Array<MyRankMode>();
    var rankModule:RankListModule = RankListModule();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        self.rankModule.removeObserver(self);
    }
    
    ///////////////////
    //MARK:- 自定义方法
    //////////////////////////////////
    
    //MARK:- 初始化
    func initView()
    {
        self.finishMyLeadingAwardLoading = false;
        self.finishLeaderAwardListLoading = false;
        self.rankModule.addObserver(self);
        
        self.profitTableView?.register(UINib.init(nibName: "RankCell", bundle: nil), forCellReuseIdentifier: "RankCell");
        self.profitTableView?.separatorColor = UIColor.clear;
        
        self.profitTableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            
            self.finishMyLeadingAwardLoading = false;
            self.finishLeaderAwardListLoading = false;
            self.rankModule.requestMyLeaderProfitRank();
            self.rankModule.requestLeaderProfitRankList(withPageIndex: DEFAULTPAGEINDEX, pageSize: DEFAULTPAGESIZE);
        });
        
        self.profitTableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            
            self.finishLeaderAwardListLoading = false;
            self.rankModule.requestLeaderProfitRankList(withPageIndex: "\(Int(self.rankModule.myLeaderListMode.pageIndex!)! + 1)", pageSize: DEFAULTPAGESIZE);
        });
        self.profitTableView?.mj_footer.isAutomaticallyHidden = true;
        
        self.rankModule.requestLeaderProfitStatus();
        self.rankModule.requestMyLeaderProfitRank();
        self.rankModule.requestLeaderProfitRankList(withPageIndex: DEFAULTPAGEINDEX, pageSize: DEFAULTPAGESIZE);
        self.view.showGifLoading();
    }
    
    //拿leader奖
    @IBAction func clickLeaderAward(sender:UIButton)
    {
        let ctrl = UniversalInteractWebViewController(requestUrl:_LOGIC?.getWebUrl(withBaseUrl: "/pages/activities/fetchLeaderReward.html"), requestMethod: "GET");
        
        _UI?.pushViewController(fromRoot:ctrl , animated: true);
    }
    
    @IBAction func clickCloseWarning(sender:UIButton)
    {
        self.sectionCount = 1;
        self.warningSection = false;
        
        self.profitTableView?.reloadData();
    }
    
    //请求成功更新
    func updateSuccessStatus()
    {
        if self.finishLeaderAwardListLoading && self.finishMyLeadingAwardLoading {
            
            self.view.hideLoading();
            self.profitTableView?.mj_header.endRefreshing();
            self.profitTableView?.mj_footer.endRefreshing();
            
            self.profitTableView?.reloadData();
        }
    }
    
    //请求失败更新
    func updateFailedStatus()
    {
        if self.finishLeaderAwardListLoading && self.finishMyLeadingAwardLoading {
            
            self.view.hideLoading();
            self.profitTableView?.mj_header.endRefreshing();
            self.profitTableView?.mj_footer.endRefreshing();
        }
    }
    
    ///////////////////
    //MARK:- 协议回调
    //////////////////////////////////
    
    //MARK:- UITableViewDatasource/UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.finishLeaderAwardListLoading && self.finishMyLeadingAwardLoading {
            
            return self.sectionCount;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((self.warningSection && section == 1) || (!self.warningSection && section == 0)) {
            
            return self.rankListArray.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (self.warningSection && section == 0) {
            
            return 41;
        }
        
        if (self.headerSection) {
            
            return CGFloat(DEFAULTRANKCELLHEIGHT);
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(DEFAULTRANKCELLHEIGHT);
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.warningSection && section == 0 {
            
            return self.warningView;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"RankCell") as! RankCell;
        
        if self.headerSection {
            
            cell.refreshRankListData(params: self.rankModule.myLeaderRankMode,titleStr: "本月奖励");
        }
        
        cell.backgroundColor = UIColor.white;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"RankCell") as! RankCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.refreshRankListData(params: self.rankListArray[indexPath.row],titleStr: "本月奖励");
        
        return cell;
    }
    
    //MARK:- RankListModule
    func xnRankListModuleGetLeaderProfitStatusDidSuccess(_ module: RankListModule!) {
        
        self.warningSection = false;
        if module.cfpLeaderStatus != "0" {
            
            if module.cfpLeaderStatus == "1" {
                
                self.middleLabel?.text = "您有成员本月满足leader奖励条件，其本月奖励将单独核算不计入您的团队leader奖励中。";
            }else
            {
                self.middleLabel?.text = "您还不满足leader奖励条件! 快邀请理财师加入吧!";
            }
            
            self.sectionCount = self.sectionCount + 1;
            self.warningSection = true;
        }
    }
    
    func xnRankListModuleGetLeaderProfitStatusDidFailed(_ module: RankListModule!) {
        
        if let dic = module.retCode.detailErrorDic as? Dictionary<String, String> {
            
            //MARK:- 字典keys，values转化为数组
            var errContent = [String](dic.values);
            
            self.showCustomWarnView(withContent: errContent[0]);
        }else
        {
            self.showCustomWarnView(withContent: module.retCode.errorMsg);
        }
    }
    
    
    func xnRankListModuleGetMyLeaderProfitRankDidSuccess(_ module: RankListModule!) {
        
        self.finishMyLeadingAwardLoading = true;
        
        self.headerSection = false;
        if NSObject.isValidateObj(module.myLeaderRankMode) {
            
            self.headerSection = true;
        }
        
        updateSuccessStatus();
    }
    
    func xnRankListModuleGetMyLeaderProfitRankDidFailed(_ module: RankListModule!) {
        
        self.finishMyLeadingAwardLoading = true;
        updateFailedStatus();
        
        if let dic = module.retCode.detailErrorDic as? Dictionary<String, String> {
            
            //MARK:- 字典keys，values转化为数组
            var errContent = [String](dic.values);
            
            self.showCustomWarnView(withContent: errContent[0]);
        }else
        {
            self.showCustomWarnView(withContent: module.retCode.errorMsg);
        }
    }
    
    func xnRankListModuleGetLeaderProfitListRankDidSuccess(_ module: RankListModule!) {
        
        self.finishLeaderAwardListLoading = true;
        
        if module.myLeaderListMode.pageIndex == "1" {
            
            self.rankListArray.removeAll();
        }
        
        for mode in module.myLeaderListMode.dataArray {
            
            self.rankListArray.append(mode as! MyRankMode);
        }
        
        updateSuccessStatus();
        
        if Int(module.myLeaderListMode.pageIndex)! >= Int(module.myLeaderListMode.pageCount)! {
            
            self.profitTableView?.mj_footer.endRefreshingWithNoMoreData();
        }else
        {
            self.profitTableView?.mj_footer.resetNoMoreData();
        }
    }
    
    func xnRankListModuleGetLeaderProfitListRankDidFailed(_ module: RankListModule!) {
        
        self.finishLeaderAwardListLoading = true;
        updateFailedStatus();
        
        if let dic = module.retCode.detailErrorDic as? Dictionary<String, String> {
            
            //MARK:- 字典keys，values转化为数组
            var errContent = [String](dic.values);
            
            self.showCustomWarnView(withContent: errContent[0]);
        }else
        {
            self.showCustomWarnView(withContent: module.retCode.errorMsg);
        }
    }
}

