//
//  ViewController.swift
//  GatewaySDK
//
//  Created by Divyank Vijayvergiya on 16/04/20.
//  Copyright © 2020 Zoop.one. All rights reserved.
//

import UIKit
import WebKit
import GatewaySDKFramework

class ViewController: UIViewController {
   let zoopResult = Notification.Name(rawValue: ZOOP_RESULT)
        var zoopResponse = "No Zoop Result Found"
        @IBOutlet weak var tvResult: UILabel!
        
        @IBOutlet weak var tvbtnResult: UILabel!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            NotificationCenter.default.addObserver(self, selector: #selector(self.qtResultHandler(notification:)), name: zoopResult, object: nil)
            print("0",zoopResponse) //no result
            
    //        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
    //        tableView.addGestureRecognizer(gesture)
        }
        
    //    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
    //         print("0Reached Here dismiss")
    //        //Your dismiss code
    //        //Here you should implement your checks for the swipe gesture
    //    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        @IBAction func btnDispResult(_ sender: Any) {
            print("Reached Here")
            NotificationCenter.default.addObserver(self, selector: #selector(self.qtResultHandler(notification:)), name: zoopResult, object: nil)
            tvbtnResult.text = "\(zoopResponse)0002"
            print("7", self.zoopResponse)
        }
        
        @IBAction func btnCallSDK(_ sender: Any) {
            
            var RequestParams  = ZoopDataObject()
            RequestParams.zoop_env = "QT_PP"
            RequestParams.zoop_gateway_id = "14a9ba38-4290-486f-8724-e4e2ee7c1cb6"
            
            RequestParams.zoop_result_storyboard = "Main"
            RequestParams.zoop_result_storyboard_id = "ViewController"
            
            RequestParams.zoop_req_type = ZOOP_REQ_ESIGN
            
//            if RequestParams.qt_req_type == QT_REQ_OFFLINEAADHAAR {
//                RequestParams.qt_validate_phone = "y"
//                RequestParams.qt_validate_email = "y"
//
//            }else if RequestParams.qt_req_type == QT_REQ_CREDITSCORE{
//                RequestParams.qt_name = "SATHISHKUMAR  M    SATHISH KU"
//                RequestParams.qt_dob = "1986-06-03"
//                RequestParams.qt_postal_code = "641045"
//                RequestParams.qt_state = "TN"
//                RequestParams.qt_pan = "BUXPS2681D"
//                RequestParams.qt_address = "223 NACHIANNAN ANGANNAN STREET  RAMANATHAPURAM COIMBATORE"
//            }
            
            let s = UIStoryboard (name: "Main", bundle: nil)
            let qtVc = s.instantiateViewController(withIdentifier: "ZoopGatewayVC") as! ZoopGatewayVC
            qtVc.zoopReqObject = RequestParams;
            self.present(qtVc, animated: true, completion: nil)
            
    //        let storyboard = UIStoryboard(name: "QtSdkView", bundle: nil)
    //        let view = storyboard.instantiateViewController(withIdentifier: "AadhaarApiVc") as! AadhaarApiVc
    //        view.qtReqObject = RequestParams;
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        appDelegate.window?.rootViewController = view
        }
        
        @objc func qtResultHandler(notification: Notification){
            print(notification.userInfo!)
            //  let serviceType = notification.userInfo!["qtServiceType"] as? String
            let resultType = notification.userInfo!["zoopResultType"] as? String
            let response = notification.userInfo!["zoopResponse"] as? String
            
            if resultType == ZOOP_RESULT_OK{
                self.zoopResponse = response!
                print("3", resultType!)
                print("4", self.zoopResponse)
                
                tvResult.text = self.zoopResponse
            }else {
                self.zoopResponse = response!
                tvResult.text = self.zoopResponse
                print("06", zoopResponse)
                print("5", resultType ?? " Result Type Not Found")
                print("6", self.zoopResponse);
            }
        }
    
}


