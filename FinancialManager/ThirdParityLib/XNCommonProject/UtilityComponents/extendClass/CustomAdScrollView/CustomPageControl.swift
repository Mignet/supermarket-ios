//
//  CustomPageControl.swift
//  FinancialManager
//
//  Created by xnkj on 03/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

import UIKit

enum AlignmentType:Int {
    case left = 0
    case center
    case right
}

class CustomPageControl: UIPageControl {
    
    var customDotImageViewArray:Array<UIImageView> = Array();
    var activeImage:UIImage?;
    var inActiveImage:UIImage?;
    var alignment:AlignmentType?;
    
    override var currentPage: Int {
    
        get{
            
            return super.currentPage;
        }
        
        set {
            
            super.currentPage = newValue;
            
            updateDots();
        }
    }
    
    override var numberOfPages: Int{
        get{
            return super.numberOfPages;
        }
        
        set{
            super.numberOfPages = newValue;
            
            createNewDot();
        }
    }
    
    init(frame: CGRect,activeImageName: String, inActiveImageName: String, alignmentType:Int) {
        
        self.activeImage = UIImage(named: activeImageName);
        self.inActiveImage = UIImage(named: inActiveImageName);
        self.alignment = AlignmentType.init(rawValue: alignmentType);
        
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 更新图片
    func updateDots()
    {
        var dotImageView:UIImageView?;
        
        
        var i:Int = 0;
         for index in 0  ..< self.subviews.count
        {
            if self.subviews[index].isKind(of:NSClassFromString("UIImageView")!)
            {
                dotImageView = self.customDotImageViewArray[self.customDotImageViewArray.count - i - 1];
                
                if self.currentPage == i
                {
                    dotImageView?.image = self.activeImage;
                }else
                {
                    dotImageView?.image = self.inActiveImage;
                }
                
                i += 1;
            }else
            {
                self.subviews[index].isHidden = true;
            }
        }
    }
    
    //MARK:- 更换视图
    func createNewDot()
    {
        var dotImageView:UIImageView?;
        
        self.customDotImageViewArray.removeAll();
        
        for var subView  in self.subviews {
            
            subView.isHidden = true;
            
            subView.removeFromSuperview();
        }
        
        //设置开始点
        var startPoint = CGFloat(SCREEN_FRAME.size.width - 15);
        let interval = CGFloat((self.numberOfPages * 10)/2 + ((self.numberOfPages - 1) * 4 ) / 2);
        if self.alignment == AlignmentType.left {
            
            startPoint = CGFloat(self.numberOfPages * 10) + CGFloat((self.numberOfPages - 1) * 4) + 15;
        }else if(self.alignment == AlignmentType.center) {
            
            startPoint = CGFloat(CGFloat(SCREEN_FRAME.size.width / 2) + interval);
        }
        
        for index in 0  ..< self.numberOfPages
        {
            if self.currentPage == index
            {
                dotImageView = UIImageView(image: self.activeImage);
            }else
            {
                dotImageView = UIImageView(image: self.inActiveImage);
            }
            
            self.addSubview(dotImageView!);
            
//            let offSet = -CGFloat(index * 14) - 24.0;
        
            let offSetValue = CGFloat( -(SCREEN_FRAME.size.width - startPoint + CGFloat(index * 14)));
            dotImageView!.mas_makeConstraints({ [unowned self] (make:MASConstraintMaker?) in
                
                make!.trailing.mas_equalTo()(self.mas_trailing)?.setOffset(offSetValue);
                make!.bottom.mas_equalTo()(self.mas_bottom);
                make!.width.mas_equalTo()(10);
                make!.height.mas_equalTo()(3);
            });
            
            self.customDotImageViewArray.append(dotImageView!);
        }
    }
}
