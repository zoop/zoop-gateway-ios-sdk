//
//  ZoopHandler.swift
//  GatewaySDK
//
//  Created by Divyank Vijayvergiya on 28/04/20.
//  Copyright © 2020 Zoop.one. All rights reserved.
//

import Foundation

class ZoopHandler{
    func generateBsaURL(ReqObject: ZoopDataObject) -> URL {
//        let zoopLogTag = "ZOOP_SDK "
//        let zoopLogTypeI = "one.zoop.sdk.Debug "
        
        var zoopComponents = URLComponents()
        zoopComponents.scheme = "https"
//        if ReqObject.zoop_env == "QT_P" {
//            zoopComponents.host = "prod.aadhaarapi.com"
//            print(zoopLogTag, zoopLogTypeI, "env: Prod")
//
//        }else if ReqObject.zoop_env == "QT_PP"{
//            zoopComponents.host = "preprod.aadhaarapi.com"
//            print(zoopLogTag, zoopLogTypeI, "env: PreProd");
//
//        }else if ReqObject.zoop_env == "QT_T"{
//            zoopComponents.host = "test.aadhaarapi.com"
//            print(zoopLogTag, zoopLogTypeI, "env: Test")
//
//        }else if ReqObject.zoop_env == "QT_L"{
//            zoopComponents.scheme = "http"
//            zoopComponents.host = "103.3.40.138"
//            print(zoopLogTag, zoopLogTypeI, "env: Local")
//
//        }else {
//            let qtUrlString = "https://InvalidBaseUrl"
//            let qtUrl = URL(string: qtUrlString)
//            return qtUrl!
//        }
        zoopComponents.host = "bsa.aadhaarapi.com"
        
        let zoopSessionId = URLQueryItem(name: "session_id", value: ReqObject.zoop_gateway_id)
        let zoopPlatform = URLQueryItem(name: "platform", value: "ios")

        let zoopQueryItems = [zoopSessionId, zoopPlatform]
        
        zoopComponents.queryItems = zoopQueryItems;
        return zoopComponents.url!
    }
    
    
   func generateItrURL(ReqObject: ZoopDataObject) -> URL {
            
            var zoopComponents = URLComponents()
            zoopComponents.scheme = "https"
            zoopComponents.host = "itr.zoop.one"
            
            let zoopSessionId = URLQueryItem(name: "session_id", value: ReqObject.zoop_gateway_id)
            let zoopPlatform = URLQueryItem(name: "platform", value: "ios")

            let zoopQueryItems = [zoopSessionId, zoopPlatform]
            
            zoopComponents.queryItems = zoopQueryItems;
            return zoopComponents.url!
        }
}
