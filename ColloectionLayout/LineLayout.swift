//
//  LineLayout.swift
//  ColloectionLayout
//
//  Created by jasnig on 16/6/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/p/b84f4dd96d0c

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

import UIKit


class LineLayout: UICollectionViewFlowLayout {
    // 用来缓存布局
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        layoutAttributes = []
        let superLayoutAttributes = super.layoutAttributesForElements(in: rect)!
        
        let collectionViewCenterX = collectionView!.bounds.width * 0.5
        
        superLayoutAttributes.forEach { (attributes) in
            // 消除警告
            /**
             This is likely occurring because the flow layout subclass ColloectionLayout.LineLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
             */
            let copyLayout = attributes.copy() as! UICollectionViewLayoutAttributes
            // 和中心点的横向距离差
            let deltaX = abs(collectionViewCenterX - (copyLayout.center.x - collectionView!.contentOffset.x))
            // 计算屏幕内的cell的transform
            if deltaX < collectionView!.bounds.width {
                let scale = 1.0 -  deltaX / collectionViewCenterX
                copyLayout.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            layoutAttributes.append(copyLayout)
        }
        return layoutAttributes
    }
    /** 返回true将会标记collectionView的data为 'dirty'
     * collectionView检测到 'dirty'标记时会在下一个周期中更新布局
     * 滚动的时候实时更新布局
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
}
