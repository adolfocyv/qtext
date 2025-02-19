//
//  ViewControllerTextMode.swift
//  ServerForQLab
//
//  Created by Adolfo García on 25/12/23.
//

import UIKit
import Network

class ViewControllerTextMode: UIViewController, textObserverDelegate {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
        
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var udpSocketMain: UdpTextSocket?
    var mainLabelStr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // IP label updated with IP, waiting for connection
        ipLabel.text = "Your IP is \(self.getIPAddress()) / Your port is 2525"
        // Socket declaration and delegate
        udpSocketMain = UdpTextSocket(port: 2525, viewControllerTextMode: self)
        udpSocketMain!.delegate = self
        // Receiving messages from QLab - Delegate function
        receivedTextFromQlab()
    }
    //
    // Functions
    //
    func receivedTextFromQlab(){
        updateLabelAndBackground(label: mainLabel, background: backgroundImage, incomingStr: mainLabelStr)
        updateIpLabel()
    }
    // Splits the string, updates mainLabel and background
    func updateLabelAndBackground(label: UILabel?,background: UIImageView?, incomingStr: String){
        var incomingText = incomingStr.split(separator: "/", maxSplits: 2)
        updateLabel(label: label, subString: incomingText[0])
        if (incomingText.count == 2) {
            updateBackgroundColor(background: backgroundImage, incomingText[1])
        } else {
            updateBackgroundColor(background: backgroundImage, nil)
        }
    }
    // Update label text with input string
    func updateLabel(label: UILabel?,subString: Substring) {
        var stringLabel = String(subString)
        label!.text = stringLabel
    }
    // Update background color
    func updateBackgroundColor(background: UIImageView,_ subString: Substring?) {
        if (subString != nil) {
            var stringColor = String(subString!)
            if let _ = colorsDict[stringColor] {
                backgroundImage.backgroundColor = colorsDict[stringColor]
            } else {
                backgroundImage.backgroundColor = colorsDict["BLACK"]
            }
        } else {
            backgroundImage.backgroundColor = colorsDict["BLACK"]
        }
    }
    // Update ip label
    func updateIpLabel() {
        if mainLabel.text != "Hello!"{
            ipLabel.text = ""
        }
    }
    //Get own IP address
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    // Colors dictionary
    let colorsDict = ["GREEN" : UIColor.green,
                      "RED" : UIColor.red,
                      "ORANGE" : UIColor.orange,
                      "BLACK" : UIColor.black]
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
