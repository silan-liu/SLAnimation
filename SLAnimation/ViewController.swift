//
//  ViewController.swift
//  SLAnimation
//
//  Created by liusilan on 16/5/24.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    var curSelectIndex: NSInteger = 2
    let baseTag: NSInteger = 1000
    
    lazy var animationHelper: SLAnimationHelper = SLAnimationHelper()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectItem(sender: AnyObject) {

        if let btn = sender as? SLAnimationItemView {
            let index = btn.tag - baseTag - 1
            if index == curSelectIndex {
                return
            }

            let preSelectBtn = self.view.viewWithTag(1 + curSelectIndex + baseTag)
            if let preSelectBtn = preSelectBtn as? SLAnimationItemView {
                
                containerView.userInteractionEnabled = false
                
                // hide outlayer
                preSelectBtn.showOutLineLayer(false)
                
                // create animation layer
                animationHelper.createAnimationLayer(containerView, fromPoint: preSelectBtn.center, toPoint: btn.center, radius: btn.radius())
                
                animationHelper.startAnimation({
                    // show outlayer
                    btn.showOutLineLayer(true)
                    self.containerView.userInteractionEnabled = true
                })
            }

            curSelectIndex = index
        }
    }
}

