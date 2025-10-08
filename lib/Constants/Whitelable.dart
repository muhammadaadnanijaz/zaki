
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zaki/Constants/Styles.dart';

Color heading1Color = darkGrey;
Color heading2Color = green;
Color heading3Color = darkGrey;
Color heading4Color = lightGrey;
Color heading5Color = black;
Color appBarTextColor= black;

String INTIAL_BANK_ID = 'SA_01';
String INTIAL_COUNTRY_CODE = 'PK';
// Image Addresses
String INTIAL_imageBaseAddress = 'assets/images/';
String INTIAL_appLogosBaseAddress = 'assets/images/AppLogos/';
String INTIAL_userLogoBaseAddress = 'assets/images/userLogo/';
String INTIAL_userBackgroundImagesBaseAddress = 'assets/images/userBackgroundImages/';
String INTIAL_sendOrRequestImagesBaseAddress = 'assets/images/sendOrRequest/';
String INTIAL_cardImagesBaseAddress = 'assets/images/cardimages/';

String APPLICATION_LOGO='${INTIAL_appLogosBaseAddress}ZakiPay.png';
String APPLICATION_INTRO_VIDEO='${INTIAL_imageBaseAddress}intro_video.mp4';
String APPLICATION_LOADING_IMAGE='${INTIAL_appLogosBaseAddress}loading_screen_transparent.gif';
String APPLICATION_SUCCESS_BOY_IMAGE='${INTIAL_appLogosBaseAddress}success.png';
String APPLICATION_SUCCESS_MISSION_ACCOMPLISHED_IMAGE='${INTIAL_appLogosBaseAddress}mission_accomplished_body.png';

bool googleSignIn = true;
bool facebookSignIn = true;
bool appleSignIn = true;
bool xSignIn = true;
bool aiChat = true;
bool shareFeature = true;

TextStyle appFont(TextStyle style) {
  return GoogleFonts.lato(textStyle: style);
}

class NotificationText {
  static String NO_INTERNET_CONNECTION_MESSAGE = 'Oops NO internet! Limited Functionality. Reconnect.';
  static String ZAKI_PAY_JOINED_NOTIFICATION_TITLE = '🎊 joined ZakiPay.';
  static String ZAKI_PAY_JOINED_NOTIFICATION_SUB_TITLE =
      'Your buddy is now on Zakipay. Pay or request money and have fun!';
  static String PAY_REQUEST_CANCEL_NOTIFICATION_TITLE = 'Send Request Cancel';
  static String REQUEST_NOTIFICATION_TITLE = '🤑 Cash Requested from';
  static String PAY_REQUEST_CANCEL_NOTIFICATION_SUB_TITLE =
      'Send Request Cancel';

    static String PAY_NOTIFICATION_TITLE = '💰 Wow! Cash from';
  static String PAY_NOTIFICATION_SUB_TITLE = 'Your account was credited with';

  static String PAY_REQUEST_PAYED_NOTIFICATION_TITLE = 'Send Request Paid';
  static String PAY_REQUEST_PAYED_NOTIFICATION_SUB_TITLE =
      'Send Request Paid successfully';
  static String REQUEST_NOTIFICATION_SUB_TITLE =
      'Your friends is requesting for';

  static String GOAL_INVITED_NOTIFICATION_TITLE = '💰 Fund the goal of';
  static String GOAL_INVITED_NOTIFICATION_SUB_TITLE =
      'Help your friend raise money';
  static String GOAL_COMPLETED_NOTIFICATION_TITLE = '🌟 Hooray! Goal Achieved!';
  static String GOAL_COMPLETED_NOTIFICATION_SUB_TITLE = 'has hit their financial target. Time to bask in their success!';

  static String GOAL_EDIT_TITLE = 'Goal Editted';
  static String GOAL_EDIT_SUB_TITLE = 'User has Editted the Goal';

  static String PAYMENT_LOCKED = 'Not able to pay, Beacuse its locked';
  static String NOT_ENOUGH_BALANCE =
      'Not enough money :(  add funds to your wallet first';
  static String LOCK_WALLET =
      'If you need to move money from this wallet, you must ask your parents to “unlock it for you';

