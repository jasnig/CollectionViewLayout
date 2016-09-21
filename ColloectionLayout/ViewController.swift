//
//  ViewController.swift
//  ColloectionLayout
//
//  Created by jasnig on 16/6/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class ViewController: UICollectionViewController {
    var cellCount = 50
    
    public lazy var cellHeight:[CGFloat] = { //changed private to public
        var arr:[CGFloat] = []
        for _ in 0..<self.cellCount {
            arr.append(CGFloat(arc4random() % 150 + 40))
        }
        return arr
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.red //deleted ()
        print(cellHeight)
        // 瀑布流
      //  setWaterFallLayout()
        // 圆形
       setCircleLayout()
        // 线性
//        setLineLayout()
    }
    
    func setLineLayout() {
        let layout = LineLayout()
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        collectionView?.collectionViewLayout = layout
    }
    
    
    func setCircleLayout() {
        let layout = CircleLayout()
        collectionView?.collectionViewLayout = layout
    }
    
    
    func setWaterFallLayout() {
        let layout = WaterFallLayout()
        layout.delegate = self
        layout.numberOfColums = 4
        collectionView?.collectionViewLayout = layout
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: WaterFallLayoutDelegate {
    func heightForItemAtIndexPath(indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}

extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {//偶数
            cellCount -= 1
            cellHeight.remove(at: indexPath.row)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
                }, completion: nil)
        } else {
            cellCount += 1
            cellHeight.append(CGFloat(arc4random() % 150 + 40))
            
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }
    

}

