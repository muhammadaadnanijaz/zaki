import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:us_states/us_states.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/AuthMethods.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Screens/AddFamilyMember.dart';
import 'package:zaki/Services/CreaditCardApis.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Widgets/SelectCouneryState.dart';
import 'package:zaki/Widgets/StateSuffixIcon.dart';
import 'package:zaki/Widgets/TermsAndConditions.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
// Create a GlobalKey for FormState to validate the form
// final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class AddMemberWorkFlow extends StatefulWidget {
  final bool? fromDebitcard;
  const AddMemberWorkFlow({Key? key, this.fromDebitcard}) : super(key: key);

  @override
  State<AddMemberWorkFlow> createState() => _AddMemberWorkFlowState();
}

class _AddMemberWorkFlowState extends State<AddMemberWorkFlow> {
  List<FormData> forms = [];
  bool _obscureText = true;
  Stream<QuerySnapshot>? userKids;
  final ExpansionTileController expansionTileController =
      ExpansionTileController();
  final ExpansionTileController expansionTileKidsController =
      ExpansionTileController();

  void handleValidation(int index) {
    print("Hnadling data}");
    FormData data = forms[index];
    print("First Name: ${data.firstName}");
    print("Last Name: ${data.lastName}");
    print("Phone Number: ${data.phoneNumber}");
  }

  // late SignUpVia? signUpThrough = SignUpVia.number;
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneOrEmailNameController = TextEditingController();
  final stateController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  DateTime now = DateTime.now();
  late DateTime firstDate;
  late DateTime lastDate;
  // bool _isExpanded=false;

