//
//  test-objc-runtime.swift
//  TestAppConsole
//
//  Created by wookyoung on 19/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
//import AppConsole

class TestObjcRuntime: WTestCase {

    @objc func test_selector() {
        let nssel = NSSelectorFromString("add")
        Assert.True(isa(nssel, Selector.self))

        let sel = Selector(("add"))
        Assert.True(isa(sel, Selector.self))
    }

    @objc func test_nsobject() {
        let NSTaggedPointerString: Any.Type = NSClassFromString("NSTaggedPointerString")!
        let a = "a" as NSString
        let oa = a as NSObject
        Assert.True(isa(a, NSTaggedPointerString.self))
        Assert.True(isa(oa, NSTaggedPointerString.self))
        let b = "b"
        let ob = b as NSObject
        Assert.True(isa(b, String.self))
        Assert.equal(typeof(ob), NSTaggedPointerString.self)
    }

}
