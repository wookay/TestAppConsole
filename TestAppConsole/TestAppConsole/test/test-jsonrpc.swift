//  test-jsonrpc.swift

import MuckoSwift
import JSONRPCKit

public struct CastError: Exception {
}

// https://github.com/bricklife/JSONRPCKit
struct Subtract: JSONRPCKit.Request {
    typealias Response = String

    let minuend: Int
    let subtrahend: Int

    // JSONRPC: var method: String { get }
    var method: String {
        return "subtract"
    }

    // JSONRPC: var parameters: Any? { get }
    var parameters: Any? {
        return [minuend, subtrahend]
    }

    // JSONRPC: func response(from resultObject: Any) throws -> Response
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError()
        }
    }
}

extension Batch1 {
    public func get(_ object: Any) -> Batch1.Responses {
        let response = try! self.responses(from: object)
        return response
    }
}

class TestJSONRPC: WTestCase {

    @objc func test_jsonrpc() {
        let request1 = Subtract(minuend: 42, subtrahend: 23)
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let batch = batchFactory.create(request1)
        Assert.equal(batch.requestObject as! [String: Any], ["id": 1, "params": [42, 23], "jsonrpc": "2.0", "method": "subtract"])

        let responseObject: Any = ["jsonrpc": "2.0", "result": "abc", "id": 1]
        let got = batch.get(responseObject)
        Assert.equal(got, "abc")
    }

}
