import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:gal/gal.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dynamic_links_constants.dart';
import 'package:silah/widgets/starter_divider.dart';

import '../../widgets/snack_bar.dart';

class GenerateQRCodeView extends StatefulWidget {
  const GenerateQRCodeView({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<GenerateQRCodeView> createState() => _GenerateQRCodeViewState();
}

class _GenerateQRCodeViewState extends State<GenerateQRCodeView> {
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  BranchResponse? response;
  BranchResponse? responseQrCodeImage;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    initializeDeepLinkData();
    _generateDeepLink(context);
    _generateQrCode(context);
  }

  //To Setup Data For Generation Of Deep Link
  void initializeDeepLinkData() {
    buo = BranchUniversalObject(
      canonicalIdentifier: AppConstants.branchIoCanonicalIdentifier,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata(
          AppConstants.deepLinkTitle,
          widget.id,
        ),
    );
    FlutterBranchSdk.registerView(buo: buo!);

    lp = BranchLinkProperties();
    lp?.addControlParam(AppConstants.controlParamsKey, '1');
  }

  //To Generate Deep Link For Branch Io
  void _generateDeepLink(BuildContext context) async {
    response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
    if (response?.success ?? false) {
      print('FlutterBranchSdk.getShortUrl${response?.result}');
      setState(() {});
      // print("${response.result}");
    } else {
      print('${response?.errorCode} - ${response?.errorMessage}');
    }
  }

  void _generateQrCode(BuildContext context) async {
    responseQrCodeImage = await FlutterBranchSdk.getQRCodeAsData(
        buo: buo!,
        linkProperties: lp!,
        qrCode: BranchQrCode(
            primaryColor: Colors.black,
            //primaryColor: const Color(0xff443a49), //Hex colors
            // centerLogoUrl: imageURL,
            backgroundColor: Colors.white,
            imageFormat: BranchImageFormat.PNG));
    if (responseQrCodeImage?.success ?? false) {
      print('FlutterBranchSdk.BranchImageFormat${response?.result}');
      setState(() {});
      // print("${response.result}");
    } else {
      print('${responseQrCodeImage?.errorCode} - ${response?.errorMessage}');
    }
  }

  _saved(Uint8List imageFile) async {
    try {
      await Gal.requestAccess();
      if (await Gal.hasAccess()) {
        await Gal.putImageBytes(imageFile);
        print("File Saved to Gallery");
        showSnackBar("تم الحفظ");
        // final imagePath = await directory.createFile('image.png');
      }
    } on GalException catch (e) {
      log(e.type.message);
    }

    // TODO: fix save issue
    // final result = await ImageGallerySaver.saveImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 15),
            StarterDivider(height: 5, width: 50),
            const SizedBox(height: 40),
            Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white, width: 3),
                    color: Color(0xff70F1EB),
                
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  child: QrImageView(
                    backgroundColor: Colors.transparent,
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(25, 25),
                    ),
                    size: 200,
                    data: response?.result ?? AppStorage.customerID.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 43),
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(0xff1B4259),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    copyText(response?.result);
                  },
                  child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 43),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 19),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 30,
                          ),
                          Spacer(),
                          Text(
                            textAlign: TextAlign.center,
                            "مشاركة رمز روجر",
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      )

                      // _TabWithIcon(
                      //   title: "مشاركة رمز روجر",
                      //   iconData: Icons.copy,
                      //   onTap: () {
                      //     copyText(response?.result);
                      //   },
                      // ),
                      ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 43),
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(0xff1B4259),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    // final directory = (await getApplicationDocumentsDirectory())
                    //     .path; //from path_provide package
                    // int fileName = DateTime.now().microsecondsSinceEpoch;
                    // String path = '$fileName$directory';
                    screenshotController
                        //     .captureFromLongWidget(QrImageView(
                        //   size: 140,
                        //   data: response?.result ??
                        //       AppStorage.customerID.toString(),
                        // ))
                        .capture()
                        .then((image) async {
                      if (image != null) {
                        print('inCapture');
                        // final directory =
                        //     await getApplicationDocumentsDirectory();
                        // final imageFile = await im.writeAsBytes(image);

                        _saved(image);
                      }
                    });
                  },
                  child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 43),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 19),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.save_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                          Spacer(),
                          Text(
                            textAlign: TextAlign.center,
                            "الحفظ في ألبوم الكاميرا",
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      )),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ), //EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(AppStorage.isStore ? "لديك رمز QR" : "لديه رمز  QR",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ), //EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                  AppStorage.isStore
                      ? "يمكنك مشاركة الرمز الخاص بك مع الأصدقاء"
                      : "يمكنك مشاركة الرمز مع الاصدقاء",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            // const SizedBox(height: 20),
          ],
        ));
  }
}

class _TabWithIcon extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  const _TabWithIcon({
    required this.iconData,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(iconData, size: 30, color: kPrimaryColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
          const Spacer(),
          const Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(Icons.arrow_forward_ios))
        ],
      ),
    );
  }
}

enum GalExceptionType {
  accessDenied,
  notEnoughSpace,
  notSupportedFormat,
  unexpected;

  String get message => switch (this) {
        accessDenied => 'Permission to access the gallery is denied.',
        notEnoughSpace => 'Not enough space for storage.',
        notSupportedFormat => 'Unsupported file formats.',
        unexpected => 'An unexpected error has occurred.',
      };
}
