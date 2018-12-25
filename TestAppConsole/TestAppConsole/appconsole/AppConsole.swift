//
//  AppConsole.swift
//  TestAppConsole
//
//  Created by wookyoung on 18/12/2018.
//  Copyright © 2018 wookyoung. All rights reserved.
//

import Foundation
import Embassy // Log DefaultLogger PrintLogHandler
import MuckoSwift

let Log = DefaultLogger(name: "Logger", level: .notset)

func handle(path: String, env: [String: Any]) -> Render {
    switch path {
    case "/":
        return render(200, JSON.self, "Hello")
    default:
        break
    }
    return render(404, HTML.self, "<p>Not Found</p>")
}

class AppConsole {
    var initial: AnyObject
    let web = WebServer(port: 8080, handle: handle)
    
    public init(initial: AnyObject) {
        self.initial = initial
        Log.add(handler: PrintLogHandler())
    }

    public func run() {
        web.start()
        let addr = string(web.server.interface, ":", web.server.port)
        Log.info("AppConsole Server has started on \(addr)")
    }
    
    public func stop() {
        web.stop()
        Log.info("AppConsole Server has stopped.")
    }
}
