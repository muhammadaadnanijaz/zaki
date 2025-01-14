import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';
import 'package:http/http.dart' as http;
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Models/BalanceModel.dart';
import 'package:zaki/Models/CardInformationModel.dart';
import 'package:zaki/Models/CardModel.dart';
import 'package:zaki/Models/PaymentAccessTokenModel.dart';
import 'package:zaki/Models/PaymentModel.dart';
import 'package:zaki/Payment/PayFortConstants.dart';

import '../Constants/AppConstants.dart';
import '../Models/CardProductModel.dart';
import '../Models/FundingSourceModel.dart';
import '../Models/TransactionModel.dart';
class UserAddedCard {
	String? token;
	bool? active;
	String? gender;
	String? firstName;
	String? lastName;
	String? email;
	String? address1;
	String? city;
	String ?country;
	bool? usesParentAccount;
	bool? corporateCardHolder;
	String? password;
	String? createdTime;
	String? lastModifiedTime;
	Metadata? metadata;
	String? accountHolderGroupToken;
	String? status;

	UserAddedCard({this.token, this.active, this.gender, this.firstName, this.lastName, this.email, this.address1, this.city, this.country, this.usesParentAccount, this.corporateCardHolder, this.password, this.createdTime, this.lastModifiedTime, this.metadata, this.accountHolderGroupToken, this.status});

	UserAddedCard.fromJson(Map<String, dynamic> json) {
		token = json['token'];
		active = json['active'];
		gender = json['gender'];
		firstName = json['first_name'];
		lastName = json['last_name'];
		email = json['email'];
		address1 = json['address1'];
		city = json['city'];
		country = json['country'];
		usesParentAccount = json['uses_parent_account'];
		corporateCardHolder = json['corporate_card_holder'];
		password = json['password'];
		createdTime = json['created_time'];
		lastModifiedTime = json['last_modified_time'];
		metadata = (json['metadata'] != null ? new Metadata.fromJson(json['metadata']) : null);
		accountHolderGroupToken = json['account_holder_group_token'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['token'] = this.token;
		data['active'] = this.active;
		data['gender'] = this.gender;
		data['first_name'] = this.firstName;
		data['last_name'] = this.lastName;
		data['email'] = this.email;
		data['address1'] = this.address1;
		data['city'] = this.city;
		data['country'] = this.country;
		data['uses_parent_account'] = this.usesParentAccount;
		data['corporate_card_holder'] = this.corporateCardHolder;
		data['password'] = this.password;
		data['created_time'] = this.createdTime;
		data['last_modified_time'] = this.lastModifiedTime;
		if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
		data['account_holder_group_token'] = this.accountHolderGroupToken;
		data['status'] = this.status;
		return data;
	}
}

class Metadata {


	// Metadata({});

	Metadata.fromJson(Map<String, dynamic> json) {
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}


class ApiConstants {
  static final String MARQATA_AUTH_KEY = 'YTkwNDA3NzItOTJkOS00NThlLTkyOTEtMjYzMTlhZmZlZjU0OjkxYzdiZDVmLWI1MjgtNGQ1ZC1hMGQ2LWRiZDZmN2NhMTU1OQ==';
  static final String MARQATA_BASE_URL = 'https://sandbox-api.marqeta.com/v3/';
  static final String ADD_USER_URL = 'users';
  static final String CARD_PRODUCT = 'cardproducts';
  static final String FUNDING_SOURCE = 'fundingsources/program';
  static final String ADD_TRANSACTIONS_gpaorders = 'gpaorders';
  static final String PAY = 'peertransfers';
  static final String CARDS = 'cards';
  static final String CARD_TRANSACTIONS = 'cardtransitions';
  static final String TRANSACTIONS = 'transactions';
  static final String BALANCE = 'balances/';
  static final String VELOCITY_CONTROL_SPEND_LIMIT = 'velocitycontrols';
  
