import 'package:flutter/material.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Widgets/TermsView.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'I agree to ZakiPay’s ',
              style: heading4TextSmall(width),
            ),
            InkWell(
              onTap: ()async{
                await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/terms-conditions/");
                
                    // await showDialog(
                    // context: context,
                    // builder:(BuildContext context) {
                    //   return TermsView(url: 'https://zakipay.com/terms-conditions/',);
                    //   },
                    // );
                  },
              child: Text(
                'Terms & Conditions,',
                style: heading4TextSmall(width, underline: true),
              ),
            ),
    
          ],
        ),
          Row(
            children: [
              InkWell(
                onTap: ()async{
                  await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/cardholder-agreement/");
                  /////
                //             await showModalBottomSheet(
                //   context: context,
                //   // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                //   isScrollControlled: false,
                //   useSafeArea: true,
                //   // scrollControlDisabledMaxHeightRatio: width,
                //   // enableDrag: false,
                //   showDragHandle: true,
                //   enableDrag: false,
                //   // backgroundColor: ,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(width * 0.09),
                //       topRight: Radius.circular(width * 0.09),
                //     ),
                //   ),
                //   builder: (context) {
                //     return Container(
                //       width: double.infinity,
                //         height: height * 0.5, // 80% of screen height
                //         // decoration: BoxDecoration(
                //         //   image: DecorationImage(
                //         //   image: AssetImage(imageBaseAddress+'empty_wallet_background.png'),
                //         //   fit: BoxFit.fill
                        
                //         //   ),
                //         // ),
                //         // :null,
                //         child: TermsView(url: 'https://zakipay.com/cardholder-agreement/',));
                //   },
                // );
                    // await showDialog(
                    // context: context,
                    // builder:(BuildContext context) {
                    //   return TermsView(url: 'https://zakipay.com/cardholder-agreement/',);
                    //   },
                    // );
                  },
                child: Text(
                  'Cardholder Agreement ',
                  style: heading4TextSmall(width, underline: true),
                ),
              ),
              Text(
                '& ',
                style: heading4TextSmall(width),
          
              ),
              InkWell(
                onTap: () async{
                  await teamViewMethod(context: context , height: height,width: width, url: "https://zakipay.com/privacy-policy/");

                  ///
                //   await showModalBottomSheet(
                //   context: context,
                //   // constraints: BoxConstraints(maxHeight: 800, maxWidth: double.infinity, minHeight: 800, minWidth: double.infinity),
                //   isScrollControlled: false,
                //   useSafeArea: true,
                //   // scrollControlDisabledMaxHeightRatio: width,
                //   // enableDrag: false,
                //   showDragHandle: true,
                //   enableDrag: false,
                //   // backgroundColor: ,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(width * 0.09),
                //       topRight: Radius.circular(width * 0.09),
                //     ),
                //   ),
                //   builder: (context) {
                //     return Container(
                //       width: double.infinity,
                //         height: height * 0.5, // 80% of screen height
                //         // decoration: BoxDecoration(
                //         //   image: DecorationImage(
                //         //   image: AssetImage(imageBaseAddress+'empty_wallet_background.png'),
                //         //   fit: BoxFit.fill
                        
                //         //   ),
                //         // ),
                //         // :null,
                //         child: TermsView(url: '',));
                //   },
                // );

                    // await showDialog(
                    // context: context,
                    // builder:(BuildContext context) {
                    //   return TermsView(url: 'https://zakipay.com/privacy-policy/',);
                    //   },
                    // );
                  },
          child: Text(
            'Privacy Policy.',
            style: heading4TextSmall(width, underline: true),
          ),
        ),
            ],
          ),
        
      ],
    );
  }
}