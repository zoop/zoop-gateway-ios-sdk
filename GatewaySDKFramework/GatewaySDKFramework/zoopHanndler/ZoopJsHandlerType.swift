//
//  ZoopJsHandlerType.swift
//  GatewaySDK
//
//  Created by Divyank Vijayvergiya on 28/04/20.
//  Copyright © 2020 Zoop.one. All rights reserved.
//

import Foundation

public enum ZoopJsHandlerType: String {
    case ITR_SUCCESS = "handleITRSuccess"
    case ITR_ERROR = "handleITRError"
    case BSA_SUCCESS = "handleBsaSuccess"
    case BSA_ERROR = "handleBsaFail"
//    case OFFLINE_AADHAAR_FILE_TYPE = "handleFileExplorerOptions"
    case OTP_ERROR = "handleOTPError"
    case DENY_CONSENT = "handleConsentDenied"
    case WV_ERROR = "handleGatewayError"
    case WV_TERMINATION = "handleGatewayTermination"
}
