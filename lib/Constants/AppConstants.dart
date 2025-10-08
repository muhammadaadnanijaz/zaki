import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Models/FundMeWalletModel.dart';
import 'package:zaki/Models/GoalModel.dart';
import 'package:zaki/Models/NickNameModel.dart';
import 'package:zaki/Models/PayRequestsModel.dart';
import 'package:zaki/Models/TransactionModel.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Services/mode_services.dart';

import '../Models/PersonalizationSettingsModel.dart';
import '../Models/TagItModel.dart';
import '../Models/TransactionDetailModel.dart';

enum SingingCharacter { yes, no }

class AppConstants extends ChangeNotifier {
   static String TEMP_CODE = 'Temo_Code';
   static String NEED_FIX_CODE = 'Need_fix_code';
   

  static String TWITTER_API_KEY = '65W1v4z2PDyMDOuolNLNQ3v4X';
  static String TWITTER_SECRET_API_KEY = 'ZpmHXt9h4mNjDTlEJa1EjvjAVr74jI2nFVH5FILuXiaCDwVPYD';
  // static String BRAINTREE_TOCKENIZATION_KEY = 'sandbox_8hqqbbn8_ty4v4w7skfn9m4cz';
  static String BASE_URL_OF_TAG_IT_GOOGLE_SHEET =
      'https://script.google.com/macros/s/AKfycbwQoRyZ73FdCNxemUpemuTCVRBux7VvW6N4sdotl2La4HhMKTTQq_-LDmU5--e9JXxC/exec';

  static String HOME_SCREEN = 'home_screen';
  static String PAY_OR_REQUEST = 'pay_or_request';
  static String MISSION_ACCOMPLISHED = 'mission_accomplished';

static String LOGIN_TYPE_GOOGLE = 'GOOGLE';
static String LOGIN_TYPE_APPLE = 'APPLE';
static String LOGIN_TYPE_FACEBOOK = 'FACEBOOK';
static String LOGIN_TYPE_X = 'X';
static String LOGIN_TYPE_EMAIL = 'EMAIL';
  
static String FUND_MY_WALLET_SCREEN = 'fund_my_wallet';
static String ADD_FAMILY_MEMBER = 'add_family_member';
static String SETUP_WALLET_AND_CARD = 'setup_wallet_and_card';
static String MOVE_MONEY_INTERNALLY = 'move_money_internally';

  static String COUNTRY_PAKISTAN = 'PKR';
  static String COUNTRY_SAUDIA = 'SA';
  static String COUNTRY_SAUDIA_CURRENCY = 'SAR';

  static String COUNTRY_QATAR = 'QA';
  static String COUNTRY_QATAR_CURRENCY = 'QA';

  static String ZAKI_PAY_ACCOUNT_NUMBER = '6eb9401b-d44d-44ca-ae22-5efc0e2d10ce';
  static String ZAKI_PAY_SHARED_TEXT = 'Shared from zakipay';
  static String ZAKI_PAY_TOPIC = 'ZAKI_PAY_TOPIC';

  static String ZAKI_PAY_SHARED_LINK =
      'https://zakipay.com/category/learning-center/';
  static String ZAKI_PAY_APP_LINK =
      'https://play.google.com/store/apps/details?id=com.zakipay.teencard&hl=en&gl=US';

  static String ZAKI_PAY_PROMOTIONAL_TEXT =
      'recommends downloading ZakiPay! a FREE Family Financial Literacy App, that helps teach your kids concepts around money, savings, setting goals, rewards , pay each other and so much more! \nRaise Smart Kids! Download ZakiPay for FREE Now!:';
  static String ZAKI_PAY_GOAL_SHARE_TEXT_FIRST_TITLE =
      'is inviting you to contribute to a Goal they setup: ';
  static String ZAKI_PAY_GOAL_SHARE_TEXT_LAST_TITLE =
      'Download ZakiPay for FREE and review more details about thier Goal';
  static String ZAKI_PAY_SOCILIZE_SHARE_FIRST_TEXT =
      'is sharing a fun activity they had via ZakiPay. Check it out & join the Fun!';
  static String ZAKI_PAY_SOCILIZE_SHARE_LAST_TEXT =
      'Download ZakiPay for FREE Now!';
  static String USER_TYPE_KID = 'Kid';
  static String USER_TYPE_PARENT = 'Parent';
  static String USER_TYPE_SINGLE = 'Single';
  static String USER_TYPE_ADULT = 'Adult';



  static String ZAKI_PAY_IMAGE_URL =
      'https://www.w3schools.com/html/img_chania.jpg';
  // static String API_KEY =
  //     'ya29.a0AeDClZDHnSpG_uJSMj2tBMaI6g6eut4bu4wC9gZv7HknKxwscfkjxO8V_-GvIHf1yp1S09Nrm-LwLrfJf00smIDoncsG-QYLyoK8-S3rDNo32j_bTJG4DXY2CYxbFDnoBCUPpRJfyk669mKfBI3C2sBOjh-iYiY0P4C75OrEaCgYKAUcSARMSFQHGX2Mi-qKxvrMu5aRo4GZHIafigg0175';
  static String USER = 'USER';
  static String TagitCollection = 'Tagit';

  String BANK_ID = INTIAL_BANK_ID;
  // String COUNTRY_CODE = 'SA';
  String COUNTRY_CODE = INTIAL_COUNTRY_CODE;

  static String device_list = 'device_list';
  static String USER_UserID = 'USER_UserID';
  static String USER_Family_Id = 'USER_Family_Id';
  static String USER_first_name = 'USER_first_name';
  static String USER_last_name = 'USER_last_name';
  static String USER_legalfirst_name = 'USER_legalfirst_name';
  static String USER_legallast_name = 'USER_legallast_name';

  static String USER_email = 'USER_email';
  static String USER_dob = 'USER_dob';
  static String USER_password = 'USER_password';
  static String USER_UserType = 'USER_UserType';
  static String USER_isEmailVerified = 'USER_isEmailVerified';
  static String USER_phone_number = 'USER_phone_number';
  static String USER_phone_number_parent = 'USER_phone_number_parent';
  static String USER_gender = 'USER_gender';
  static String USER_lat_lng = 'USER_lat_lng';
  static String USER_city = 'USER_city';
  static String USER_country = 'USER_country';
  static String USER_SignUp_Method = 'USER_SignUp_Method';
  static String USER_currency = 'USER_currency';
  static String USER_created_at = 'USER_created_at';
  static String USER_pin_code_length = 'USER_pin_code_length';
  static String USER_pin_code = 'USER_pin_code';
  static String USER_user_name = 'USER_user_name';
  static String USER_pin_enable = 'USER_pin_enable';
  static String USER_email_verified_status = 'USER_email_verified_status';
  static String SubscriptionExpired = 'SubscriptionExpired';
  static String USER_State = 'USER_state';
  static String USER_BankAccountID = 'User_BankAccountID';
  static String DateOfSubscription = 'DateOfSubscription';
  static String DateOfExpirationSubscription = 'DateOfExpirationSubscription';

