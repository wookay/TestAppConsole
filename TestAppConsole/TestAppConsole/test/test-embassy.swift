// test-embassy.swift

import Foundation
import MuckoSwift
import Embassy // SelectorEventLoop KqueueSelector DefaultHTTPServer

class TestEmbassy: WTestCase {
    private func makeWebServer(_ f: @escaping () -> Data) -> (SelectorEventLoop, DefaultHTTPServer) {
        let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        let server = DefaultHTTPServer(eventLoop: loop, interface: "127.0.0.1", port: 8081) {
            (env: [String: Any], startResponse: ((String, [(String, String)]) -> Void), sendBody: ((Data) -> Void)) in
            startResponse("200 OK", [])
            let EOF = Data()
            sendBody(f())
            sendBody(EOF)
        }
        return (loop, server)
    }

    func http_get(_ urlstr: String, _ f: @escaping (Data?) -> Void) {
        let url = URL(url: urlstr)
        let completion: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            f(data)
        }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    @objc func test_embassy() {
        let (loop, server) = makeWebServer {
            let data = Data(string: "Hello")
            return data
        }
        do {
            try server.start()
        } catch {
        }

//        loop.runForever()
        DispatchQueue(label: "server").async {
            loop.runForever()
        }

        http_get("http://127.0.0.1:8081") { data in
            Assert.equal("Hello", String(data: data))
        }

        usleep(useconds_t(0.3 * 1000_000)) // n seconds
        server.stopAndWait()
        loop.stop()
    }
}
