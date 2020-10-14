# zoop-gateway-ios-sdk
AadhaarAPI | Zoop IOS SDK for Income Tax Return and Bank Statement Analysis Gateway


# Table of Contents

## Zoop.one Income Tax Department(ITR) Gateway (Beta)  
1. [INTRODUCTION](#itrIntroduction)
2. [PROCESS FLOW](#itrProcessFlow)
3. [INITIATING A GATEWAY TRANSACTION](#itrInit)
   - [INIT URL](#itrInitUrl)
   - [REQUEST HEADERS](#itrRequestHeader)
   - [REQUEST BODY PARAMS](#itrRequestBody)
   - [RESPONSE PARAMS](#itrRespParam)
4. [FETCH URL](#itrFetchUrl)   
   - [FETCH RESPONSE](#itrFetchResponse)
5. [ADDING FRAMEWORK TO YOUR PROJECT](#itrAddSDK)
6. [CONFIGURING AND LAUNCHING THE ITR SDK](#itrConfigureSDK)
   - [IMPORT FILES](#itrImportFiles)
   - [CALL ITR FAMEWORK FROM THE VIEW CONTROLLER](#itrCallSDK)
   - [HANDLE SDK RESPONSE](#itrHandleSDK)
7. [RESPONSE FORMAT SENT ON MOBILE](#itrRespMobile)
   - [SUCCESS JSON RESPONSE FORMAT FOR ITR SUCCESS](#itrRespSuccessMobile)
   - [ERROR JSON RESPONSE FORMAT FOR ITR ERROR](#itrRespErrorMobile)
   - [EVENT- ITD CONSENT DENIED](#itrRespErrorConsentDenied)
   - [[EVENT- ITD GATEWAY TERMINATED](#itrRespErrorGatewayTerminated)
8. [Handling Webhook Response](#itrWebhook)
   - [SUCCESSFUL REQUEST BODY](#itrSuccessWebhookReqBody)
   - [FAILURE REQUEST BODY](#itrErrorWebhookReqBody)
   - [26AS SUCCESSFUL REQUEST BODY](#26asSuccessWebhookReqBody)
   - [WEBHOOK EVENT TYPES](#itrWebhookEventTypes)
   - [REASON AND RESPONSE CODES AND MESSAGES](#itrErrorCodeWebhook)

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


## Zoop.one E-Sign Gateway (V3 BETA)
1. [INTRODUCTION](#esignIntroduction)
2. [PROCESS FLOW](#esignProcessFlow)
   - [END USER FLOW](#esignEndUserFlow)
3. [INITIATING A GATEWAY TRANSACTION FOR E-SIGN](#esignInit)
   - [INIT URL](#esignInitUrl)
   - [REQUEST HEADERS](#esignRequestHeaders)
   - [REQUEST BODY PARAMS](#esignRequestbody)
   - [RESPONSE PARAMS](#esignResponseParams)
4. [ADDING SDK TO YOUR PROJECT](#esignAddSDK)
5. [CONFIGURING AND LAUNCHING THE ESIGN FRAMEWORK](#esignConfigureSDK)
   - [IMPORT FILES](#esignImportFiles)
   - [CALL ESIGN SDK FROM THE VIEW CONTROLLER](#esignCallSDK)
   - [HANDLE SDK RESPONSE](#esignHandleSDK)
6. [RESPONSE FORMAT SENT ON MOBILE](#esignRespMobile)
   - [SUCCESS JSON RESPONSE FORMAT FOR E-SIGN SUCCESS](#esignSuccessRespMob)
   - [ERROR JSON RESPONSE FORMAT FOR E_SIGN ERROR](#esignErrorRespMob)
   - [ERROR JSON RESPONSE FORMAT FOR GATEWAY ERROR](#esignErrorRespGateway)
7. [RESPONSE FORMAT SENT ON RESPONSE_URL(ADDED IN INIT API CALL)](#esignRespInit)
   - [SUCCESS JSON RESPONSE FORMAT FOR E-SIGN SUCCESS](#esignRespInitSuccess)
   - [ERROR JSON RESPONSE FORMAT FOR E_SIGN ERROR](#esignRespInitError)
8. [BIOMETRIC DEVICES SETUP](#esignBiometric)
9. [PULLING TRANSACTION STATUS AT BACKEND](#esignStatus)
   - [RESPONSE PARAMS](#esignStatusResp)
   
## Zoop.one Income Tax Department(ITR) Gateway (Beta)

<a name="itrIntroduction"></a>
### 1. INTRODUCTION
**Income Tax Department** holds and verifies the earnings and tax related information of an individual.
Income tax return is a form where a person submits information about his income earned and the tax paid to the Department. Whereas 26AS is a consolidated annual tax credit statement of an individual's earnings as per the ITD records. The Zoop ITD Gateway allows you to fetch and verify the financial information of your client in order to make better business decisions.

<a name="itrProcessFlow"></a>
### 2. PROCESS FLOW
1. At your backend server, Initiate the **ITD** transaction using a simple Rest API [POST] call. Details of these are available in the documents later. You will require API key and Agency Id for accessing this API which can be generated from the Dashboard.
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

    URL: POST: {{base_url}}/itd/v2/init

 **{{base_url}}**:
 
 **For Pre-Production Environment:** https://preprod.aadhaarapi.com
 
 **For Production Environment:** https://prod.aadhaarapi.com
 
 **Example Url:** https://preprod.aadhaarapi.com/itd/v2/init
 
<a name="itrRequestHeader"></a> 
#### 3.2 REQUEST HEADERS: [All Mandatory]

 **qt_api_key** -- API key generated via Dashboard (PREPROD and PROD)
 
 **qt_agency_id** -- Agency ID available from My account section in Dashboard
 
  Content-Type: application/json
  
<a name="itrRequestBody"></a> 
#### 3.3 REQUEST BODY PARAMS:
 
```json
{
  "mode": "POPUP",
  "webhook_url": "https://your-website.com/webhook",
  "redirect_url": "https://your-website.com",
  "purpose": "testing",
  "phone": "9999999999",
  "dob": "01-01-1990",
  "phone_override": false,
  "document_required": {
    "ITR": 1,
    "26AS": 2
  },
  "pan": "ABCDE1234F",
  "pdf_required": false
}
```
      
| Parameters          | Mandatory | Description/Value                                      |
| ------------------- | --------- | ------------------------------------------------------ |
| mode                | true      | REDIRECT or POPUP                                      |
| redirect_url        | false     | A valid URL                                            |
| webhook_url         | true      | A valid URL                                            |
| purpose             | true      | The reason for the transaction                         |
| phone_override      | false     | If you wanted to update your phone number              |
| document_required { | true      | If you wanted to update your phone number              |
| ITR                 | false     | Specify for how many years of ITR you wanted to fetch  |
| 26AS }              | false     | Specify for how many years of 26AS you wanted to fetch |
| phone               | true      | Phone number you wanted to use at our platform         |
| pan                 | true      | PAN number linked to ITR portal                        |
| dob                 | true      | Date of birth of the PAN holder in MM-DD-YYYY format   |
| pdf_required        | false     | Whether you need PDF of ITR fetched                    |

**NOTE**: If an existing user submits invalid combination of Phone registered against PAN and DOB. We will return an error that _PAN is already linked with a different phone number **\*\***1234_ with last 4 digits of correct phone number.
In such scenario if the user doesn't have the phone number then they need to login into Income Tax Department (ITD) Portal using their ID password and remove us as e-Return Intermediary using this process.
After that you need to provided `phone_override` as `true` to evade the error.

**New User** - New unique user being added to the ITD Portal for ITR and/or 26AS verification for the first time via ZOOP.ONE

**Existing User** - User that was added to ITD by ZOOP.ONE to verify and fetch ITR and/or 26AS details, has been requested for re-verification of documents for the user on the same credentials as stored in ZOOP.ONE system earlier.

<a name="itrRespParam"></a>
#### 3.4 RESPONSE PARAMS:
##### 3.4.1 Successful Response:

```json
{
  "id": "<<transaction_id>>",
  "mode": "POPUP",
  "env": "production",
  "request_version": "2.0",
  "webhook_security_key": "<<security_key>>",
  "request_timestamp": "2020-10-13T09:34:02.204Z",
  "expires_at": "2020-10-13T09:44:02.194Z"
}
```

The above generated gateway transactionId is needed to make open gateway via Android SDK.

**Note:** A transaction is valid only for 10 mins after generation.

##### 3.4.2 Failure Response:

```json
{
  "error": {
    "reason_message": "<<ERROR MESSAGE>>,
    "reason_code": "<<ERROR_CODE>>"
  }
}
```

##### 3.4.3 Reason code and reason message list

Here are the list of reason code and message that you might receive if there is an error while making the init call.

| Reason Code                      | Reason Message                                                       |
| -------------------------------- | -------------------------------------------------------------------- |
| MISSING_MODE                     | Mode is required                                                     |
| INVALID_MODE                     | Mode should either be POPUP or REDIRECT                              |
| MISSING_REDIRECT_URL             | Redirect URL is required when mode is REDIRECT                       |
| INVALID_REDIRECT_URL             | Redirect URL is invalid                                              |
| MISSING_PAN                      | PAN number is required                                               |
| INVALID_PAN                      | PAN is invalid                                                       |
| MISSING_PHONE_NUMBER             | Phone number is required                                             |
| INVALID_PHONE_NUMBER             | Phone number is invalid                                              |
| MISSING_DATE_OF_BIRTH            | Date of birth is required                                            |
| INVALID_DATE_OF_BIRTH            | Date of birth is invalid                                             |
| MISSING_WEBHOOK_URL              | Webhook URL is required                                              |
| INVALID_WEBHOOK_URL              | Webhook URL is invalid                                               |
| MISSING_PURPOSE                  | Purpose is required                                                  |
| INVALID_PURPOSE                  | Purpose should be with 1000 characters                               |
| INVALID_PHONE_OVERRIDE           | Phone override should be boolean                                     |
| INVALID_PDF_REQUIRED             | PDF required should be boolean                                       |
| INVALID_ITR_DOCUMENT_REQUIRED    | ITR duration should be between 1 to 3 years                          |
| MAX_DURATION_REACHED_ITR         | ITR should be maximum of 3 years                                     |
| MAX_DURATION_REACHED_26AS        | 26AS should be maximum of 2 years                                    |
| INVALID_26AS_DOCUMENT_REQUIRED   | 26AS duration should be between 1 to 2 years                         |
| MISSING_DOCUMENT_REQUIRED        | Required document should either be ITR or 26AS or both               |
| PAN_LINKED_WITH_DIFFERENT_NUMBER | PAN is already linked with a different phone number **\*\***0797     |
| DATE_OF_BIRTH_MISMATCH           | Provided date of birth (1995-05-19) did not match with existing data |
| SOMETHING_WENT_WRONG             | Something went wrong                                                 |

<a name="itrFetchUrl"></a>
#### 4 FETCH URL:

After generating the transaction id, at any point in time to get the details about the transaction state you can use this API.

    URL: GET: {{base_url}}/itd/v2/fetch/<<transaction_id>>
    
<a name="itrFetchResponse"></a>
#### 4.1 FETCH RESPONSE:

After successful response you will receive the following JSON

```json
{
  "org": {
    "id": "<<your org id>>",
    "name": "<<your org name>>"
  },
  "last_user_stage_code": "TXN_INITIALIZED",
  "itr_requested": true,
  "26as_requested": true,
  "request_version": "2.0",
  "phone_override": false,
  "otp_resend_count": 0,
  "otp_verify_count": 0,
  "mode": "POPUP",
  "pan": "ABCDE1234F",
  "consent_text": "By clicking \"Submit\" you allow ZOOP.ONE to fetch ITR and 26AS and submit to YOUR COMPANY for testing",
  "env": "production",
  "webhook_security_key": "<<some secure key>>",
  "26as_duration": 2,
  "itr_duration": 1,
  "webhook_url": "https://your-website.com/webhook",
  "redirect_url": "https://your-website.com",
  "pdf_required": false,
  "id": "<<transaction_id>>",
  "itr_response_sent": false,
  "phone": "9999999999",
  "dob": "01-01-1990",
  "26as_response_sent": false,
  "request_timestamp": "2020-10-12T11:26:07.398Z"
}
```
<a name="itrAddSDK"></a>
### 5.ADDING FRAMEWORK TO YOUR PROJECT

1. Drag and Drop GatewaySdkFramework to your Xcode project root file

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-04-30+at+5.33.08+PM.png "Optional title")

2. Inside build phases click on Link Binary with Libraries and then click + button at below.

3. Choose GatewaySdkFrameork.framework from the list after that embed framework in general tab inside Frameworks, Libraries and Embedded Content then click on + button add framework again

4. Inside Build Phases one more section must visible in which you can see your embedded framework as shown below in image.

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.06.52+PM.png "Optional title")

<a name="itrConfigureSDK"></a>
### 6. CONFIGURING AND LAUNCHING THE ITR SDK 

<a name="itrImportFiles"></a>
#### 6.1 IMPORT FILES

    import UIKit
    import GatewaySDKFramework
    
Also define constants inside your view controller as mentioned below

    let zoopResult = Notification.Name(rawValue: ZOOP_RESULT)
    var zoopResponse = "No Zoop Result Found"
    
<a name="itrCallSDK"></a> 
#### 6.2 CALL ITR SDK FROM THE VIEW CONTROLLER

1. Define one action button in your view controller from which you wan to open framework

        @IBAction func btnCallSDK(_ sender: Any) {
            
            var RequestParams  = ZoopDataObject()
            RequestParams.zoop_gateway_id = "5f86c1b22b0f3b0012b770d5"
            
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
#### 6.3 HANDLE SDK RESPONSE

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
### 7. RESPONSE FORMAT SENT ON MOBILE

<a name="itrRespSuccessMobile"></a>
#### 7.1 SUCCESS JSON RESPONSE FORMAT FOR ITR SUCCESS 

```json
{
  "id":"10543aba-e09f-4ee0-9452-ee62584fdb2e",
  "response_message":"Transaction Successful",
  "response_code":"TRANSACTION_SUCCESSFUL"
}
```
<a name="itrRespErrorMobile"></a>    
#### 7.2 ERROR JSON RESPONSE FORMAT FOR ITR ERROR

```json
   {   
     "id": "<<transaction_id>>",
    "error": {
      "reason_code": "ITD_PAN_ALREADY_ADDED",
      "reason_message": "PAN Number already added with Income Tax Department",
      "response_code": "106",
      "response_message": "Invalid combination of inputs"
      }
    }
```

These are the values that you may receive in case there is an error while processing the transaction. Please note that for some errors you might not receive `response_code` and `response_message` that's why they are `undefined`.

| reason_code             | reason_message                                                     | response_code | response_message              |
| ----------------------- | ------------------------------------------------------------------ | ------------- | ----------------------------- |
| INTERNAL_ERROR          | Something went wrong                                               | 111           | Internal Error                |
| TXN_EXPIRED             | Transaction expired                                                | `undefined`   | `undefined`                   |
| TXN_COMPLETED           | Transaction Successfully Completed                                 | `undefined`   | `undefined`                   |
| TXN_IN_QUEUE            | Transaction is already in progress                                 | `undefined`   | `undefined`                   |
| TXN_OTP_LIMIT_EXHAUSTED | Transaction is already finished with error                         | `undefined`   | `undefined`                   |
| TXN_NOT_FOUND           | Transaction not found                                              | `undefined`   | `undefined`                   |
| ITD_PAN_ALREADY_ADDED   | PAN Number already added with Income Tax Department                | 106           | Invalid combination of inputs |
| ITD_PAN_NOT_EXIST       | Unable to fetch the PAN Number entered from the Income Tax records | 101           | No Records Found              |
| ITD_DOB_MISSING         | Date of birth missing                                              | 106           | Invalid combination of inputs |
| ITD_INVALID_DOB_PATTERN | Invalid date of birth pattern                                      | 106           | Invalid combination of inputs |
| ITD_INVALID_DOB         | Date of birth invalid                                              | 106           | Invalid combination of inputs |
| ITD_INVALID_PAN_FORMAT  | PAN format invalid                                                 | 106           | Invalid combination of inputs |
| ITD_PAN_NOT_REGISTERED  | Unable to fetch the PAN Number entered from the Income Tax records | 101           | No Records Found              |
| ITD_MOBILE_OTP_EMPTY    | Mobile OTP required                                                | 106           | Invalid combination of inputs |
| ITD_EMAIL_OTP_EMPTY     | Email OTP required                                                 | 106           | Invalid combination of inputs |
| ITD_INVALID_MOBILE_OTP  | Mobile OTP is invalid                                              | 106           | Invalid combination of inputs |
| ITD_INVALID_EMAIL_OTP   | Email OTP is invalid                                               | 106           | Invalid combination of inputs |
| ITD_INCORRECT_OTP       | Email and Mobile OTP invalid                                       | 106           | Invalid combination of inputs |

<a name="itrRespErrorConsentDenied"></a> 
#### 7.3 Event: `itd-consent-denied`

This event is fired when user don't want to agree going ahead with the transaction and explicitly _Deny_ the transaction in the gateway. The respective callback is called and `message` parameter is passed. The `message` is an object with `action` and `payload` property on it.

The `payload` has `id`, `response_code`, and `response_message` properties.

| response_code  | response_message |
| -------------- | ---------------- |
| CONSENT_DENIED | Consent Denied   |

```json
{
    "id": "<<transaction_id>>",
    "response_code": "CONSENT_DENIED",
    "response_message": "Consent Denied"
}
```
<a name="itrRespErrorGatewayTerminated"></a> 
#### 7.4 Event: `itd-gateway-terminated`

This event is fired when user explicitly closed the an ongoing transaction. The respective callback is called and `message` parameter is passed. The `message` is an object with `action` and `payload` property on it.

The `payload` has `id`, `response_code`, and `response_message` properties.

| response_code      | response_message   |
| ------------------ | ------------------ |
| GATEWAY_TERMINATED | Gateway Terminated |

```json
{
    "id": "<<transaction_id>>",
    "response_code": "GATEWAY_TERMINATED",
    "response_message": "Gateway Terminated"
}
```
<a name="itrWebhook"></a>
### 8. Handling Webhook Response

The webhook response will be sent to `webhook_url` provided at the init call. When receiving the webhook response please match the `webhook_security_key` in the header of the request to be the same as the one provided in the init call. If they are not the same **you must abandon the webhook response**.

<a name="itrSuccessWebhookReqBody"></a>
#### 8.1 SUCCESSFUL REQUEST BODY

```json
{
  "id": "<<transaction_id>>",
  "pan_id": "ABCDE1234F",
  "result": {
    "PersonalInfo": {
      "Name": " String ",
      "Father Name": "Sanjay Bansal",
      "AssesseeName": {
        "FirstName": " Rajat ",
        "MiddleName": " ",
        "LastName": " Bansal "
      },
      "PAN": " ABCDE1234F ",
      "DOB": "25-10-1992",
      "Status": "Active",
      "AadhaarCardNo": "**** **** 9876",
      "EmployerCategory": " Government/Public sector undertaking/Pensioners/Others ",
      "Address": {
        "ResidenceNo": " H.NO 89 DWARKA NAGAR COACH FACTORY",
        "ResidenceName": "Rajat Bansal",
        "RoadOrStreet": "Old post office",
        "LocalityOrArea": " DWARKA NGAR",
        "CityOrTownOrDistrict": " BHOPAL",
        "State": " MADHYA PRADESH",
        "PinCode": " 462010",
        "MobileNo": "9999999999",
        "EmailAddress": " abc@gmail.com ",
        "Country": "India"
      }
    },
    "ITR1_IncomeDeductions": {
      "Salary": " Integer ",
      "IncomeFromSal": " 452000",
      "AlwnsNotExempt": " 0 ",
      "PerquisitesValue": " 0 ",
      "ProfitsInSalary": " 0 ",
      "DeductionUs16": " 40000 ",
      "TotalIncomeOfHP": " 0 ",
      "IncomeOthSrc": " 0 ",
      "GrossTotIncome": " 412000",
      "TotalIncome": " 0 ",
      "UsrDeductUndChapVIA": {
        "Section80C": " 0 ",
        "Section80CCC": " 0 ",
        "Section80CCDEmployeeOrSE": " 0 ",
        "Section80CCD1B": " 0 ",
        "Section80CCDEmployer": " 0 ",
        "Section80CCG": " 0 ",
        "Section80DD": " 0 ",
        "Section80DDB": " 0 ",
        "Section80E": " 195000 ",
        "Section80EE": " 0 ",
        "Section80G": " 0 ",
        "Section80GG": " 30000 ",
        "Section80GGA": " 0 ",
        "Section80GGC": " 0 ",
        "Section80RRB": " 0 ",
        "Section80QQB": " 0 ",
        "Section80TTA": " 0 ",
        "Section80U": " 0 ",
        "TotalChapVIADeductions": " 225000",
        "TotalIncome": " 187000 ",
        "Section80DHealthInsPremium": {
          "Sec80DHealthInsurancePremiumUsr": " 0 ",
          "Sec80DMedicalExpenditureUsr": " 0 ",
          "Sec80DPreventiveHealthCheckUpUsr": " 0 "
        }
      }
    },
    "TaxesPaid": {
      "TCS": " 0 ",
      "TDS": " 0 ",
      "OthersInc": {
        "SEC 10-5-LeaveTravelAllowance": " 0 ",
        "SEC 10-14-i": " 0 ",
        "SEC 10-13-A": " 0 "
      },
      "TotalTaxesPaid": " 15000 ",
      "SelfAssessmentTax": " 0 ",
      "AdvanceTax": " 0 "
    },
    "BalTaxPayable": " Integer ",
    "ITR1_TaxComputation": {
      "TotalIntrstPay": " 0 ",
      "Section89": " 0 ",
      "NetTaxLiability": " 0 ",
      "Rebate87A": " 0 ",
      "GrossTaxLiability": " 0 ",
      "TotalTaxPayable": " 0 ",
      "TotTaxPlusIntrstPay": " 0 ",
      "TaxPayableOnRebate": " 0 ",
      "EducationCess": " 0 ",
      "IntrstPay": {
        "IntrstPayUs234A": " 0 ",
        "IntrstPayUs234C": " 0 ",
        "IntrstPayUs234B": " 0 "
      }
    },
    "refund": {
      "RefundDue": "15000",
      "BankAccountDtls": {
        "PriBankDetails": {
          "IFSCCode": " ICIC0000558",
          "BankName": " ICICI BANK LIMITED",
          "BankAccountNo": " 055811234556"
        }
      },
      "employer": {
        "tan": " abcde123456",
        "Name of deductor": "Zoop.one",
        "Salary": " 240000",
        "Tax Deducted": "15000"
      }
    }
  },
  "event": "itr.processed",
  "request_timestamp": "2020-10-12T11:54:21.249Z",
  "response_timestamp": "2020-10-12T11:58:25.689Z"
}
```
<a name="26asSuccessWebhookReqBody"></a>
#### 8.2 26AS SUCCESSFUL REQUEST BODY

```json
{
  "id": "<<transaction_id>>",
  "pan_id": "ABCDE1234F",
  "result": {
    "2020-21": {
      "metadata": {
        "pan": "ABCDE1234F",
        "current status of pan": "Active",
        "financial year": "2020-21",
        "assessment year": "2021-22",
        "name of assessee": "ASSESSEE NAME",
        "address of assessee": "ASSESSEE FULL ADDRESS"
      },
      "accordions": {
        "part_a": {
          "name": "Details of Tax Deducted at Source",
          "entries": [
            {
              "sr_no": 1,
              "deductor_name": "YOUR CO. PRIVATE LIMITED",
              "tan": "ABCDE1234F",
              "total_amount_credited": "100000.00",
              "total_tax_deducted": "1000.00",
              "total_tds_deposited": "1000.00",
              "transactions": [
                {
                  "sr_no": 1,
                  "section": "192",
                  "transaction_date": "30-Jun-2020",
                  "booking_status": "F",
                  "booking_date": "21-Jul-2020",
                  "remarks": "-",
                  "amount_credited": "10000.00",
                  "tax_deducted": "1000.00",
                  "tds_deposited": "1000.00"
                },
                {
                  "sr_no": 2,
                  "section": "192",
                  "transaction_date": "31-May-2020",
                  "booking_status": "F",
                  "booking_date": "21-Jul-2020",
                  "remarks": "-",
                  "amount_credited": "10000.00",
                  "tax_deducted": "1000.00",
                  "tds_deposited": "1000.00"
                },
                {
                  "sr_no": 3,
                  "section": "192",
                  "transaction_date": "30-Apr-2020",
                  "booking_status": "F",
                  "booking_date": "21-Jul-2020",
                  "remarks": "-",
                  "amount_credited": "10000.00",
                  "tax_deducted": "1000.00",
                  "tds_deposited": "1000.00"
                }
              ]
            }
          ]
        },
        "part_a1": {
          "name": "Details of Tax Deducted at Source for 15G / 15H",
          "entries": []
        },
        "part_a2": {
          "name": "Details of Tax Deducted at Source on Sale of Immovable Property u/s 194IA/ TDS on Rent of Property u/s 194IB / TDS on payment to resident contractors and professionals u/s 194M (For Seller/Landlord of Property/Payee of resident contractors and professionals)",
          "entries": []
        },
        "part_b": {
          "name": "Details of Tax Collected at Source",
          "entries": []
        },
        "part_c": {
          "name": "Details of Tax Paid (other than TDS or TCS)",
          "entries": []
        },
        "part_d": {
          "name": "Details of Paid Refund",
          "entries": []
        },
        "part_e": {
          "name": "Details of SFT Transaction",
          "entries": []
        },
        "part_f": {
          "name": "Details of Tax Deducted at Source on Sale of Immovable Property u/s 194IA/ TDS on Rent of Property u/s 194IB /TDS on payment to resident contractors and professionals u/s 194M (For Buyer/Tenant of Property /Payer of resident contractors and professionals)",
          "entries": []
        },
        "part_g": {
          "name": "TDS Defaults* (Processing of Statements)",
          "entries": []
        }
      }
    },
    "2019-20": {
      "metadata": {
        "pan": "ABCDE1234F",
        "current status of pan": "Active",
        "financial year": "2019-20",
        "assessment year": "2020-21",
        "name of assessee": "ASSESSEE NAME",
        "address of assessee": "ASSESSEE ADDRESS"
      },
      "accordions": {
        "part_a": {
          "name": "Details of Tax Deducted at Source",
          "entries": [
            {
              "sr_no": 1,
              "deductor_name": "YOUR CO. PRIVATE LIMITED",
              "tan": "ABCDE1234F",
              "total_amount_credited": "100000.00",
              "total_tax_deducted": "1000.00",
              "total_tds_deposited": "1000.00",
              "transactions": [
                {
                  "sr_no": 1,
                  "section": "192",
                  "transaction_date": "01-Apr-2019",
                  "booking_status": "F",
                  "booking_date": "30-Jun-2020",
                  "remarks": "-",
                  "amount_credited": "100000.00",
                  "tax_deducted": "1000.00",
                  "tds_deposited": "1000.00"
                }
              ]
            }
          ]
        },
        "part_a1": {
          "name": "Details of Tax Deducted at Source for 15G / 15H",
          "entries": []
        },
        "part_a2": {
          "name": "Details of Tax Deducted at Source on Sale of Immovable Property u/s 194IA/ TDS on Rent of Property u/s 194IB / TDS on payment to resident contractors and professionals u/s 194M (For Seller/Landlord of Property/Payee of resident contractors and professionals)",
          "entries": []
        },
        "part_b": {
          "name": "Details of Tax Collected at Source",
          "entries": []
        },
        "part_c": {
          "name": "Details of Tax Paid (other than TDS or TCS)",
          "entries": []
        },
        "part_d": {
          "name": "Details of Paid Refund",
          "entries": []
        },
        "part_e": {
          "name": "Details of SFT Transaction",
          "entries": []
        },
        "part_f": {
          "name": "Details of Tax Deducted at Source on Sale of Immovable Property u/s 194IA/ TDS on Rent of Property u/s 194IB /TDS on payment to resident contractors and professionals u/s 194M (For Buyer/Tenant of Property /Payer of resident contractors and professionals)",
          "entries": []
        },
        "part_g": {
          "name": "TDS Defaults* (Processing of Statements)",
          "entries": []
        }
      }
    }
  },
  "event": "26as.processed",
  "request_timestamp": "2020-10-13T10:48:52.791Z",
  "response_timestamp": "2020-10-13T10:56:34.257Z"
}
```

<a name="itrErrorWebhookReqBody"></a>
#### 8.3 FAILURE REQUEST BODY

```json
{
  "id": "<<transaction_id>>",
  "pan_id": "ABCDE1234F",
  "event": "itr.failed",
  "error": {
    "response_code": "111",
    "response_message": "Internal Error",
    "reason_code": "INTERNAL_ERROR",
    "reason_message": "Something went wrong"
  },
  "request_timestamp": "2020-10-12T16:25:20.409Z",
  "response_timestamp": "2020-10-12T16:28:13.979Z"
}
```

<a name="itrWebhookEventTypes"></a>
#### 8.4 WEBHOOK EVENT TYPES

To differentiate when and for which product you have received the webhook, you
can use the `event` property present in the webhook request. Here is a table
where it's mentioned that which event type you will receive for which product.

If any error occurred in the gateway you will receive `txn.failed` and for
successfully completion on the gateway you will receive `txn.completed`.

| Event          | ITR | 26AS |
| -------------- | --- | ---- |
| txn.completed  | Yes | Yes  |
| txn.failed     | Yes | Yes  |
| itr.failed     | Yes | No   |
| itr.processed  | Yes | No   |
| 26as.failed    | No  | Yes  |
| 26as.processed | No  | Yes  |

<a name="itrErrorCodeWebhook"></a>
#### 8.5 REASON & RESPONSE CODES AND MESSAGES

In case of error you might receive these values in the reason_code, reason_message, response_code, and response_message.

| reason_code             | reason_message                                                      | response_code | response_message              |
| ----------------------- | ------------------------------------------------------------------- | ------------- | ----------------------------- |
| INTERNAL_ERROR          | Something went wrong                                                | 111           | Internal Error                |
| SOURCE_ERROR            | Unable to reach the source at this time. Please try after sometime. | 108           | Source Error                  |
| PAN_NOT_ADDED           | PAN access was removed by customer                                  | 111           | Internal Error                |
| SOURCE_DOWN             | Unable to reach the source at this time. Please try after sometime. | 110           | Source Down                   |
| PARSING_FAILED          | Unable to fetch details from source file                            | 111           | Internal Error                |
| PARSING_FAILED          | Unable to fetch details from source file                            | 111           | Internal Error                |
| ITD_PAN_ALREADY_ADDED   | PAN Number already added with Income Tax Department                 | 106           | Invalid combination of inputs |
| ITD_PAN_NOT_EXIST       | Unable to fetch the PAN Number entered from the Income Tax records  | 101           | No Records Found              |
| ITD_DOB_MISSING         | Date of birth missing                                               | 106           | Invalid combination of inputs |
| ITD_INVALID_DOB_PATTERN | Invalid date of birth pattern                                       | 106           | Invalid combination of inputs |
| ITD_INVALID_DOB         | Date of birth invalid                                               | 106           | Invalid combination of inputs |
| ITD_INVALID_PAN_FORMAT  | PAN format invalid                                                  | 106           | Invalid combination of inputs |
| ITD_PAN_NOT_REGISTERED  | Unable to fetch the PAN Number entered from the Income Tax records  | 101           | No Records Found              |
| ITD_MOBILE_OTP_EMPTY    | Mobile OTP required                                                 | 106           | Invalid combination of inputs |
| ITD_EMAIL_OTP_EMPTY     | Email OTP required                                                  | 106           | Invalid combination of inputs |
| ITD_INVALID_MOBILE_OTP  | Mobile OTP is invalid                                               | 106           | Invalid combination of inputs |
| ITD_INVALID_EMAIL_OTP   | Email OTP is invalid                                                | 106           | Invalid combination of inputs |
| ITD_INCORRECT_OTP       | Email and Mobile OTP invalid                                        | 106           | Invalid combination of inputs |


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
   
   
## Zoop.one E-Sign Gateway (V3 BETA)
 
<a name="esignIntroduction"></a>
### 1. INTRODUCTION   
As a registered ASP under ESP AadhaarAPI provide WEB and Mobile gateway for E-signing of
documents. Using these gateways any organisation on-boarded with us can get their documents
signed digitally by their customer using Aadhaar number based EKYC (performed on ESP portal).
The mode of transaction can be following:
1. Aadhaar Number + OTP (works only on web and android)
2. Aadhaar Number + Fingerprint (works only on windows machine and android)
3. Aadhaar Number + IRIS (works only on Samsung IRIS tablet) 

This solves the problem of wet signing of documents, which is a costly and time-consuming
process. Aadhaar based E-sign is a valid and legal signature as per government regulations and is
accepted widely across India by various organisations.

<a name="esignProcessFlow"></a>
### 2. PROCESS FLOW
1. At your backend server, Initiate the **E-Sign** transaction using a simple Rest API [POST] call. Details of these are available in the documents later. You will require API key and Agency Id for accessing this API which can be generated from the Dashboard.
2. This gateway transaction id then needs to be communicated back to the frontend(in IOS Project) where SDK is to be called.
3. After adding the Framework in your ios project, client has to pass the above generated transaction id to a Framework View Controller, which will open the Framework.
4. Framework will open with a user login after which and the rest of the process till response will be handled by the gateway itself.
5. Once the transaction is successful or failed, appropriate handler function will be called with response JSON, that can be used by the client to process the flow further. 
6. Client will also have a REST API available to pull the status of a gateway transaction from backend.

<a name="esignEndUserFlow"></a>
#### 2.1 END USER FLOW
1. Customer Login [ Phone + OTP ]
2. Document displayed to customer. (Draggable signature option can be turned on via gateway config or
   signPageNumber and coordinates can be fixed during initiation call)
3. Customer chooses Mode of Authentication for performing E-Sign
4. Customer is redirected to ESP’s Auth portal where EKYC is performed after entering either Aadhaar number
   or Virtual Id.
5. After successful EKYC customer is displayed Sign details received and customer’s consent is taken to
   attach signature to the document and share a copy with requesting organization.
6. On success, customer is provided with an option to download the signed file. Also, a download URL is sent
   to customer’s phone number and responseURL which is valid for 48 hours.
7. On failure during request to ESP, customer is displayed an error code and error message. Same error details
   are sent to the responseURL.
8. End Customer can validate the signature on PDF by opening the PDF in acrobat reader and Developer can
   programmatically fetch certificate from PDF to ensure validity of certificate if required.

<a name="esignInit"></a>
### 3. INITIATING A GATEWAY TRANSACTION

To initiate a gateway transaction a REST API call has to be made to backend. This call will generate a Gateway Transaction Id which needs to be passed to the frontend ios-sdk to launch the gateway.

<a name="esignInitUrl"></a>
#### 3.1 INIT URL: 

    URL: POST: {{base_url}}/esign/v3/init

 **{{base_url}}**:
 
 **For Pre-Production Environment:** https://preprod.aadhaarapi.com
 
 **For Production Environment:** https://prod.aadhaarapi.com
 
 **Example Url:** https://preprod.aadhaarapi.com/esign/v2/init
 
<a name="esignRequestHeaders"></a> 
#### 3.2 REQUEST HEADERS: [All Mandatory]

 **qt_api_key** -- API key generated via Dashboard (PREPROD and PROD)
 
 **qt_agency_id** -- Agency ID available from My account section in Dashboard
 
  Content-Type: application/json
  
<a name="esignRequestbody"></a>
#### 3.3 REQUEST BODY PARAMS: [All Mandatory]
    {
    "document": {
      "data”: "<<document data in based64 format>>",
      "type": "<<pdf is only supported for now>>",
      "info”: "<<information about the document – minimum length 15>>",
      "signPageNumber": 1,
    },
    "signerName": "<<name of the signer, must be same as on Aadhaar Card>>",
    "signerCity": "<<city of the signer, preferably as mentioned in Aadhaar>>",
    "purpose": "Purpose of transaction, Mandatory",
    "responseURL":"<<POST[REST] URL to which response is to be sent after the transaction is complete>>",
    } 
  
| Parameters | Description/Values | Checks |
| --- | --- | --- |
| document { | Is an object that provides details of the document. It has below mentioned values in the object |      |
| data | Show file differences that **haven't been** staged | Valid base64 formatted pdf |
| type | Format of the document. For now, only value pdf is supported |      |
| info | Information about the document to be sent to  ESP | Minimum length 15 |
| } |   |   |
| signerName | Name of the signer | Same as in Aadhaar Card |
| signerCity | Place of signing (Current City/As mentioned in Aadhaar) |   |
| purpose | Purpose of document signature | Mandate as per norms. Will be used to generate consent text and logged in DB. |
|responseURL | POST API URL where the Agency receives the response after the e-signing is completed. | A valid POST API URL,  else response back to your server will fail.| 
  
<a name="esignResponseParams"></a>
#### 3.4 RESPONSE PARAMS:
    {
    "id": "<<transactionId>>",
    "docs": [
    "<<document ID>>"
    ],
    "createdAt": "<<timestamp>>",
    "agreement": "this is a static agreement",
    "webhook_security_key": "<<key>>"
    } 

The above generated gateway transactionId has to be made available in your ios project to
open the E-Sign SDK.

<a name="esignAddSDK"></a>
### 4.ADDING FRAMEWORK TO YOUR PROJECT

1. Drag and Drop GatewaySdkFramework to your Xcode project root file

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-04-30+at+5.33.08+PM.png "Optional title")

2. Inside build phases click on Link Binary with Libraries and then click + button at below.

3. Choose GatewaySdkFrameork.framework from the list after that embed framework in general tab inside Frameworks, Libraries and Embedded Content then click on + button add framework again

4. Inside Build Phases one more section must visible in which you can see your embedded framework as shown below in image.

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.06.52+PM.png "Optional title")

<a name="esignConfigureSDK"></a>
### 5. CONFIGURING AND LAUNCHING THE ITR SDK 

<a name="esignImportFiles"></a>
#### 5.1 IMPORT FILES

    import UIKit
    import GatewaySDKFramework
    
Also define constants inside your view controller as mentioned below

    let zoopResult = Notification.Name(rawValue: ZOOP_RESULT)
    var zoopResponse = "No Zoop Result Found"
    
<a name="esignCallSDK"></a> 
#### 5.2 CALL ESIGN SDK FROM THE VIEW CONTROLLER

1. Define one action button in your view controller from which you wan to open framework

        @IBAction func btnCallSDK(_ sender: Any) {
            
            var RequestParams  = ZoopDataObject()
            RequestParams.zoop_gateway_id = "b9180f6b-9100-4a68-9867-ea4a230a1b00"
            
            RequestParams.zoop_result_storyboard = "Main"
            RequestParams.zoop_result_storyboard_id = "ViewController"
            
            RequestParams.zoop_req_type = ZOOP_REQ_ESIGN
            
            let s = UIStoryboard (name: "Main", bundle: nil)
            let qtVc = s.instantiateViewController(withIdentifier: "ZoopGatewayVC") as! ZoopGatewayVC
            qtVc.zoopReqObject = RequestParams;
            self.present(qtVc, animated: true, completion: nil)

        }
   
Params:

zoop_gateway_id: “Transaction Id generated from your backend must be passed here”


2. Add another View Controller in your Main.Storyboard to aligned it with the Framework View Controller named as ZoopGatewayVC shown in image given below

![Alt text](https://static-aadhaarapi.s3.ap-south-1.amazonaws.com/screens/Screenshot+2020-05-01+at+2.45.17+PM.png "Optional title")



 **Note:**  A transaction is valid only for 45 mins after generation.   
 
 <a name="esignHandleSDK"></a> 
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
        
 <a name="esignRespMobile"></a> 
### 6. RESPONSE FORMAT SENT ON MOBILE 
<a name="esignSuccessRespMob"></a>
#### 6.1 SUCCESS JSON RESPONSE FORMAT FOR E-SIGN SUCCESS
    { "id": “<<transaction_Id>>",
    "response_timestamp": "2018-08-01T09:50:06.831Z",
    "transaction_status": 16,
    "signer_consent": "Y",
    "request_medium": “ANDROID",
    "last_document": “true",
    "current_document": 1,
    "documents": [
    { "id": “<<unique-document-id >>”,
     "index": 1,
     "type": “pdf",
     "doc_info": "Sample pdf - sample doc",
     "dynamic_url": “<<links-to-download-document>>”,
     "sign_status": "Y",
     "auth_mode": "O",
     "response_status": "Y",
     "error_code": null,
     "error_message": null,
     "request_timestamp": “2018-08-01T09:50:06.831Z” }, ….
    ], "dynamic_url": “<<links-to-download-document>>”,
     "msg": “<<Esign Message from ESP/Internal>>” }
     
| Response Parameter  | Description/Possible Values |
| ------------- | ------------- |
| id | E-sign Transaction Id  |
| response_timestamp | ESP response timestamp |
| transaction_status | Status Code to track last transaction state. List of codes available in Annexure1. |
| signer_consent | Y/N - Will be N if user denies consent |
| request_medium | WEB/ANDROID - Platform from which esign transaction was performed |
| last_document | true/false- true if document is last else false |
| documents[ | Is an object that provides details of the single/multiple documents in array. It has below mentioned values in the object|
| { id | Document id |
| index | Index of this document |
| doc_info | Info of this document |
| type | Format of the document. For now, only value pdf is supported |
| dynamic_url | Url to download the signed pdf |
| sign_status | Y/N - if document is signed by the user or not |
| auth_mode | O/F/I – OTP, Fingerprint, Iris |
| response_status | Y/N - if ESP response was success or not. |
| error_code | Error code from ESP/Internal (available only in case of error) |
| error_message | Error message from ESP/Internal (available only in case of error) |
| request_timestamp } | Time at which the request was sent to ESP |
| ] dynamic_url | Url to download the signed pdf of the current document |
| message | Message from ESP/Internal |

<a name="esignErrorRespMob"></a>
#### 6.2 ERROR JSON RESPONSE FORMAT FOR E_SIGN ERROR 
    { "id": “<<transaction id>>",
    "signer_name": “Abc Name",
    "signer_city": “xyz city",
    "current_document": 1,
    "user_notified": "N",
    "purpose": "Development and testing purpose",
    "transaction_status": 17,
    "signer_consent": "Y",
    "request_medium": "M",
    "signed_document_count": 0,
    "error_code": "ESP-123",
    "error_message": “<<Error Message>>","response_status": "N",
    "response_timestamp": “2018-08-01T12:09:48.500Z”,
    "msg": "Error Code :ESP-123 (<<Error Message>>)” } 
    
|Response Parameter| Description/Possible Values|
| ------------- | ------------- |
|id |E-sign Transaction Id|
|signer_name| Name of signer as provided in INIT call.|
|signer_city| City of signer as provided in INIT call.|
|current_document| Current document number|
|signer_consent| Y/N - Will be N if user denies consent|
|request_medium |WEB/M - Platform from which esign transaction was performed|
|Purpose| Purpose for signing the document |
|user_notified| Y/N - User notified of the E-sign success and sent a copy of document to download.|
|transaction_status| Status Code to track last transaction state. List of codes available in Annexure1.|
|signed_document_count| count of the number of documents signed|
|response_status| Y/N - if ESP response was success or not.|
|error_code| Error code from ESP/Internal (available only in case of error)|
|error_message| Error message from ESP/Internal (available only in case of error)|
|response_timestamp| ESP response timestamp.|
|msg|Error code and error message|

### Annexure 1 – Transaction Status

INITIATED : 1,

INITIATION_FAILED: 2,

OTP_SENT: 3,

OTP_FAILED: 4,

SUCCESSFUL: 5,

FAILED: 6,

OTP_MISMATCH: 7,

FP_MISMATCH: 8,

EXPIRED: 9,

CONSENT_DENIED: 10,

TERMINATED_BY_USER: 11,

OTP_REQUEST_LIMIT_CROSSED: 12,

OTP_FAILURE_LIMIT_CROSSED: 20,

OTP_EXPIRED: 13,

LOGIN_SUCCESS: 14,

ESP_REQ_INITIATED: 15,

ESP_REQ_SUCCESS: 16,

ESP_REQ_FAILED: 17,

USER_NOTIFIED: 18,

TRANSACTION_LIMIT_CROSSED: 19 

<a name="esignErrorRespGateway"></a>
#### 6.3 ERROR JSON RESPONSE FORMAT FOR GATEWAY ERROR 
    {"statusCode": 422,
     "message": "Maximum OTP Tries Reached, Transaction Failed” } 
|Response Parameter| Description/Possible Values|
| ---------- | ----------- |
|statusCode| Error code from gateway/sdk|
|message| Error message from gateway/sdk|

<a name="esignRespInit"></a>
### 7. RESPONSE FORMAT SENT ON RESPONSE_URL(ADDED IN INIT API CALL)
<a name="esignRespInitSuccess"></a>
#### 7.1 SUCCESS JSON RESPONSE FORMAT FOR E-SIGN SUCCESS
    {
    "id": “<<transaction_Id>>",
    "response_timestamp": "2018-08-01T09:50:06.831Z",
    "transaction_status": 16,
    "signer_consent": "Y",
    "request_medium": “M",
    "last_document": “true",
    "current_document": 1,
    "documents": [
     { "id": “<<unique-document-id >>”,
       "index": 1,
       "type": “pdf",
       "doc_info": "Sample pdf - sample doc",
       "dynamic_url": “<<links-to-download-document>>”,
       "sign_status": "Y",
       "auth_mode": "O",
       "response_status": "Y",
       "error_code": null,
       "error_message": null,
       "request_timestamp": “2018-08-01T09:50:06.831Z"
     }, ….]
    } 
|Response| Parameter Description/Possible Values|
|------|-----|
|id| E-sign Transaction Id|
|response_timestamp| ESP response timestamp.|
|transaction_status| Status Code to track last transaction state. List of codes available in Annexure1.|
|signer_consent| Y/N - Will be N if user denies consent|
|request_medium| W for WEB/ M for Mobile - Platform from which esign transaction was performed|
|last_document| true/false- true if document is last else false|
|documents [| Is an object that provides details of the single/multiple documents in array. It has below mentioned values in the object|
|{ id| Document id|
|index| Index of this document|
|doc_info| Info of this document
|type| Format of the document. For now, only value pdf is supported|
|dynamic_url |Url to download the signed pdf|
|sign_status| Y/N - if document is signed by the user or not|
|auth_mode| O/F/I – OTP, Fingerprint, Iris|
|response_status| Y/N - if ESP response was success or not.|
|error_message| Error message from ESP/Internal (available only in case of error)|
|request_timestamp }| Time at which the request was sent to ESP|
|]|  |

<a name="esignRespInitError"></a>
#### 7.2 ERROR JSON RESPONSE FORMAT FOR E_SIGN ERROR 
    { "id": “<<transaction_Id>>", "response_timestamp":
    "2018-08-03T09:14:21.805Z", "transaction_status":
    17,
    "signer_consent": "Y",
    "request_medium": "M",
    "current_document": 1,
    "documents": [
      { "id": “<<unique-document-id >>”,
       "index": 1,
       "doc_info": "Sample pdf - sample doc",
       "type": "pdf",
       "dynamic_url": “<<links-to-download-document>>”,
       "sign_status": "N",
       "auth_mode": "O",
       "response_status": "N",
       "error_code": “<<Error code if
       any>>”,
       "error_message": “<<Error message if any>>”,
       "request_timestamp":
       "2018-08-03T09:14:21.805Z"
       } ]…
    }
|Response| Parameter Description/Possible Values|
|-----|-----|
|id| E-sign Transaction Id|
|response_timestamp| ESP response timestamp.|
|current_document| Current document number|
|signer_consent| Y/N - Will be N if user denies consent|
|request_medium| WEB/ANDROID - Platform from which esign transaction was performed|
|transaction_status| Status Code to track last transaction state. List of codes available in Annexure1.|
|documents [| Is an object that provides details of the single/multiple documents in array. It has below mentioned values in the object|
|{ id| Document id|
|index|Index of this document|
|doc_info|Info of this document|
|type| Format of the document. For now, only value pdf is supported|
|dynamic_url| Url to download the signed pdf|
|sign_status| Y/N - if document is signed by the user or not|
|auth_mode| O/F/I – OTP, Fingerprint, Iris|
|response_status| Y/N - if ESP response was success or not.|
|error_code| Error code from ESP/Internal (available only in case of error)|
|error_message| Error message from ESP/Internal (available only in case of error)|
|request_timestamp }| Time at which the request was sent to ESP|
|]|    |

<a name="esignBiometric"></a>
### 8. BIOMETRIC DEVICES SETUP 

For bio transactions UIDAI has made use of RD service mandatory and all devices has to be
registered with device vendor’s RD management server before performing biometric based
transactions. Also for devices to work in windows RD services has to be setup in the
windows machine and for Android devices to work, RD service APPs has to be installed from
Play-store from specific device vendors.

In order to perform the E-sign transaction via biometric modes (i.e. Fingerprint and Iris).

The device must be registered with their respective device vendor’s RD management server
and Application from play store or SDK provided by some device vendor(provided incase of
some iris devices) must be installed in your Android Device before performing E-sign
transaction through biometric mode.

In case of RD service not working with the Demo apps. please contact the device vendor
support team. Once these demo apps are working. You will be able to use these devices with
our SDKs. 

#### List of supported Biometric Devices
<a name="esignStatus"></a>
### 9. PULLING TRANSACTION STATUS AT BACKEND 

In case the response JSON is lost at frontend, there is an option to pull the transaction status from
backend using the same Esign Transaction Id. 
#### 9.1 URL
    GET {{base_url}}/esign/v3/<<esign_transaction_id>>/fetch/ 
    
<a name="esignStatusResp"></a>    
#### 9.2 RESPONSE PARAMS:
|Sr. No.| Device Manufacturer| Model|
|----|----|----|
|1|Morpho| MSO 1300 E; MSO 1300 E2; MSO 1300 E3|
|2|Secugen| Hamster Pro HU20|
|3|Mantra| %MFS100 |
|4|Startek| FM220U|
|5| Evolute| Falcon Identi5 Leopard|
|6| Cogent| CSD 200|
|7| Precision| PB510|
|8| Freedom| ABB-100-NIR|
|9| Samsung Galaxy IRIS Tab| SM-T116IR|

    {
    "id": “<<transaction id>>",
    "signer_consent": "Y",
    "response_url": "<<POST[REST] URL to which response is to be sent after the transaction is
    complete>>",
    "current_document": 1,
    "signed_document_count": 1,
    "public_ip": "223.196.31.21",
    "env": 1,
    "signer_name": "Demo Name",
    "signer_city": "Demo City",
    "purpose": "Development and testing purpose",
    "transaction_status": 5,
    "request_medium": "M",
    "transaction_attempts": 1,
    "otp_attempts": 1,
    "otp_failures": 0,
    "user_notified": "Y", 
    "response_to_agency": "Y",
    "createdAt": "2018-08-03T08:43:39.751Z",
    "documents": [
      {
       "id": “<<document id>>",
       "index": 1,
       "doc_info": "Sample pdf - sample doc",
       "type": "pdf",
       "dynamic_url": “<<Link to download this pdf>>",
       "sign_status": "Y",
       "auth_mode": "O",
       "response_status": "Y",
       "error_code": “<<error code if any>>”,
       "error_message": “<<error message if any>>”,
       "request_timestamp": “2018-08-03T08:47:50.661Z"
      }
     ]
    }
|Response Parameter| Description/Possible Values|
|----|----|
|id| E-sign Transaction Id|
|request_version| Esign version – currently 2.0|
|signer_consent| Y/N - Will be N if user denies consent|
|signed_document_count| count of the number of documents signed|
|response_url| URL to which the response was sent on completion|
|current_document| Current document number}
|request_medium| W for Web/ M for Mobile - Platform from which esign transaction was performed|
|public_ip| End user IP using which the transaction was performed.|
|env| 1/2 – 1(preproduction) & 2 (production)|
|signer_name| Name of signer as provided in INIT call.|
|purpose| Purpose for signing the document|
|signer_city| City of signer as provided in INIT call.|
|transaction_status| Status Code to track last transaction state. List of codes available in Annexure1.|
|transaction_attempts| Transaction attempt count. Currently allowed only once.|
|otp_attempts| Number of times login OTP was requested|
|otp_failures| Number of times login failed due to wrong OTP|
|user_notified| Y/N - User notified of the E-sign success and sent a copy of document to download.|
|response_to_agency| Y/N - Response sent to responseURL was success or failure.|
|createdAt| Transaction initiated at - YYYY-MM-DDTHH:MM:SS.122Z|
|documents[| Is an object that provides details of the single/multiple documents in array. It has below mentioned values in the object|
|{ id|Document id|
|index|Index of document|
|doc_info|Info of the document|
|type| Format of the document. For now, only value pdf is supported|
|dynamic_url| Url to download the signed pdf|
|sign_status| Y/N - if document is signed by the user or not|
|auth_mode| O/F/I – OTP, Fingerprint, Iris|
|response_status| Y/N - if ESP response was success or not.|
|error_code| Error code from ESP/Internal (available only in case of error)|
|error_message| Error message from ESP/Internal (available only in case of error)|
|request_timestamp } ,.. ]| Time at which the request was sent to ESP| 
  
In case you are facing any issues with integration please open a ticket on our [support portal](https://aadhaarapi.freshdesk.com/support/home)
        