  static String USER_Subscription_Method = 'USER_Subscription_Method';
  static String USER_Subscription_Method_Card = 'Creadit_card';
  static String USER_Subscription_Method_Google = 'Google_pay';
  static String USER_Subscription_Method_Apple = 'Apple_pay';

  static String USER_TouchID_isEnabled = 'USER_TouchID_isEnabled';
  static String NewMember_isEnabled = 'NewMember_isEnabled';
  static String NewMember_kid_isEnabled = 'NewMember_kid_isEnabled';
  static String USER_SubscriptionValue = 'USER_SubscriptionValue';
  

  static String USER_Notification_isEnabled = 'USER_Notification_isEnabled';
  static String USER_IsUserPin = 'USER_IsUserPin';
  static String USER_Location_isEnabled = 'USER_Location_isEnabled';
  static String USER_Logo = 'USER_Logo';
  static String USER_background_image_url = 'USER_background_image_url';
  static String USER_zip_code = 'USER_zip_code';
  static String USER_iNApp_NotifyToken = 'USER_iNApp_NotifyToken';
  static String USER_Status = 'USER_Status';
  static String USER_SignupMember_Type = 'USER_SignupMember_Type';
  static String USER_Fully_Registered = 'USER_Fully_Registered';
  static String USER_See_Kids = 'USER_See_Kids'; 
  static String USER_wedding_anniversary = 'USER_wedding_anniversary'; 

  static String USER_familymemberlimitreached = 'USER_familymemberlimitreached';

  static String USER_WALLETS = 'USER_WALLETS';

  static String Donations_Wallet = 'Donations-Wallet';
  static String Savings_Wallet = 'Savings-Wallet-Main';
  static String Spend_Wallet = 'Spend-Wallet';
  static String All_Goals_Wallet = 'Savings-Goals-Wallet';

  static String P_FEE = 'PROCESSING_FEE';
  static String P_FEE_USER_ID = 'P_FEE_USER_ID';
  static String P_FEE_TOTAL_AMOUNT = 'P_FEE_TOTAL_AMOUNT';
  static String P_FEE_AMOUNT = 'P_FEE_AMOUNT';

  static String main_account_nick_name = 'main_account_nick_name';
  //
  static String Donate_account_nick_name = 'Donate_account_nick_name';
  static String saving_account_nick_name = 'saving_account_nick_name';

  static String updated_at = 'updated_at';
  static String wallet_balance = 'wallet_balance';

  static String USER_contacts = 'USER_contacts';
  static String USER_contact_invitedphone = 'USER_contact_invitedphone';
  static String USER_invited_signedup = 'USER_invited_signedup';
  static String USER_IsFavorite = 'USER_IsFavorite';

  static String USER_Invites = 'USER_Invites';
  static String USER_Invited_By_Id = 'USER_Invited_By_Id';

static String INTERNET_STATUS_NOT_CONNECTED = 'INTERNET_STATUS_NOT_CONNECTED';
/////////////User Allowances

  static String ALLOW = 'ALLOW';
  static String USER_parent_id = 'USER_parent_id';
  static String USER_kid_id = 'USER_kid_id';
  static String USER_Allow1_amount = 'USER_Allow1_amount';
  static String USER_allowance_schedule = 'USER_allowance_schedule';
  static String USER_Main_amount = 'USER_Main_amount';
  static String USER_saving_amount = 'USER_saving_amount';
  static String USER_donate_amount = 'USER_donate_amount';
  static String USER_donate_amount_percent = 'USER_donate_amount_percent';
  static String USER_Main_amount_percent = 'USER_Main_amount_percent';
  static String USER_saving_amount_percent = 'USER_saving_amount_percent';
  static String USER_delivery_on = 'USER_delivery_on';
  static String USER_allowance_status = 'USER_allowance_status';
  static String USER_allowance_linked_ToDo = 'USER_allowance_linked_ToDo';
  static String USER_allowance_Parent_BankAccount_Id = 'USER_allowance_Parent_BankAccount_Id';
  static String USER_allowance_Kid_BankAccount_Id = 'USER_allowance_Kid_BankAccount_Id';
  static String created_at = 'created_at';
  static String USER_Block_Time = 'USER_Block_Time';
  static String USER_LAST_LOGIN_DATE_TIME = 'USER_LAST_LOGIN_DATE_TIME';
  static String USER_PIN_CODE_SETUP_DATE_TIME = 'USER_PIN_CODE_SETUP_DATE_TIME';


//For Goals
  static String GOAL = 'GOAL';

  static String GOAL_user_id = 'GOAL_user_id';
  static String GOAL_id = 'GOAL_id';
  static String GOAL_name = 'GOAL_name';
  static String Goal_Target_Amount = 'Goal_Target_Amount';
// remove  static String GOAL_allowance_id = 'GOAL_allowance_id';
// remove  static String GOAL_allowance_name = 'GOAL_allowance_name';
  static String GOAL_isPrivate = 'GOAL_isPrivate';
  static String GOAL_created_at = 'GOAL_created_at';
// NEW
  static String GOAL_last_updated_on = 'GOAL_last_updated_on';
  static String GOAL_Expired_Status = 'GOAL_Expired_Status';
  static String GOAL_Expired_Date = 'GOAL_Due_Date';
// remove  static String GOAL_complete_status = 'GOAL_complete_status';
// NEW
  static String GOAL_Status = 'GOAL_Status';
  static String GOAL_Status_Active = 'Active';
  static String GOAL_Status_expired = 'expired';
  static String GOAL_Status_completed = 'completed';
// --value = Active, Expired, Completed
  static String GOAL_amount_collected = 'GOAL_amount_collected';
  static String GOAL_selected_index = 'fund_goal_from';
  static String GOAL_Invited_List = 'GOAL_Invited_List';
  static String GOAL_Invited_Token_List = 'GOAL_Invited_Token_List';
  static String Goal_InviteSentTo_UserID = 'Goal_InviteSentTo_UserID';
  static String Goal_InviteReceivedFrom_UserID =
      'Goal_InviteReceivedFrom_UserID';

  static String Goal_InviteSent_User_SenderId = 'Goal_InviteSent_User_SenderId';
  static String Goal_InviteSent_User_ReceiverId =
      'Goal_InviteSent_User_ReceiverId';

