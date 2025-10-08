import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
// import 'package:zaki/Constants/NotificationTitle.dart';
import 'package:zaki/Widgets/TextHeader.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';
import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Spacing.dart';
import '../Constants/Styles.dart';
import '../Models/ImageModels.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';
import '../Widgets/CustomLoadingScreen.dart';
import 'package:zaki/Constants/Whitelable.dart';

class ChooseImageForUpload extends StatefulWidget {
  const ChooseImageForUpload(
      {Key? key, this.imageUrl, this.gender, this.userType})
      : super(key: key);
  final String? imageUrl;
  final String? gender, userType;

  @override
  State<ChooseImageForUpload> createState() => _ChooseImageForUploadState();
}

class _ChooseImageForUploadState extends State<ChooseImageForUpload> {
  List<ImageModel> imageList = [];
  List<ImageModel> backgroundImageList = [
    ImageModel(id: 0, imageName: userBackgroundImagesBaseAddress + '1_background.png'),
    ImageModel(id: 1, imageName: userBackgroundImagesBaseAddress + '2_background.png'),
    ImageModel(id: 2, imageName: userBackgroundImagesBaseAddress + '3_background.jpg'),
    ImageModel(id: 3, imageName: userBackgroundImagesBaseAddress + '4_background.png'),
    ImageModel(id: 4, imageName: userBackgroundImagesBaseAddress + '5_background.png'),
    ImageModel(id: 5, imageName: userBackgroundImagesBaseAddress + '6_background.png'),
    ImageModel(id: 6, imageName: userBackgroundImagesBaseAddress + '7_background.png'),
    ImageModel(id: 7, imageName: userBackgroundImagesBaseAddress + '8_background.png'),
    ImageModel(id: 8, imageName: userBackgroundImagesBaseAddress + '9_background.png'),
    ImageModel(id: 9, imageName: userBackgroundImagesBaseAddress + '10_background.png'),
    ImageModel(id: 10, imageName: userBackgroundImagesBaseAddress + '11_background.png'),
    ImageModel(id: 11, imageName: userBackgroundImagesBaseAddress + '12_background.png'),
    ImageModel(id: 12, imageName: userBackgroundImagesBaseAddress + '13_background.png'),
    ImageModel(id: 13, imageName: userBackgroundImagesBaseAddress + '14_background.png'),
    ImageModel(id: 14, imageName: userBackgroundImagesBaseAddress + '15_background.png'),
  ];
  List<ImageModel> logoList = [
    ImageModel(id: 0, imageName: userLogoBaseAddress + 'Logo_Boy1.png'),
    ImageModel(id: 1, imageName: userLogoBaseAddress + 'Logo_Boy2.png'),
    ImageModel(id: 2, imageName: userLogoBaseAddress + 'Logo_DadorSingle.png'),
    ImageModel(id: 3, imageName: userLogoBaseAddress + 'Logo_Mom.png'),
    ImageModel(id: 4, imageName: userLogoBaseAddress + 'Logo_Girl1.png'),
    ImageModel(id: 5, imageName: userLogoBaseAddress + 'Logo_Girl2.png'),
    ImageModel(id: 6, imageName: userLogoBaseAddress + 'Logo_1.png'),
    ImageModel(id: 7, imageName: userLogoBaseAddress + 'Logo_2.png'),
    ImageModel(id: 8, imageName: userLogoBaseAddress + 'Logo_3.png'),
    ImageModel(id: 9, imageName: userLogoBaseAddress + 'Logo_4.png'),
    ImageModel(id: 10, imageName: userLogoBaseAddress + 'Logo_5.png'),
    ImageModel(id: 11, imageName: userLogoBaseAddress + 'Logo_6.png'),
    ImageModel(id: 12, imageName: userLogoBaseAddress + 'Logo_7.png'),
    ImageModel(id: 13, imageName: userLogoBaseAddress + 'Logo_8.png'),
    ImageModel(id: 14, imageName: userLogoBaseAddress + 'Logo_9.png'),
    ImageModel(id: 15, imageName: userLogoBaseAddress + 'Logo_10.png'),

    // ImageModel(id: 5, imageName: imageBaseAddress + 'Logo_Genral.png'),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      var appConstants = Provider.of<AppConstants>(context, listen: false);
      if (appConstants.fromLogo == true) {
        setState(() {
          imageList = logoList;
        });
      } else {
        setState(() {
          imageList = backgroundImageList;
        });
      }
      imageUrl = widget.imageUrl != ""
          ? widget.imageUrl.toString()
          : imageList.first.imageName.toString();
      // logMethod(title: "image Url", message: imageUrl);
      setState(() {});
    });
  }

