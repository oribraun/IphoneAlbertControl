//
//  ViewController.swift
//  AlbertControl
//
//  Created by macOS Sierra on 12/19/18.
//  Copyright © 2018 macOS Sierra. All rights reserved.
//
import CoreBluetooth
import UIKit

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            // We will just handle it the easy way here: if Bluetooth is on, proceed...start scan!
            print("Bluetooth Enabled")
            startScan()
            
        } else {
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
            
            let alertVC = UIAlertController(title: "Bluetooth is not enabled", message: "Make sure that your bluetooth is turned on", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    
    var centralManager: CBCentralManager?
    var RSSIs = [NSNumber]()
    var peripherals = Array<CBPeripheral>()
    var timer = Timer();
    
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var RecButton: RoundButton!
    @IBOutlet weak var bluetoothView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Initialise CoreBluetooth Central Manager
        //centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        let btn = UITapGestureRecognizer(target: self, action: #selector(self.bluetoothClick))
        bluetoothView.addGestureRecognizer(btn)
        bluetoothView.isUserInteractionEnabled = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickingTheButton(_ sender: Any) {
        label.text = "changed";
    }
    
    @IBAction func StartRec(_ sender: Any) {
        createAlert(title: "hi", message: "this is my alert")
    }
    
    @objc func bluetoothClick() {
        createAlert(title: "click", message: "bluetooth clicked")
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            print("Yes")
        }))
        alert.addAction(UIAlertAction(title: "No",style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            print("No")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func serchBluetoothDevices () {
        
    }
    
    
    func startScan() {
        print("Now Scanning...")
        self.timer.invalidate()
        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "00001101-0000-1000-8000-00805f9b34fb")] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(timeInterval: 17, target: self, selector: #selector(self.cancelScan), userInfo: nil, repeats: false)
    }
    
    @objc func cancelScan() {
        self.centralManager?.stopScan()
        print("scan stopped")
        print("number of peropherals found: \(peripherals.count)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //stopScan()
        self.peripherals.append(peripheral)
        self.RSSIs.append(RSSI)
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "00001101-0000-1000-8000-00805f9b34fb")])
        //self.baseTableView.reloadData()
        //if blePeripheral == nil {
            print("We found a new pheripheral devices with services")
            print("Peripheral name: \(peripheral.name)")
            print("**********************************")
            print ("Advertisement Data : \(advertisementData)")
            //blePeripheral = peripheral
        //}
    }

}


