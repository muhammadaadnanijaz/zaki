import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Widgets/CustomSizedBox.dart';
import 'package:zaki/Widgets/ZakiPrimaryButton.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import '../Constants/Styles.dart';
import '../Models/ImageModels.dart';
import '../Services/api.dart';
import '../Widgets/AppBars/AppBar.dart';

class CardBackGroundImage extends StatefulWidget {
  final String selectedCardId;
  final String previousImage;
  const CardBackGroundImage(
      {Key? key, required this.selectedCardId, required this.previousImage})
      : super(key: key);

  @override
  State<CardBackGroundImage> createState() => _CardBackGroundImageState();
}

class _CardBackGroundImageState extends State<CardBackGroundImage> {
  List<ImageModel> imageList = [
    ImageModel(id: 0, imageName: userBackgroundImagesBaseAddress + '1_background.png'),
    ImageModel(id: 1, imageName: userBackgroundImagesBaseAddress + '2_background.jpg'),
    ImageModel(id: 2, imageName: userBackgroundImagesBaseAddress + '3_background.jpg'),
    ImageModel(id: 3, imageName: userBackgroundImagesBaseAddress + '4_background.jpg'),
    ImageModel(id: 4, imageName: userBackgroundImagesBaseAddress + '5_background.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      imageUrl = imageList.first.imageName.toString();
    });
  }

  String imageUrl = '1';
  @override
  Widget build(BuildContext context) {
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarHeader_005(
                  context: context,
                  appBarTitle: 'Credit Card Image',
                  backArrow: false,
                  height: height,
                  width: width,
                  leadingIcon: true),
              CustomSizedBox(
                height: height,
              ),
              Text(
                'Select or upload an image',
                style: heading3TextStyle(width),
              ),
              CustomSizedBox(
                height: height,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: green.withValues(alpha: 0.15)),
                        // shape:appConstants.fromLogo == true? BoxShape.circle : BoxShape.rectangle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: green,
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
                                aspectRatio: CropAspectRatio(ratioX: 20, ratioY: 20),
                                // aspectRatioPresets: [
                                //   CropAspectRatioPreset.square,
                                //   CropAspectRatioPreset.ratio3x2,
                                //   CropAspectRatioPreset.original,
                                //   CropAspectRatioPreset.ratio4x3,
                                //   CropAspectRatioPreset.ratio16x9
                                // ],
                                // cropStyle:
                                //     // appConstants.fromLogo == true
                                //     //     ? CropStyle.circle
                                //     //     :
                                //     CropStyle.rectangle,
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
                                imageList.add(ImageModel(
                                    id: 6, imageName: croppedFile!.path));
                                imageUrl = croppedFile.path;
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
                                  ),
                                  // color: Colors.grey.withValues(alpha:0.2),
                                  child: imageList[index]
                                          .imageName!
                                          .contains('com.zakipay.teencard')
                                      ? Image.file(
                                          File(imageList[index].imageName!),
                                          // height: 150,
                                          // width: double.infinity,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          imageList[index].imageName!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
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
                    : imageUrl.contains('com.zakipay.teencard')
                        ? Image.file(
                            File(imageUrl),
                            fit: BoxFit.cover,
                            width: width,
                            height: height * 0.42,
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: width,
                            height: height * 0.42,
                          ),
              ),
              const Spacer(),
              ZakiPrimaryButton(
                title: 'Select',
                width: width,
                onPressed: () async {
                  if (widget.previousImage.contains("http")) {
                    Reference photoRef = await FirebaseStorage.instance
                        .refFromURL(widget.previousImage);
                    await photoRef.delete().then((value) {
                      print('Deleted Successfully');
                    });
                  }
                  if (imageUrl.contains('assets/images/')) {
                    showNotification(
                        error: 0, icon: Icons.check, message: imageUrl);
                    await ApiServices().updateCardBakgroundImagePath(
                        parentId: appConstants.userRegisteredId,
                        cardId: widget.selectedCardId,
                        imageUrl: imageUrl);
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context, "success");
                    });
                    return;
                  }
                  // ZakiPay/Country code-bank code/sendreceive/User id/images/
                  String fullPath = '${appConstants.userModel.usaCountry}/cardImages/${appConstants.userRegisteredId}/images';
                  String? path =
                      await ApiServices().uploadImage(fullPath: fullPath, path: imageUrl, userId: appConstants.userRegisteredId);
                  if (path != null) {
                    showNotification(
                        error: 0, icon: Icons.check, message: path);
                    await ApiServices().updateCardBakgroundImagePath(
                        parentId: appConstants.userRegisteredId,
                        cardId: widget.selectedCardId,
                        imageUrl: path);
                  }
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context, "success");
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
