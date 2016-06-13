//
//  WaterFallLayout.swift
//  ColloectionLayout
//
//  Created by jasnig on 16/6/11.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

import UIKit

protocol WaterFallLayoutDelegate: NSObjectProtocol {
    // 用来设置每一个cell的高度
    func heightForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class WaterFallLayout: UICollectionViewLayout {
    /// 共有多少列
    var numberOfColums = 0 {
        didSet {
            // 初始化为0
            for _ in 0..<numberOfColums {
                maxYOfColums.append(0)
            }
        }
    }
    /// cell之间的间隙 默认为5.0
    var itemSpace: CGFloat = 5.0
    
    weak var delegate: WaterFallLayoutDelegate?
    // 当item比较少(几百个)的时候建议缓存
    // 当有成千个item的时候建议其他方式计算
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    // 初始都设置为0
    private var maxYOfColums: [CGFloat] = []
    /// 用于记录之前屏幕的宽度 便于在旋转的时候刷新视图
    private var oldScreenWidth: CGFloat = 0.0
    

    // 在这个方法里面计算好各个cell的LayoutAttributes 对于瀑布流布局, 只需要更改LayoutAttributes.frame即可
    // 在每次collectionView的data(init delete insert reload)变化的时候都会调用这个方法准备布局
    override func prepareLayout() {
        super.prepareLayout()
        layoutAttributes = computeLayoutAttributes()
        // 设置为当前屏幕的宽度
        oldScreenWidth = UIScreen.mainScreen().bounds.width
        
    }
    
    // Apple建议要重写这个方法, 因为某些情况下(delete insert...)系统可能需要调用这个方法来布局
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    // 必须重写这个方法来返回计算好的LayoutAttributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 返回计算好的layoutAttributes
        return layoutAttributes
    }
    
    // 返回collectionView的ContentSize -> 滚动范围
    override func collectionViewContentSize() -> CGSize {
        let maxY = maxYOfColums.maxElement()!
        return CGSize(width: 0.0, height: maxY)
    }
    
    // 当collectionView的bounds(滚动, 或者frame变化)发生改变的时候就会调用这个方法
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // 旋转屏幕后刷新视图
        return newBounds.width != oldScreenWidth
        
    }
    // 计算所有的UICollectionViewLayoutAttributes
    func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        let totalNums = collectionView!.numberOfItemsInSection(0)
        let width = (collectionView!.bounds.width - itemSpace * CGFloat(numberOfColums + 1)) / CGFloat(numberOfColums)
        
        var x: CGFloat
        var y: CGFloat
        var height: CGFloat
        var currentColum: Int
        var indexPath: NSIndexPath
        var attributesArr: [UICollectionViewLayoutAttributes] = []

        guard let unwapDelegate = delegate else {
            assert(false, "需要设置代理")
            return attributesArr
        }
        
        for index in 0..<numberOfColums {
            self.maxYOfColums[index] = 0
        }
        for currentIndex in 0..<totalNums {
            indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            
            height = unwapDelegate.heightForItemAtIndexPath(indexPath)
            
            if currentIndex < numberOfColums {// 第一行直接添加到当前的列
                currentColum = currentIndex
                
            } else {// 其他行添加到最短的那一列
                // 这里使用!会得到期望的值
                let minMaxY = maxYOfColums.minElement()!
                currentColum = maxYOfColums.indexOf(minMaxY)!
            }
            //            currentColum = currentIndex % numberOfColums
            x = itemSpace + CGFloat(currentColum) * (width + itemSpace)
            // 每个cell的y
            y = itemSpace + maxYOfColums[currentColum]
            // 记录每一列的最后一个cell的最大Y
            maxYOfColums[currentColum] = y + height
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            // 设置用于瀑布流效果的attributes的frame
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            
            attributesArr.append(attributes)
        }
        return attributesArr
        
    }
}