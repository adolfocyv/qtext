//
//  udpTextSocket.swift
//  ServerForQLab
//
//  Created by Adolfo García on 23/12/23.
//

import UIKit
import CocoaAsyncSocket

// Protocol for text delegate function
protocol textObserverDelegate: AnyObject {
    func receivedTextFromQlab()
}

class UdpTextSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    var udpSocket: GCDAsyncUdpSocket!
    var port: UInt16
    weak var viewControllerTextMode: ViewControllerTextMode?
    weak var delegate: textObserverDelegate?
    
    init(port: UInt16, viewControllerTextMode: ViewControllerTextMode) {
        self.port = port
        self.viewControllerTextMode = viewControllerTextMode

        super.init()
        
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try udpSocket.bind(toPort: port)
            try udpSocket.beginReceiving()
            viewControllerTextMode.mainLabelStr = "Hello!"
        } catch {
            print("Connection error: \(error)")
            viewControllerTextMode.mainLabelStr = "Connection error, check QLab and restart."
        }
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?){
        let receivedString = String(data: data, encoding: .utf8)
        print("Received: \(receivedString ?? "") from \(address)")
        viewControllerTextMode?.mainLabelStr = receivedString!
        delegate?.receivedTextFromQlab()
    }
    
}