  static String Contribution = 'Contribution';
  static String contributor_user_Id = 'contributor_user_Id';
  static String contribution_date = 'contribution_date';
  static String countributed_amount = 'countributed_amount';
  static String contributor_wallet_name = 'contributor_wallet_name';
  static String contribution_amount_currency = 'contribution_amount_currency';

/////////Allocations (Should be deleted)
  static String At = 'At';
  static String At_user_id = 'At_user_id';
  static String At_parent_id = 'At_parent_id';
  static String At_amount = 'At_amount';
  static String At_sender_id = 'At_sender_id';
  static String At_image_url = 'At_image_url';
  static String At_message = 'At_message';
  static String At_allocation_id = 'At_allocation_id';
  static String At_allocation_name = 'At_allocation_name';
  static String At_acount_type = 'At_acount_type';
  static String At_acount_holder_name = 'At_acount_holder_name';

//////Requested

  static String Requested = "Requested";
  static String RQT_ReceiverUser_id = "RQT_ReceiverUser_id";
  static String RQT_SocialPrivacy_Code = "RQT_SocialPrivacy_Code";

  static String RQT_receiver_name = "RQT_receiver_name";
  static String RQT_sender_image_url = "RQT_sender_image_url";
  static String RQT_receiver_image_url = "RQT_receiver_image_url";
  static String RQT_amount = "RQT_amount";
  static String RQT_SenderUser_id = "RQT_SenderUser_id";
  static String RQT_image_url = "RQT_image_url";
  static String RQT_Message_Text = "RQT_Message_Text";
  static String RQT_TAGIT_id = "RQT_TAGIT_id";
  static String RQT_TAGIT_name = "RQT_TAGIT_name";
  static String RQT_WalletName = "RQT_WalletName";
  static String RQT_transaction_type = "RQT_transaction_type";
  static String RQT_Sender_UserName = "RQT_Sender_UserName";
  static String RQT_likes_list = "RQT_likes_list";
  static String RQT_DocumentId = "RQT_DocumentId";
  

  static String Pay = "Pay";
  static String SOCIAL = "SOCIAL";

  static String Social_Sender_user_id = 'Social_Sender_user_id';
  static String Social_receiver_user_id = 'Social_receiver_user_id';
  static String Social_transaction_type = "Social_transaction_type";
  static String Social_Post_id = 'Social_Post_id';
  static String Social_Message_Text = 'Social_Message_Text';
  static String Social_image_url = 'Social_image_url';
  static String Social_Is_private = 'Social_Is_private';
  static String Social_amount = 'Social_amount';
  static String Social_Privacy_Code = 'Social_Privacy_Code';
// RQT_Social
  static String Social_Sharedwith_Users_List = 'Social_Sharedwith_Users_List';
  static String Social_Likes_UserId = 'Social_Likes_UserId';
  static String Social_Sharing_Count = 'Social_Sharing_Count';
  static String Social_Transaction_id = 'Social_Transaction_id';
  static String Social_created_at = 'Social_created_at';
  static String Social_updated_at = 'Social_updated_at';

// Transaction table
  static String Transaction = "Transaction";
  static String Transaction_ReceiverUser_id = "Transaction_ReceiverUser_id";
  // static String Transaction_SocialPrivacy_Code = "Transaction_SocialPrivacy_Code";
  static String Transaction_receiver_name = "Transaction_receiver_name";
  static String Transaction_sender_image_url = "Transaction_sender_image_url";
  static String Transaction_receiver_image_url =
      "Transaction_receiver_image_url";
  static String Transaction_amount = "Transaction_amount";
  static String Transaction_SenderUser_id = "Transaction_SenderUser_id";
  static String Transaction_image_url = "Transaction_image_url";
  static String Transaction_Message_Text = "Transaction_Message_Text";
  static String Transaction_transaction_type = "Transaction_transaction_type";
  static String Transaction_Sender_UserName = "Transaction_Sender_UserName";
  static String Transaction_TAGIT_code = "Transaction_TAGIT_code";
  static String Transaction_id = "Transaction_id";
  static String Transaction_Common_id = "Transaction_Common_id";
  
  static String Transaction_To_Wallet = "Transaction_To_Wallet";
  static String Transaction_From_Wallet = "Transaction_From_Wallet";
  
  static String Transaction_TAGIT_Category = "Transaction_TAGIT_Category";
  static String Transaction_Method = "Transaction_Method";

  static String Transaction_Method_Received = "Received";
  static String Transaction_Method_Payment = "Payment";

  //Do we need it for something??
  static String Transaction_Method_Refund = "Refund";

  static String TAG_IT_Transaction_TYPE_ALLOWANCE = 'Allowance';
   static String TAG_IT_Transaction_TYPE_GOALS = 'Goals';
  static String TAG_IT_Transaction_TYPE_SEND_OR_REQUEST = 'Send Or Request';
  static String TAG_IT_Transaction_TYPE_Fund_My_Wallet = 'Fund_My_Wallet';
  static String TAG_IT_Transaction_TYPE_Fund_My_Wallet_FULL_NAME = 'Fund My Wallet';
  
  static String TAG_IT_Transaction_TYPE_DEBIT_CARD_V = 'DebitCardV';
    static String TAG_IT_Transaction_TYPE_DEBIT_CARD_V_FULL_NAME = 'Debit Card Virtual';
  static String TAG_IT_Transaction_TYPE_DEBIT_CARD_P_FULL_NAME = 'Debit Card Physical';
  static String TAG_IT_Transaction_TYPE_DEBIT_CARD_P = 'DebitCardP';
  static String TAG_IT_Transaction_TYPE_TODO_REWARD = 'ToDoReward';
  static String TAG_IT_Transaction_TYPE_TODO_REWARD_FULL_NAME = 'To Do - Rewards';
  static String TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER = 'Internal_Transfer';
 static String TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER_FULL_NAME = 'Internal Transfer';

 static String TAG_IT_Transaction_TYPE_SUBSCRIPTION = 'Subscription';

  static List<String> TRANSACTION_LIST = [
    TAG_IT_Transaction_TYPE_ALLOWANCE, 
    TAG_IT_Transaction_TYPE_GOALS,
     TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
     TAG_IT_Transaction_TYPE_Fund_My_Wallet, 
     TAG_IT_Transaction_TYPE_DEBIT_CARD_V,
     TAG_IT_Transaction_TYPE_DEBIT_CARD_P,
     TAG_IT_Transaction_TYPE_TODO_REWARD,
     TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER,
    ];

// "TT=Goal,FM=SpendWallet,ToWallet=All Goals, GoalId=123, Transaction_Method=Payment, TAGId=tg12, tagidName=tagname-as";
  ////////For memo Building
  static String M_Transaction_type = "TT";
  static String M_From_Wallet = "FW";
  static String M_To_Wallet = "TW";
  static String M_Goal_id = "GI";
  static String M_Transaction_Method = "TM";
  static String M_Tag_It_Id = "TI";
  static String M_Tag_It_Name = "TN";

