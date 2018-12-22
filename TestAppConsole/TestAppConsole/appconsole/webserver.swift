//
//  webserver.swift
//  TestAppConsole
//
//  Created by wookyoung on 23/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import MuckoSwift
import Embassy // SelectorEventLoop KqueueSelector DefaultHTTPServer

struct Render {
    var status: Int
    var body: Data
}

protocol MIME {
}

struct Text: MIME {
}

struct HTML: MIME {
}

func render(_ typ: Any.Type, _ status: Int, _ value: String) -> Render {
    let data = Data(string: value)
    return Render(status: status, body: data)
}

class WebServer {
    var loop: SelectorEventLoop
    var server: DefaultHTTPServer
    
    public init(port: Int, handle: @escaping ((String, [String: Any]) -> Render)) {
        let loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        let server = DefaultHTTPServer(eventLoop: loop, interface: "127.0.0.1", port: port) {
        (
        env: [String: Any],
        startResponse: ((String, [(String, String)]) -> Void),
        sendBody: ((Data) -> Void)
        ) in
        let path = something(env["PATH_INFO"], "")
        let resp = handle(path, env)
        startResponse(string(resp.status, " OK"), [])
        let EOF = Data()
        sendBody(resp.body)
        sendBody(EOF)
        }
        self.loop = loop
        self.server = server
    }
    
    public func start() {
        do {
            try self.server.start()
        } catch {
        }
        // self.loop.runForever()
        DispatchQueue(label: "server").async {
            self.loop.runForever()
        }
    }
    
    public func stop(after n: Float = 0.0) {
        usleep(useconds_t(n * 1000_000)) // n seconds
        self.server.stopAndWait()
        self.loop.stop()
    }
}

func http_get(url urlstr: String, _ f: @escaping (Data?, HTTPURLResponse) -> Void) {
    let url = URL(url: urlstr)
    let completion: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
        let response = response as! HTTPURLResponse
        f(data, response)
    }
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