  String alreadyExist = '';
  var roleList = [
    'Husband',
    'Wife',
    'Son',
    'Daughter',
    'An Adult',
    'A Kid',
  ];
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneOrEmailNameController.dispose();
    super.dispose();
  }

  void clearFields() {
    firstNameController.text = '';
    lastNameController.text = '';
    phoneOrEmailNameController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setScreenName(name: AppConstants.SETUP_WALLET_AND_CARD);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      if (appConstants.userModel.usaUserType == AppConstants.USER_TYPE_SINGLE) {
        appConstants.updateIssueDebitCardCheckBox(true);
      }
      userKids = ApiServices().fetchUserKids(
          appConstants.userModel.seeKids == true
              ? appConstants.userModel.userFamilyId!
              : appConstants.userRegisteredId,
          currentUserId: appConstants.userRegisteredId,
          subscriptionValue: false);
      appConstants.updateDateOfBirth('dd / mm / yyyy');
      if (appConstants.userModel.usaUserType == AppConstants.USER_TYPE_PARENT ||
          appConstants.userModel.usaUserType == AppConstants.USER_TYPE_SINGLE) {
        firstDate = DateTime(now.year - 80, now.month, now.day);
        lastDate = DateTime(now.year - 18, now.month, now.day);
      } else if (appConstants.userModel.usaUserType ==
          AppConstants.USER_TYPE_KID) {
        firstDate = DateTime(now.year - 30, now.month, now.day);
        lastDate = DateTime(now.year - 8, now.month, now.day);
      } else {
        // For 'single' or any other types, define your logic here
        firstDate = DateTime(now.year - 80, now.month, now.day);
        lastDate = DateTime.now(); // or any other end date
      }
      setState(() {});

      if (appConstants.kidsLength == 0 ||
          appConstants.userModel.subScriptionValue! < 2) {
        expansionTileController.expand();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              children: [
                appBarHeader_005( 
                    context: context,
                    requiredHeader: false,
                    appBarTitle: 'Setup Wallet & Card',
                    backArrow: false,
                    width: width),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: appConstants.userModel.subScriptionValue == 3
                              ? white
                              : green.withOpacity(0.3),
                          width: appConstants.userModel.subScriptionValue == 3
                              ? 0
                              : 1)),
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(dividerColor: transparent),
                    child: ExpansionTile(
                      // key: UniqueKey(),
                      // initiallyExpanded: _isExpanded,
                      controller: expansionTileController,
                
                      maintainState: true,
                      // backgroundColor: Colors.red,
                      // collapsedBackgroundColor: Colors.yellow,
                      // shape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      // collapsedShape: roundedBorderCustom(sunscriptionValue: appConstants.userModel.subScriptionValue),
                      onExpansionChanged: (value) {},
                      childrenPadding: getCustomPadding(),
                      iconColor: green,
                      trailing: appConstants.userModel.subScriptionValue == 3
                          ? Icon(
                              Icons.done,
                              color: grey.withOpacity(0.6),
                            )
                          : null,
                      // initiallyExpanded: appConstants.userModel.subScriptionValue==2?false:true ,
                      title: Text(
                        '${appConstants.userModel.usaFirstName}',
                        style: heading1TextStyle(context, width,
                            color:
                                appConstants.userModel.subScriptionValue == 3
                                    ? grey.withOpacity(0.6)
                                    : grey),
                      ),
                      children: [
                        (appConstants.userModel.subScriptionValue == 3)
                            ? const SizedBox()
                            : Form(
                                autovalidateMode: AutovalidateMode.disabled,
                                key: formGlobalKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    spacing_small,
                                    Text(
                                      'About Me:',
                                      style: heading1TextStyle(context, width,
                                          color: green),
                                    ),
                                    spacing_medium,
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter Name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: firstNameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      maxLength: 15,
                                      onChanged: (String username) {},
                                      decoration: InputDecoration(
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        counterText: "",
                                        isDense: true,
                                        hintText: 'Legal First Name',
                                        hintStyle: heading3TextStyle(width,
                                            color: grey),
                                      ),
                                    ),
                                    spacing_medium,
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter Last Name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: lastNameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      maxLength: 15,
                                      onChanged: (String username) {},
                                      decoration: InputDecoration(
                                        counterText: '',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        hintText: 'Legal Last Name',
                                        hintStyle: heading3TextStyle(width,
                                            color: grey),
                                      ),
                                    ),
                                    spacing_medium,
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: grey.withOpacity(0.4))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ListTile(
                                          dense: true,
                                          onTap: () async {
                                            DateTime? dateTime =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        lastDate, // or any initial date within the range
                                                    firstDate: firstDate,
                                                    lastDate: lastDate,
                                                    selectableDayPredicate:
                                                        (DateTime val) {
                                                      if ((val.isAfter(
                                                                  firstDate) ||
                                                              val.isAtSameMomentAs(
                                                                  firstDate)) &&
                                                          (val.isBefore(
                                                                  lastDate) ||
                                                              val.isAtSameMomentAs(
                                                                  lastDate))) {
                                                        return true;
                                                      }
                                                      return false;
                                                    },
                                                    builder:
                                                        (context, child) {
                                                      return Theme(
                                                        data:
                                                            Theme.of(context)
                                                                .copyWith(
                                                          colorScheme:
                                                              ColorScheme
                                                                  .light(
                                                            primary: green,
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                    initialEntryMode:
                                                        DatePickerEntryMode
                                                            .calendar);
                                            if (dateTime != null) {
                                              if (calculateAge(
                                                      birthDate: dateTime) <
                                                  6) {
                                                showNotification(
                                                    error: 1,
                                                    icon: Icons.date_range,
                                                    message: NotificationText
                                                        .AGE_UNDER_6);
                                                return;
                                              }
                                              appConstants.updateDateOfBirth(
                                                  '${dateTime.day} / ${dateTime.month} / ${dateTime.year}');
                                            }
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            appConstants.dateOfBirth,
                                            overflow: TextOverflow.clip,
                                            style: heading3TextStyle(width,
                                                color: grey),
                                          ),
                                          trailing: const Icon(
                                              Icons.calendar_today_rounded),
                                        ),
                                      ),
                                    ),
                                    // Divider(
                                    //   color: black,
                                    //   height: 0.3,
                                    // ),
                                    spacing_medium,
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 15,
                                      obscureText: _obscureText,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                        ssnMaskFormatter
                                      ],
                
                                      validator: (String? state) {
                                        // return null;
                                        if (state!.isEmpty) {
                                          return 'Enter Security Number';
                                        } else if (state.length < 11) {
                                          return 'Enter Full Social security Number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // obscureText: true,
                                      decoration: InputDecoration(
                                          counterText: '',
                                          isDense: true,
                                          border: circularOutLineBorder,
                                          enabledBorder:
                                              circularOutLineBorder,
                                          hintText: 'Social Security Number',
                                          hintStyle: heading3TextStyle(width,
                                              color: grey),
                                          suffixIconColor: grey,
                                          contentPadding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 12),
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                },
                                                child: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off)),
                                          )),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: ssnController,
                                      // obscureText: appConstants.passwordVissibleRegistration,
                                      keyboardType: TextInputType.number,
                                    ),
                                    spacing_large,
                                    Text(
                                      'Home Address:',
                                      style: heading1TextStyle(context, width,
                                          color: green),
                                    ),
                                    spacing_medium,
                                    //  TextHeader1(title: 'Street Address'),
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled: true,
                                      validator: (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a Street Address';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: streetAddressController,
                                      obscureText: false,
                                      keyboardType:
                                          TextInputType.streetAddress,
                                      maxLines: 1,
                                      maxLength: 40,
                                      decoration: InputDecoration(
                                        hintText: 'Street Address',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        counterText: '',
                                        hintStyle: heading3TextStyle(width,
                                            color: grey),
                                      ),
                                    ),
                                    spacing_medium,
                                    // TextHeader1(title: 'Apartment or Suite (Optional)'),
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled: true,
                                      // validator: (String? name) {
                                      // if (name!.isEmpty) {
                                      //   return 'Enter a Street Adress';
                                      // } else {
                                      // return null;
                                      // }
                                      // },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: appartOrSuitController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      maxLength: 40,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Apartment or Suite (Optional)',
                                        counterText: '',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        hintStyle: heading3TextStyle(width,
                                            color: grey),
                                      ),
                                    ),
                                    spacing_medium,
                
                                    // TextHeader1(title: 'City'),
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      // readOnly:   true: false,
                                      enabled: true,
                                      validator: (String? name) {
                                        if (name!.isEmpty) {
                                          return 'Enter a City Name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      // style: TextStyle(color: primaryColor),
                                      style: heading3TextStyle(width,
                                          color: grey),
                                      controller: cityController,
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      maxLines: 1,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                        hintText: 'City',
                                        counterText: '',
                                        isDense: true,
                                        border: circularOutLineBorder,
                                        enabledBorder: circularOutLineBorder,
                                        hintStyle: heading3TextStyle(width,
                                            color: grey),
                                      ),
                                    ),
                                    spacing_medium,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLength: 5,
                                            // inputFormatters: [
                                            //   FilteringTextInputFormatter.digitsOnly
                                            // ],
                                            validator: (String? state) {
                                              // return null;
                
                                              if (state!.isEmpty) {
                                                return 'Enter state';
                                              } else {
                                                return null;
                                              }
                                            },
                                            // obscureText: true,
                                            onTap: () async {
                                              // String data =
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SelectCounteryState(
                                                    listItems: USStates
                                                        .getAllNames(),
                                                  );
                                                },
                                              );
                                              stateController.text =
                                                  appConstants
                                                      .selectedCountrySate;
                                            },
                                            // enabled: false,
                                            enableInteractiveSelection: false,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              isDense: true,
                                              border: circularOutLineBorder,
                                              enabledBorder:
                                                  circularOutLineBorder,
                                              hintText: 'State',
                                              suffixIcon: StateSuffixIcon(),
                                              hintStyle: heading3TextStyle(
                                                  width,
                                                  color: grey),
                                            ),
                                            style: heading3TextStyle(width,
                                                color: grey),
                                            controller: stateController,
                                            // obscureText: appConstants.passwordVissibleRegistration,
                                            keyboardType: TextInputType.name,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            maxLength: 5,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (String? zipCode) {
                                              // return null;
                
                                              if (zipCode!.isEmpty) {
                                                return 'Enter ZipCode';
                                              } else if (zipCode.length < 5) {
                                                return 'Enter Full ZipCode';
                                              } else {
                                                return null;
                                              }
                                            },
                                            // obscureText: true,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              isDense: true,
                                              border: circularOutLineBorder,
                                              enabledBorder:
                                                  circularOutLineBorder,
                                              hintText: 'Zip Code',
                                              hintStyle: heading3TextStyle(
                                                  width,
                                                  color: grey),
                                            ),
                                            style: heading3TextStyle(width,
                                                color: grey),
                                            controller: zipCodeController,
                                            // obscureText: appConstants.passwordVissibleRegistration,
                                            keyboardType:
                                                TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    spacing_medium,
                                    Row(
                                      children: [
                                        Checkbox(
                                            activeColor: green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            value: appConstants
                                                .issueDebitCardCheckBox,
                                            onChanged: (value) {
                                              appConstants
                                                  .updateIssueDebitCardCheckBox(
                                                      value);
                                            }),
                                        TextValue3(
                                          title: 'Issue a debit card',
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            activeColor: green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            value: appConstants
                                                .registrationCheckBox,
                                            onChanged: (value) {
                                              appConstants
                                                  .updateRegistrationCheckBox(
                                                      value);
                                            }),
                                        TermsAndConditions(width: width)
                                      ],
                                    ),
                                    spacing_medium,
                                    ZakiPrimaryButton(
                                        width: width,
                                        title: 'Setup',
                                        onPressed:
                                            (firstNameController
                                                        .text.isEmpty ||
                                                    lastNameController
                                                        .text.isEmpty ||
                                                    appConstants
                                                            .dateOfBirth ==
                                                        'dd / mm / yyyy' ||
                                                    appConstants.registrationCheckBox ==
                                                        false ||
                                                    firstNameController
                                                        .text.isEmpty ||
                                                    lastNameController
                                                        .text.isEmpty ||
                                                    cityController
                                                        .text.isEmpty ||
                                                    stateController
                                                        .text.isEmpty ||
                                                    ssnController
                                                            .text.length <
                                                        11 ||
                                                    zipCodeController
                                                            .text.length <
                                                        5)
                                                ? null
                                                : () async {
                                                    ApiServices services =
                                                        ApiServices();
                                                    // if (signUpThrough!.index == 0) {
                                                    if (!formGlobalKey
                                                        .currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    bool? checkAuth =
                                                        await authenticateTransactionUsingBioOrPinCode(
                                                            appConstants:
                                                                appConstants,
                                                            context: context);
                                                    if (checkAuth == false) {
                                                      return;
                                                    }
                                                    // else {
                                                    // List mobileDevices = [
                                                    //   await services.getDeviceId()
                                                    // ];
                                                    CustomProgressDialog
                                                        progressDialog =
                                                        CustomProgressDialog(
                                                            context,
                                                            blur: 6);
                                                    progressDialog
                                                        .setLoadingWidget(
                                                            CustomLoadingScreen());
                                                    progressDialog.show();
                
                                                    CreaditCardApi
                                                        creaditCardApi =
                                                        CreaditCardApi();
                
                                                    if (appConstants.userModel
                                                                .subScriptionValue ==
                                                            0 ||
                                                        appConstants.userModel
                                                                .subScriptionValue ==
                                                            null) {}
                                                    String? userToken = await creaditCardApi
                                                        .createUserForCard(
                                                            gender: 'M',
                                                            city: cityController
                                                                .text
                                                                .trim(),
                                                            country: 'US',
                                                            // email: emailAddressController.text.trim(),
                                                            firstName:
                                                                firstNameController
                                                                    .text,
                                                            lastName:
                                                                lastNameController
                                                                    .text,
                                                            password: '',
                                                            address1:
                                                                streetAddressController
                                                                    .text
                                                                    .trim(),
                                                            phoneNumber:
                                                                appConstants
                                                                    .userModel
                                                                    .usaPhoneNumber,
                                                            postalCode:
                                                                zipCodeController
                                                                    .text
                                                                    .trim(),
                                                            state:
                                                                stateController
                                                                    .text,
                                                            useParentAccount:
                                                                false
                                                            // useParentAccount: widget.selectedUserId==appConstants.userRegisteredId?false:true
                                                            );
                                                    if (userToken != null) {
                                                      await services
                                                          .addUserTokenBankApi(
                                                              appConstants
                                                                  .userRegisteredId,
                                                              userToken,
                                                              value: 2);
                                                      if (appConstants
                                                              .issueDebitCardCheckBox ==
                                                          true) {
                                                        String? cardProductToken = await creaditCardApi.createCardProduct(
                                                            city: cityController
                                                                .text
                                                                .trim(),
                                                            country: 'US',
                                                            firstName:
                                                                firstNameController
                                                                    .text,
                                                            lastName:
                                                                lastNameController
                                                                    .text,
                                                            address1:
                                                                streetAddressController
                                                                    .text
                                                                    .trim(),
                                                            phoneNumber:
                                                                appConstants
                                                                    .userModel
                                                                    .usaPhoneNumber,
                                                            postalCode:
                                                                zipCodeController
                                                                    .text
                                                                    .trim(),
                                                            state:
                                                                stateController
                                                                    .text,
                                                            userToken:
                                                                userToken);
                                                        if (cardProductToken !=
                                                            null) {
                                                          String? cardToken =
                                                              await creaditCardApi.card(
                                                                  userToken:
                                                                      userToken,
                                                                  cardProductToken:
                                                                      cardProductToken);
                                                          ApiServices
                                                              services =
                                                              ApiServices();
                                                          // logMethod(title: 'Id is: ', message: selectedUserId);
                                                          await services.issueCard(
                                                              parentId: appConstants
                                                                  .userRegisteredId,
                                                              dateOfBirth: appConstants
                                                                  .dateOfBirth,
                                                              firstName:
                                                                  firstNameController
                                                                      .text,
                                                              lastName:
                                                                  lastNameController
                                                                      .text,
                                                              phoneNumber: '',
                                                              userId: appConstants
                                                                  .userRegisteredId,
                                                              apartmentOrSuit:
                                                                  appartOrSuitController
                                                                      .text
                                                                      .trim(),
                                                              city: cityController
                                                                  .text
                                                                  .trim(),
                                                              ssnNumber: int.parse(
                                                                  getPhoneNumber(
                                                                      number: ssnController.text
                                                                          .trim())),
                                                              state: stateController
                                                                  .text
                                                                  .trim(),
                                                              streetAddress:
                                                                  streetAddressController.text.trim(),
                                                              zipCode: int.parse(zipCodeController.text.trim()),
                                                              cardToken: cardToken,
                                                              userToken: userToken);
                                                          await services
                                                              .addUserTokenBankApi(
                                                                  appConstants
                                                                      .userRegisteredId
                                                                      .toString(),
                                                                  userToken,
                                                                  value: 3);
                                                        }
                                                      }
                                                    }
                                                    Future.delayed(
                                                        Duration(seconds: 2),
                                                        () async {
                                                      await services.getUserData(
                                                          userId: appConstants
                                                              .userRegisteredId,
                                                          context: context);
                                                    });
                
                                                    expansionTileController
                                                        .collapse();
                                                    if (widget
                                                            .fromDebitcard ==
                                                        true) {
                                                      Navigator.pop(
                                                          context, 'success');
                                                      return;
                                                    }
                                                    ///////////////Now we need to add Assign user a card if
                                                    ///issue debit card is checked
                                                    // services.newUserCreateDbDefault(gender: appConstants.genderType, parentId: appConstants.userRegisteredId, status: appConstants.signUpRole, userId: await userPref.getCurrentUserId());
                                                    showNotification(
                                                        error: 0,
                                                        icon: Icons.check,
                                                        message:
                                                            NotificationText
                                                                .WALLET_SETUP);
                                                    // Navigator.pop(context);
                                                    progressDialog.dismiss();
                                                    return;
                                                    // }
                                                    // } else {
                                                    // if (!formGlobalKey.currentState!
                                                    //     .validate()) {
                                                    //   return;
                                                    // }
                                                    // appConstants.updateFirstName(
                                                    //     firstNameController.text);
                                                    // appConstants.updateLastName(
                                                    //     lastNameController.text);
                                                    // // var respose = await
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             const PinCodeSetUp(
                                                    //               fromKidsSignUpPage: 0,
                                                    //             )));
                                                    // if (respose == "Matched") {
                                                    //   ApiServices service = ApiServices();
                                                    //   List mobileDevices = [await service.getDeviceId()];
                                                    //   UserPreferences userPref = UserPreferences();
                                                    //   await service.addUserToDatabase(
                                                    //       isPinUser: true,
                                                    //       zipCode: '',
                                                    //       deviceId: mobileDevices,
                                                    //       parentId: await userPref.getCurrentUserId(),
                                                    //       email: '',
                                                    //       firstName: firstNameController.text,
                                                    //       lastName: lastNameController.text,
                                                    //       password: '',
                                                    //       status: appConstants.signUpRole,
                                                    //       city: '',
                                                    //       country: appConstants.selectedCountry,
                                                    //       currency: 'US',
                                                    //       dob: appConstants.dateOfBirth,
                                                    //       gender: appConstants.genderType,
                                                    //       isEmailVerified: false,
                                                    //       latLng: '',
                                                    //       locationStatus: true,
                                                    //       method: appConstants.signUpMethod,
                                                    //       notificationStatus: true,
                                                    //       phoneNumber: '',
                                                    //       pinCode: appConstants.pin.toString(),
                                                    //       pinEnabled: true,
                                                    //       pinLength: appConstants.pinLength,
                                                    //       userName: '',
                                                    //       touchEnable: appConstants.isTouchEnable,
                                                    //       isEnabled: false);
                                                    //   showNotification(
                                                    //       error: 0,
                                                    //       icon: Icons.check,
                                                    //       message: 'Kid Added Successfully');
                                                    //   Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //         builder: (context) => ConfirmedScreen(
                                                    //             name: firstNameController.text.toString()),
                                                    //       ));
                                                    // }
                                                    // }
                                                  }),
                                    spacing_medium
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                spacing_small,
                userKids == null
                    ? const SizedBox()
                    : StreamBuilder<QuerySnapshot>(
                        stream: userKids,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Ooops, Something went wrong!');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("");
                          }
                          if (snapshot.data!.size == 0) {
                            return SizedBox.shrink();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Card(
                                  elevation: snapshot.data!.docs[index][
                                              AppConstants
                                                  .USER_SubscriptionValue] ==
                                          3
                                      ? 0
                                      : 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    // side: BorderSide(color: grey)
                                    //set border radius more than 50% of height and width to make circle
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: snapshot.data!.docs[index][
                                                        AppConstants
                                                            .USER_SubscriptionValue] ==
                                                    3
                                                ? white
                                                : green.withOpacity(0.3),
                                            width: snapshot.data!.docs[index][
                                                        AppConstants
                                                            .USER_SubscriptionValue] ==
                                                    3
                                                ? 0
                                                : 1)),
                                    child: Theme(
                                      data: Theme.of(context)
                                          .copyWith(dividerColor: transparent),
                                      child: ExpansionTile(
                                        // key: UniqueKey(),
                                        maintainState: true,
                                        onExpansionChanged: (value) {},
                                        childrenPadding: getCustomPadding(),
                                        title: Text(
                                          '${snapshot.data!.docs[index][AppConstants.USER_first_name]}',
                                          style: heading1TextStyle(
                                              context, width,
                                              color: snapshot.data!.docs[index][
                                                          AppConstants
                                                              .USER_SubscriptionValue] ==
                                                      3
                                                  ? grey.withOpacity(0.6)
                                                  : grey),
                                        ),
                                        trailing: snapshot.data!.docs[index][
                                                    AppConstants
                                                        .USER_SubscriptionValue] ==
                                                3
                                            ? Icon(Icons.done,
                                                color: grey.withOpacity(0.6))
                                            : null,
                                        iconColor: green,
                                        children: [
                                          snapshot.data!.docs[index][
                                                      AppConstants
                                                          .USER_SubscriptionValue] ==
                                                  3
                                              ? const SizedBox()
                                              : KidsNewWorkFlowContiner(
                                                  width: width,
                                                  snapshot: snapshot
                                                      .data!.docs[index],
                                                  expansionTileController:
                                                      expansionTileKidsController,
                                                  fromDebitcard:
                                                      widget.fromDebitcard),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                spacing_medium,
                (appConstants.userModel.usaUserType !=
                            AppConstants.USER_TYPE_PARENT ||
                        (appConstants.userModel.userFamilyId !=
                                appConstants.userModel.usaUserId &&
                            appConstants.userModel.userFamilyId != '' && appConstants.userModel.userFamilyId!=null) ||
                        appConstants.familymemberlimitreached == true)
                    ? SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ZakiPrimaryButton(
                            width: width,
                            title: 'Add a Family Member',
                            icon: Icons.add,
                            textStyle:
                                heading2TextStyle(context, width, color: white),
                            onPressed: (internet.status ==
                                        AppConstants
                                            .INTERNET_STATUS_NOT_CONNECTED ||
                                    appConstants.userModel.subScriptionValue ==
                                        null ||
                                    appConstants.userModel.subScriptionValue ==
                                        0 ||
                                    appConstants.userModel.subScriptionValue ==
                                        1)
                                ? null
                                : () async {
                                    // setState(() {
                                    //   forms.add(FormData());
                                    // });
                                    String? userAdded = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddFamilyMember()));
                                    if (userAdded != null) {}

                                    // formKey.currentState?.validate();
                                    // formKey.currentState!.save();
                                  },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder roundedBorderCustom({int? sunscriptionValue}) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side:
            BorderSide(color: sunscriptionValue == 3 ? grey : green, width: 1));
  }
}

class KidsNewWorkFlowContiner extends StatefulWidget {
  KidsNewWorkFlowContiner(
      {Key? key,
      required this.width,
      required this.snapshot,
      required this.expansionTileController,
      this.fromDebitcard})
      : super(key: key);

  final ExpansionTileController expansionTileController;
  final double width;
  final QueryDocumentSnapshot snapshot;
  final bool? fromDebitcard;

  @override
  State<KidsNewWorkFlowContiner> createState() =>
      _KidsNewWorkFlowContinerState();
}

class _KidsNewWorkFlowContinerState extends State<KidsNewWorkFlowContiner> {
  final formGlobalKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneOrEmailNameController = TextEditingController();
  final stateController = TextEditingController();
  final ssnController = TextEditingController();
  final zipCodeController = TextEditingController();
  final streetAddressController = TextEditingController();
  final appartOrSuitController = TextEditingController();
  final cityController = TextEditingController();
  int subscriptionValue = 0;
  bool subScription = false;
  bool _obscureText = true;

  @override
  void initState() {
    setState(() {
      firstNameController.text = widget.snapshot[AppConstants.USER_first_name];
      lastNameController.text = widget.snapshot[AppConstants.USER_last_name];
      dateOfBirthController.text = widget.snapshot[AppConstants.USER_dob];
      subscriptionValue =
          widget.snapshot[AppConstants.USER_SubscriptionValue] ?? 0;
      subScription =
          (subscriptionValue == 0 || subscriptionValue == 1) ? false : true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var appConstants = Provider.of<AppConstants>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacing_small,
        Text(
          'Family Member Info:',
          style: heading1TextStyle(context, width, color: green),
        ),
        spacing_medium,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? name) {
            if (name!.isEmpty) {
              return 'Enter Name';
            } else {
              return null;
            }
          },
          enabled: false,
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: firstNameController,
          obscureText: false,
          keyboardType: TextInputType.name,
          maxLines: 1,
          maxLength: 15,
          onChanged: (String username) {},
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            border: circularOutLineBorder,
            enabledBorder: circularOutLineBorder,
            hintText: 'Legal First Name',
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? name) {
            if (name!.isEmpty) {
              return 'Enter Last Name';
            } else {
              return null;
            }
          },
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: lastNameController,
          obscureText: false,
          enabled: false,
          keyboardType: TextInputType.name,
          maxLines: 1,
          maxLength: 15,
          onChanged: (String username) {},
          decoration: InputDecoration(
            isDense: true,
            border: circularOutLineBorder,
            enabledBorder: circularOutLineBorder,
            counterText: '',
            hintText: 'Legal Last Name',
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? name) {
            if (name!.isEmpty) {
              return 'Enter Name';
            } else {
              return null;
            }
          },
          enabled: false,
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: dateOfBirthController,
          obscureText: false,
          keyboardType: TextInputType.name,
          maxLines: 1,
          maxLength: 15,
          onChanged: (String username) {},
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            border: circularOutLineBorder,
            enabledBorder: circularOutLineBorder,
            hintText: 'Legal First Name',
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 15,
          obscureText: _obscureText,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ssnMaskFormatter
          ],

          validator: (String? state) {
            // return null;
            if (state!.isEmpty) {
              return 'Enter Security Number';
            } else if (state.length < 11) {
              return 'Enter Full Social security Number';
            } else {
              return null;
            }
          },
          // obscureText: true,
          decoration: InputDecoration(
              counterText: '',
              isDense: true,
              border: circularOutLineBorder,
              enabledBorder: circularOutLineBorder,
              hintText: 'Social Security Number',
              hintStyle: heading3TextStyle(width, color: grey),
              suffixIconColor: grey,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off)),
              )),
          style: heading3TextStyle(width, color: grey),
          controller: ssnController,
          // obscureText: appConstants.passwordVissibleRegistration,
          keyboardType: TextInputType.number,
        ),
        spacing_large,
        Text(
          'Home Address:',
          style: heading1TextStyle(context, width, color: green),
        ),
        spacing_medium,
        //  TextHeader1(title: 'Street Address'),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // readOnly:   true: false,
          enabled: true,
          validator: (String? name) {
            if (name!.isEmpty) {
              return 'Enter a Street Address';
            } else {
              return null;
            }
          },
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: streetAddressController,
          obscureText: false,
          keyboardType: TextInputType.streetAddress,
          maxLines: 1,
          maxLength: 40,
          decoration: InputDecoration(
            hintText: 'Street Address',
            isDense: true,
            border: circularOutLineBorder,
            enabledBorder: circularOutLineBorder,
            counterText: '',
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,
        // TextHeader1(title: 'Apartment or Suite (Optional)'),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // readOnly:   true: false,
          enabled: true,
          // validator: (String? name) {
          // if (name!.isEmpty) {
          //   return 'Enter a Street Adress';
          // } else {
          // return null;
          // }
          // },
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: appartOrSuitController,
          obscureText: false,
          keyboardType: TextInputType.name,
          maxLines: 1,
          maxLength: 40,
          decoration: InputDecoration(
            hintText: 'Apartment or Suite (Optional)',
            counterText: '',
            border: circularOutLineBorder,
            isDense: true,
            enabledBorder: circularOutLineBorder,
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,

        // TextHeader1(title: 'City'),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // readOnly:   true: false,
          enabled: true,
          validator: (String? name) {
            if (name!.isEmpty) {
              return 'Enter a City Name';
            } else {
              return null;
            }
          },
          // style: TextStyle(color: primaryColor),
          style: heading3TextStyle(width, color: grey),
          controller: cityController,
          obscureText: false,
          keyboardType: TextInputType.name,
          maxLines: 1,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: 'City',
            counterText: '',
            isDense: true,
            border: circularOutLineBorder,
            enabledBorder: circularOutLineBorder,
            hintStyle: heading3TextStyle(width, color: grey),
          ),
        ),
        spacing_medium,
        Row(
          children: [
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 5,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                validator: (String? state) {
                  // return null;

                  if (state!.isEmpty) {
                    return 'Enter state';
                  } else {
                    return null;
                  }
                },
                // obscureText: true,
                onTap: () async {
                  // String data =
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SelectCounteryState(
                        listItems: USStates.getAllNames(),
                      );
                    },
                  );
                  stateController.text = appConstants.selectedCountrySate;
                },
                // enabled: false,
                enableInteractiveSelection: false,
                readOnly: true,
                decoration: InputDecoration(
                  counterText: '',
                  isDense: true,
                  border: circularOutLineBorder,
                  enabledBorder: circularOutLineBorder,
                  hintText: 'State',
                  suffixIcon: StateSuffixIcon(),
                  hintStyle: heading3TextStyle(width, color: grey),
                ),
                style: heading3TextStyle(width, color: grey),
                controller: stateController,
                // obscureText: appConstants.passwordVissibleRegistration,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 5,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String? zipCode) {
                  // return null;

                  if (zipCode!.isEmpty) {
                    return 'Enter ZipCode';
                  } else if (zipCode.length < 5) {
                    return 'Enter Full ZipCode';
                  } else {
                    return null;
                  }
                },
                // obscureText: true,
                decoration: InputDecoration(
                  counterText: '',
                  isDense: true,
                  border: circularOutLineBorder,
                  enabledBorder: circularOutLineBorder,
                  hintText: 'Zip Code',
                  hintStyle: heading3TextStyle(width, color: grey),
                ),
                style: heading3TextStyle(width, color: grey),
                controller: zipCodeController,
                // obscureText: appConstants.passwordVissibleRegistration,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        spacing_medium,

        Row(
          children: [
            Checkbox(
                activeColor: green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                value: subScription,
                onChanged: subscriptionValue == 3
                    ? null
                    : (value) {
                        setState(() {
                          subScription = value!;
                        });
                      }),
            TextValue3(
              title: 'Issue a debit card',
            )
          ],
        ),

        if (subscriptionValue != 3)
          Center(
            child: ZakiPrimaryButton(
              width: widget.width,
              title: 'Confirm',
              textStyle: heading2TextStyle(context, widget.width, color: white),
              onPressed: (subscriptionValue == 3 ||
                      subScription == false ||
                      (firstNameController.text.isEmpty ||
                          lastNameController.text.isEmpty ||
                          dateOfBirthController.text == 'dd / mm / yyyy' ||
                          lastNameController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          stateController.text.length < 5 ||
                          ssnController.text.length < 4 ||
                          zipCodeController.text.length < 5))
                  ? null
                  : () async {
                      CreaditCardApi creaditCardApi = CreaditCardApi();
                      if (subScription == true) {
                        CustomProgressDialog progressDialog =
                            CustomProgressDialog(context, blur: 6);
                        progressDialog.setLoadingWidget(CustomLoadingScreen());
                        progressDialog.show();

                        String? cardProductToken =
                            await creaditCardApi.createCardProduct(
                                city: cityController.text.trim(),
                                country: 'US',
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                address1: streetAddressController.text.trim(),
                                phoneNumber: "000",
                                postalCode: zipCodeController.text.trim(),
                                state: stateController.text,
                                userToken: widget
                                    .snapshot[AppConstants.USER_BankAccountID]);
                        if (cardProductToken != null) {
                          String? cardToken = await creaditCardApi.card(
                              userToken: widget
                                  .snapshot[AppConstants.USER_BankAccountID],
                              cardProductToken: cardProductToken);
                          ApiServices services = ApiServices();
                          // logMethod(title: 'Id is: ', message: selectedUserId);
                          await services.issueCard(
                              parentId:
                                  widget.snapshot[AppConstants.USER_Family_Id],
                              dateOfBirth: dateOfBirthController.text.trim(),
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              phoneNumber: '',
                              userId: widget.snapshot.id,
                              apartmentOrSuit:
                                  appartOrSuitController.text.trim(),
                              city: cityController.text.trim(),
                              ssnNumber: int.parse(getPhoneNumber(
                                  number: ssnController.text.trim())),
                              state: stateController.text.trim(),
                              streetAddress:
                                  streetAddressController.text.trim(),
                              zipCode: int.parse(zipCodeController.text.trim()),
                              cardToken: cardToken,
                              userToken: widget
                                  .snapshot[AppConstants.USER_BankAccountID]);
                          await services.addUserTokenBankApi(
                              widget.snapshot.id.toString(),
                              widget.snapshot[AppConstants.USER_BankAccountID],
                              value: 3);
                          progressDialog.dismiss();
                        }
                        // try {
                        //   if (widget.fromDebitcard==true) {
                        //     Navigator.pop(context, 'success');
                        //   }
                        //   widget.expansionTileController.collapse();
                        //   progressDialog.dismiss();

                        // } catch (e) {
                        if (widget.fromDebitcard == true) {
                          Navigator.pop(context, 'success');
                          return;
                        }
                        widget.expansionTileController.collapse();
                        progressDialog.dismiss();
                        // }
                      }
                    },
            ),
          ),
        spacing_medium,
      ],
    );
  }
}

