//
//  HomeVC.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/26.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit


class HomeVC: UIViewController {
 
    @IBOutlet var contentCollectionView: UICollectionView!
    
    var isPanAnimation = false
    
    var beginLocation:CGPoint = CGPoint.zero    //记录起始点
    
    var count = 0
    private var nextColor: UIColor {
        return [
            UIColor(red:0.83, green:0.88, blue:0.61, alpha:1.00),
            UIColor(red:0.78, green:0.92, blue:0.94, alpha:1.00),
            UIColor(red:0.30, green:0.46, blue:0.67, alpha:1.00)
            ][max(count, 0) % 3]
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        configContentCollectionView()
        
        HomeRequest.getRequest()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configNavStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeVC{
    
    func click() {
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func configNavStyle() {
        let leftItem1 = customNavBarItem(size: CGSize.init(width: 100, height: 50),
                                   normalImage: "img_player_loadingbg",
                                   highlightedImage: "img_player_loadingbg",
                                   target: self,
                                   selector: #selector(click))
        
        configLeftItems(leftItems: [leftItem1])
        
        
        let rightItem1 = customNavBarItem(size: CGSize.init(width: 40, height: 40),
                                    normalImage: "btn_top_search_n",
                                    highlightedImage: "btn_top_search_p",
                                    target: nil,
                                    selector: nil)
        
        configRightItems(rightItems: [rightItem1])
    }
    
}

extension HomeVC{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1000
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:HomeCell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
        cell.contentView.backgroundColor = nextColor
        return cell;
    }
    
    func configContentCollectionView() {
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: (UIScreen.mainScreen.bounds.width)/2-15, height: 140)
    
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        contentCollectionView.collectionViewLayout = flowLayout
        
        contentCollectionView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        
        contentCollectionView.panGestureRecognizer.addTarget(self, action: #selector(collectionViewPanGesTure(_:)))
        
        addObserve()
      
    }

}

extension HomeVC{
    
    func addObserve() {
        contentCollectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    func removeObserve() {
        contentCollectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

extension HomeVC{
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            
            if let offSet = change![NSKeyValueChangeNewKey] {
                let offset = (offSet as! NSValue).CGPointValue()
                if offset.y <= 0 && contentCollectionView.dragging && contentCollectionView.tracking{
                    
                    contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                    
                    isPanAnimation = true
                    removeObserve()
                    
                    contentCollectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                    beginLocation = contentCollectionView.panGestureRecognizer.locationInView(view)
                    
                    let bgButton = UIButton.init(type: .Custom)
                    bgButton.backgroundColor = UIColor.blackColor
                    bgButton.alpha = 0.7
                    bgButton.tag = 2000
                    view.insertSubview(bgButton, aboveSubview: contentCollectionView);
                    bgButton.updateConstraints(closure: { (make) in
                        make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                    })
                    
                    
                    let snapshot = contentCollectionView.snapshotView(afterScreenUpdates: false)
                    snapshot?.tag = 1000
                    view.insertSubview(snapshot, aboveSubview: bgButton)
                    snapshot?.frame.origin = CGPoint(x: 0, y: 64)
        
                    count += 1
                    contentCollectionView.reloadData()
                    
                }
            }
        }
    }
    
}

extension HomeVC{
    
    func collectionViewPanGesTure(pan:UIPanGestureRecognizer) {
        
        let location = pan.locationInView(view)
        let distance = view.frame.height - beginLocation.y
        
        let progress = (location.y - beginLocation.y) / distance  //0 - 1进度
        
        switch pan.state {
        case .Began:
            ()
        case .changed:
            if isPanAnimation {
                let progressHeight = progress * view.frame.height  //截屏偏移量 progress * view.height
                
                let progressAlpha = 1-(progress * 0.7 + 0.3) //0.6 - 1进度
                
                let progressScale =  progress * 0.2 + 0.8 //0.8 - 1进度
               
                //背景遮罩view alpha起始 0.6   结束  1
                let bgButton = view.viewWithTag(2000)
                bgButton?.alpha = progressAlpha
             
                //截屏view Translation起始 0  结束  1
                let snapView = view.viewWithTag(1000)
                snapView?.transform = CGAffineTransformMakeTranslation(0, progressHeight)
                
                //内容view Scale起始0.8  结束  1
                contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                contentCollectionView.transform = CGAffineTransformMakeScale(progressScale, progressScale)
            }
        case .Ended:
            
            let canceled = progress <= 0.5
            
            if isPanAnimation {
                
                isPanAnimation = false
                
                if canceled {
                    
                    count -= 1
                    
                    UIView.animateWithDuration(0.3, animations: { [weak self] in
                        self!.view.viewWithTag(1000)!.transform = CGAffineTransformMakeTranslation(0, 0)
                        
                        self!.contentCollectionView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                        
                        self!.view.viewWithTag(2000)!.alpha = 0
                        
                        }, completion: { [weak self] (finished) in
                            self!.contentCollectionView.transform = CGAffineTransformMakeScale(1, 1)
                            self!.contentCollectionView.reloadData()
                            self!.addObserve()
                            self!.view.viewWithTag(1000)!.removeFromSuperview()
                            self!.view.viewWithTag(2000)!.removeFromSuperview()
                    })
                }else{
                    UIView.animateWithDuration(0.3, animations: { [weak self] in
                        self!.view.viewWithTag(1000)!.transform = CGAffineTransformMakeTranslation(0, 10000)
                        
                        self!.contentCollectionView.transform = CGAffineTransformMakeScale(1, 1)
                        
                        self!.view.viewWithTag(2000)!.alpha = 0
                        
                        }, completion: { [weak self] (finished) in
                            self!.addObserve()
                            self!.view.viewWithTag(1000)!.removeFromSuperview()
                            self!.view.viewWithTag(2000)!.removeFromSuperview()
                    })
                }
            }
        default:
            ()
        }
        
    }
}









