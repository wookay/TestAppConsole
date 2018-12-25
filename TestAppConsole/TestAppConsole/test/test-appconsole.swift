//
//  appconsole.swift
//  TestAppConsole
//
//  Created by wookyoung on 18/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
//import AppConsole

class TestAppConsole: WTestCase {

    @objc func test_appconsole() {
        let appconsole = AppConsole(initial: self)
        Assert.True(isa(appconsole, AppConsole.self))
        Assert.equal(appconsole.initial as? TestAppConsole, self)
        Assert.True(isa(self, TestAppConsole.self))
//        appconsole.run()
//        appconsole.stop()
    }

}