  static String M_Transaction_type_P = "TTP";
  static String M_Transaction_type_A = "TTA";
  static String M_Transaction_type_G = "TTG";
  static String M_Transaction_type_R = "TTR";
  // static String M_Transaction_type_G = "TTG";

  // static String TransactionTYPE_REQUEST = 'Request';
// static String = '';
// static String = '';

  static String KidPersonalization = 'KidP';
  static String KidP_user_id = 'KidP_user_id';
  static String KidP_Parent_id = 'KidP_Parent_id';
  static String KidP_SeePendApprovals = 'KidP_SeePendApprovals';
  static String KidP_Kid2PayFriends = 'KidP_Kid2PayFriends';
  static String KidP_Kids2Publish = 'KidP_Kids2Publish';
  static String KidP_UseSlide2Pay = 'KidP_UseSlide2Pay';
  static String KidP_lockSavings = 'KidP_lockSavings';
  static String KidP_lockDonate = 'KidP_lockDonate';
  static String KidP_disableTo_Do = 'KidP_disableTo_Do';
  static String KidP_created_at = 'KidP_created_at';

  static String ICard_Collection = 'ICard';
  static String ICard_user_id = 'ICard_user_id';
  static String ICard_firstName = 'ICard_firstName';
  static String ICard_lastName = 'ICard_lastName';
  static String ICard_USER_DOB = 'ICard_USER_DOB';
  static String ICard_GovID = 'ICard_GovId';
  static String ICard_PhoneNum = 'ICard_PhoneNum';
  static String ICard_cardStatus = 'ICard_cardStatus';
  static String ICard_streetAddress = 'ICard_streetAddress';
  static String ICard_apartmentOrSuit = 'ICard_apartmentOrSuit';
  static String ICard_city = 'ICard_city';
  static String ICard_state = 'ICard_state';
  static String ICard_zipCode = 'ICard_zipCode';
  static String ICard_ssnNumber = 'ICard_ssnNumber';
  static String ICard_backGroundImage = 'ICard_backGroundImage';
  static String ICard_physical_card = 'ICard_physical_card';
  static String ICard_lockedStatus = 'ICard_lockedStatus';
  static String ICard_Expired_Date = 'ICard_Expired_Date';
  static String ICard_Token = 'ICard_Token';
  static String ICard_User_Token = 'ICard_User_Token';

  static String ICard_created_at = 'ICard_created_at';
  static String ICard_number = 'ICard_number';
  //

  static String SpendLimits = 'SpendL';
  static String SpendL_user_id = 'SpendL_user_id';
  static String SpendL_parent_id = 'SpendL_parent_id';
  static String SpendL_TransactionActive_Max = 'SpendL_Transaction_Active_Max';
  static String SpendL_Transaction_Amount_Max = 'SpendL_Transaction_Amount_Max';
  static String SpendL_daily_Amount_Max = 'SpendL_daily_Amount_Max';
  static String SpendL_daily_Amount_Remain = 'SpendL_daily_Amount_Remain';

  static String SpendL_TAGID0001_Max = 'SpendL_TAGID0001_Max';
  static String SpendL_TAGID0003_Max = 'SpendL_TAGID0003_Max';
  static String SpendL_TAGID0003_mcc_id = 'SpendL_TAGID0003_mcc_id';

  static String SpendL_TAGID0001_mcc_id = 'SpendL_TAGID0001_mcc_id';

  static String SpendL_TAGID0002_Max = 'SpendL_TAGID0002_Max';
  static String SpendL_TAGID0002_mcc_id = 'SpendL_TAGID0002_mcc_id';

  static String SpendL_TAGID0004_Max = 'SpendL_TAGID0004_Max';
  static String SpendL_TAGID0004_mcc_id = 'SpendL_TAGID0004_mcc_id';

  static String SpendL_TAGID0005_Max = 'SpendL_TAGID0005_Max';
  static String SpendL_TAGID0005_mcc_id = 'SpendL_TAGID0005_mcc_id';

  static String SpendL_TAGID0006_Max = 'SpendL_TAGID0006_Max';
  static String SpendL_TAGID0006_mcc_id = 'SpendL_TAGID0006_mcc_id';

  static String SpendL_TAGID0007_Max = 'SpendL_TAGID0007_Max';
  static String SpendL_TAGID0007_mcc_id = 'SpendL_TAGID0007_mcc_id';

  static String SpendL_TAGID0008_Max = 'SpendL_TAGID0008_Max';
  static String SpendL_TAGID0008_mcc_id = 'SpendL_TAGID0008_mcc_id';

  static String SpendL_TAGID0009_Max = 'SpendL_TAGID0009_Max';
  static String SpendL_TAGID0009_mcc_id = 'SpendL_TAGID0009_mcc_id';

static String SpendL_company_id_001 = 'SpendL_company_id_001';
static String SpendL_company_id_002 = 'SpendL_company_id_002';
static String SpendL_company_id_003 = 'SpendL_company_id_003';

static String SpendL_company_id_100 = 'SpendL_company_id_100';
static String SpendL_company_id_200 = 'SpendL_company_id_200';
static String SpendL_company_id_300 = 'SpendL_company_id_300';

  static String SpendL_TAGID0010_Max = 'SpendL_TAGID0010_Max';
  static String SpendL_TAGID0010_mcc_id = 'SpendL_TAGID0010_mcc_id';

  static String SpendL_TAGID0011_Max = 'SpendL_TAGID0011_Max';
  static String SpendL_TAGID0011_mcc_id = 'SpendL_TAGID0011_mcc_id';

  static String SpendL_TAGID0022_Max = 'SpendL_TAGID001122_Max';
  static String SpendL_TAGID0022_mcc_id = 'SpendL_TAGID001122_mcc_id';

  static String SpendL_TAGID0012_Max = 'SpendL_TAGID0012_Max';
  static String SpendL_TAGID0012_mcc_id = 'SpendL_TAGID0012_mcc_id';

   static String SpendL_TokenOfMaxSpendControllPerTran = 'SpendL_TokenOfMaxSpendControllPerTran';












  static String TAGID0001 = 'Entertainment';
  static String TAGID0003 = 'Food';
  static String TAGID0002 = 'Transportation';

  static String TAGID0004 = 'Other';
  static String TAGID0005 = 'Clothing';

  static String TAGID0006 = 'Personal Care';
  static String TAGID0007 = 'Video Games';

  static String TAGID0008 = 'Electronics';

  static String TAGID0009 = 'Pets';
  static String TAGID0010 = 'Gifts';
  static String TAGID0011 = 'Donations';
  
  static String TAGID0012 = 'Video Games';
  static String TAGID9997 = 'Reward';
  static String TAGID9998 = 'Internal Transfer';

