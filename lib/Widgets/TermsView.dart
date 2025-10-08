// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/CustomLoader.dart';

// flutter_inappwebview
class TermsView extends StatefulWidget {
  final String? url;
  TermsView({this.url});
  @override
  _TermsViewState createState() => _TermsViewState();
}

class _TermsViewState extends State<TermsView> {
  // int selectedType=0;
// var isDeviceConnected = true;

  double progress = 0;
  //  var plugin;
  // bool isDrawerBeingShown = false;
  late InAppWebViewController _webViewController;
  // String url = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    // var width = MediaQuery.of(buildContext).size.width;
    // var height = MediaQuery.of(context).size.height;
    // var appConstants = Provider.of<AppConstants>(context, listen: true);
    return Container(
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url.toString())),
            // ignore: deprecated_member_use
            initialOptions: InAppWebViewGroupOptions(
              // ignore: deprecated_member_use
              crossPlatform: InAppWebViewOptions(
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
              ),
              // ignore: deprecated_member_use
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                loadWithOverviewMode: true,
                useWideViewPort: false,
                builtInZoomControls: false,
                domStorageEnabled: true,
                supportMultipleWindows: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            // onLoadStart: (InAppWebViewController controller, String url) {
            //   setState(() {
            //     this.url = url;
            //   });
            // },
            // onLoadStop: (InAppWebViewController controller, String url) async {
            //   setState(() {
            //     this.url = url;
            //   });
            // },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
            onDownloadStartRequest: (controller, url) async {
              // _download(url.toString());
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? CustomLoader(
                        // value: progress,
                        // color: green,
                      )
                    : Container()),
          ),
        ],
      ),
    );
    // AlertDialog(
    //   // contentPadding: EdgeInsets.zero,
    //   title: Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       InkWell(
    //         onTap: (){
    //           _webViewController.dispose();
    //           Navigator.pop(buildContext);
    //         },
    //         child: Icon(Icons.close)),
    //     ],
    //   ),
    //   shape: shape(),
    //   content:
    //   );
  }
}
