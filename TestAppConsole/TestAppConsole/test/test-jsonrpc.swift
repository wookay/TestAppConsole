//  test-jsonrpc.swift

import MuckoSwift
import JSONRPCKit

public struct CastError: Exception {
}

struct Subtract: JSONRPCKit.Request {
    typealias Response = Int
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }
    
    var parameters: Any? {
        return [minuend, subtrahend]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError()
        }
    }
}

class TestJSONRPC: WTestCase {

    @objc func test_jsonrpc() {
        let request1 = Subtract(minuend: 42, subtrahend: 23)
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let batch = batchFactory.create(request1)
        Assert.equal(batch.requestObject as! [String: Any], ["id": 1, "params": [42, 23], "jsonrpc": "2.0", "method": "subtract"])
    }

}
