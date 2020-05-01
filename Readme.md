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
            "Name": "<<NAME>>",
            "PAN": "<<PAN_NUMBER>>",
            "DOB": "<<DATE_OF_BIRTH>>",
            "Address": {
              "ResidenceName": "",
              "LocalityOrArea": "<<AREA>>",
              "RoadOrStreet": "",
              "ResidenceNo": "<<RESIDENCE_NO>>",
              "PinCode": "<<PIN>>",
              "CityOrTownOrDistrict": "<<CITY_OR_TOWN>>",
              "MobileNo": "91 - <<PHONE>>",
              "State": "<<STATE>>",
              "EmailAddress": "<<EMAIL>>"
            },
            "AadhaarCardNo": "<<AADHAAR_NUMBER>>",
            "EmployerCategory": "Not Applicable(eg. Family pension etc)"
          },
          "ITR1_IncomeDeductions": {
            "ProfitsInSalary": "0",
            "Salary": "<<SALARY>>",
            "AlwnsNotExempt": "0",
            "IncomeFromSal": "<<SALARY>>",
            "UsrDeductUndChapVIA": {
              "Section80DD": "0\r0",
              "TotalChapVIADeductions": "0",
              "Section80GGA": "0",
              "Section80CCG": "0",
              "Section80GG": "0",
              "Section80CCDEmployer": "0",
              "Section80CCD1B": "0",
              "Section80GGC": "0",
              "Section80TTA": "0",
              "Section80DHealthInsPremium": {
                "Sec80DHealthInsurancePremiumUsr": "0\r0\r0"
              },
              "Section80CCDEmployeeOrSE": "0",
              "Section80E": "0",
              "Section80C": "0",
              "Section80CCC": "0",
              "Section80EE": "0"
            },
            "IncomeOthSrc": "0",
            "GrossTotIncome": "0",
            "TotalIncomeOfHP": "0",
            "TotalIncome": "0",
            "PerquisitesValue": "0"
          },
          "ITR1_TaxComputation": {
            "TotalTaxPayable": "0",
            "Rebate87A": "0",
            "EducationCess": "0",
            "GrossTaxLiability": "0",
            "Section89": "0",
            "NetTaxLiability": "0",
            "IntrstPay": {
              "IntrstPayUs234A": "0",
              "IntrstPayUs234C": "0\r0\r0"
            },
            "TotalIntrstPay": "0"
          },
          "TaxPaid": {
            "TaxesPaid": {
              "TDS": "0\r0\r0\r0",
              "TotalTaxesPaid": "0"
            },
            "BalTaxPayable": "0"
          },
          "refund": {
            "RefundDue": "0",
            "BankAccountDtls": {
              "PriBankDetails": {
                "IFSCCode": "<<IFSC>>",
                "BankName": "<<BANK_NAME>>",
                "BankAccountNo": "<<ACCOUNT_NUMBER>>"
              }
            }
          }
        }
      },
      {
        "2017-18": {
          "ITR1FORM:ITR1": {
            "ITRForm:FilingStatus": {
              "ITRForm:ReturnFileSec": "11",
              "ITRForm:ReturnType": "O",
              "ITRForm:ResidentialStatus": "RES",
              "ITRForm:PortugeseCC5A": "N"
            },
            "ITRForm:Verification": {
              "ITRForm:Declaration": {
                "ITRForm:AssesseeVerName": "<<FULL_NAME>>",
                "ITRForm:FatherName": "<<FATHER_NAME>>",
                "ITRForm:AssesseeVerPAN": "<<PAN_NUMBER>>"
              },
              "ITRForm:Place": "<<CITY>>",
              "ITRForm:Date": "<<ITR_DATE>>"
            },
            "ITR1FORM:TaxExmpIntInc": "0",
            "ITRForm:PersonalInfo": {
              "ITRForm:AssesseeName": {
                "ITRForm:FirstName": "<<FIRST_NAME>>",
                "ITRForm:SurNameOrOrgName": "<<LAST_NAME>>"
              },
              "ITRForm:PAN": "<<PAN_NUMBER>>",
              "ITRForm:Address": {
                "ITRForm:ResidenceNo": "<<RESIDENCE>>",
                "ITRForm:LocalityOrArea": "<<AREA>>",
                "ITRForm:CityOrTownOrDistrict": "<<CITY>>",
                "ITRForm:StateCode": "<<STATE_CODE>>",
                "ITRForm:CountryCode": "<<COUNTRY_CODE>>",
                "ITRForm:PinCode": "<<PIN>>",
                "ITRForm:MobileNo": "<<PHONE>>",
                "ITRForm:EmailAddress": "<<EMAIL>>"
              },
              "ITRForm:DOB": "<<DOB>>",
              "ITRForm:EmployerCategory": "NA",
              "ITRForm:AadhaarCardNo": "<<AADHAAR_NUMBER>>"
            },
            "ITRForm:TaxPaid": {
              "ITRForm:TaxesPaid": {
                "ITRForm:AdvanceTax": "0",
                "ITRForm:TDS": "0",
                "ITRForm:TCS": "0",
                "ITRForm:SelfAssessmentTax": "0",
                "ITRForm:TotalTaxesPaid": "0",
                "ITRForm:ExcIncSec1038": "0",
                "ITRForm:ExcIncSec1034": "0"
              },
              "ITRForm:BalTaxPayable": "0"
            },
            "ITRForm:ITR1_IncomeDeductions": {
              "ITRForm:IncomeFromSal": "0",
              "ITRForm:TotalIncomeOfHP": "0",
              "ITRForm:IncomeOthSrc": "0",
              "ITRForm:GrossTotIncome": "0",
              "ITRForm:UsrDeductUndChapVIA": {
                "ITRForm:Section80CCD1B": "0",
                "ITRForm:Section80CCG": "0",
                "ITRForm:Section80E": "0",
                "ITRForm:Section80DD": "0",
                "ITRForm:Section80GGC": "0",
                "ITRForm:Section80GGA": "0",
                "ITRForm:Section80DDB": "0",
                "ITRForm:Section80C": "0",
                "ITRForm:Section80EE": "0",
                "ITRForm:Section80G": "0",
                "ITRForm:Section80RRB": "0",
                "ITRForm:Section80CCDEmployer": "0",
                "ITRForm:Section80CCC": "0",
                "ITRForm:Section80D": "0",
                "ITRForm:Section80GG": "0",
                "ITRForm:Section80CCDEmployeeOrSE": "0",
                "ITRForm:Section80QQB": "0",
                "ITRForm:Section80TTA": "0",
                "ITRForm:TotalChapVIADeductions": "0",
                "ITRForm:Section80U": "0"
              },
              "ITRForm:DeductUndChapVIA": {
                "ITRForm:Section80CCD1B": "0",
                "ITRForm:Section80CCG": "0",
                "ITRForm:Section80E": "0",
                "ITRForm:Section80DD": "0",
                "ITRForm:Section80GGC": "0",
                "ITRForm:Section80GGA": "0",
                "ITRForm:Section80DDB": "0",
                "ITRForm:Section80C": "0",
                "ITRForm:Section80EE": "0",
                "ITRForm:Section80G": "0",
                "ITRForm:Section80RRB": "0",
                "ITRForm:Section80CCDEmployer": "0",
                "ITRForm:Section80CCC": "0",
                "ITRForm:Section80D": "0",
                "ITRForm:Section80GG": "0",
                "ITRForm:Section80CCDEmployeeOrSE": "0",
                "ITRForm:Section80QQB": "0",
                "ITRForm:Section80TTA": "0",
                "ITRForm:TotalChapVIADeductions": "0",
                "ITRForm:Section80U": "0"
              },
              "ITRForm:TotalIncome": "0"
            },
            "ITRForm:ITR1_TaxComputation": {
              "ITRForm:IntrstPay": {
                "ITRForm:IntrstPayUs234A": "0",
                "ITRForm:IntrstPayUs234B": "0",
                "ITRForm:IntrstPayUs234C": "0"
              },
              "ITRForm:TaxPayableOnRebate": "0",
              "ITRForm:NetTaxLiability": "0",
              "ITRForm:GrossTaxLiability": "0",
              "ITRForm:Section89": "0",
              "ITRForm:TotalTaxPayable": "0",
              "ITRForm:EducationCess": "0",
              "ITRForm:TotalIntrstPay": "0",
              "ITRForm:TotTaxPlusIntrstPay": "0",
              "ITRForm:Rebate87A": "0"
            },
            "ITRForm:Refund": {
              "ITRForm:RefundDue": "0",
              "ITRForm:BankAccountDtls": {
                "ITRForm:BankDtlsFlag": "Y",
                "ITRForm:PriBankDetails": {
                  "ITRForm:IFSCCode": "<<IFSC_CODE>>",
                  "ITRForm:BankName": "<<BANK_NAME>>",
                  "ITRForm:BankAccountNo": "<<ACCOUNT_NUMBER>>",
                  "ITRForm:CashDeposited": "<<CASH_DEPOSIT>>"
                },
                "ITRForm:AddtnlBankDetails": {
                  "ITRForm:IFSCCode": "<<IFSC_CODE>>",
                  "ITRForm:BankName": "<<BANK_NAME>>",
                  "ITRForm:BankAccountNo": "<<ACCOUNT_NUMBER>>",
                  "ITRForm:CashDeposited": "0"
                }
              }
            },
            "ITRForm:CreationInfo": {
              "ITRForm:SWVersionNo": "1.0",
              "ITRForm:SWCreatedBy": "SW10001090",
              "ITRForm:XMLCreatedBy": "SW10001090",
              "ITRForm:XMLCreationDate": "<<ITR_DATE>>",
              "ITRForm:IntermediaryCity": "<<IntermediaryCity>>",
              "ITRForm:Digest": "<<DIGEST>>"
            },
            "ITRForm:Form_ITR1": {
              "ITRForm:FormName": "ITR-1",
              "ITRForm:Description": "For Indls having Income from Salary, Pension, family pension and Interest",
              "ITRForm:AssessmentYear": "2017",
              "ITRForm:SchemaVer": "Ver1.0",
              "ITRForm:FormVer": "Ver1.0"
            }
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


In case you are facing any issues with integration please open a ticket on our [support portal](https://aadhaarapi.freshdesk.com/support/home)
        
