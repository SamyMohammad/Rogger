import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
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

  // void _generateQrCodeImage(BuildContext context) async {
  //   responseQrCodeImage = await FlutterBranchSdk.getQRCodeAsImage(
  //       buo: buo!,
  //       linkProperties: lp!,
  //       qrCode: BranchQrCode(
  //           primaryColor: Colors.black,
  //           //primaryColor: const Color(0xff443a49), //Hex colors
  //           // centerLogoUrl: imageURL,
  //           backgroundColor: Colors.white,
  //           imageFormat: BranchImageFormat.PNG));
  //   if (responseQrCodeImage?.success ?? false) {
  //     print('FlutterBranchSdk.BranchImageFormat${response?.result}');
  //     setState(() {});
  //     // print("${response.result}");
  //   } else {
  //     print('${responseQrCodeImage?.errorCode} - ${response?.errorMessage}');
  //   }
  // }

  _saved(Uint8List image) async {
    final result = await ImageGallerySaver.saveImage(image);
    print("File Saved to Gallery");
    showSnackBar("تم الحفظ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.95,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   foregroundColor: Color(0xff0022E47),
        //   iconTheme: IconThemeData(color: Colors.white),
        //   elevation: 0,
        //   backgroundColor: Color(0xff0022E47),
        //   title: SwipeDetector(
        //       onSwipeDown: ((offset) {
        //         RouteManager.pop();
        //       }),
        //       child: StarterDivider(height: 5, width: 100)),
        // ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            StarterDivider(height: 5, width: 60),
            const SizedBox(height: 80),
            Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white, width: 3),
                    color: Color.fromARGB(255, 67, 154, 205),

                    borderRadius: BorderRadius.circular(27),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  child: QrImageView(
                    backgroundColor: Colors.transparent,

                    // foregroundColor: Colors.white60,
                    // eyeStyle: QrEyeStyle(
                    //   eyeShape: QrEyeShape.square,
                    //   color: Colors.white,
                    // ),
                    // dataModuleStyle: QrDataModuleStyle(
                    // //   dataModuleShape: QrDataModuleShape.square,
                    //   dataModuleShape: QrDataModuleShape.square,
                    //   color: Colors.white,
                    // ),

                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(25, 25),

                      // color: Color(0xff009FFB)
                    ),
                    // gapless: false,
                    // embeddedImage: AssetImage(
                    //   'assets/images/qr_image.png',
                    // ),
                    // embeddedImage: AssetImage(
                    //   getAsset('main_logo'),
                    // ),

                    size: 170,
                    data: response?.result ?? AppStorage.customerID.toString(),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Center(child: const StarterDivider(width: 80)),
                  const SizedBox(height: 20),
                  Text("لديك رمز QR",
                      style: TextStyle(fontSize: 16, color: kPrimaryColor)),
                  const SizedBox(height: 20),
                  Text("يمكنك مشاركة الرمز الخاص بك مع الأصدقاء",
                      style: TextStyle(fontSize: 16, color: kDarkGreyColor)),
                  const SizedBox(height: 20),
                  _TabWithIcon(
                    title: "مشاركة رمز صلة",
                    iconData: Icons.share_outlined,
                    onTap: () {
                      copyText(response?.result);
                    },
                  ),
                  const SizedBox(height: 10),
                  _TabWithIcon(
                    title: "الحفظ في ألبوم الكاميرا",
                    iconData: Icons.save_alt_rounded,
                    onTap: () async {
                      final directory =
                          (await getApplicationDocumentsDirectory())
                              .path; //from path_provide package
                      int fileName = DateTime.now().microsecondsSinceEpoch;
                      String path = '$directory';
                      screenshotController
                      //     .captureFromLongWidget(QrImageView(
                      //   size: 140,
                      //   data: response?.result ??
                      //       AppStorage.customerID.toString(),
                      // ))
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((Uint8List? image) async {
                        if (image != null) {
                          print('inCapture');
                          final directory =
                          await getApplicationDocumentsDirectory();
                          final imagePath =
                          await File('${directory.path}/image.png')
                              .create();
                          await imagePath.writeAsBytes(image);
                          _saved(image);
                        }
                      });
                      //     .then((File e) {
                      //   _saved(e);
                      // });
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
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
