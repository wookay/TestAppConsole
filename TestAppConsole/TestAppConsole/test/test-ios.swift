//
//  test-ios.swift
//  TestiOS
//
//  Created by wookyoung on 19/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
import UIKit
//import AppConsole

class TestiOS: WTestCase {

    @objc func test_uibutton() {
        let btn = UIButton(frame: CGRect.zero)
        Assert.True(isnil(btn.backgroundColor))

        let Button: Any.Type = NSClassFromString("UIButton")!
        Assert.equal(UIButton.self, Button)
        Assert.equal(UIButton.Type.self, typeof(Button))
        Assert.equal(UIButton.Type.Type.self, typeof(UIButton.Type.self))

        let Color: Any.Type = NSClassFromString("UIColor")!
        Assert.True(Color != Button)
    }

}