  static String NO_USER_SELECTED = 'Select User First';
  static String NO_USER_REGISTERED = 'You don\'t have an account connected with Zakipay';

  static String GOAL_PARENT_ADDED_TO_TITLE = '📅 New To-Do Arrived!';
  static String GOAL_PARENT_ADDED_TO_SUB_TITLE =
      'happily assigned you a new To Do...Chop Chop, get to work 🤩';

  static String GOAL_KID_COMPLTED_REWARD_TODO_TITLE = 'Completed a To Do! 🎯';
  static String GOAL_KID_COMPLTED_REWARD_TODO_SUB_TITLE =
      'His REWARD is pending your appoval 🌟.  Review Now! ';

  static String GOAL_PARENT_PAYED_REWARD_TODO_TITLE =
      'That\'s once nice REWARD 🌟 from';
  static String GOAL_PARENT_PAYED_REWARD_TODO_SUB_TITLE = 'Check out your updated Wallet Balance! Keep up the great work!';
      // '💰 Ka-ching! Your goal just received a financial boost.';

  static String ACTIVATE_CRAD_TITLE = '💳 Card Activated for';
  static String ACTIVATE_CARD_SUBTITLE = 'Good news! Your kid\'s card is activated. Let the financial adventures begin!';

  static String DE_ACTIVATE_CRAD_TITLE = '🕒 Card Timeout!';
  static String DE_ACTIVATE_CARD_SUBTITLE = 'card is temporarily deactivated. Financial break.';

  static String ADDED_SUCCESSFULLY = 'Data Added Successfully';
  static String UPDATED_SUCCESSFULLY = 'Updated Successfully';
  static String ENTER_PIN_CODE = 'Enter correct PIN Code';

  static String ENTER_PIN = 'Enter Pin';
  static String PIN_CODE_NOT_MATCHED = 'PIN Code does not match, Try Again';

  static String USER_UPDATED = 'Woohoo...User Updated!';

  static String AGE_LESS_THAN_18 = 'Age Should not be less than 18';
  static String AGE_13_TO_30 = 'Age Should not be between 13 to 30';
  static String AGE_UNDER_6 = 'Age Should not be less than 6';

  static String UNDER_AGE_CARD_NOT_ASSIGNED =
      'Card will not be assigned beacuse underage';
  static String USER_ADDED = 'Woohoo...User Added!';
  static String USER_REGISTERED_SUCCESS = 'User Registered Successfully';
  static String NO_PHONE_REGISTERED = 'Phone number not registered, Try again';

  static String WALLET_SETUP = 'Wallet setup successfully!';
  static String EMAIL_VERIFIED = 'Email Verified';

  static String WALLET_UPDATED = 'ZakiPay Wallet updated';

  static String CARD_ASSIGN = 'Card added';
  static String CARD_ASSIGN_ERROR = 'Their is a problem While card added';
  static String USER_TOKEN = 'User added Token:';
  static String ENTER_AMOUNT = 'Enter Amount first';
  static String AMOUNT_ADDED = 'Amount Added';
  static String GOAL_AMOUNT_ADDED = 'Woohoo...Success!';
  static String REQUEST_SEND = 'Request Sent';
  static String LIMIT_REACHED = 'Not enough Lmit';

  static String DELETED = 'Deleted Successfully';
  static String ALLOWANCE_100_PER_ERROR = '100% ?, Maypbe not';
  static String ALLOWANCE_ADDED_TITLE = 'Wooho! 🌟 "Allowance Arrived"';
  static String ALLOWANCE_ADDED_SUBTITLE = 'Your allowance just landed! Ready to make some smart money moves?';
  
  static String ALLOWANCE_UPDATED = 'Allowance Updated';


  static String PIN_MULTIPLE_ATTEMPTS_ERROR = 'Incorrect PIN. Attempts:';
  static String PIN_TO_MANY_ATTEMPTS_ERROR = 'Too many attempts';
  static String TEMP_LOCKED = 'Too many attempts, ';
  static String TEMP_BLOCKED_TEXT = 'You!re blocked for: ';


  static String THRITY_MIN_PASSED_ERROR = 'You are logged in into different deveice. Problem!!!';
  
  
}