  static String SpendL_TransactionActive_Remain =
      'SpendL_Transaction_Active_Remain';
  static String SpendL_Transaction_Amount_Remain =
      'SpendL_Transaction_Amount_Remain';
  static String SpendL_TAGID0001_Remain = 'SpendL_TAGID0001_Remain';
  static String SpendL_TAGID0003_Remain = 'SpendL_TAGID0003_Remain';
  static String SpendL_TAGID0002_Remain = 'SpendL_TAGID0002_Remain';
  static String SpendL_TAGID0004_Remain = 'SpendL_TAGID0004_Remain';
  static String SpendL_TAGID0005_Remain = 'SpendL_TAGID0005_Remain';
  static String SpendL_TAGID0006_Remain = 'SpendL_TAGID0006_Remain';
  static String SpendL_TAGID0007_Remain = 'SpendL_TAGID0007_Remain';
  static String SpendL_TAGID0008_Remain = 'SpendL_TAGID0008_Remain';
  static String SpendL_TAGID0009_Remain = 'SpendL_TAGID0009_Remain';
  static String SpendL_TAGID0010_Remain = 'SpendL_TAGID0010_Remain';
  static String SpendL_TAGID0011_Remain = 'SpendL_TAGID0011_Remain';
  static String SpendL_TAGID0022_Remain = 'SpendL_TAGID0022_Remain';
  static String SpendL_TAGID0012_Remain = 'SpendL_TAGID0012_Remain';

  static String SpendL_CreatedAt = 'SpendL_CreatedAt';

  ////Nick names
  static String Nick_Name = 'NickN';

  static String Nick_Name_User_Id = 'NickN_User_Id';
  static String SpendWallet_Name = 'NickN_SpendWallet';
  static String SavingWallet_Name = 'NickN_SavingWallet';
  static String DonationWallet_Name = 'NickN_DonationWallet';
  static String TopFriends_Name = 'NickN_TopFriends';
  static String createdAt = 'created_at';

////////////////SAVE CARD FOR FUTURE FUND MY WALLET
  static String FM_WALLET = 'FM_WALLET';

  static String FM_WALLET_userId = 'FM_WALLET_userId';
  static String FM_WALLET_amount = 'FM_WALLET_amount';
  static String FM_WALLET_card_number = 'FM_WALLET_card_number';
  static String FM_WALLET_cardHolderName = 'FM_WALLET_cardHolderName';
  static String FM_WALLET_expiryDate = 'FM_WALLET_expiryDate';
  static String FM_WALLET_createdAt = 'FM_WALLET_createdAt';
  static String FM_WALLET_cardStatus = 'FM_WALLET_cardStatus';

  /////////////TO DO LIST
  static String TO_DO = 'TO_DO';
  static String TO_DO_Completed = 'TO_DO_Completed';
  static String To_Do_Pending_Approval = 'To_Do_Pending_Approval';

  static String TO_DO_Id = 'TO_DO_Id';
  static String DO_CreatedAt = 'DO_CreatedAt';
  static String DO_newCreatedAt = 'DO_newCreatedAt';
  
  static String To_DO_Completed_At = 'To_DO_Completed_At';
  static String DO_parentId = 'DO_parentId';
  static String DO_UserId = 'DO_UserId';
  static String DO_Title = 'DO_Title';
  static String DO_Receiver_Id = 'DO_Receiver_Id';
  
  static String ToDo_Repeat_Schedule = 'ToDo_Repeat_Schedule';
  static String DO_Day = 'DO_Day';
  static String DO_DUE_DATE = 'DO_DUE_DATE';
  static String DO_Status = 'DO_Status';
  static String DO_Allowance_Linked = 'DO_Allowance_Linked';
  static String DO_Deleted_By = 'DO_Deleted_By';
  static String DO_Kid_Status = 'DO_Kid_Status';
  static String DO_End_Repeat = 'DO_End_Repeat';
  static String ToDo_WithReward = 'ToDo_WithReward';
  static String ToDo_Reward_Amount = 'ToDo_Reward_Amount';
  static String ToDo_Reward_Status = 'ToDo_Reward_Status';

  static String Active = 'Active';
  static String PendingParentApproval = 'PendingParentApproval';
  static String Completed = 'Completed';
  TransactionDetailModel transactionDetailModel = TransactionDetailModel();

  static String Apps = 'Apps to db';
  static String Allowance = 'Allowance';

  static int ATTEMPTS_COUNT=4;

  static List<ImageModelTagIt> tagItList =   tagItList = [
    ImageModelTagIt(
        id: 5, icon: FontAwesomeIcons.shirt, title: TAGID0005, mccId: '1737', isSelected: false),
    ImageModelTagIt(
        id: 3,
        icon: FontAwesomeIcons.burger,
        title: TAGID0003,
         isSelected: false,
        mccId: '1735'),
    ImageModelTagIt(
        id: 6, icon: FontAwesomeIcons.hatCowboy, title: TAGID0006, mccId: '1738', isSelected: false),
    ImageModelTagIt(
        id: 8,
        icon: FontAwesomeIcons.gamepad,
        title: TAGID0007,
        mccId: '17310', isSelected: false),
    ImageModelTagIt(
        id: 0, icon: FontAwesomeIcons.icons, title: TAGID0001, mccId: '1732', isSelected: false),
    ///////////////////////End here 
    // ImageModelTagIt(
    //     id: 1,
    //     icon: FontAwesomeIcons.moneyBillTransfer,
    //     title: Allowance,
    //     mccId: '1733'),
   ImageModelTagIt(
        id: 9,
        icon: FontAwesomeIcons.tv,
        title: TAGID0008,
        mccId: '17311', isSelected: false),
    
    ImageModelTagIt(
        id: 10, icon: FontAwesomeIcons.cat, title: TAGID0009, mccId: '1725', isSelected: false),
    ImageModelTagIt(
        id: 4,
        icon: FontAwesomeIcons.bus,
        title: TAGID0002,
        mccId: '1736', isSelected: false),
    
    ImageModelTagIt(
        id: -1, icon: Icons.card_giftcard, title: TAGID0010, mccId: '1731', isSelected: false),
    ImageModelTagIt(
        id: 12,
        icon: FontAwesomeIcons.handHolding,
        title: TAGID0011,
        mccId: '1735', isSelected: false
        ),
    ImageModelTagIt(
        id: 7, icon: FontAwesomeIcons.bullseye, title: 'Goals', mccId: '1739', isSelected: false),
    ImageModelTagIt(
        id: 13,
        icon: FontAwesomeIcons.moneyBillTransfer,
        title: Allowance,
        mccId: '1736',
        publicTag_it: false,
        isSelected: false,
        ),
      ImageModelTagIt(
        id: 14,
        icon: FontAwesomeIcons.trophy,
        title: TAG_IT_Transaction_TYPE_TODO_REWARD,
        fullName: TAG_IT_Transaction_TYPE_TODO_REWARD_FULL_NAME,
        mccId: '1737',
        publicTag_it: false, isSelected: false
        ),
        ImageModelTagIt(
        id: 15,
        icon: FontAwesomeIcons.handHolding,
        title: TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER,
        mccId: '1738',
        fullName: TAG_IT_Transaction_TYPE_INTERNAL_TRANSFER_FULL_NAME,
        publicTag_it: false, isSelected: false
        ),
      ImageModelTagIt(
        id: 16,
        icon: FontAwesomeIcons.wallet,
        title: TAG_IT_Transaction_TYPE_Fund_My_Wallet,
        mccId: '1738',
        fullName: TAG_IT_Transaction_TYPE_Fund_My_Wallet_FULL_NAME,
        publicTag_it: false, isSelected: false
        ),
    ImageModelTagIt(
        id: 17,
        icon: FontAwesomeIcons.creditCard,
        title: 'Debit Card',
        fullName: 'Debit Card',
        publicTag_it: false,
        isSelected: false,
        mccId: '17388'),
  ];
  //n
  SingingCharacter? kids = SingingCharacter.yes;
  String email = '';
  String password = '';
  bool isEmailVerfied = false;
  String phoneNumber = '';
  String selectFromWallet = 'Select';
  String selectFromWalletRealName = 'Select';
  String selectToWallet = 'Select';
  String selectToWalletRealName = 'Select';
  String firstName = '';
  bool myEmailUsedStatus = false ;
  String zipCode = '';
  String lastName = '';
  String genderType = 'Male';
  String dateOfBirth = 'dd / mm / yyyy';
  String anniversaryDate = 'dd / mm / yyyy';
  DateTime? dateOfBirthWithDate = null;
  String signUpRole = 'Parent';
  String kidSignUpRole = 'Son';
  String userType = 'Dad';
  String allowanceSchedule = 'Monthly';
  String allowanceDay = 'Friday';
  String userName = '';
  String haveKids = 'No';
  bool haveKid = false;
  bool applyToKids = false;
  int kidsLength = 0;
  int pinLength = 4;
  String pin = '';
  String fullPin = '';
  String fullPinConfirm = '';
  bool? pinEnable = false;
  bool isTouchEnable = false;
  String signUpMethod = 'WhatsApp';
  bool isLoading = false;
  List<Map<String, dynamic>> kidsRegistrationList = [];

