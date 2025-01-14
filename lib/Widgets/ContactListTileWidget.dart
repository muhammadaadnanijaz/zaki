import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaki/Constants/CheckInternetConnections.dart';
import 'package:zaki/Models/UserModel.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/TextHeader.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';

class ContactListTileWidget extends StatefulWidget {
  const ContactListTileWidget({
    Key? key,
    required this.contacts,
    required this.image,
    required this.width,
    required this.data,
    required this.userModel
  }) :  super(key: key);

  final Uint8List? image;
  final Contact contacts; 
  final double width;
  final data;
  final UserModel userModel;
  
  

  @override
  State<ContactListTileWidget> createState() => _ContactListTileWidgetState();
}

class _ContactListTileWidgetState extends State<ContactListTileWidget> {
  bool inviteExist = false;
  bool invitedStatus = false;
  bool alreadyOnZakiPay = false;
  bool emailInviteExist = false;
  String idOfSelectedCheck='';
  final ApiServices services = ApiServices();

  @override
  void initState() {
    super.initState();
    checkUserAlreadyInvited();
  }
  checkUserAlreadyInvited(){
    Future.delayed(Duration.zero, () async{
      String? number;
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      if(widget.contacts.phones.isNotEmpty)
      // if(widget.contacts.phones.first.number.startsWith('0')){
        number = widget.contacts.phones.first.number.substring(1);
      // }
      if(number!= appConstants.userModel.usaPhoneNumber!){
      bool? alreadyExistInFriend = await services.checkAlreadyFriend(id: appConstants.userRegisteredId, number: (widget.contacts.phones.isNotEmpty || widget.contacts.phones.length!=0)? number!:'0');
      bool userExistOnZakipay = await services.isUserExist(number: number??'0');
        logMethod( title: 'My Number is: ${appConstants.userModel.usaPhoneNumber} and current number: $number', message:  'Already exist in friendList: $alreadyExistInFriend and isUserExist: $userExistOnZakipay');
      if(mounted)
      setState(() {
        inviteExist = alreadyExistInFriend!;
        alreadyOnZakiPay = userExistOnZakipay;
      });
      if(inviteExist==false && alreadyOnZakiPay==true){
        // Now we need to add Both of them into friend list
        String? userId = await services.getUserIdFromPhoneNumber(number: number);
        if(userId!=null){
          // 
          // logMethod(title: 'Already Zakipay Id', message: userId);
          services.addFriendsAutumatically(currentUserId: appConstants.userRegisteredId, number: number, requestReceiverName: widget.contacts.displayName, requestReceiverrId: userId, requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
        }

        logMethod(title: 'Already on zakipay', message: number);
      }
      }
      
    });
  }
  checkUserAlreadyInviteds(){
    Future.delayed(Duration.zero, () async{
      String? number;
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      if(widget.contacts.phones.isNotEmpty)
      // if(widget.contacts.phones.first.number.startsWith('0')){
        number = widget.contacts.phones.first.number.substring(1);
      // }
      if(number!= appConstants.userModel.usaPhoneNumber!){
      // bool? exist= await services.checkAlreadyFriend(id: appConstants.userRegisteredId, number: (widget.contacts.phones.isNotEmpty || widget.contacts.phones.length!=0)? number!:'0');

      // bool? alreadyExistInFriend = exist==false? exist: true;
      // idOfSelectedCheck= exist==false?'':exist.id;
      // emailInviteExist= exist==false?false:exist.emailExist;
       bool? exist= await services.checkAlreadyFriend(id: appConstants.userRegisteredId, number: (widget.contacts.phones.isNotEmpty || widget.contacts.phones.length!=0)? number!:'0');

      bool? alreadyExistInFriend = exist==false? exist: true;
      // idOfSelectedCheck= exist==false?'':exist.id;
      // emailInviteExist= exist==false?false:exist;

      bool userExistOnZakipay = await services.isUserExist(number: number??'0');
        // logMethod( title: 'My Number is: ${appConstants.userModel.usaPhoneNumber} and current number: $number', message:  'Already exist in friendList: $alreadyExistInFriend and isUserExist: $userExistOnZakipay');
      if(mounted)
      setState(() {
        inviteExist = alreadyExistInFriend!;
        alreadyOnZakiPay = userExistOnZakipay;
      });
      logMethod(title: 'Selected Id', message:'Selected:: $idOfSelectedCheck');
      print('Selected Id: $idOfSelectedCheck');
      if(inviteExist==false && alreadyOnZakiPay==true){
        // Now we need to add Both of them into friend list
        String? userId = await services.getUserIdFromPhoneNumber(number: number);
        if(userId!=null){
          // 
          // logMethod(title: 'Already Zakipay Id', message: userId);
          services.addFriendsAutumatically(currentUserId: appConstants.userRegisteredId, number: number, requestReceiverName: widget.contacts.displayName, requestReceiverrId: userId, requestSenderName: '${appConstants.userModel.usaFirstName} ${appConstants.userModel.usaLastName}', requestSenderPhoneNumber: appConstants.userModel.usaPhoneNumber);
        }

        // logMethod(title: 'Already on zakipay', message: number);
      }
      }
      
    });
  }
  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var internet = Provider.of<CheckInternet>(context, listen: true);
    // appConstants.userModel.invitedList!.forEach((element) {
    //   if(widget.contacts.phones.isNotEmpty || widget.contacts.phones.length!=0)
    //  if(element.number!.contains(widget.contacts.phones.first.number)){
    //   inviteExist = true;
    //   invitedStatus = element.status!;
    //   }
    //   // logMethod(title: 'IS Exist?', message: element.number!.contains(widget.contacts.phones.first.number)?'Conatins':'Not conatins');
      
    //   }
    //   );
    return 
    (invitedStatus)? const SizedBox() : 
    // (!widget.contacts.phones.isEmpty && widget.contacts.emails.length==0)?
    // const SizedBox.shrink():
    ( widget.contacts.phones.isNotEmpty && widget.contacts.phones.first.number.substring(1) == appConstants.userModel.usaPhoneNumber)?
    const SizedBox.shrink():
    ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6),
        leading: 
        ClipOval(
          child: Container(
            height: 55,
            width: 55,
            child: (widget.contacts.photo == null)
                ? 
                CircleAvatar(
                  backgroundColor: grey.withValues(alpha:0.4),
                  child: Icon(
                    Icons.person,
                    color: white,
                    size: 35,
                    ))
                : 
                CircleAvatar(
                    backgroundImage: MemoryImage(widget.image!)
                    ),
          ),
        ),
        title: TextValue2(
          title: 
          "${widget.contacts.displayName}",
        ),
        subtitle: TextValue3(
          title: 
          '${!widget.contacts.phones.isEmpty ? widget.contacts.phones.first.number : widget.contacts.emails.length!=0? widget.contacts.emails.first.address:''}',
          
        ),
        onTap: () {
          // showNotification(
          //     error: 0,
          //     icon: Icons.clear,
          //     message: _contacts![index].phones.first.number.isNotEmpty
          //         ? '${_contacts![index].phones.first.number}'
          //         : 'Sorry');
          // showNotification(
          //     error: 0,
          //     icon: Icons.clear,
          //     message: _contacts![index].emails.isNotEmpty
          //         ? '${_contacts![index].emails.first.address}'
          //         : 'Sorry');
        },
        trailing: 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            alreadyOnZakiPay? Image.asset(
              imageBaseAddress+ 'zakipay_logo_black.png',
              height: 25,
              width: 35,
              alignment: Alignment.centerRight,
              // width: 20,
              ):
            inviteExist? 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.check, size: 25,),
            ):
            // Icon(Icons.check_circle_rounded, color: invitedStatus? green : orange,):
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.contacts.phones.isEmpty ? const SizedBox.shrink() :
                  InkWell(
                onTap: internet.status ==AppConstants.INTERNET_STATUS_NOT_CONNECTED ? null: () async{
                  inviteExist=true;
                  setState(() {
                    
                  });
                  String number='';
                  if (widget.contacts.phones.isNotEmpty) {
                    ApiServices service = ApiServices();
                    if(widget.contacts.phones.first.number.length>=11){
                      if(widget.contacts.phones.first.number.startsWith('0')){
                        number = widget.contacts.phones.first.number.substring(1);
                        logMethod(message: '${number}', title: 'Trim number:');

                        // String response = 
                        await service.inviteUser(number: number, uid: appConstants.userRegisteredId, isFavrite: false, name: widget.contacts.displayName);
                      // if (response=='success') {
                        // service.getUserData(context: context, userId: appConstants.userRegisteredId);
                        service.userInvited(phoneNumber: number, userId: appConstants.userRegisteredId);
                        // Future.delayed(Duration(seconds: 4), () async{
                        
                        // // setState(() {
                          
                        // // });
                       

                        // });
                        
                        bool? launch = await  _launchURL(number, appConstants.userModel.usaFirstName.toString());
                        logMethod(title: 'Launched', message: '$launch');
                        if(launch==true){
                          await appConstants.getContact();
                        setState(() {
                          
                        });
                        }
                      // }

                      }
                    }
                      
                  }
                },
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: internet.status ==AppConstants.INTERNET_STATUS_NOT_CONNECTED ? grey: green,
                  size: 25,
                ),
              ),
                  widget.data!=null ?Icon(Icons.check, size: 25,): SizedBox(),
                  
                ],
              ),
            ),
            widget.contacts.emails.isNotEmpty
                  ? 
                  emailInviteExist==true?
                  Icon(Icons.check, size: 25,):
                  Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: InkWell(
                        onTap: internet.status ==AppConstants.INTERNET_STATUS_NOT_CONNECTED ? null: () async {
                          logMethod(title: 'Id from Selected', message: idOfSelectedCheck.toString());
                          
                          setState(() {
                            emailInviteExist = true;
                          });
                          String number='';
                      if (widget.contacts.phones.isNotEmpty) 
                        // ApiServices service = ApiServices();
                        if(widget.contacts.phones.first.number.length>=11)
                          if(widget.contacts.phones.first.number.startsWith('0'))
                            number = widget.contacts.phones.first.number.substring(1);
                            logMethod(message: '${number}', title: 'Trim number:');
                          // await ApiServices().inviteUser(number: number, uid: appConstants.userRegisteredId, isFavrite: false, name: widget.contacts.displayName, updatedDocId: idOfSelectedCheck, emailSended: true);
                          logMethod(title: 'Email Send', message: widget.contacts.emails.first.address.toString());
                          final username = 'hi@zakipay.com';
                          final password = 'Xjehe8B#9BuuxAwV';
                          final receiverEmail = '${widget.contacts.emails.first.address.toString()}';
                          final smtpServer = SmtpServer(
                              'mail.zakipay.com',
                              port: 465,
                              username: username,
                              password: password,
                              allowInsecure: true,
                              ssl: true,
                              ignoreBadCertificate: false,);
                          // Use the SmtpServer class to configure an SMTP server:
                          // final smtpServer = SmtpServer('smtp.domain.com');
                          // See the named arguments of SmtpServer for further configuration
                          // options.

                          // Create our message.
                          final message = Message()
                            ..from = Address(username, 'ZakiPay Beta Invite')
                            ..recipients.add(receiverEmail)
                            ..ccRecipients
                                .addAll([receiverEmail, receiverEmail])
                            ..bccRecipients.add(Address(receiverEmail))
                            ..subject = '${appConstants.userModel.usaFirstName} recommends downloading ZakiPay'
                            ..text = '${appConstants.userModel.usaFirstName} ${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT} ${AppConstants.ZAKI_PAY_APP_LINK}';
                          // ..html = "<h1>${reportController.text} </h1>\n<p> Message is: ${reportController.text} & Phone Number: ${appConstants.userModel.usaPhoneNumber} & UserName: ${appConstants.userModel.usaUserName}</p> </n><h2>${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT}</h2> </n> <img src='${AppConstants.ZAKI_PAY_IMAGE_URL}' alt='Italian Trulli'>";

                          try {
                            final sendReport = await send(message, smtpServer);
                            print('Message sent: ' + sendReport.toString());

                          } on MailerException catch (e) {
                            print('Message not sent.');
                            for (var p in e.problems) {
                              print('Problem: ${p.code}: ${p.msg}');
                            }
                          }
                        },
                        child: Icon(
                          Icons.email_outlined,
                          color: internet.status ==AppConstants.INTERNET_STATUS_NOT_CONNECTED ? grey: green,
                          size: 25,
                        ),
                      ),
                    )
                  : 
                  const SizedBox(),
          ],
        )
        );
  }
}

Future<bool?> _launchURL(number, String name) async {

  try {
    var whatsappAndroid =
    Uri.parse("whatsapp://send?phone=$number&text=${name} ${AppConstants.ZAKI_PAY_PROMOTIONAL_TEXT} ${AppConstants.ZAKI_PAY_APP_LINK}");
if (await canLaunchUrl(whatsappAndroid)) {
  bool launch =  await launchUrl(whatsappAndroid,);
  
  return launch;
} else {
  logMethod(title: 'Error', message: 'Whatsapp Not Installed');
  return false;
}
  } catch (e) {
    return false;
  }
}