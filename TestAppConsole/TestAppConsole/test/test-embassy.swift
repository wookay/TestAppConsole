// test-embassy.swift

import Foundation
import MuckoSwift
import Embassy // SelectorEventLoop KqueueSelector DefaultHTTPServer

struct Render {
    var status: Int
    var body: Data
}

func render(_ typ: Any.Type, _ status: Int, _ value: String) -> Render {
    let data = Data(string: value)
    return Render(status: status, body: data)
}

class TestEmbassy: WTestCase {
    private func makeWebServer(_ f: @escaping ([String: Any]) -> Render) -> (SelectorEventLoop, DefaultHTTPServer) {
        let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        let server = DefaultHTTPServer(eventLoop: loop, interface: "127.0.0.1", port: 8081) {
            (
                env: [String: Any],
                startResponse: ((String, [(String, String)]) -> Void),
                sendBody: ((Data) -> Void)
            ) in
            let r = f(env)
            startResponse(string(r.status, " OK"), [])
            let EOF = Data()
            sendBody(r.body)
            sendBody(EOF)
        }
        return (loop, server)
    }

    func http_get(_ urlstr: String, _ f: @escaping (Data?, HTTPURLResponse) -> Void) {
        let url = URL(url: urlstr)
        let completion: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            let response = response as! HTTPURLResponse
            f(data, response)
        }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    typealias Text = String
    func route(env: [String: Any]) -> Render {
        if let path = env["PATH_INFO"] as? String {
            switch path {
            case "/":
                return render(Text.self, 200, "Hello")
            default:
                break
            }
        }
        return render(Text.self, 404, "Not Found")
    }

    @objc func test_embassy() {
        let (loop, server) = makeWebServer { env in
            self.route(env: env)
        }
    
        do {
            try server.start()
        } catch {
        }

//        loop.runForever()
        DispatchQueue(label: "server").async {
            loop.runForever()
        }

        var test_cnt = 0
        http_get("http://127.0.0.1:8081") { (data, response) in
            Assert.equal(data, Data(string: "Hello"))
            Assert.equal(response.statusCode, 200)
            test_cnt += 1
        }
        http_get("http://127.0.0.1:8081/none") { (data, response) in
            Assert.equal(data, Data(string: "Not Found"))
            Assert.equal(response.statusCode, 404)
            test_cnt += 1
        }
        
        usleep(useconds_t(0.3 * 1000_000)) // n seconds
        server.stopAndWait()
        loop.stop()
        
        Assert.equal(test_cnt, 2)
    }

}
