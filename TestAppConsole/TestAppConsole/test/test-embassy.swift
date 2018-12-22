// test-embassy.swift

import Foundation
import MuckoSwift
// import AppConsole // Render Text HTML render http_get

class TestEmbassy: WTestCase {

    func handle(path: String, env: [String: Any]) -> Render {
        switch path {
        case "/":
            return render(Text.self, 200, "Hello")
        default:
            break
        }
        return render(Text.self, 404, "Not Found")
    }

    @objc func test_embassy() {
        let web = WebServer(port: 8081, handle: self.handle)
        web.start()

        var test_cnt = 0
        http_get(url: "http://127.0.0.1:8081") { (data, resp) in
            Assert.equal(data, Data(string: "Hello"))
            Assert.equal(resp.statusCode, 200)
            test_cnt += 1
        }
        http_get(url: "http://127.0.0.1:8081/none") { (data, resp) in
            Assert.equal(data, Data(string: "Not Found"))
            Assert.equal(resp.statusCode, 404)
            test_cnt += 1
        }
        web.stop(after: 0.3)
        Assert.equal(test_cnt, 2)
    }

}
