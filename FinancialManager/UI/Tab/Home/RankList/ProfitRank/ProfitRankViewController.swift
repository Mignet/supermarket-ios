//
//  ProfitRankViewController.swift
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

import UIKit

let DEFAULTPAGEINDEX = "1";
let DEFAULTPAGESIZE = "10";
let DEFAULTRANKCELLHEIGHT = 66;

class ProfitRankViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,RankListModuleObserver {

    @IBOutlet var profitTableView:UITableView?;
    @IBOutlet var warningLabel:UILabel?;
    @IBOutlet var warningView:UIView?;
    
    var warningSection:Bool = false;
//    var headerSection:Bool = false;
    var sectionCount = 1;
//    var finishMyLeadingAwardLoading:Bool = false;
    var finishLeaderAwardListLoading:Bool = false;
    var rankListArray:Array<MyRankMode> = Array<MyRankMode>();
    var rankModule:RankListModule = RankListModule();
    var monthString:String = "";
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, profitMonth:String?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        self.monthString = profitMonth!;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.title = "猎财\(self.monthString)月收益榜";
        
//        self.finishMyLeadingAwardLoading = false;
        self.finishLeaderAwardListLoading = false;
        self.rankModule.addObserver(self);
        
        let warning = _LOGIC?.getValueForKey(XN_MY_PROFIT_WARNING_TAG)
        if warning == "1" {
            
            self.sectionCount = self.sectionCount + 1;
            self.warningSection = true;
        }
        
        self.profitTableView?.register(UINib.init(nibName: "RankCell", bundle: nil), forCellReuseIdentifier: "RankCell");
        self.profitTableView?.register(UINib.init(nibName: "UserRankCell", bundle: nil), forCellReuseIdentifier: "UserRankCell");
        self.profitTableView?.separatorColor = UIColor.clear;
        
        self.profitTableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
        
//            self.finishMyLeadingAwardLoading = false;
            self.finishLeaderAwardListLoading = false;
//            self.rankModule.requestMyProfitRank();
            self.rankModule.requestProfitRankList(withPageIndex: DEFAULTPAGEINDEX, pageSize: DEFAULTPAGESIZE);
        });
        
        self.profitTableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            
            self.finishLeaderAwardListLoading = false;
            self.rankModule.requestProfitRankList(withPageIndex: "\(Int(self.rankModule.rankListMode.pageIndex!)! + 1)", pageSize: DEFAULTPAGESIZE);
        });
        self.profitTableView?.mj_footer.isAutomaticallyHidden = true;
        
//        self.rankModule.requestMyProfitRank();
        
        self.rankModule.requestProfitRankList(withPageIndex: DEFAULTPAGEINDEX, pageSize: DEFAULTPAGESIZE);
        self.view.showGifLoading();
    }
    
    //请求成功更新
    func updateSuccessStatus()
    {
        if self.finishLeaderAwardListLoading {//&& self.finishMyLeadingAwardLoading {
            
            self.view.hideLoading();
            self.profitTableView?.mj_header.endRefreshing();
            self.profitTableView?.mj_footer.endRefreshing();
            
            self.profitTableView?.reloadData();
        }
    }
    
    //请求失败更新
    func updateFailedStatus()
    {
        if self.finishLeaderAwardListLoading {//&& self.finishMyLeadingAwardLoading {
            
            self.view.hideLoading();
            self.profitTableView?.mj_header.endRefreshing();
            self.profitTableView?.mj_footer.endRefreshing();
        }
    }
    
    @IBAction func clickCloseWarning(sender:UIButton)
    {
        self.sectionCount = self.sectionCount - 1;
        self.warningSection = false;
        
        _LOGIC?.saveValue(forKey: XN_MY_PROFIT_WARNING_TAG, value: "0");
        
        self.profitTableView?.reloadData();
    }
    
    ///////////////////
    //MARK:- 协议回调
    //////////////////////////////////
    
    //MARK:- UITableViewDatasource/UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.finishLeaderAwardListLoading {//&& self.finishMyLeadingAwardLoading {
            
            return self.sectionCount;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.warningSection && section == 0 {
            
            return 0;
        }
        
        return self.rankListArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (self.warningSection && section == 0) {
            
            return 41;
        }
        
        /*
        if self.headerSection {
            
            return CGFloat(DEFAULTRANKCELLHEIGHT);
        }
 */
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(DEFAULTRANKCELLHEIGHT);
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.warningSection && section == 0 {
            
            self.warningLabel?.text = "总收益=销售佣金+推荐奖励+直接管理津贴+团队管理津贴+活动奖励+红包奖励";
            
//            return self.warningView;
        }
        return self.warningView;

        /*
        let cell = tableView.dequeueReusableCell(withIdentifier:"UserRankCell") as! UserRankCell;
        
        if self.headerSection {
            
            cell.refreshMyRankData(params: self.rankModule.myProfitRankMode,titleStr: "本月总收益");
        }
        
        cell.backgroundColor = UIColor.white;
        
        return cell;
 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"RankCell") as! RankCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.refreshRankListData(params: self.rankListArray[indexPath.row],titleStr: "\(self.monthString)月总收益");
        
        return cell;
    }
    
    /*
    //MARK:- RankListModule
    func xnRankListModuleGetMyProfitRankDidSuccess(_ module: RankListModule!) {
        
        self.finishMyLeadingAwardLoading = true;
        
        self.headerSection = false;
        if NSObject.isValidateObj(module.myProfitRankMode) {
            
            self.headerSection = true;
        }
        
        updateSuccessStatus();
    }
    
    func xnRankListModuleGetMyProfitRankDidFailed(_ module: RankListModule!) {
        
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
 */
    
    func xnRankListModuleGetProfitListRankDidSuccess(_ module: RankListModule!) {
       
         self.finishLeaderAwardListLoading = true;
        
        if module.rankListMode.pageIndex == "1" {
            
            self.rankListArray.removeAll();
        }
        
        for mode in module.rankListMode.dataArray {
            
            self.rankListArray.append(mode as! MyRankMode);
        }
        
        updateSuccessStatus();
        
        if Int(module.rankListMode.pageIndex)! >= Int(module.rankListMode.pageCount)! {
            
            self.profitTableView?.mj_footer.endRefreshingWithNoMoreData();
        }else
        {
            self.profitTableView?.mj_footer.resetNoMoreData();
        }
    }
    
    func xnRankListModuleGetProfitListRankDidFailed(_ module: RankListModule!) {
        
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
