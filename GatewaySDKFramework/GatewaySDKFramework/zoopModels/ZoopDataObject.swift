//
//  ZoopDataObject.swift
//  GatewaySDK
//
//  Created by Divyank Vijayvergiya on 28/04/20.
//  Copyright © 2020 Zoop.one. All rights reserved.
//

import Foundation

public struct ZoopDataObject {
    public init(){}
    
       public var zoop_env : String = "QT_PP"
       public var zoop_gateway_id : String = ""
       public var zoop_color_bg : String = "2c3e50"
       public var zoop_color_ft : String = "ffffff"
       public var zoop_req_type : String = ""

    //   public var qt_req_type : String = QT_REQ_CREDITSCORE
    //   public var qt_req_type : String = QT_REQ_OFFLINEAADHAAR
       
       //Define Sdk's Result receiving Activity
       public var zoop_result_storyboard : String = ""
       public var zoop_result_storyboard_id : String = ""
       
       public var zoop_name : String = ""
       public var zoop_dob : String = ""
       public var zoop_address : String = ""
       public var zoop_postal_code : String = ""
       public var zoop_state : String = ""
       public var zoop_pan : String = ""
       
       public var zoop_validate_phone : String = ""
       public var zoop_validate_email : String = ""
}
public struct ZoopResultObject {
    
    public init() {}
    //    public var qt_storyboard : String = "";
    //    public var qt_storyboard_id : String = "";
    
    // SDK Result Params
    public var zoop_result_type : String = ""
    public var zoop_response : String = ""
    public var zoop_cs_pdf : String = ""
    
}
