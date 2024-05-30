import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:images_picker/images_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:silah/core/dynamic_links_constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/app_bar.dart';

import '../../widgets/snack_bar.dart';

class ScanQRCodeView extends StatefulWidget {
  const ScanQRCodeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRCodeViewState();
}

class _ScanQRCodeViewState extends State<ScanQRCodeView> {
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool enableOnScanData = true;
  StreamSubscription<Map>? streamSubscriptionDeepLink;
  QRViewController? controller;

  void listenDeepLinkData(BuildContext context) async {
    streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
      debugPrint('data: $data');
      if (data.containsKey(AppConstants.clickedBranchLink) &&
          data[AppConstants.clickedBranchLink] == true) {
        // Navigate to relative screen
        // RouteManager.navigateTo(StoreProfileView(
        //   storeId: data[AppConstants.deepLinkTitle],
        // ));
        RouteManager.navigateAndPopUntilFirstPage(
            StoreProfileView(storeId: data[AppConstants.deepLinkTitle]));
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      debugPrint('exception: $platformException');
    });
  }

  @override
  void initState() {
    super.initState();
    listenDeepLinkData(context);
  }

  @override
  void dispose() {
    streamSubscriptionDeepLink?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تحقق من الرمز'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              // onDetect: (capture) {
              //   final List<Barcode> barcodes = capture.barcodes;
              //   for (final barcode in barcodes) {
              //     print(barcode.rawValue);
              //   }
              // },
              // : controller,
              key: qrKey,
              onQRViewCreated: (controller) {
                if (!enableOnScanData) {
                  return;
                }
                try {
                  this.controller = controller;
                  this.controller?.scannedDataStream.listen((scanData) {
                    setState(() {
                      result = scanData;
                    });
                    print('beforeScanscanly');
                    if (result != null) {
                      FlutterBranchSdk.handleDeepLink(result?.code ?? '');
                    }
                  });
                  // int.parse(qr!);
                  // RouteManager.navigateAndPopUntilFirstPage(
                  //     StoreProfileView(storeId: '50'));
                  print('beforeScanscanly');
                  if (result != null) {
                    FlutterBranchSdk.handleDeepLink(result?.code ?? '');
                  }

                  print('scanscanly');
                  enableOnScanData = false;
                  Future.delayed(
                      Duration(seconds: 2), () => enableOnScanData = true);
                } catch (_) {
                  showSnackBar("رمز خاطئ!", errorMessage: true);
                }
              },
            ),
            // child: ScanlyQRScanner(
            //   onScanData: (qr) {
            //     if (!enableOnScanData) {
            //       return;
            //     }
            //     try {
            //       // int.parse(qr!);
            //       // RouteManager.navigateAndPopUntilFirstPage(
            //       //     StoreProfileView(storeId: '50'));
            //       FlutterBranchSdk.handleDeepLink(qr!);
            //       //  FlutterBranchSdk.listSession().listen((data) {
            //       //     debugPrint('data: $data');
            //       //     if (data.containsKey(AppConstants.clickedBranchLink) &&
            //       //         data[AppConstants.clickedBranchLink] == true) {
            //       //       // Navigate to relative screen
            //       //       RouteManager.navigateTo(StoreProfileView(
            //       //         storeId: data[AppConstants.deepLinkTitle],
            //       //       ));
            //       //     }
            //       //   }, onError: (error) {
            //       //     PlatformException platformException =
            //       //         error as PlatformException;
            //       //     debugPrint('exception: $platformException');
            //       //   });
            //       print('scanscanly');
            //       enableOnScanData = false;
            //       Future.delayed(
            //           Duration(seconds: 2), () => enableOnScanData = true);
            //     } catch (_) {
            //       showSnackBar("رمز خاطئ!", errorMessage: true);
            //     }
            //   },
            // ),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  final image = await ImagesPicker.pick(
                    count: 1,
                    pickType: PickType.image,
                  );
                  if (image == null) return;
                  setState(() {
                    selectedFile = File(image.first.path);
                  });
                  // controller!.scannedDataStream.(selectedFile!.path);
                  await decode(selectedFile!.path);
                  FlutterBranchSdk.handleDeepLink(_data ?? '');
                } catch (_) {
                  showSnackBar("رمز خاطئ!", errorMessage: true);
                }
              },
              child: Text('اختر صورة من المعرض'))
        ],
      ),
    );
  }

  late String _data;

  /// decode from local file
  Future decode(String file) async {
    String? data = await QrCodeToolsPlugin.decodeFrom(file);
    setState(() {
      _data = data ?? '';
    });
  }
}

// _launchURL(String urlQRCode) async {
//   String url = urlQRCode;
//   if (await canLaunchUrl(Uri(path: url, scheme: 'https'))) {
//     await launchUrl(Uri(path: url, scheme: 'https'));
//   } else {
//     throw 'Could not launch $url';
//   }
// }
