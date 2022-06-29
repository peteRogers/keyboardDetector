//
//  ViewController.swift
//  keyboardDetector
//
//  Created by dt on 29/06/2022.
//

import Cocoa
import ORSSerial

class ViewController: NSViewController,  ORSSerialPortDelegate, NSWindowDelegate {
    
    @IBOutlet var tView: NSTextView!
    
   
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
//        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: {(mouseEvent:NSEvent) in
//              let position = mouseEvent.locationInWindow
//                self.sendData(string:"foof");
//          })
//
        openOrClosePort()
        

        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: { (keyEvent:NSEvent) in
            let k = keyEvent.keyCode
            print(k.description)
            self.tView.string = self.tView.string + (keyEvent.characters ?? "")
            self.sendData(string:"foof>");
        })
        
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        //self.openCloseButton.title = "Close"
        let descriptor = ORSSerialPacketDescriptor(prefixString: "<", suffixString: ">", maximumPacketLength: 8, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        //self.openCloseButton.title = "Open"
    }
    
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    override func viewDidAppear() {
            self.view.window?.delegate = self
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
  
    func openOrClosePort() {
        print("port closed")
        let availablePorts = ORSSerialPortManager.shared().availablePorts
        print(availablePorts)
        self.serialPort = ORSSerialPort(path: availablePorts[0].path)
        // self.serialPort = availablePorts[0]
        self.serialPort?.baudRate = 115200
        self.serialPort?.open()
        print("port opened")
        
        
    }
    
    func sendData(string:String) {
        
        if let data = string.data(using: String.Encoding.utf8) {
            self.serialPort?.send(data)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

