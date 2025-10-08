import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/LocationGetting.dart';
import 'package:zaki/Constants/Whitelable.dart';
import 'package:zaki/Models/PayRequestsModel.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Services/future_flags.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';

class SendMoneyFlowController {
  static Future<SendMoneyResult> send({
    required BuildContext context,
    required AppConstants appConstants,
    required String toUserId,
    required String selectedKidName,
    required String selectedKidImageUrl,
    required String receiverGender,
    required String receiverUserType,
    required int tagId,
    required String imagePath,
    required String message,
    required String amount,
  }) async {
    final isAllowed = PaymentValidator.canSendMoney(appConstants);
    if (!isAllowed) {
      return SendMoneyResult.errorResult("Sending money is locked by settings.");
    }

    final isAuthenticated = await authenticateTransactionUsingBioOrPinCode(
      context: context,
      appConstants: appConstants,
    );
    if (isAuthenticated != true) {
      // return SendMoneyResult.errorResult("Authentication failed.");
    }

    final transactionId = const Uuid().v1();
    final userLocation = await UserLocation().determinePosition();
    final mode = FeatureFlags.has(context, 'feature.bankIntegration')
        ? PaymentMode.full
        : PaymentMode.lite;

    final validationError = await PaymentValidator.validate(
      appConstants: appConstants,
      amount: amount,
      toUserId: toUserId,
      mode: mode,
    );
    if (validationError != null) {
      return SendMoneyResult.errorResult(validationError);
    }

    final model = PayRequestModel(
      isFromReview: false,
      senderImageUrl: appConstants.userModel.usaLogo,
      receiverGender: receiverGender,
      selectedKidName: selectedKidName,
      receiverUserType: receiverUserType,
      selectedKidImageUrl: selectedKidImageUrl,
      accountHolderName: appConstants.userModel.usaFirstName,
      accountType: '',
      tagItId: tagId.toString(),
      tagItName: AppConstants.tagItList[tagId].title,
      amount: amount,
      fromUserId: appConstants.userRegisteredId,
      imageUrl: imagePath,
      message: message,
      requestType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
      toUserId: toUserId,
    );
    appConstants.updatePayRequestModel(model);

    final invitedUsers = await PrivacyService.getVisibleUsers(
      userId: appConstants.userRegisteredId,
      receiverId: toUserId,
      privacyType: appConstants.selectedPrivacyType,
    );

    final progressDialog = CustomProgressDialog(context, blur: 6);
    progressDialog.setLoadingWidget(CustomLoadingScreen());
    progressDialog.show();

    final result = await MoneyTransferService.sendMoney(
      mode: mode,
      appConstants: appConstants,
      model: model,
      tagId: tagId,
      transactionId: transactionId,
      userLocation: userLocation,
    );

    if (!result.success) {
      progressDialog.dismiss();
      return result;
    }

    await ApiServices().addSocialFeed(
      likesList: [],
      usersList: invitedUsers,
      selectedKidImageUrl: model.selectedKidImageUrl,
      selectedKidName: model.selectedKidName,
      senderImageUrl: model.senderImageUrl,
      requestType: model.requestType,
      privacy: appConstants.selectedPrivacyType,
      accountHolderName: appConstants.userModel.usaUserName,
      message: model.message,
      accountType: '',
      tagItId: model.tagItId,
      tagItName: model.tagItName,
      amount: model.amount,
      imageUrl: model.imageUrl,
      receiverId: model.toUserId,
      senderId: model.fromUserId,
      transactionId: transactionId,
    );

    await ApiServices().getUserTokenAndSendNotification(
      userId: toUserId,
      title:
          '${NotificationText.PAY_NOTIFICATION_TITLE} ${appConstants.userModel.usaUserName}',
      subTitle:
          '${NotificationText.PAY_NOTIFICATION_SUB_TITLE} ${getCurrencySymbol(context, appConstants: appConstants)} $amount',
      checkParent: true,
      parentTitle:
          '${appConstants.userModel.usaUserName} sent ${getCurrencySymbol(context, appConstants: appConstants)} $amount',
      parentSubtitle: 'See Details in ZakiPay',
    );

    progressDialog.dismiss();
    return SendMoneyResult.successResult();
  }
}

