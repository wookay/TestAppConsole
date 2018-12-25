//
//  objc-runtime.swift
//  TestAppConsole
//
//  Created by wookyoung on 19/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import Foundation
import MuckoSwift

// Ref: https://github.com/ReactiveX/RxSwift/blob/master/Tests/RxCocoaTests/RuntimeStateSnapshot.swift
//      https://gist.github.com/kristopherjohnson/9759461784c7411788a4

struct NS {
    static func swift_property_names(_ a: AnyObject) -> [String] {
        return Mirror(reflecting: a).children.filter { $0.label != nil }.map { $0.label! }
    }

    static func method_names(_ klass: AnyClass) -> [String] {
        var count: UInt32 = 0
        let methods = class_copyMethodList(klass, &count)
        var result = [String]()
        for i in 0 ..< count {
            let method: Method = methods!.advanced(by: Int(i)).pointee
            let name = method_getName(method)
            result.pushI(String(selector: name))
        }
        free(methods)
        return result
    }

    static func method_names(_ obj: NSObject) -> [String] {
        let klass: AnyClass = object_getClass(obj)!
        return self.method_names(klass)
    }

    static func property_names(_ obj: NSObject) -> Array<String> {
        let myClass: AnyClass = object_getClass(obj)!
        var results: Array<String> = []
        var count: UInt32 = 0
        let properties = class_copyPropertyList(myClass, &count)
        for i: UInt32 in 0 ..< count {
            let property = properties![Int(i)]
            let name = String(cString: property_getName(property))
            results.pushI(name)
        }
        free(properties)
        return results
    }

}
