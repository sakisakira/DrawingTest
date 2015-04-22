//
//  ViewController.swift
//  DrawingTest
//
//  Created by sakira on 2015/04/21.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(DrawingView(frame: CGRectMake(10, 10, 200, 200)))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

