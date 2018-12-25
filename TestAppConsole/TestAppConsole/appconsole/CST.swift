//
//  CST.swift
//  TestAppConsole
//
//  Created by wookyoung on 24/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import Foundation
import MuckoSwift

// https://github.com/ZacLN/CSTParser.jl

protocol LeafNode {
}

struct IDENTIFIER: LeafNode, Decodable {
    var val: String
    var fullspan: Int
    var span: Int

    static func ==(_ lhs: IDENTIFIER, _ rhs: IDENTIFIER) -> Bool {
        return lhs.val == rhs.val && lhs.fullspan == rhs.fullspan && lhs.span == rhs.span
    }
}

struct EXPR: Decodable {
    var args: Array<[String: Any]>
    var fullspan: Int
    var span: Int

    enum CodingKeys: String, CodingKey {
        case args, fullspan, span
    }

    public init(args: Array<[String: Any]>, fullspan: Int, span: Int) {
        self.args = args
        self.fullspan = fullspan
        self.span = span
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.args = try container.decode(Array<Any>.self, forKey: .args) as! Array<[String: Any]>
        self.fullspan = try container.decode(Int.self, forKey: .fullspan)
        self.span = try container.decode(Int.self, forKey: .span)
    }

}

struct Quotenode {

}

class CST {
    func decode<T: Decodable>(_ typ: T.Type, data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            println("error ", error)
        }
        return nil
    }
}
