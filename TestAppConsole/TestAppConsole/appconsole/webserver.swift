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
    var content_type: String
}

protocol MIME {
}

struct Text: MIME {
}

struct HTML: MIME {
}

struct JSON: MIME {
}

func content_type(_ typ: Any.Type) -> String {
    switch typ {
    case is Text.Type:
        return "text/plain; charset=utf-8"
    case is HTML.Type:
        return "text/html; charset=utf-8"
    case is JSON.Type:
        return "application/json; charset=utf-8"
    default:
        break
    }
    return ""
}

func render<T: Encodable>(_ status: Int, _ typ: Any.Type, _ value: T) -> Render {
    var data: Data
    switch typ {
    case is Text.Type, is HTML.Type:
        data = Data(string: value as? String)
    case is JSON.Type:
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            data = try encoder.encode(value)
        } catch {
            switch value {
            case is String:
                let quot = "\""
                data = Data(string: string(quot, value, quot))
            default:
                data = Data(string: string(value))
            }
        }
    default:
        data = Data()
    }
    return Render(status: status, body: data, content_type: content_type(typ))
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
            startResponse(string(resp.status, " OK"), [
                ("Content-Type", resp.content_type),
                ("Content-Length", string(length(resp.body))),
            ])
            let EOF = Data()
            sendBody(resp.body)
            sendBody(EOF)
        }
        self.loop = loop
        self.server = server
    }
    
    public func start(forever: Bool = false) {
        do {
            try self.server.start()
        } catch {
        }
        if forever {
            self.loop.runForever()
        } else {
            DispatchQueue(label: "server").async {
                self.loop.runForever()
            }
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
