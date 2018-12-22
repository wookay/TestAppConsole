//
//  ViewController.swift
//  TestOSX
//
//  Created by wookyoung on 22/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import Cocoa
import MuckoSwift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UnitTest.run(tests)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