// checkIntialImage(String? imageUrl, appConstants){
//   String intialImage;
//   return
//   (imageUrl == '' && widget.userType=="Kid" && widget.gender=='Male' && appConstants.fromLogo == true)?
//     intialImage;
// }
  String imageUrl = '1';
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: getCustomPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarHeader_005(
                  width: width,
                  height: height,
                  context: context,
                  appBarTitle: appConstants.fromLogo == true
                      ? 'Profile Logo'
                      : 'Background Image',
                  backArrow: false),
              spacing_large,
              TextHeader1(
                title: 'Select or Upload an Image',
              ),
              spacing_large,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: grey.withValues(alpha:0.5)),
                          shape: appConstants.fromLogo == true
                              ? BoxShape.circle
                              : BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: black,
                          ),
                          onPressed: () async {
                            final XFile? image = await ImagePicker().pickImage(
                                maxWidth: 500,
                                maxHeight: 600,
                                imageQuality: 80,
                                source: ImageSource.gallery);
                            if (image != null) {
                              CroppedFile? croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: image.path,
                                // aspectRatioPresets: [
                                //   CropAspectRatioPreset.square,
                                //   CropAspectRatioPreset.ratio3x2,
                                //   CropAspectRatioPreset.original,
                                //   CropAspectRatioPreset.ratio4x3,
                                //   CropAspectRatioPreset.ratio16x9
                                // ],
                                
                                // cropStyle: appConstants.fromLogo == true
                                //     ? CropStyle.circle
                                //     : CropStyle.rectangle,
                                // androidUiSettings: AndroidUiSettings(
                                //     toolbarTitle: 'Cropper',
                                //     toolbarColor: green,
                                //     toolbarWidgetColor: Colors.white,
                                //     initAspectRatio: CropAspectRatioPreset.original,
                                //     lockAspectRatio: false),
                                // iosUiSettings: const IOSUiSettings(
                                //   minimumAspectRatio: 1.0,
                                // )
                              );
                              setState(() {
                                imageUrl = croppedFile!.path;
                                imageList.add(ImageModel(
                                    id: 6, imageName: croppedFile.path));
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: height * 0.1,
                      child: ListView.builder(
                          itemCount: imageList.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 6),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    imageUrl = imageList[index].imageName!;
                                  });
                                  print(
                                      'Name is: ${imageList[index].imageName}');
                                  // setState(() {
                                  //   headerImage = croppedFile;
                                  // });
                                  // if (croppedFile!=null) {
                                  //   // appConstants.updateImageUploadHeaderStatus(
                                  //   //   imageStatus: true
                                  //   // );
                                  // String? path = await ApiServices().uploadImage(path: headerImage!.path);
                                  // if (path!=null) {
                                  //   showNotification(error: 0, icon: Icons.check, message: path);
                                  //   await ApiServices().updateImagePath(field: 'USA_background_image_url', id: appConstants.userRegisteredId, value: path);
                                  //   await ApiServices().getUserData(context: context, userId: appConstants.userRegisteredId);
                                  //   // appConstants.updateImageUploadHeaderStatus(
                                  //   //   imageStatus: false
                                  //   // );
                                  // }

                                  // }
                                },
                                child: Container(
                                  // height: height * 0.13,
                                  // width: width * 0.25,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: grey.withValues(alpha:0.5)),
                                      shape: appConstants.fromLogo == true
                                          ? BoxShape.circle
                                          : BoxShape.rectangle),
                                  // color: Colors.grey.withValues(alpha:0.2),
                                  child: imageList[index]
                                          .imageName!
                                          .contains('com.zakipay.teencard')
                                      ? Container(
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.circle,
                                            border: Border.all(
                                                color: grey.withValues(alpha:0.5)),
                                            shape: appConstants.fromLogo == true
                                                ? BoxShape.circle
                                                : BoxShape.rectangle,
                                          ),
                                          child: Image.file(
                                            File(imageList[index].imageName!),
                                            // height: 150,
                                            // width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: grey.withValues(alpha:0.5)),
                                              shape:
                                                  appConstants.fromLogo == true
                                                      ? BoxShape.circle
                                                      : BoxShape.rectangle),
                                          child: Image.asset(
                                            imageList[index].imageName!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              spacing_large,
              // SizedBox(
              //   height: height * 0.01,
              // ),
              appConstants.fromLogo == true
                  ? Center(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundColor: green,
                            radius: 115,
                            child: CircleAvatar(
                              radius: 113,
                              backgroundColor: white,
                              backgroundImage: imageUrl == '1'
                                  ? AssetImage(
                                      imageBaseAddress + 'image_upload.png',
                                    )
                                  : imageUrl.contains("http")
                                      ? NetworkImage(imageUrl)
                                      : imageUrl
                                              .contains('com.zakipay.teencard')
                                          ?
                                          // FileImage(File(imageUrl)):
                                          Image.file(
                                              File(imageUrl),
                                              // fit: BoxFit.cover,
                                              // width: width,
                                              // height: height * 0.42,
                                            ).image
                                          // ,
                                          : AssetImage(imageUrl),
                            ),
                          ),
                          // Image.asset(imageUrl),
                          // Positioned(
                          //   right: -12,
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: white,
                          //       shape: BoxShape.circle
                          //     ),
                          //     child: InkWell(
                          //       onTap: (){
                          //       },
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(6.0),
                          //         child: Icon(
                          //             Icons.camera_alt,
                          //             color: green,
                          //             size: width*0.045,
                          //             ),
                          //       ),
                          //     ),
                          //   ),)
                        ],
                      ),
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: grey.withValues(alpha:0.5))),
                      child: imageUrl == '1'
                          ? Image.asset(
                              imageBaseAddress + 'image_upload.png',
                              fit: BoxFit.cover,
                              width: width,
                              height: height * 0.42,
                              // width: width * 0.25,
                              // height: height * 0.1,
                            )
                          : imageUrl.contains("http")
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  width: width,
                                  height: height * 0.42,
                                )
                              : imageUrl.contains('com.zakipay.teencard')
                                  ? Image.file(
                                      File(imageUrl),
                                      fit: BoxFit.contain,
                                      width: width,
                                      height: height * 0.5,
                                    )
                                  : Image.asset(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      width: width,
                                      height: height * 0.42,
                                    ),
                    ),
              spacing_large,

              ZakiPrimaryButton(
                title: 'Save',
                width: width,
                onPressed: () async {
                  CustomProgressDialog progressDialog =
                      CustomProgressDialog(context, blur: 10);
                  progressDialog.setLoadingWidget(CustomLoadingScreen());
                  progressDialog.show();
                  if (imageUrl.contains('assets/images/')) {
                    showNotification(
                        error: 0, icon: Icons.check, message: NotificationText.ADDED_SUCCESSFULLY);

                    await ApiServices().updateImagePath(
                        field: appConstants.fromLogo == true
                            ? AppConstants.USER_Logo
                            : AppConstants.USER_background_image_url,
                        id: appConstants.userRegisteredId,
                        value: imageUrl);
                    await ApiServices().getUserData(
                        context: context,
                        userId: appConstants.userRegisteredId);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.pop(context);
                    });
                    progressDialog.dismiss();
                    return;
                  }
                  String userImagesPath = '${appConstants.userModel.usaCountry}/profileimages/users/${appConstants.userRegisteredId}/images';
                  String? path =
                      await ApiServices().uploadImage(fullPath: userImagesPath, userId: appConstants.userRegisteredId);
                  if (path != null) {
                    showNotification(
                        error: 0, icon: Icons.check, message: path);
                    await ApiServices().updateImagePath(
                        field: appConstants.fromLogo == true
                            ? AppConstants.USER_Logo
                            : AppConstants.USER_background_image_url,
                        id: appConstants.userRegisteredId,
                        value: path);
                        
                    // ApiServices().getUserDataWithThreading(
                    //     context: context,
                    //     userId: appConstants.userRegisteredId);
                    await ApiServices().getUserData(
                        context: context,
                        userId: appConstants.userRegisteredId);
                    Future.delayed(const Duration(milliseconds: 200),(){
                    progressDialog.dismiss();
                      Navigator.pop(context);

                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