  static Map<String, String> headers(){
    return <String, String>{
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Basic ${ApiConstants.MARQATA_AUTH_KEY}'
            };
  }

}

class CreaditCardApi {
  Future<String?> createUserForCard({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? password,
    String? city,
    String? country,
    String? address1,
    String? phoneNumber,
    String? postalCode,
    String? state,
    bool? useParentAccount,
    String? countryCode,
    String? countryName
  }) async {

    
  //We can call another API for Different Countrt
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.ADD_USER_URL}'),
            headers: ApiConstants.headers() ,
            body: jsonEncode(
              // countryName==AppConstants.COUNTRY_PAKISTAN?
              // {
              //   'active': true,
              //   'gender': gender,
              //   'first_name': firstName,
              //   'last_name': lastName,
              // } :
              {
              'active': true,
              'gender': gender,
              'first_name': firstName,
              'last_name': lastName,
              // 'email': email,
              // 'password':password,
              'address1': address1,
              'city': city,
              'country': country,
              'uses_parent_account': useParentAccount
              }
             )
          ).whenComplete(() {
     print('sendOrderCollected(): message sent');
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
    logMethod(title: 'User Registered', message: data.body);
    var model = UserAddedCard.fromJson(json.decode(data.body));
    // if(model.token!=null){
    //   createCardProduct(userToken: model.token, address1: address1, city: city, country: country, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, postalCode: postalCode, state: state);
    // }
    if(data.statusCode==200){
      //We need to code
    } else{
      
    }
    return model.token;
  }
  Future<String?> createCardProduct({
    String? userToken,
    String? firstName,
    String? lastName,
    String? city,
    String? country,
    String? address1,
    String? phoneNumber,
    String? postalCode,
    String? state

  }) async {
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.CARD_PRODUCT}'),
            headers: ApiConstants.headers() ,
            body: jsonEncode({
              ////
              "name": "$firstName $lastName",
              "start_date": "2019-08-24",
                "config": {
                "fulfillment": { 
                  "shipping": {
                      "recipient_address":{
                      "address1": "$address1",
                      "city": "$city",
                      "country": "$country",
                      "first_name": "$firstName",
                      "last_name": "$lastName",
                      "postal_code":"$postalCode",
                      "phone":"$phoneNumber",
                      "state":"$state"
                      },
                      "return_address":{
                      "address1": "$address1",
                      "city": "$city",
                      "country": "$country"
                    }
                    }
                    
                }
              }
/////
              }
             )
          ).whenComplete(() {
     print('sendOrderCollected(): message sent');
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
    logMethod(title: 'Card Product Created', message: data.body);
    final cardProductModel = cardProductModelFromMap(data.body);

    if(cardProductModel.token!=''){
      logMethod(title: 'Card product Token::', message:cardProductModel.token);
      
    }
    return cardProductModel.token;
  }
  Future<String?> card({
    String? cardProductToken,
    String? userToken,
  }) async {
    logMethod(title: 'Card product Token in card', message: '${cardProductToken.toString()} and user Token: $userToken');
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.CARDS}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              // countryName==AppConstants.COUNTRY_PAKISTAN?
              // {
              //   "user_token": "$userToken"
              // } :
              {
                  "card_product_token": "$cardProductToken",
                  "user_token": "$userToken"
              }
              
             )
          ).whenComplete(() {
     print('sendOrderCollected(): message sent');
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
    logMethod(title: 'Card Model', message: data.body);
    var model = CardModel.fromJson(json.decode(data.body));
    return model.token;
  }

  Future<CardInformationModel> showCardInformation({String? cardToken}) async{
    // 
    logMethod(title: 'Card Token:', message: cardToken);
    var data = await http.get(Uri.parse('${ApiConstants.MARQATA_BASE_URL}cards/$cardToken/showpan'),
            headers: ApiConstants.headers(),
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Card Full detail:', message: data.body);
    // ignore: unused_local_variable
    final cardInformationModel = cardInformationModelFromMap(data.body);
    // appConstants!.updateTransactionList(cardTransationModel);
    // logMethod(title: 'Card TransactionsFrom Model:', message: appConstants.cardTransactionList.count.toString());
    // cardTransationModel.data.first.gpaOrder.
    // return cardTransationModel;
    return cardInformationModel;
  }


   Future<String?> updateCardStatus({
    String? cardToken,
    String? status,
  }) async {
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.CARD_TRANSACTIONS}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              // countryName==AppConstants.COUNTRY_PAKISTAN?
              // {
              //     "card_token": "$cardToken",
              //     "state": "$status"
              // } :
              {
                  "card_token": "$cardToken",
                  "channel": "API",
                  "state": "$status",
                  "reason_code": "19"

              }
              
             )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Card Status:', message: data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    return data.body;
  }