class MoneyTransferService {
  static Future<SendMoneyResult> sendMoney({
    required PaymentMode mode,
    required AppConstants appConstants,
    required PayRequestModel model,
    required int tagId,
    required String transactionId,
    required Position userLocation,
  }) async {
    if (model.imageUrl!.contains('bank_of_punjab')) {
      final fullPath = '${appConstants.userModel.usaCountry}/sendreceive/${appConstants.userRegisteredId}/images';
      final uploadedPath = await ApiServices().uploadImage(
        fullPath: fullPath,
        path: model.imageUrl,
        userId: appConstants.userRegisteredId,
      );
      model.imageUrl = uploadedPath;
      appConstants.updatePayRequestModel(model);
    }

    if (mode == PaymentMode.full) {
      final api = CreaditCardApi();
      await api.moveMoney(
        amount: model.amount,
        name: model.accountHolderName,
        senderUserToken: appConstants.userModel.userTokenId,
        receiverUserToken: "selectedKidBankToken",
        tags: createMemo(
          fromWallet: AppConstants.Spend_Wallet,
          toWallet: AppConstants.Spend_Wallet,
          transactionMethod: AppConstants.Transaction_Method_Received,
          tagItId: model.tagItId,
          tagItName: model.tagItName,
          goalId: '',
          transactionType: AppConstants.TAG_IT_Transaction_TYPE_SEND_OR_REQUEST,
          receiverId: model.toUserId,
          senderId: model.fromUserId,
          transactionId: transactionId,
          latLng: '${userLocation.latitude},${userLocation.longitude}',
        ),
      );
    }

    await ApiServices().payPlusMoney(
      likesList: [],
      selectedKidImageUrl: model.selectedKidImageUrl,
      selectedKidName: model.selectedKidName,
      senderImageUrl: model.senderImageUrl,
      requestType: model.requestType,
      privacy: appConstants.selectedPrivacyType,
      accountHolderName: model.accountHolderName,
      message: model.message,
      accountType: '',
      tagItId: model.tagItId,
      tagItName: model.tagItName,
      amount: model.amount,
      imageUrl: model.imageUrl,
      toUserId: model.toUserId,
      currentUserId: appConstants.userRegisteredId,
      transactionId: transactionId,
    );

    return SendMoneyResult.successResult();
  }
}

class PaymentValidator {
  static bool canSendMoney(AppConstants appConstants) {
    return appConstants.personalizationSettingModel?.kidPKid2PayFriends != false;
  }

  static Future<String?> validate({
    required AppConstants appConstants,
    required String amount,
    required String toUserId,
    required PaymentMode mode,
  }) async {
    final parsedAmount = double.tryParse(amount.trim()) ?? 0;
    final services = ApiServices();

    if (mode == PaymentMode.full) {
      final balance = await CreaditCardApi().checkBalance(userToken: appConstants.userModel.userTokenId);
      if (balance == null || balance.gpa.availableBalance < parsedAmount) {
        return NotificationText.NOT_ENOUGH_BALANCE;
      }

      final limits = await services.getKidSpendingLimit(
        appConstants.userModel.userFamilyId.toString(),
        appConstants.userRegisteredId,
      );

      if (limits != null &&
          parsedAmount > limits[AppConstants.SpendL_Transaction_Amount_Max]) {
        return NotificationText.LIMIT_REACHED;
      }
    } else {
      final hasBalance = await services.checkWalletHasAmount(
        amount: parsedAmount,
        userId: appConstants.userRegisteredId,
        fromWalletName: AppConstants.Spend_Wallet,
      );
      if (hasBalance == true) {
        return NotificationText.NOT_ENOUGH_BALANCE;
      }
    }

    return null;
  }
}

enum PaymentMode { full, lite }

class SendMoneyResult {
  final bool success;
  final String? error;

  SendMoneyResult._(this.success, this.error);

  static SendMoneyResult successResult() => SendMoneyResult._(true, null);
  static SendMoneyResult errorResult(String error) => SendMoneyResult._(false, error);
}

class PrivacyService {
  /// Returns the list of user IDs who should be included in the social visibility
  /// (e.g. friends, family, or direct only).
  static Future<List<String>> getVisibleUsers({
    required String userId,
    required String receiverId,
    required int privacyType,
  }) async {
    final services = ApiServices();

    switch (privacyType) {
      case 2: // Friends
        final senderFriends = await services.getUserFriendsList(userId);
        final receiverFriends = await services.getUserFriendsList(receiverId);
        return {
          ...senderFriends,
          ...receiverFriends,
          userId,
        }.toList();

      case 3: // Family
        final userKids = await services.getUserKids(userId);
        return {
          ...userKids,
          userId,
        }.toList();

      case 4: // Just me and receiver
        return [userId, receiverId];

      default: // Public or no one
        return [];
    }
  }
}