  bool? fromWhoLoginPage = false;

  bool? fromAcoountOrNot = true;
  bool? fromReportAnIssue = true;
  String userRegisteredId = '';
  String userChildRegisteredId = '';

  String accountSettingUpFor = 'Family';

  bool kidsToPayFriends = true;
  String pendingApprovales = 'No';
  bool kidsToPublish = true;
  bool slideToPay = true;
  bool lockSaving = true;
  bool lockCharity = true;
  bool disableToDo = false;
  // bool appMode = true;
  bool appMode = ModeService.appMode;
  bool payFortTestingModeForFundMyWallet = false;
  bool payFortTestingModeForSubscription = false;

  bool allowApplePayAndGooglePay = false;

  int selectedAllocationIndex = -1;
  int startIndex = 0;

  int selectedPrivacyType = 1;
  bool passwordVissible = true;
  bool? registrationCheckBox = false;
  bool? issueDebitCardCheckBox = false;
  bool passwordVissibleRegistration = true;
  bool obSecurePin = true;
  int selectedIndexDashBoard = 0;
  int selectedIndex=0;

  bool notificationAllow = false;
  bool touchIdAllowOrNot = false;
  bool locationAllow = false;
  bool setMaxSpendTransaction = true;
  String selectedCountry = 'SA';
  String currency = 'SAR';
  
  String selectedCountrySate = 'Select State';
  String selectedCountryCode = 'SA';
  String selectedCountryDialCode = '+966';
  ///////////User Location
  double userLat = 0.00;
  double userLng = 0.00;

  //////////////mobile contacts 
  List<Contact>? contacts;
  List<Contact>? filteredContacts;
  bool inviteAll = false;
  bool singleInvite = false;
  bool differentDevice = false;
  bool kidsSignUpFirstTime = false;
  String currentUserIdForBottomSheet = '';
  DateTime? time;
  ///////////User Model
  UserModel userModel = UserModel();
  NickNameModel nickNameModel = NickNameModel();
  FundMeWalletModel fundMeWalletModel = FundMeWalletModel();
  PersonalizationSettingModel? personalizationSettingModel = null;
  bool? isUserPinUser;

  int? themeId = 0;

  int? lengthOfList = -1;

  int? kidSelectedIndex = -1;
  static String? allonaceKidId = '';
  String alreadyExistUserNameErrorMessage = '';
  String alreadyExistEmailErrorMessage = '';
  int familyMmebersLength = 0;
  bool familymemberlimitreached = false;

  //////////User Goal Model
  GoalModel goal = GoalModel();
  PayRequestModel payRequestModel = PayRequestModel();

//   bool? imageUploadedHeader = false;
  bool? fromLogo = false;
  bool? forCardLockStatus = false;
  bool? isGirdView = false;
  bool? isLoginFirstTime = false;
  bool? onPinCodeScreen  = false;

  int? requestedMoneyListLength = 0;
  int? topFriendsListLength = 0;

  String? batchCounter;
  String selectedWallatFilter = '';
  CardTransation cardTransactionList = CardTransation(count: 0, startIndex: 0, endIndex: 0, isMore: false, data: []);

  int _attempts = 0;

  int get attempts => _attempts;
  // Required Google SignIn, X, Facebook, Apple SignIn
  bool isGoogleSignIn = googleSignIn;
  bool isFacebookSignIn = facebookSignIn;
  bool isAppleSignIn = appleSignIn;
  bool isXSignIn = xSignIn;
  bool isAiChat = aiChat;
  bool isShareFeature= shareFeature;

  // void updateTagItList( List<ImageModelTagIt> newtagItList){
  //   tagItList=newtagItList;
  
  // notifyListeners();
  // }
void isShareFeatureRequired(bool share) {
    isShareFeature=share;
    notifyListeners();
  }
  
void isGoogleSignInRequired(bool isSignIn) {
    isGoogleSignIn=isSignIn;
    notifyListeners();
  }
void isFacebookSignInRequired(bool isSignIn) {
    isFacebookSignIn=isSignIn;
    notifyListeners();
  }
  void isAppleSignInRequired(bool isSignIn) {
    isAppleSignIn=isSignIn;
    notifyListeners();
  }
  void isXSignInRequired(bool isSignIn) {
    isXSignIn=isSignIn;
    notifyListeners();
  }

  void isAiChatRequired(bool isChat) {
    isAiChat=isChat;
    notifyListeners();
  }
  void incrementAttempts(int attempt) {
    logMethod(title: 'Login Attempt', message: _attempts.toString());
    _attempts=attempt;
    notifyListeners();
  }