class FormWidget extends StatefulWidget {
  final FormData? formData;
  final VoidCallback? onRemove;
  final VoidCallback? onValidate;
  FormWidget({this.formData, this.onRemove, this.onValidate});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  // new callback when data is validated
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                controller: firstNameController,
                onChanged: (val) => widget.formData?.firstNameI = val,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'First Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                controller: lastNameController,
                onChanged: (val) => widget.formData?.lastNameI = val,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (val) => widget.formData?.phoneNumberI = val,
                controller: phoneNumberController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Phone Number is required';
                  }
                  return null;
                },
              ),
              // Add other form fields if required.
              ElevatedButton(
                child: Text('Save'),
                onPressed:
                    //  (formKey.currentState!.validate())?
                    // widget.onValidate
                    // :
                    () {
                  if (formKey.currentState!.validate()) {
                    logMethod(
                        title: 'In validation',
                        message:
                            'Successfully entered into Validation Method ${firstNameController.text} and ${lastNameController.text}');
                    List<UserModel> kidsList = [];
                    UserModel newUser = UserModel(
                        usaFirstName: firstNameController.text,
                        usaLastName: lastNameController.text);
                    kidsList.add(newUser);
                    // widget.onValidate;  // call the provided callback
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Validation Passed!')));
                    kidsList.forEach((element) {
                      ApiServices().newUserPhoneVerification(
                        firstName: element.usaFirstName,
                        zipCode: '',
                      );
                      CreaditCardApi().createUserForCard(
                        firstName: element.usaFirstName,
                      );
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FormData {
  String? firstNameI;
  String? lastNameI;
  String? phoneNumberI;

  TextEditingController? firstNameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();
  TextEditingController? phoneNumberController = TextEditingController();

  String get firstName => firstNameController!.text;
  String get lastName => lastNameController!.text;
  String get phoneNumber => phoneNumberController!.text;

  FormData(
      {this.firstNameI,
      this.lastNameI,
      this.phoneNumberI,
      this.firstNameController,
      this.lastNameController,
      this.phoneNumberController});
}
