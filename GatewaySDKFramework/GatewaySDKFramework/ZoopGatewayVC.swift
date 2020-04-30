//
//  ZoopGatewayVC.swift
//  GatewaySdkFramework
//
//  Created by Divyank Vijayvergiya on 29/04/20.
//  Copyright © 2020 Divyank. All rights reserved.
//

import UIKit
import WebKit
public let ZOOP_RESULT = "one.zoop.sdk.RESULT";

public class ZoopGatewayVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var zoopView1: UIView!
   
     var zoopWebView: WKWebView!
        var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

        public var zoopReqObject = ZoopDataObject();
           let zoopLogTag = "ZOOP_SDK "
           let zoopLogTypeT = "one.zoop.sdk.Test "
           let zoopLogTypeD = "one.zoop.sdk.Debug "
           let zoopLogTypeE = "one.zoop.sdk.Error "
           let zoopLogTypeI = "one.zoop.sdk.Info "
        
        func webViewInit(){
            zoopWebView = WKWebView(frame: .zero)
            zoopView1.addSubview(zoopWebView)
            
            zoopWebView.translatesAutoresizingMaskIntoConstraints = false
            let height = NSLayoutConstraint(item: zoopWebView!, attribute: .height, relatedBy: .equal, toItem: zoopView1, attribute: .height, multiplier: 1, constant: 0)
                  let width = NSLayoutConstraint(item: zoopWebView!, attribute: .width, relatedBy: .equal, toItem: zoopView1, attribute: .width, multiplier: 1, constant: 0)
                  let leftConstraint = NSLayoutConstraint(item: zoopWebView!, attribute: .leftMargin, relatedBy: .equal, toItem: zoopView1, attribute: .leftMargin, multiplier: 1, constant: 0)
                  let rightConstraint = NSLayoutConstraint(item: zoopWebView!, attribute: .rightMargin, relatedBy: .equal, toItem: zoopView1, attribute: .rightMargin, multiplier: 1, constant: 0)
                  let bottomContraint = NSLayoutConstraint(item: zoopWebView!, attribute: .bottomMargin, relatedBy: .equal, toItem: zoopView1, attribute: .bottomMargin, multiplier: 1, constant: 0)
                  zoopView1.addConstraints([height, width, leftConstraint, rightConstraint, bottomContraint])
        }
        
    public override func viewDidLoad() {
            super.viewDidLoad()
            webViewInit()
            zoopJsMsgHandlers()
            zoopInitParamCheck()
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            self.view.addSubview(indicator)
            self.view.bringSubviewToFront(indicator)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            // Do any additional setup after loading the view.
            indicator.stopAnimating()

        }
        
        override public func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            ZoopLoadingUtils.show()
            // Dispose of any resources that can be recreated.
        }
        
        func zoopJsMsgHandlers() {
            let qtConfig = WKWebViewConfiguration()
            let jsContentController = WKUserContentController()
            qtConfig.userContentController = jsContentController
            
            // Add script message handlers that, when run, will make the function
            jsContentController.add(self, name: ZoopJsHandlerType.ITR_SUCCESS.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.ITR_ERROR.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.BSA_SUCCESS.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.BSA_ERROR.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.WV_ERROR.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.OTP_ERROR.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.WV_TERMINATION.rawValue)
            jsContentController.add(self, name: ZoopJsHandlerType.DENY_CONSENT.rawValue)
            zoopWebView = WKWebView( frame: view.bounds, configuration: qtConfig)
        }
        
        func zoopInitParamCheck() {
              print(zoopReqObject.zoop_req_type)
              
              if zoopReqObject.zoop_gateway_id.count == 36 {
                  if ZoopConnectivityUtils.isConnectedToNetwork(){
                      let qtReqUrl = ZoopHandler()
                     
                      if zoopReqObject.zoop_req_type == ZOOP_REQ_ITR {
                      let reqUrl = qtReqUrl.generateItrURL(ReqObject: zoopReqObject)
                          urlCheck(reqUrl: reqUrl)
                        //  print(reqUrl)
                      }else if zoopReqObject.zoop_req_type == ZOOP_REQ_BSA {
                       let reqUrl = qtReqUrl.generateBsaURL(ReqObject: zoopReqObject)
                        //  print(reqUrl)
                          urlCheck(reqUrl: reqUrl)
                      }
                  }else{
                      print(zoopLogTag, zoopLogTypeE, "No Internet Connection")
                      self.zoopDisplayErr(qtErrTitle: "No Internet Connection", qtErrString: "Please, Turn on cellular data or wifi to proceed further")
                  }
              } else{
                  print(zoopLogTag, zoopLogTypeE, "Invalid Transaction ID")
                  self.zoopDisplayErr(qtErrTitle:  "Invalid Transaction ID", qtErrString: "Please pass the valid gateway transaction Id")
              }
          }
          
          func zoopDisplayErr(qtErrTitle: String, qtErrString: String){
              let qtAlertVc = UIAlertController(title: qtErrTitle, message: qtErrString, preferredStyle: .alert)
              let qtAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                  self.dismiss(animated: true, completion: nil)
              })
              qtAlertVc.addAction(qtAction)
              if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
                  rootVC.present(qtAlertVc, animated: true, completion: nil)
              } else {
                  print(zoopLogTag, zoopLogTypeE, "Root view controller is not set.")
              }
          }
          
          func urlCheck(reqUrl: URL) {
              if reqUrl == URL(string: "https://InvalidBaseUrl"){
                  zoopDisplayErr(qtErrTitle: "Invalid Base URL", qtErrString: "Base Url entered is invalid. Please try again with correct url")
              }else {
                  let request = URLRequest(url: reqUrl)
                  zoopWebView.navigationDelegate = self
                  self.view.addSubview(self.zoopWebView)
                  zoopWebView.load(request)
                  indicator.startAnimating()

              }
          }
          
          public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
              print(zoopLogTag, zoopLogTypeE, "Navigation Failed: ",error)
              zoopDisplayErr(qtErrTitle: "Navigation Failed", qtErrString: error.localizedDescription)
          }
          
          public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
              print(zoopLogTag, zoopLogTypeE, "Provisonal Navigation Failed: ",error)
              zoopDisplayErr(qtErrTitle: "Provisional Navigation Failed", qtErrString: error.localizedDescription)
          }
    }

    extension ZoopGatewayVC: WKScriptMessageHandler{
        func dispResult(zoopSbInfo : ZoopDataObject, zoopResultInfo : ZoopResultObject) {
              let zoopResSb = zoopSbInfo.zoop_result_storyboard
              let zoopResSbId = zoopSbInfo.zoop_result_storyboard_id
              let zoopStoryboard = UIStoryboard(name: zoopResSb, bundle: nil)
              let zoopResView = zoopStoryboard.instantiateViewController(withIdentifier: zoopResSbId) as UIViewController
              self.present(zoopResView, animated: true, completion: {
                  let name = Notification.Name(rawValue: ZOOP_RESULT)
                  NotificationCenter.default.post(name: name, object: nil, userInfo: ["zoopResultType": zoopResultInfo.zoop_result_type, "zoopResponse": zoopResultInfo.zoop_response ])
              })
          }
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            let zoopHandlerType = message.name
                var zoopResInfo = ZoopResultObject()
                zoopResInfo.zoop_result_type = message.name
           
            if zoopHandlerType == ZoopJsHandlerType.ITR_SUCCESS.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.ITR_ERROR.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.BSA_SUCCESS.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.BSA_ERROR.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.WV_ERROR.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.OTP_ERROR.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.WV_TERMINATION.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }else if zoopHandlerType == ZoopJsHandlerType.DENY_CONSENT.rawValue {
                    print(message.name)
                    zoopResInfo.zoop_response = message.body as! String
                    dispResult(zoopSbInfo: zoopReqObject, zoopResultInfo: zoopResInfo)
                    
                }
            }
        }
        


    extension ZoopGatewayVC : UIScrollViewDelegate {
        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return nil
        }

}
