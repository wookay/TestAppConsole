//
//  test-objc-runtime.swift
//  TestAppConsole
//
//  Created by wookyoung on 19/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
//import AppConsole

class K: NSObject {
    var prop: String = "prop"
    
    @objc func f(_ a: Int) -> Int {
        return a+1
    }
}

class TestObjcRuntime: WTestCase {
    @objc var a: Int = 1
    var b: Int = 2

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
    
    @objc func test_ns_property_names() {
        let prop_names = NS.property_names(self)
        Assert.equal(prop_names, ["a"])
    }

    @objc func test_swift_property_names() {
        let prop_names = NS.swift_property_names(self)
        Assert.equal(prop_names, ["a", "b"])
    }

    @objc func test_K() {
        let k = K()
        let prop_names = NS.swift_property_names(k)
        Assert.equal(prop_names, ["prop"])
        let meth_names = NS.method_names(k)
        Assert.equal(meth_names, ["f:", "init", ".cxx_destruct"])
//        invoke(k, "f", 2)
    }

}
