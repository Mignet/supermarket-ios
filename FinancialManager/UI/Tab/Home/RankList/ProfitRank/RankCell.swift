//
//  RankCell.swift
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {
    
    @IBOutlet var rankIcon:UIImageView?;
    @IBOutlet var rankLabel:UILabel?;
    @IBOutlet var rankHeaderIcon:UIImageView?;
    @IBOutlet var userNameLabel:UILabel?;
    @IBOutlet var userMobileLabel:UILabel?;
    @IBOutlet var totalProfitLabel:UILabel?;
    @IBOutlet var awardTitleLabel:UILabel?;

    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- 初始化排名列表
    func refreshRankListData(params:MyRankMode, titleStr:String)
    {
        
        if NSObject.isValidateObj(params) {
            
            self.awardTitleLabel?.text = titleStr;
            
            if Int(params.rank)! > 3 {
                
                self.rankIcon?.isHidden = true;
                self.rankLabel?.isHidden = false;
                
                self.rankLabel?.text = params.rank;
            }else
            {
                self.rankIcon?.isHidden = false;
                self.rankLabel?.isHidden = true;
                
                self.rankIcon?.image = UIImage(named: "xn_home_rank_" + params.rank + ".png");
            }
            
            self.rankHeaderIcon?.sd_setImage(with: URL.init(string: _LOGIC!.getImagePathUrl(withBaseUrl: "\(params.headImageStr!)?f=png")), completed: nil);
            self.rankHeaderIcon?.layer.cornerRadius = 17.5;
            self.rankHeaderIcon?.layer.masksToBounds = true;
            
            self.userNameLabel?.text = "职级:\(params.levelName!)";
            self.userMobileLabel?.text = params.mobile.convertToSecurityPhoneNumber();
            
            let firstDic:NSMutableDictionary = NSMutableDictionary();
            firstDic.setValue(params.totalProfit, forKey: "range");
            firstDic.setValue(UIColorFromHex(hex: "#02a0f2"), forKey: "color");
            firstDic.setValue(UIFont.init(name:"DINOT" , size: 16), forKey: "font");
            let secondDic:NSMutableDictionary = NSMutableDictionary();
            secondDic.setValue("元", forKey: "range");
            secondDic.setValue(UIColorFromHex(hex: "#02a0f2"), forKey: "color");
            secondDic.setValue(UIFont.systemFont(ofSize: 10), forKey: "font");
            
            self.totalProfitLabel?.attributedText = NSString.getAttributeString(withAttributeArray: [firstDic,secondDic]);   
        }
    }
}