  void resetAttempts() {
    _attempts = 0;
    notifyListeners();
  }
  
  AppConstants() {
    logMethod(
        title: '++++++=====>>>>>>>> AppConsts created',
        message: '+++++++++<<<<<<=========');
  }
  
  updateStartIndex(int index){
    startIndex = index;
    notifyListeners();
  }
  updateCurrentUserIdForBottomSheet(String value){
    logMethod(title: 'Selected User For Bottom Sheet', message: '$value');
    currentUserIdForBottomSheet = value;
    notifyListeners();
  }
  updateLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
  updateTime({DateTime? dateTime}){
    time= dateTime;
    notifyListeners();
  }

  updateSelectedWalletFilter(String walletName){
    selectedWallatFilter = walletName;
    notifyListeners();
  }

  updateTransactionList(CardTransation transactionList){
    cardTransactionList = transactionList;
    notifyListeners();
  }

  updateRequestedMoneyLength(int? length) {
    
    requestedMoneyListLength = length;
    notifyListeners();
  }
  updateBatchCounter(String batch){
    batchCounter = batch;
    notifyListeners();
  }
   updateDetailTransactionModel(TransactionDetailModel model) {
    transactionDetailModel = model;
    notifyListeners();
  }

  updateTopFriendsListLength(int? length) {
    topFriendsListLength = length;
    notifyListeners();
  }

  updateSelectedCounteryState(String state) {
    selectedCountrySate = state;
    notifyListeners();
  }

  updateIsLoginFirstTime(bool? loginFirstTime) {
    isLoginFirstTime = loginFirstTime;
    notifyListeners();
  }
  
  updateUserOnLoginWithPinCodeScreen(bool? pinCodeScreen) {
    onPinCodeScreen = pinCodeScreen;
    notifyListeners();
  }

  updateIsGridView() {
    isGirdView = !isGirdView!;
    notifyListeners();
  }

  calculateFamilyMemberLength(int length) {
    familyMmebersLength = length;
    notifyListeners();
  }

  familyMemberLimitUpdate(bool value) {
    familymemberlimitreached = value;
    notifyListeners();
  }

  // USER_familymemberlimitreached
  updateIItfromAcoountOrNot(bool? fromOrNot) {
    fromAcoountOrNot = fromOrNot;
    notifyListeners();
  }

  alreadyExistUserNameErrorMessageUpdate(String msg) {
    alreadyExistUserNameErrorMessage = msg;
    notifyListeners();
  }

  alreadyExistEmailErrorMessageUpdate(String msg) {
    alreadyExistEmailErrorMessage = msg;
    notifyListeners();
  }

  updateFromWhoLoginPage(bool? from) {
    fromWhoLoginPage = from;
    notifyListeners();
  }

  updatePinEnable(bool? enabled) {
    pinEnable = enabled;
    notifyListeners();
  }

  updateFromReportAnIssue(bool? decission) {
    fromReportAnIssue = decission;
    notifyListeners();
  }

  updateSelectFromWallet({String? from}) {
    selectFromWallet = from!;
    notifyListeners();
  }

  updateSelectToWallet({String? to}) {
    selectToWallet = to!;
    notifyListeners();
  }

  updateSelectToWalletRealName({String? toRealName}) {
    selectToWalletRealName = toRealName!;
    notifyListeners();
  }

  updateSelectFromWalletRealName({String? fromRealName}) {
    selectFromWalletRealName = fromRealName!;
    notifyListeners();
  }

  updateComeFrom({bool? from}) {
    fromLogo = from;
    notifyListeners();
  }

  updateForCardLockStatus({bool? from}) {
    forCardLockStatus = from;
    notifyListeners();
  }

//
// updateImageUploadHeaderStatus({bool? imageStatus}){
//   imageUploadedHeader = imageStatus;
//   notifyListeners();
// }
  updateLengthOfList(int? length) {
    lengthOfList = length;
    notifyListeners();
  }

  updatePayRequestModel(PayRequestModel model) {
    payRequestModel = model;
    notifyListeners();
  }

  updateGoalModel(GoalModel model) {
    goal = model;
    notifyListeners();
  }

  updateAllonaceKidId(String? id) {
    allonaceKidId = id;
    notifyListeners();
  }

  updateKidSelectedIndex(int? index) {
    kidSelectedIndex = index;
    notifyListeners();
  }

  updateTheme(int? theme) {
    themeId = theme;
    notifyListeners();
  }

  updateUserModel(UserModel model) {
    userModel = model;
    notifyListeners();
  }

  updateNickNameModel(NickNameModel model) {
    nickNameModel = model;
    notifyListeners();
  }

  updateFundMeWalletModel(FundMeWalletModel model) {
    fundMeWalletModel = model;
    notifyListeners();
  }

  updatePersonalizationSettingModel(PersonalizationSettingModel? model) {
    personalizationSettingModel = model;
    notifyListeners();
  }

  updateKidsSignUpFirstTime(bool kidsSignUp) {
    kidsSignUpFirstTime = kidsSignUp;
    notifyListeners();
  }

  updateUserChildRegisteredId(String id) {
    userChildRegisteredId = id;
    notifyListeners();
  }

  updateAccountSettingUpFor(String accountFor) {
    accountSettingUpFor = accountFor;
    notifyListeners();
  }

  updateUserId(String id) {
    userRegisteredId = id;
    notifyListeners();
  }

  updateHaveKids(SingingCharacter? caha) {
    kids = caha;
    notifyListeners();
  }

  updateHaveKid(bool caha) {
    haveKid = caha;
    notifyListeners();
  }

  updateSignUpMethod(String method) {
    signUpMethod = method;
    notifyListeners();
  }

  updateKidsRegistrationList(List<Map<String, dynamic>> json) {
    kidsRegistrationList = json;
    notifyListeners();
  }

  updatePhoneNumber(String? number) {
    phoneNumber = number!;
    notifyListeners();
  }

  updateDifferentDeviceStatus(bool? deviceStatus) {
    differentDevice = deviceStatus!;
    notifyListeners();
  }

  updateToucheds(bool? isToucheds) {
    isTouchEnable = isToucheds!;
    notifyListeners();
  }

  updatePin(String? pins) {
    pin = pins!;
    notifyListeners();
  }

  updateExactPinCode(String? fullPinCode) {
    fullPin = fullPinCode!;
    notifyListeners();
  }

  updateExactFullPinConfirm(String? fullPinCode) {
    fullPinConfirm = fullPinCode!;
    notifyListeners();
  }

  updateUserName(String? userNames) {
    userName = userNames!;
    notifyListeners();
  }

  updateLastName(String? lastNames) {
    lastName = lastNames!;
    notifyListeners();
  }