 Future<String?> spendControll({
    String? mcc,
    String? amount,
    String? userToken,
    String? countryName
  }) async {
    logMethod(title: 'Amount and Add New Spend Controll', message: amount.toString());
    // return '';
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${countryName==AppConstants.COUNTRY_PAKISTAN?ApiConstants.VELOCITY_CONTROL_SPEND_LIMIT:ApiConstants.VELOCITY_CONTROL_SPEND_LIMIT}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              countryName==AppConstants.COUNTRY_PAKISTAN?
              {
              "currency_code": "USD",
              "amount_limit": int.parse(amount.toString()),
              } :
              {
              "currency_code": "USD",
              "amount_limit": int.parse(amount.toString()),
              "velocity_window": "MONTH",
              "association":{
                "user_token" : "$userToken"
                }
            }
          )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Card Max Transaction Setted Up', message: data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    jsonDecode(data.body)['token'];
    return jsonDecode(data.body)['token'];
  }

   Future<String?> upDateSpendControllPerTransaction({
    String? mcc,
    String? amount,
    String? userToken,
    String? maxSpendControllToken

  }) async {
    logMethod(title: 'Amount and Update', message: amount.toString());
    // return '';
   var data = await http.put(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.VELOCITY_CONTROL_SPEND_LIMIT}/${maxSpendControllToken}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              {
              "currency_code": "USD",
              "amount_limit": int.parse(amount.toString()),
              "velocity_window": "MONTH",
              "association":{
                "user_token" : "$userToken"
                }
            }
          )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Card Max Transaction Setted Up', message: data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    jsonDecode(data.body)['token'];
    return jsonDecode(data.body)['token'];
  }

    Future<String?> addCardSpendingLimits(
      {String? userId,
      String? parentId,
      int? amount,
      String? mcc,
      }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(AppConstants.SpendLimits);
    await users
        .doc(parentId)
        .collection('Debit_Card_Vendor')
        // .doc(userId)
        .add({
      AppConstants.SpendL_user_id: userId,
      AppConstants.SpendL_parent_id: parentId,
      'amount_limit': amount,
      'amount_limit_remain': amount,
      AppConstants.SpendL_CreatedAt: DateTime.now()
    });
    return 'updated';
  }

   Future<String?> createFundingSource({
    String? name,
    String? userToken
  }) async {

    logMethod(title: 'URL is ---->>>', message: '${ApiConstants.MARQATA_BASE_URL}${ApiConstants.FUNDING_SOURCE}');
   
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.FUNDING_SOURCE}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              {
                 "name":'Adnan',
                 "token":userToken
              }
              
             )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Funding Source Created Transaction:', message: data.body);
    final fundingSourceModel = fundingSourceModelFromMap(data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    return fundingSourceModel.token;
  }
  
  Future<String?> addAmountFromCardToBank({
    String? amount,
    String? userToken,
    String? name,
    required String? tags
  }) async {
    logMethod(title: 'UserToken ---->>>', message: userToken);
   String? sourceToken =  await createFundingSource(name: name, userToken: userToken);
  //  return'';
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.ADD_TRANSACTIONS_gpaorders}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              {
                "amount": double.parse(amount!),
                "currency_code": "USD",
                "funding_source_token": sourceToken,
                "user_token":userToken,
                "tags":tags
              }
              
             )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Card Transaction From Card To Bank:', message: data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    return null;
  }


Future<CardTransation>? cardTransaction(
      {String? userToken,
      String? actingUserToken,
      AppConstants? appConstants,
      int? startIndex,
      int? limit,

      }) async {
   var data = await http.get(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.TRANSACTIONS}?user_token=$userToken&acting_user_token=$actingUserToken&start_index=$startIndex&limit=$limit'),
            headers: ApiConstants.headers(),
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    // logMethod(title: 'Card Transactions:', message: data.body);
    // ignore: unused_local_variable
    final cardTransationModel = cardTransationFromMap(data.body);
    appConstants!.updateTransactionList(cardTransationModel);
    // logMethod(title: 'Card TransactionsFrom Model:', message: appConstants.cardTransactionList.count.toString());
    // cardTransationModel.data.first.gpaOrder.
    return cardTransationModel;
  }

