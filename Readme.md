# zoop-gateway-android-sdk
AadhaarAPI | Zoop Android SDK for Income Tax Return and Bank Statement Analysis Gateway


# Table of Contents

## Zoop.one Income Tax Return(ITR) Gateway     
1. [INTRODUCTION](#itrIntroduction)
2. [PROCESS FLOW](#itrProcessFlow)
3. [INITIATING A GATEWAY TRANSACTION](#itrInit)
   - [INIT URL](#itrInitUrl)
   - [REQUEST HEADERS](#itrRequestHeader)
   - [REQUEST BODY PARAMS](#itrRequestBody)
   - [RESPONSE PARAMS](#itrRespParam)
4. [ADDING FRAMEWORK TO YOUR PROJECT](#itrAddSDK)
5. [CONFIGURING AND LAUNCHING THE ITR SDK](#itrConfigureSDK)
   - [IMPORT FILES](#itrImportFiles)
   - [CALL ITR FAMEWORK FROM THE VIEW CONTROLLER](#itrCallSDK)
   - [HANDLE SDK RESPONSE](#itrHandleSDK)
6. [RESPONSE FORMAT SENT ON MOBILE](#itrRespMobile)
   - [SUCCESS JSON RESPONSE FORMAT FOR ITR SUCCESS](#itrRespSuccessMobile)
   - [ERROR JSON RESPONSE FORMAT FOR ITR ERROR](#itrRespErrorMobile)
7. [Handling Webhook Response](#itrWebhook)
   - [SUCCESSFUL REQUEST BODY](#itrSuccessWebhookReqBody)
   - [FAILURE REQUEST BODY](#itrErrorWebhookReqBody)
   - [RESPONSE CODES AND MESSAGES](#itrErrorCodeWebhook)

## Zoop.one Bank Statement Analysis(BSA) Gateway   
1. [INTRODUCTION](#bsaIntro)
2. [PROCESS FLOW](#bsaProcessFlow)
3. [INITIATING A GATEWAY TRANSACTION](#bsaInit)
   - [INIT URL](#bsaInitUrl)
   - [REQUEST HEADERS](#bsaRequestHeader)
   - [REQUEST BODY PARAMS](#bsaRequestBody)
   - [RESPONSE PARAMS](#bsaRespParam)
4. [ADDING FRAMEWORK TO YOUR PROJECT](#bsaAddSDK)
5. [CONFIGURING AND LAUNCHING THE BSA FRAMEWORK](#bsaConfigureSDK)
   - [IMPORT FILES](#bsaImportFiles)
   - [CALL BSA SDK FROM THE VIEW CONTROLLER](#bsaCallSDK)
   - [HANDLE SDK RESPONSE](#bsaHandleSDK)
6. [RESPONSE FORMAT SENT ON MOBILE](#bsaRespMobile)
   - [SUCCESS JSON RESPONSE FORMAT FOR BSA SUCCESS](#bsaRespSuccessMobile)
   - [ERROR JSON RESPONSE FORMAT FOR BSA ERROR](#bsaRespErrorMobile)
   - [GATEWAY ERROR](#bsaRespGatewayErrorMobile)
7. [WEBHOOK](#bsaWebhook)
   - [SUCCESSFUL REQUEST BODY](#bsaSuccessWebhookReqBody)
   - [FAILURE REQUEST BODY](#bsaErrorWebhookReqBody)
   - [ERROR CODES AND MESSAGES](#bsaErrorCodeWebhook)
8. [STAGE](#bsaStage)
   - [SUCCESSFUL RESPONSE BODY](#bsaStageSuccess)
   - [USER STAGES](#bsaUserStage)
   - [FAILURE RESPONSE BODY](#bsaStageFailure)

## Zoop.one Income Tax Return(ITR) Gateway

<a name="itrIntroduction"></a>
### 1. INTRODUCTION
**Income Tax Return** is the form in which assessee files information about his Income and tax thereon to Income Tax Department. The Zoop ITR Gateway allows allows you to fetch the tax returns of your client and make better business decision on them.

<a name="itrProcessFlow"></a>
### 2. PROCESS FLOW
1. At your backend server, Initiate the **ITR** transaction using a simple Rest API [POST] call. Details of these are available in the documents later. You will require API key and Agency Id for accessing this API which can be generated from the Dashboard.
2. This gateway transaction id then needs to be communicated back to the frontend(in Android Project) where SDK is to be called.
3. After adding the Framework in your ios project, client has to pass the above generated transaction id to a Framework View Controller, which will open the Framework.
4. Framework will open with a user login after which and the rest of the process till response will be handled by the gateway itself.
5. Once the transaction is successful or failed, appropriate handler function will be called with response JSON, that can be used by the client to process the flow further. 
6. Client will also have a REST API available to pull the status of a gateway transaction from backend. 

<a name="itrInit"></a>
### 3. INITIATING A GATEWAY TRANSACTION

To initiate a gateway transaction a REST API call has to be made to backend. This call will generate a Gateway Transaction Id which needs to be passed to the frontend ios-sdk to launch the gateway.

<a name="itrInitUrl"></a>
#### 3.1 INIT URL: 

    URL: POST: {{base_url}}/itr/v1/init

 **{{base_url}}**:
 
 **For Pre-Production Environment:** https://preprod.aadhaarapi.com
 
 **For Production Environment:** https://prod.aadhaarapi.com
 
 **Example Url:** https://preprod.aadhaarapi.com/itr/v1/init
 
<a name="itrRequestHeader"></a> 
#### 3.2 REQUEST HEADERS: [All Mandatory]

 **qt_api_key** -- API key generated via Dashboard (PREPROD and PROD)
 
 **qt_agency_id** -- Agency ID available from My account section in Dashboard
 
  Content-Type: application/json
  
<a name="itrRequestBody"></a> 
#### 3.3 REQUEST BODY PARAMS:

      {
        "mode": "POPUP",
        "redirect_url": "https://google.com",
        "webhook_url": "https://webhook.site/7772560d-c97d-43cc-bf8e-248dc41946e1",
        "purpose": "load agreement",
        "phone": "<<PHONE>>",
        "pan": "<<PAN_NUMBER>>",
        "dob": "<<DOB>>",
        "pdf_required": "Y",
        "duration": 3
      }
      
| Parameters   | Mandatory | Description/Value                                    |
| ------------ | --------- | ---------------------------------------------------- |
| mode         | true      | REDIRECT or POPUP                                    |
| redirect_url | false     | A valid URL                                          |
| webhook_url  | true      | A valid URL                                          |
| purpose      | true      | Your purpose                                         |
| phone        | true      | Phone number linked to ITR portal                    |
| pan          | true      | PAN number linked to ITR portal                      |
| dob          | true      | Date of birth of the PAN holder in YYYY-MM-DD format |
| pdf_required | false     | Whether you need PDF of ITR fetched                  |
| duration     | false     | Years for which ITR details to fetch                 |


<a name="itrRespParam"></a>
#### 3.4 RESPONSE PARAMS:
##### 3.4.1 Successful Response:

```json
{
  "id": "<<transaction_id>>",
  "mode": "POPUP",
  "env": "PRODUCTION",
  "webhook_security_key": "<<UUID>>",
  "request_version": "1.0",
  "request_timestamp": "2020-02-17T13:14:26.423Z",
  "expires_at": "2020-02-17T13:24:26.423Z"
}
```

The above generated gateway transactionId is needed to make open gateway via Android SDK.

**Note:** A transaction is valid only for 10 mins after generation.

##### 3.4.2 Failure Response:

```json
{
  "statusCode": 400,
  "errors": [],
  "message": "<<message about the error>>"
}
```
<a name="itrAddSDK"></a>
### 4.ADDING FRAMEWORK TO YOUR PROJECT

1. Drag and Drop GatewaySdkFramework to your Xcode project root file

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-04-30+at+5.33.08+PM.png "Optional title")

2. Inside build phases click on Link Binary with Libraries and then click + button at below.

3. Choose GatewaySdkFrameork.framework from the list after that embed framework in general tab inside Frameworks, Libraries and Embedded Content then click on + button add framework again

4. Inside Build Phases one more section must visible in which you can see your embedded framework as shown below in image.

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.06.52+PM.png "Optional title")

<a name="itrConfigureSDK"></a>
### 5. CONFIGURING AND LAUNCHING THE ITR SDK 

<a name="itrImportFiles"></a>
#### 5.1 IMPORT FILES

    import UIKit
    import GatewaySDKFramework
    
Also define constants inside your view controller as mentioned below

    let zoopResult = Notification.Name(rawValue: ZOOP_RESULT)
    var zoopResponse = "No Zoop Result Found"
    
<a name="itrCallSDK"></a> 
#### 5.2 CALL ITR SDK FROM THE VIEW CONTROLLER

1. Define one action button in your view controller from which you wan to open framework

        @IBAction func btnCallSDK(_ sender: Any) {
            
            var RequestParams  = ZoopDataObject()
            RequestParams.zoop_gateway_id = "b9180f6b-9100-4a68-9867-ea4a230a1b00"
            
            RequestParams.zoop_result_storyboard = "Main"
            RequestParams.zoop_result_storyboard_id = "ViewController"
            
            RequestParams.zoop_req_type = ZOOP_REQ_ITR
            
            let s = UIStoryboard (name: "Main", bundle: nil)
            let qtVc = s.instantiateViewController(withIdentifier: "ZoopGatewayVC") as! ZoopGatewayVC
            qtVc.zoopReqObject = RequestParams;
            self.present(qtVc, animated: true, completion: nil)

        }
   
Params:

zoop_gateway_id: “Transaction Id generated from your backend must be passed here”


2. Add another View Controller in your Main.Storyboard to aligned it with the Framework View Controller named as ZoopGatewayVC shown in image given below

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.45.17+PM.png "Optional title")



<a name="itrHandleSDK"></a> 
#### 5.3 HANDLE SDK RESPONSE

After performing a Successful Transaction: ITR of user will be downloaded 

Also the responses incase of successful transaction as well as response in case of error will be sent to your view controller & can be handled via qtResultHandler method as shown below.

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
                tvResult.text = self.zoopResponse         // tvResult is a label 
                print("06", zoopResponse)
                print("5", resultType ?? " Result Type Not Found")
                print("6", self.zoopResponse);
            }
        }
       
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            NotificationCenter.default.addObserver(self, selector: #selector(self.qtResultHandler(notification:)), name:      zoopResult, object: nil)
            print("0",zoopResponse) //no result
            
        }  
        
        
 
 <a name="itrRespMobile"></a>
### 6. RESPONSE FORMAT SENT ON MOBILE
<a name="itrRespSuccessMobile"></a>
#### 6.1 SUCCESS JSON RESPONSE FORMAT FOR ITR SUCCESS 

```json
{
  "id":"10543aba-e09f-4ee0-9452-ee62584fdb2e",
  "response_message":"Transaction Successful",
  "response_code":"101"
}
```
<a name="itrRespErrorMobile"></a>    
#### 6.2 ERROR JSON RESPONSE FORMAT FOR ITR ERROR

```json
   {   
      "id":"10543aba-e09f-4ee0-9452-ee62584fdb2e",
      "response_message":"Session expired or invalid session",
      "response_code":"606"
    }
```

|Response Parameter| Description/Possible Values|
|----|----|
|response_code| if transaction is successful then value is '101' otherwise there should be an error code|
|response_message| if transaction is successful then value is 'Transaction Successful' otherwise there should be an error message|
|id| Transaction id |


| response_code | response_message           |
| ------------- | -------------------------- |
| 601           | Unknown Error              |
| 602           | Unable to download ITR     |
| 603           | Unable to process response |
| 604           | Unable to submit the OTP   |
| 605           | Unable to parse ITR        |
| 606           | Session expired or invalid |
| 611           | Service unavailable        |

<a name="itrWebhook"></a>
### 7. Handling Webhook Response

The webhook response will be sent to `webhook_url` provided at the init call. When receiving the webhook response please match the `webhook_security_key` in the header of the request to be the same as the one provided in the init call. If they are not the same **you must abandon the webhook response**.

<a name="itrSuccessWebhookReqBody"></a>
#### 7.1 SUCCESSFUL REQUEST BODY

```json
{
  "id": "<<transaction_id>>",
  "mode": "POPUP",
  "env": "PRODUCTION",
  "response_code": "101",
  "response_message": "Transaction Successful",
  "phone_number": "<<PHONE>>",
  "dob": "<<DOB>>",
  "request_version": "1.0",
  "pan": "<<PAN_NUMBER>>",
  "request_medium": "<<web | android | ios>>",
  "sdk_name": "1",
  "data": {
    "transactions": [
      {
        "2019-20": {
          "PersonalInfo": {
            "Address": {
              "PinCode": "453009",
              "ResidenceNo": "Vikasnagar  West Part R.No.3",
              "CityOrTownOrDistrict": "Indore",
              "State": "Madhya pradesh",
              "MobileNo": "8765476856",
              "EmailAddress": "abc@gmail.com",
              "LocalityOrArea": "Tehri Garhwal"
            },
            "AadhaarCardNo": "1123457684302546",
            "PAN": "BFZPT11897",
            "DOB": "04/04/1982",
            "Name": "Rahul  Gupta",
            "EmployerCategory": "Not Applicable"
          },
          "ITR1_IncomeDeductions": {
            "ProfitsInSalary": "0",
            "Salary": "10000",
            "AlwnsNotExempt": "0",
            "IncomeFromSal": "10000",
            "DeductionUs16": "10000",
            "UsrDeductUndChapVIA": {
              "Section80DD": "0",
              "TotalChapVIADeductions": "0",
              "Section80GGA": "0",
              "Section80DDB": "0",
              "Section80CCG": "0",
              "Section80GG": "0",
              "Section80CCDEmployer": "0",
              "Section80CCD1B": "0",
              "Section80GGC": "0",
              "Section80TTA": "0",
              "Section80DHealthInsPremium": {
                "Sec80DHealthInsurancePremiumUsr": "0",
                "Sec80DMedicalExpenditureUsr": "0",
                "Sec80DPreventiveHealthCheckUpUsr": "0"
              },
              "Section80CCDEmployeeOrSE": "0",
              "Section80E": "0",
              "Section80C": "0",
              "Section80CCC": "0",
              "Section80EE": "0",
              "Section80U": "0"
            },
            "IncomeOthSrc": "0",
            "GrossTotIncome": "0",
            "TotalIncomeOfHP": "0",
            "TotalIncome": "0",
            "PerquisitesValue": "0"
          },
          "ITR1_TaxComputation": {
            "TotalIntrstPay": "0",
            "Section89": "0",
            "NetTaxLiability": "0",
            "Rebate87A": "0",
            "GrossTaxLiability": "0",
            "TotalTaxPayable": "0",
            "TotTaxPlusIntrstPay": "0",
            "TaxPayableOnRebate": "0",
            "EducationCess": "0",
            "IntrstPay": {
              "IntrstPayUs234A": "0",
              "IntrstPayUs234B": "0",
              "IntrstPayUs234C": "0"
            }
          },
          "TaxPaid": {
            "TaxesPaid": {
              "AdvanceTax": "0",
              "SelfAssessmentTax": "0",
              "TDS": "0",
              "TCS": "0",
              "TotalTaxesPaid": "0"
            },
            "BalTaxPayable": "0"
          },
          "refund": {
            "BankAccountDtls": {
              "PriBankDetails": {
                "IFSCCode": "SBIN0000454",
                "BankName": "SBI",
                "BankAccountNo": "931815897678"
              }
            },
            "RefundDue": "0"
          }
        },
        "2017-18": {
          "PersonalInfo": {
            "Address": {
              "ResidenceNo": "Vikasnagar  West Part R.No.3",
              "LocalityOrArea": "Tehri Garhwal",
              "MobileNo": "8765476856",
              "EmailAddress": "abc@gmail.com",
              "CityOrTownOrDistrict": "Indore",
              "State": "Madhya pradesh",
              "PinCode": "453009"
            },
            "EmployerCategory": "Not Applicable",
            "Status": "RES - Resident",
            "AadhaarCardNo": "1123457684302546",
            "PAN": "BFZPT11897",
            "DOB": "04/04/1982",
            "Name": "Rahul Gupta"
          },
          "ITR1_IncomeDeductions": {
            "UsrDeductUndChapVIA": {
              "TotalChapVIADeductions": "0",
              "Section80GGA": "0",
              "Section80DDB": "0",
              "Section80CCG": "0",
              "Section80CCDEmployer": "0",
              "Section80QQB": "0",
              "Section80GGC": "0",
              "Section80RRB": "0",
              "Section80TTA": "0",
              "Section80CCC": "0",
              "Section80EE": "0"
            },
            "TotalIncome": "0"
          },
          "ITR1_TaxComputation": {
            "NetTaxLiability": "0",
            "IntrstPay": {
              "IntrstPayUs234A": "0",
              "IntrstPayUs234B": "0",
              "IntrstPayUs234C": "0"
            },
            "GrossTaxLiability": "0",
            "Rebate87A": "0",
            "TaxPayableOnRebate": "0",
            "TotalTaxPayable": "0",
            "Section89": "0"
          },
          "TaxPaid": {
            "TaxesPaid": {
              "AdvanceTax": "0",
              "TCS": "0",
              "TotalTaxesPaid": "0",
              "SelfAssessmentTax": "0",
              "TDS": "0"
            },
            "BalTaxPayable": "0"
          },
          "refund": {
            "BankAccountDtls": {
              "PriBankDetails": {
                "IFSCCode": "YESB0000008",
                "BankName": "YESBANK"
              }
            },
            "RefundDue": "0"
          }
        }
      }
    ]
  }
}
```

<a name="itrErrorWebhookReqBody"></a>
#### 7.2 FAILURE REQUEST BODY

```json
{
  "id": "<<transaction_id>>",
  "mode": "POPUP",
  "env": "PRODUCTION",
  "response_code": "100",
  "response_message": "Transaction Failed",
  "phone_number": "<<PHONE>>",
  "dob": "<<DOB>>",
  "request_version": "1.0",
  "pan": "<<PAN_NUMBER>>",
  "request_medium": "<<web | android | ios>>",
  "sdk_name": "1",
  "error": {
    "code": "<<error_code>>",
    "message": "<<error_message>>"
  }
}
```

<a name="itrErrorCodeWebhook"></a>
#### 7.3 RESPONSE CODES AND MESSAGES

| Code | Billable | Message                    |
| ---- | -------- | -------------------------- |
| 101  | true     | Transaction Successful     |
| 601  | false    | Unknown Error              |
| 602  | false    | Unable to download ITR     |
| 603  | false    | Unable to process response |
| 604  | false    | Unable to submit the OTP   |
| 605  | false    | Unable to parse ITR        |
| 606  | false    | Session expired or invalid |
| 609  | false    | Consent Denied             |
| 610  | false    | Gateway Terminated         |
| 611  | false    | Service unavailable        |



## Zoop.one Bank Statement Analysis(BSA) Gateway 

<a name="bsaIntro"></a>
### 1. INTRODUCTION 

**Bank statement analyzer** predicts the worthiness of an individual and his/her credibility for a loan, after analyzing a considerable number of bank transactions, with the assistance of complex algorithm, text extraction, data categorization and smart analysis techniques.

<a name="bsaProcessFlow"></a>
### 2. PROCESS FLOW
1. At your backend server, Initiate the BSA transaction using a simple Rest API [POST] call. Details of these are available in the documents later. You will require API key and Agency Id for accessing this API which can be generated from the Dashboard.
2. This gateway transaction id then needs to be communicated back to the frontend(in Android Project) where SDK is to be called.
3. After adding the Framework in your ios project, client has to pass the above generated transaction id to an Framework View Controller , which will open the Framework.
4. Framework will open with a user login after which and the rest of the process till response will be handled by the gateway itself.
5. Once the transaction is successful or failed, appropriate handler function will be called with response JSON, that can be used by the client to process the flow further. 
6. Client will also have a REST API available to pull the status of a gateway transaction from backend. 

<a name="bsaInit"></a>
### 3. INITIATING A GATEWAY TRANSACTION

To initiate a gateway transaction a REST API call has to be made to backend. This call will generate a Gateway Transaction Id which needs to be passed to the frontend web-sdk to launch the gateway. 

<a name="bsaInitUrl"></a>
#### 3.1 INIT URL: 
    URL: POST: {{base_url}}/bsa/v1/init
    
 **{{base_url}}**:
 
 **For Pre-Production Environment:** https://preprod.aadhaarapi.com
 
 **For Production Environment:** https://prod.aadhaarapi.com
 
 **Example Url:** https://preprod.aadhaarapi.com/bsa/v1/init

<a name="bsaRequestHeader"></a>
#### 3.2 REQUEST HEADERS: [All Mandatory]

 **qt_api_key** -- API key generated via Dashboard (PREPROD and PROD)
 
 **qt_agency_id** -- Agency ID available from My account section in Dashboard
 
  Content-Type: application/json

<a name="bsaRequestBody"></a>
#### 3.3 REQUEST BODY PARAMS: 
    {
    "mode": "REDIRECT",
    "redirect_url": "https://yourdomain.com",
    "webhook_url": "https://yourdomain.com/webhook",
    "purpose": "load agreement",
    "bank": "YESBANK",
    "months": 3
    }
|Parameters| Required| Description/Value|
|----|----|----|
|mode| true| REDIRECT or POPUP|
|redirect_url| true |A valid URL|
|webhook_url| true| A valid URL|
|purpose| true| Your purpose|
|bank| false| ICICI or YESBANK or HDFC or SBI or AXIS or KOTAK or SC|
|months| false| 1 - 12|

Currently, supported banks are ICICI, YES BANK, HDFC, STATE BANK OF INDIA, AXIS, KOTAK, STANDARD CHARTERED.

<a name="bsaRespParam"></a>
#### 3.4 RESPONSE PARAMS:
##### 3.4.1 Successful Response:
  
      {
          "id": "<<transaction_id>>",
          "mode": "REDIRECT",
          "env": "PREPROD",
          "webhook_security_key": "<<UUID>>",
          "request_version": "1.0",
          "request_timestamp": "2020-01-13T13:31:16.941Z",
          "expires_at": "2020-01-13T13:41:16.941Z"
      }    
      
After successful creating of transaction proceed to https://bsa.aadhaarapi.com?session_id=<<transaction_id>>

The above generated gateway transactionId has to be made available in your android project to
open the BSA SDK.

**Note:** A transaction is valid only for 10 mins after generation. Please check the **webhook_security_key** when receiving any response on the webhook. If the keys didn’t match then **don’t proceed** with the request.
    
##### 3.4.2 Failure Response:   
    {
        "statusCode": 400,
        "errors": [],
        "message": "<<message about the error>>"
    }
    
<a name="bsaAddSDK"></a>    
### 4.ADDING FRAMEWORK TO YOUR PROJECT

1. Drag and Drop GatewaySdkFramework to your Xcode project root file

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-04-30+at+5.33.08+PM.png "Optional title")

2. Inside build phases click on Link Binary with Libraries and then click + button at below.

3. Choose GatewaySdkFrameork.framework from the list after that embed framework in general tab inside Frameworks, Libraries and Embedded Content then click on + button add framework again

4. Inside Build Phases one more section must visible in which you can see your embedded framework as shown below in image.

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.06.52+PM.png "Optional title")

<a name="bsaConfigureSDK"></a>
### 5. CONFIGURING AND LAUNCHING THE BSA FRAMEWORK 

<a name="bsaImportFiles"></a>
#### 5.1 IMPORT FILES

    import UIKit
    import GatewaySDKFramework
    
Also define constants inside your view controller as mentioned below

    let zoopResult = Notification.Name(rawValue: ZOOP_RESULT)
    var zoopResponse = "No Zoop Result Found"
    
<a name="bsaCallSDK"></a> 
#### 5.2 CALL BSA SDK FROM THE VIEW CONTROLLER

1. Define one action button in your view controller from which you wan to open framework

        @IBAction func btnCallSDK(_ sender: Any) {
            
            var RequestParams  = ZoopDataObject()
            RequestParams.zoop_gateway_id = "b9180f6b-9100-4a68-9867-ea4a230a1b00"
            
            RequestParams.zoop_result_storyboard = "Main"
            RequestParams.zoop_result_storyboard_id = "ViewController"
            
            RequestParams.zoop_req_type = ZOOP_REQ_BSA
            
            let s = UIStoryboard (name: "Main", bundle: nil)
            let qtVc = s.instantiateViewController(withIdentifier: "ZoopGatewayVC") as! ZoopGatewayVC
            qtVc.zoopReqObject = RequestParams;
            self.present(qtVc, animated: true, completion: nil)

        }
   
Params:

zoop_gateway_id: “Transaction Id generated from your backend must be passed here”


2. Add another View Controller in your Main.Storyboard to aligned it with the Framework View Controller named as ZoopGatewayVC shown in image given below

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.45.17+PM.png "Optional title")



<a name="bsaHandleSDK"></a> 
#### 5.3 HANDLE SDK RESPONSE

After performing a Successful Transaction: ITR of user will be downloaded 

Also the responses incase of successful transaction as well as response in case of error will be sent to your view controller & can be handled via qtResultHandler method as shown below.

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
                tvResult.text = self.zoopResponse         // tvResult is a label 
                print("06", zoopResponse)
                print("5", resultType ?? " Result Type Not Found")
                print("6", self.zoopResponse);
            }
        }
       
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            NotificationCenter.default.addObserver(self, selector: #selector(self.qtResultHandler(notification:)), name:      zoopResult, object: nil)
            print("0",zoopResponse) //no result
            
        }  
            
   
<a name="bsaRespMobile"></a>
### 6. RESPONSE FORMAT SENT ON MOBILE
<a name="bsaRespSuccessMobile"></a>
#### 6.1 SUCCESS JSON RESPONSE FORMAT FOR BSA SUCCESS 
    {   
        response_code: "SUCCESS"
        response_message: "Transaction Successful"
        payload: { //success data here if any otherwise null}
    }
<a name="bsaRespErrorMobile"></a>    
#### 6.2 ERROR JSON RESPONSE FORMAT FOR BSA ERROR
    {   
        response_code: "OTP_ATTEMPT_EXPIRED"
        response_message: "All attempts for otp expired."
        payload: null
    }
<a name="bsaRespGatewayErrorMobile"></a>    
#### 6.3 GATEWAY ERROR
    {   
        response_code: "SESSION_EXPIRED"
        response_message: "Session key is expired"
        payload: null
    }

|Response Parameter| Description/Possible Values|
|----|----|
|response_code| if transaction is successful then value is 'SUCCESS' otherwise there should be an error code|
|response_message| if transaction is successful then value is 'Transaction Successful' otherwise there should be an error message|
|payload| if there is success payload data then it is not null otherwise it is always null|

<a name="bsaWebhook"></a>
### 7. WEBHOOK

The webhook response will be received to the webhook_url provided in the initialization call. When receiving the webhook response please match the webhook_security_key in the header of the request to be the same as the one provided in the init call. **If they are not the same you must abandon the webhook response**.

<a name="bsaSuccessWebhookReqBody"></a>
#### 7.1 SUCCESSFUL REQUEST BODY

    {
      "id": "b5245253-425c-4291-8ea7-5760f5ecd86a",
      "mode": "REDIRECT",
      "env": "PREPROD",
      "bank": "YESBANK",
      "response_code": 100,
      "response_message": "Transaction Successful",
      "last_user_stage_code": 10,
      "last_user_stage": "parse_statement",
      "request_version": "1.0",
      "data": {
        "metadata": {
          "acc_number": "<<account_number>> ",
          "start_date": "09/01/2019",
          "end_date": "08/01/2020"
        },
        "transactions": [
          {
            "date": "2019-03-17",
            "value_date": "2019-03-17",
            "chq": "",
            "particulars": "Details About the transaction",
            "balance": 100,
            "amount": 100,
            "label": "CREDIT",
            "validation": true
          }
        ]
      }
    }
<a name="bsaErrorWebhookReqBody"></a>
#### 7.2 FAILURE REQUEST BODY

    {
      "id": "b5245253-425c-4291-8ea7-5760f5ecd86a",
      "mode": "REDIRECT",
      "env": "PREPROD",
      "bank": "YESBANK",
      "response_code": 100,
      "response_message": "Transaction Successful",
      "last_user_stage_code": 10,
      "last_user_stage": "parse_statement",
      "request_version": "1.0",
      "error": {
        “code”: <<error_code>>,
        “Message”: <<error_message>>
      }
    }

<a name="bsaErrorCodeWebhook"></a>
#### 7.3 ERROR CODES AND MESSAGES

651: 'Technical Error',

652: 'Session Closed Error',

653: 'Bank Server Unresponsive Error',

654: 'Consent Denied Error',

655: 'Document Parsing Error',

656: 'Validity Expiry Error',

657: 'Authentication Error'

<a name="bsaStage"></a>
### 8. STAGE

After creating an initialization request successfully you can check at which stage your transaction is currently.

    GET: {{base_url}}/bsa/v1/stage/<<transaction_id>>

<a name="bsaStageSuccess"></a>
#### 8.1 SUCCESSFUL RESPONSE BODY

    {
        "id": "24f575ad-c706-477c-9618-8f079b5c985c",
        "mode": "REDIRECT",
        "env": "PREPROD",
        "request_version": "1.0",
        "bank": "YESBANK",
        "last_user_stage": "transaction_initiated",
        “last_user_stage_code": 11
    }

<a name="bsaUserStage"></a>
#### 8.2 USER STAGES


|Stage Code| Stage Message|
|----|----|
|-1 |failed_stage|
|0| get_login_page|
|1| crawl_after_credentials|
|2| crawl_after_acc_select|
|3| crawl_after_captcha1|
|4| crawl_after_captcha2|
|5| crawl_after_answer|
|6| crawl_after_otp|
|7| crawl_after_credentials_captcha1|
|10| parse_statement|
|11| transaction_initiated|

<a name="bsaStageFailure"></a>
#### 8.3 FAILURE RESPONSE BODY

    {
        "statusCode": 404,
        "errors": [],
        "message": "transaction id not found in our records"
    }
   
In case you are facing any issues with integration please open a ticket on our [support portal](https://aadhaarapi.freshdesk.com/support/home)
        
