import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Screens/Socialize.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../Constants/AppConstants.dart';
import '../Constants/Styles.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomConfermationScreen.dart';
import 'HomeScreen.dart';

class ReportAnIssue extends StatefulWidget {
  const ReportAnIssue({Key? key}) : super(key: key);

  @override
  State<ReportAnIssue> createState() => _ReportAnIssueState();
}

class _ReportAnIssueState extends State<ReportAnIssue> {
  final reportController = TextEditingController();
  bool isSuccessfullReport = false;

  @override
  void dispose() {
    reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child:
            // isSuccessfullReport == true
            //     ? successfullyReported(height: height, width: width)
            //     :
            SingleChildScrollView(
          child: Padding(
            padding: getCustomPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                    context: context,
                    appBarTitle: appConstants.fromReportAnIssue == true
                        ? 'Report an Issue'
                        : 'Ideas to improve',
                    backArrow: false,
                    height: height,
                    width: width,
                    leadingIcon: true),
                TextField(
                  maxLines: 12,
                  controller: reportController,
                  style: heading3TextStyle(width),
                  decoration: InputDecoration(
                      hintText:
                          'Please share any ideas or suggestions you have that may improve the app',
                      hintStyle: heading3TextStyle(width),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(8),
                      )),
                ),
                spacing_large,
                ZakiPrimaryButton(
                  title: 'Submit',
                  width: width,
                  onPressed: reportController.text.isEmpty
                      ? null
                      : () async {
                          String? mobileData = await getDeviceInfo();
                          logMethod(
                              title: 'Mobile Dta',
                              message: mobileData.toString());

                          // Create a file attachment
                          // final attachment = FileAttachment(imageFile);

                          final username = 'hi@zakipay.com';
                          final password = 'Xjehe8B#9BuuxAwV';
                          final receiverEmail = 'muhammadadnanijaz01@gmail.com';
                          final secondReceiverEmail = 'hi@zakipay.com';
                          final smtpServer = SmtpServer(
                            'mail.zakipay.com',
                            port: 465,
                            username: username,
                            password: password,
                            allowInsecure: true,
                            ssl: true,
                            ignoreBadCertificate: false,
                          );
                          // Use the SmtpServer class to configure an SMTP server:
                          // final smtpServer = SmtpServer('smtp.domain.com');
                          // See the named arguments of SmtpServer for further configuration
                          // options.

                          // Create our message.
                          final message = Message()
                            ..from = Address(
                                username,
                                appConstants.fromReportAnIssue == true
                                    ? 'App Issue reported - ZakiPay'
                                    : 'App User Ideas - ZakiPay')
                            ..recipients
                                .addAll([receiverEmail, secondReceiverEmail])
                            ..ccRecipients
                                .addAll([receiverEmail, receiverEmail])
                            ..bccRecipients.add(Address(receiverEmail))
                            ..subject = appConstants.fromReportAnIssue == true
                                ? 'App Issue reported - ZakiPay'
                                : 'App User Ideas - ZakiPay'
                            ..text = reportController.text.trim()
                            // ..attachments = [attachment]
                            ..html =
                                "<h1>${reportController.text.trim()} </h1>\n </n><h2>${formatedDateWithMonth(date: DateTime.now())} </h2> </n> </n><h2>UserName: ${appConstants.userModel.usaUserName} </h2> </n><h2>${await getDeviceInfo()} </h2> ";

                          try {
                            final sendReport = await send(message, smtpServer);
                            print('Message sent: ' + sendReport.toString());
                          } on MailerException catch (e) {
                            print('Message not sent.');
                            for (var p in e.problems) {
                              print('Problem: ${p.code}: ${p.msg}');
                            }
                          }
                          // setState(() {
                          //   isSuccessfullReport = true;
                          // });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomConfermationScreen(
                                        // title: 'Allowance Updated',
                                        subTitle:
                                            "Thank you for alerting us to this issue.  We will review as soon as possible.",
                                      )));
                        },
                ),
                spacing_medium
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget successfullyReported({double? width, double? height}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageBaseAddress + 'issue_report_successfully.png'),
            spacing_large,
            TextHeader1(
              title: 'Mission Accomplished!',
            ),
            spacing_medium,
            TextValue2(
              title:
                  'Thank you for alerting us to this issue. We will \nreview as soon as possible.',
            ),
            spacing_large,
            ZakiPrimaryButton(
              title: 'See Friends Activities',
              width: width,
              // selected: 1,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllActivities()));
              },
            ),
            spacing_large,
            ZakiPrimaryButton(
              title: 'Home',
              width: width,
              // selected: 1,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