Future<String?> addTransactionsToDb(
      {String? userId,
      String? parentId,
      int? type,
      String? identifier,
      String? currencyCode,
      String? token,
      double? amount, 
      DateTime? createdAt,
      DateTime? last_modified_time,
      String? transaction_token,
      
      }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(AppConstants.SpendLimits);
    await users
        .doc(parentId)
        .collection(AppConstants.Transaction)
        .doc(userId)
        .set({
      AppConstants.SpendL_user_id: userId,
      AppConstants.SpendL_parent_id: parentId,
      'amount_limit': amount,
      'amount_limit_remain': amount,
      AppConstants.SpendL_CreatedAt: DateTime.now()
    });
    return 'updated';
  }

    Future<String?> moveMoney({
    String? amount,
    String? senderUserToken,
    String? receiverUserToken,
    String? name,
    String? memo,
    required String? tags
  }) async {
    logMethod(title: 'UserToken Move Money and also amount ---->>>', message: 'Sender---->>>: $senderUserToken Receiver---->>>: $receiverUserToken amount---->>>: $amount and Tag---->>>: $tags');
  //  String? sourceToken =  await createFundingSource(name: name, userToken: senderUserToken);
  //  return'';
  try {
   var data = await http.post(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.PAY}'),
            headers: ApiConstants.headers(),
            body: jsonEncode(
              {
                "amount": double.parse(amount!),
                "currency_code": "USD",
                "sender_user_token": senderUserToken,
                "recipient_user_token": receiverUserToken,
                "tags":tags
              }
              
             )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    logMethod(title: 'Amount Transaction:', message: data.body);
        final paymentModel = paymentModelFromMap(data.body);
    // var model = CardModel.fromJson(json.decode(data.body));
    return paymentModel.token;
    } catch (e) {
    return e.toString();
  }
  }
  Future<BalanceModel?> checkBalance(
      {String? userToken,
      }) async {
        // logMethod(title: 'User Token is:', message: userToken.toString());
   var data = await http.get(Uri.parse('${ApiConstants.MARQATA_BASE_URL}${ApiConstants.BALANCE}$userToken'),
            headers: ApiConstants.headers(),
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    // logMethod(title: 'Get Balance:', message: data.body);
        final balanceModel = balanceModelFromMap(data.body);
    // cardTransationModel.data.first.gpaOrder.
    return balanceModel;
  }


  ////////Geting token from server
  Future<String> getClientTokenFromYourServer() async {
  final url = Uri.parse('https://yourbackendserver.com/get_client_token');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['token'];
      
    } else {
      // Handling different status codes or server errors
      return AppConstants.BRAINTREE_TOCKENIZATION_KEY;
      // throw Exception('Failed to retrieve client token with status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handling exceptions that occur during the HTTP request
    return AppConstants.BRAINTREE_TOCKENIZATION_KEY;
    // throw Exception('Error occurred while fetching client token: $e');
  }
}

//Payfort tokenCreation
Future<String?> tokenCreationPayfort({
    String? amount,
    String? senderUserToken,
    String? receiverUserToken,
    String? name,
    String? memo,
    required String? tags
  }) async {
    logMethod(title: 'UserToken Move Money and also amount ---->>>', message: 'Sender---->>>: $senderUserToken Receiver---->>>: $receiverUserToken amount---->>>: $amount and Tag---->>>: $tags');
  //  String? sourceToken =  await createFundingSource(name: name, userToken: senderUserToken);
  //  return'';
  // String? deviceId = await FlutterAmazonpaymentservices.getUDID;
  "PASSaccess_code=SILgpo7pWbmzuURp2qriamount=1000command=PURCHASEcurrency=USDcustomer_email=test@gmail.comlanguage=enmerchant_identifier=MxvOupuGmerchant_reference=Test010PASS";
   var data = await http.post(Uri.parse('${Payfortconstants.payfortAccessTokenUrl}'),
            // headers: ApiConstants.headers(),
            body: jsonEncode(
              {
                "service_command": "SDK_TOKEN",
                "access_code" : "zx0IPmPy5jp1vAz8Kpg7",
                "merchant_identifier" : "${Payfortconstants.MERCHANT_TOKEN}",
                "language" : "en",
                // "device_id" : "$deviceId",
                "signature" : "7cad05f0212ed933c9a5d5dffa31661acf2c827a"
              }
              
             )
          ).whenComplete(() {
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    // logMethod(title: 'Amount Transaction:', message: data.body);
       final paymentAccessTokenModel = paymentAccessTokenModelFromJson(data.body);

    // var model = CardModel.fromJson(json.decode(data.body));
    return paymentAccessTokenModel.accessCode;
  }

}