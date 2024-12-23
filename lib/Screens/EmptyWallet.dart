import 'package:flutter/material.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import 'FundMyWallet.dart';


class EmptyWallet extends StatelessWidget {
  const EmptyWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageBaseAddress+'empty_wallet_background.png'),
              fit: BoxFit.fill
            ),
          ),
          child: Padding(
            padding: getCustomPadding(),
         child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(imageBaseAddress+'empty_wallet.png'),
                  
                  Column(
                    children: [
                      Text(
                    'Wallet a bit light?😦',
                    style: appBarTextStyle(context, width, color: white),
                    ),
                  spacing_small,
                      Text(
                        'Always keep your wallet healthy.',
                        style: heading2TextStyle(context, width, color: white),
                        ),
                        
                    ],
                  ),
                  spacing_small,
                  spacing_small,
                  spacing_small,
                    ZakiPrimaryButton(
                      title: 'Fund it Now',
                      width: width,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: 
                            (context) => FundMyWallet()));
                      },
                    )
          
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}