  updateFirstName(String? firstNames) {
    firstName = firstNames!;
    notifyListeners();
  }
  updateEmailUsed(bool emailUsed) {
    logMethod(title: 'Email Used Status', message: emailUsed.toString());
    myEmailUsedStatus = emailUsed;
    notifyListeners();
  }
  

  updateZipCode(String? code) {
    zipCode = code!;
    notifyListeners();
  }

  updateIfUserIsPinUser(bool? pinUser) {
    isUserPinUser = pinUser!;
    notifyListeners();
  }

  updateIsEmailVerfied(bool? isEmailVerfieds) {
    isEmailVerfied = isEmailVerfieds!;
    notifyListeners();
  }

  updateEmail(String? emails) {
    email = emails!;
    notifyListeners();
  }

  updatePassword(String? passwords) {
    password = passwords!;
    notifyListeners();
  }

  updateSelectedAllocationIndex(int index) {
    selectedAllocationIndex = index;
    notifyListeners();
  }

  updateRegistrationCheckBox(bool? checkBox) {
    registrationCheckBox = checkBox;
    notifyListeners();
  }
  updateIssueDebitCardCheckBox(bool? checkBox) {
    issueDebitCardCheckBox = checkBox;
    notifyListeners();
  }
  

  updateAllowanceSchedule(String schedule) {
    allowanceSchedule = schedule;
    notifyListeners();
  }

  updateAllowanceDay(String day) {
    allowanceDay = day;
    notifyListeners();
  }

  updateSignUpRole(String role) {
    signUpRole = role;
    notifyListeners();
  }

  updateKidSignUpRole(String role) {
    kidSignUpRole = role;
    notifyListeners();
  }

  updateUserType(String type) {
    userType = type;
    notifyListeners();
  }

  updateDateOfBirth(String dob) {
    dateOfBirth = dob;
    notifyListeners();
  }

  updateDateOfBirthWithDate(DateTime? dob) {
    dateOfBirthWithDate = dob;
    notifyListeners();
  }

  updateAnniversaryDate(String dob) {
    anniversaryDate = dob;
    notifyListeners();
  }

  updateKidsLength(int length) {
    kidsLength = length;
    notifyListeners();
  }

  updateGenderType(String gender) {
    genderType = gender;
    notifyListeners();
  }

  updateHveKidsOrNot(String kids) {
    haveKids = kids;
    notifyListeners();
  }

  updateApplyToKids(bool kids) {
    applyToKids = kids;
    notifyListeners();
  }

  updatependingApprovales(String kids) {
    pendingApprovales = kids;
    notifyListeners();
  }

  updatekidsToPayFriends(bool kids) {
    kidsToPayFriends = kids;
    notifyListeners();
  }

  updatekidsToPublish(bool kids) {
    kidsToPublish = kids;
    notifyListeners();
  }

  updateslideToPay(bool kids) {
    slideToPay = kids;
    notifyListeners();
  }

  updatelockSaving(bool kids) {
    lockSaving = kids;
    notifyListeners();
  }

  updatelockCharity(bool kids) {
    lockCharity = kids;
    notifyListeners();
  }
  updateTestMode(bool mode) {
    appMode = mode;
    notifyListeners();
  }
  payfortTestingModeStatusForFundMyWallet(bool mode) {
    payFortTestingModeForFundMyWallet = mode;
    notifyListeners();
  }

  payfortTestingModeStatusForSubscription(bool mode) {
    payFortTestingModeForSubscription = mode;
    notifyListeners();
  }
  allowApplePayAndGooglePayMode(bool mode) {
    allowApplePayAndGooglePay = mode;
    notifyListeners();
  }
  
  
  updateDisableToDo(bool toDo) {
    disableToDo = toDo;
    notifyListeners();
  }

  updateNotificationAllow(bool notification) {
    notificationAllow = notification;
    notifyListeners();
  }
  updateTouchIdAllowOrNot(bool touchId) {
    touchIdAllowOrNot = touchId;
    notifyListeners();
  }
  // touchIdAllowOrNot

  updateMaximunSpendTransaction(bool transactionLimit) {
    setMaxSpendTransaction = transactionLimit;
    notifyListeners();
  }

  updateLocationAllow(bool location) {
    locationAllow = location;
    notifyListeners();
  }

  updateCountry(String countery) {
    selectedCountry = countery;
    notifyListeners();
  }

  updateCurrency(String curr) {
    currency = curr;
    notifyListeners();
  }

  

  updateSelectedCounteryCode(String code) {
    selectedCountryCode = code;
    notifyListeners();
  }

  updateSelectedCounteryDialCode(String code) {
    selectedCountryDialCode = code;
    notifyListeners();
  }

  Future getContact() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      // Get all contacts (lightly fetched)
      // List<Contact> contacts = await FlutterContacts.getContacts();

      // Get all contacts (fully fetched)
      logMethod(title: 'Contacts Loaded', message: 'Successfully');
      contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
          withThumbnail: false,
          
          deduplicateProperties: false);
      // contacts!.forEach((element) async{
      //   ApiServices services = ApiServices();
      //   var data = await services.isUserExist(number: element.phones.first.number);
      // });
      // print(contacts);
      filteredContacts = contacts;
      notifyListeners();
    }
  }

  void inviteAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      // contacts = await FlutterContacts.getContacts(
      //     withProperties: true, withPhoto: true);
      // print(contacts);
      contacts?.forEach((element) {
        element.isStarred = inviteAll;
      });
      notifyListeners();
    }
  }

  updateSlectedPrivacyTypeIndex(int index) {
    selectedPrivacyType = index;
    notifyListeners();
  }

  updateLatAndLng(double lat, double lng) {
    userLat = lat;
    userLng = lng;
    notifyListeners();
  }

  updateInviteAll(bool invite) {
    inviteAll = invite;
    notifyListeners();
  }

  updateSingleInvite(bool invite) {
    singleInvite = invite;
    notifyListeners();
  }

  updatedSelectedIndexDashBoard(int index) {
    selectedIndexDashBoard = index;
    notifyListeners();
  }
updateIndex(int index) {
  logMethod(title: 'Registered Index before assign', message: index.toString());
    selectedIndex = index;
    notifyListeners();
  logMethod(title: 'Registered Index before After', message: selectedIndex.toString());
  }
  

  updatePinLength(int length) {
    pinLength = length;
    notifyListeners();
  }

  updatePasswordVisibility(bool isVisible) {
    passwordVissible = !isVisible;
    notifyListeners();
  }

  updatePasswordVisibilityRegistartion(bool isVisible) {
    passwordVissibleRegistration = !isVisible;
    notifyListeners();
  }

  updatePinObsecure(bool obsecure) {
    obSecurePin = !obSecurePin;
    notifyListeners();
  }

  static containsKey(List<String> list) {}
}
