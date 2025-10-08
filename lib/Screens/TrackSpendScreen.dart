import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/AppConstants.dart';
import 'package:zaki/Constants/HelperFunctions.dart';
import 'package:zaki/Constants/Spacing.dart';
import 'package:zaki/Constants/Styles.dart';
import 'package:zaki/Services/api.dart';
import 'package:zaki/Widgets/AppBars/AppBar.dart';
import 'package:zaki/Widgets/CustomConfermationScreen.dart';
import 'package:zaki/Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

class TrackSpendScreen extends StatefulWidget {
  const TrackSpendScreen({Key? key});

  @override
  State<TrackSpendScreen> createState() => _TrackSpendScreenState();
}

class _TrackSpendScreenState extends State<TrackSpendScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _spendName = TextEditingController();
  int selectedAllocation = -2;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedWallet = 'Spend'; // Default wallet key

  final List<String> _walletOptions = [
    'Spend','Savings','Charity',
  ];



  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
        var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(title: const Text('Track Spend')),
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBarHeader_005(
                      context: context,
                      appBarTitle: 'Track Spend',
                      height: height,
                      width: width,
                      // tralingIconButton: SSLCustom()
                      ),
                // Amount Field
                TextFormField(
                  controller: _amountController,
                  style: heading3TextStyle(width),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                                    hintText: ' 0',
                                    counterText: '',
                                    isDense: true,
                                    // filled: true,
                                    // fillColor: white,
                                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, bottom: 1, right: 4),
                                      child: Text(
                                        "${getCurrencySymbol(context, appConstants: appConstants)}",
                                        style: heading4TextSmall(width),
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                        minWidth: 0, minHeight: 0),
                                    hintStyle: heading3TextStyle(width),
                  ),
                  validator: (value) {
                    final amt = double.tryParse(value ?? '');
                    if (amt == null || amt <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                spacing_medium,
                Text('Tag-It',
                                          style: heading1TextStyle(
                                              context, width)),
                                      spacing_medium,
                                      SizedBox(
                                        height: height * 0.1,
                                        child: ListView.builder(
                                          itemCount:
                                              AppConstants.tagItList.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return AppConstants.tagItList[index]
                                                        .publicTag_it ==
                                                    false
                                                ? SizedBox.shrink()
                                                :
                                                // index==4? IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down, size: width*0.1,)) :
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          selectedAllocation =
                                                              index;
                                                          // selectedKidIcon =
                                                        });
                                                        Map<String, dynamic>?
                                                            data =
                                                            await ApiServices()
                                                                .getKidSpendingLimit(
                                                                    appConstants
                                                                        .userModel
                                                                        .userFamilyId!,
                                                                    appConstants
                                                                        .userRegisteredId);
                                                        if (data != null) {
                                                          showNotification(
                                                              icon: AppConstants
                                                                  .tagItList[
                                                                      selectedAllocation]
                                                                  .icon,
                                                              error: 0,
                                                              message: AppConstants
                                                                  .tagItList[
                                                                      selectedAllocation]
                                                                  .title
                                                                  .toString());

                                                          logMethod(
                                                              title:
                                                                  'Spend Limit::::>>>',
                                                              message:
                                                                  'Remaining Transaction amount:>> ${data[AppConstants.SpendL_Transaction_Amount_Remain]}, Selected Tag it remaing: ${data}');
                                                        }
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              height:
                                                                  height * 0.07,
                                                              width:
                                                                  height * 0.07,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      color: selectedAllocation ==
                                                                              index
                                                                          ? green
                                                                          : grey)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
                                                                child: Icon(
                                                                    AppConstants
                                                                        .tagItList[
                                                                            index]
                                                                        .icon,
                                                                    color: selectedAllocation ==
                                                                            index
                                                                        ? green
                                                                        : grey,
                                                                    size: width *
                                                                        0.06),
                                                              )),
                                                          if (selectedAllocation ==
                                                              index)
                                                            Text(
                                                              '${AppConstants.tagItList[index].title}',
                                                              style: heading3TextStyle(
                                                                  width,
                                                                  color:
                                                                      lightGrey,
                                                                  font: 10),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                // spacing_medium,
                DropdownButton(
                            isExpanded: true,
                            // Initial Value
                            value: _selectedWallet,
                            style: heading2TextStyle(context, width, color: black),

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: _walletOptions.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items, style: heading2TextStyle(context, width, color: black),),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? value) {
                              if (value != null) {
                      setState(() => _selectedWallet = value);
                    }
                            },
                          ),
                        
                // Wallet Dropdown
                
                const SizedBox(height: 16),

                // Optional Note
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'What for? (optional)',
                    hintText: 'Snacks, gift, etc.',
                    border: circularOutLineBorder,
                                    enabledBorder: circularOutLineBorder,
                  ),
                ),
                const Spacer(),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ZakiPrimaryButton(
                          title: 'Fund Now',
                          width: width,
                    onPressed: selectedAllocation == -2? null: (){
                      
    if (_formKey.currentState?.validate() ?? false) {
      // var appConstants = Provider.of<AppConstants>(context, listen: false);
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final note = _noteController.text.trim();

     CustomProgressDialog progressDialog = CustomProgressDialog(context, blur: 3);
      progressDialog.setLoadingWidget(CustomLoadingScreen());
      progressDialog.show();
      print('Submit transaction: $amount to $_selectedWallet (Note: $note)');
      ApiServices service = ApiServices();
                                  service.addTransaction( 
                                      transactionMethod: AppConstants
                                          .Transaction_Method_Received,
                                      tagItName: AppConstants.tagItList[selectedAllocation].title.toString(),
                                      tagItId: AppConstants.tagItList[selectedAllocation].id.toString(),
                                      selectedKidName:
                                          appConstants.userModel.usaUserName,
                                        
                                      accountHolderName:
                                          appConstants.userModel.usaUserName,
                                      amount: _amountController.text.trim(),
                                      currentUserId:
                                          appConstants.userRegisteredId,
                                      receiverId: appConstants.userRegisteredId,
                                      requestType: AppConstants
                                          .TAG_IT_Transaction_TYPE_Fund_My_Wallet,
                                      senderId: appConstants.userRegisteredId,
                                      message: note.toString(),
                                      fromWallet: 'Card',
                                      toWallet: AppConstants.Spend_Wallet);
      progressDialog.dismiss();
      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomConfermationScreen(
                                              // title: 'Mission Accomplished!',
                                              subTitle:
                                                  "${getCurrencySymbol(context, appConstants: appConstants)} ${amount} Tracked",
                                            )));
      // Optionally show success snackbar or navigate back
    }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
