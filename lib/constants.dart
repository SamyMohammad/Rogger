import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/widgets/snack_bar.dart';

import 'core/router/router.dart';
import 'widgets/toast.dart';

enum SupportTypes { issue, inquiry, suggestion }

const String MAP_API_KEY = 'AIzaSyAdvXvIQSrguEjx4zPLkjxCYJDYK-tBIrE';

const String PLACE_HOLDER_IMAGE =
    "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png";

LatLng get defaultLatLng =>
    LocationManager.currentLocationFromDevice ?? LatLng(24.7136, 46.6753);

const double DEFAULT_MAP_ZOOM = 14.0;

const int PAGINATE_BY = 6;

const DefaultErrorMessage = 'حدث خطأ برجاء المحاولة!';

String getAsset(String imageName) => 'assets/images/$imageName.png';
String getIcon(String iconName) => 'assets/icons/$iconName.svg';

String getLottie(String lottie) => 'assets/lottie/$lottie.json';
final List<BoxShadow> primaryBoxShadow = [
  BoxShadow(
      offset: Offset(0, 1),
      spreadRadius: -1,
      blurRadius: 3,
      color: Colors.grey.shade500),
  BoxShadow(
      offset: Offset(1, 0),
      spreadRadius: -1,
      blurRadius: 3,
      color: Colors.grey.shade500)
];

Future<BitmapDescriptor> getMapIcon(String imageName) =>
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(100, 100)),
      getAsset('enabled-marker'),
    );

Future<File?> getFileFromImageUrl(String url) async {
  try {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final fileName =
        documentDirectory.path + '/' + getFileNameFromURL(url, '/');
    await Dio().download(
      url,
      fileName,
    );
    return File(fileName);
  } catch (e) {
    return null;
  }
}

String getFileNameFromURL(String url, String symbol) =>
    url.substring(url.lastIndexOf(symbol) + 1);

void showInternetErrorMessage() =>
    showToast(DefaultErrorMessage, color: Colors.red);

double get gridViewChildRatio => sizeFromWidth(1.0) / sizeFromHeight(1.5);

SliverGridDelegate get gridViewDelegate =>
    SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: gridViewChildRatio,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15);

const List<String> daysList = [
  'الاحد',
  'الاثنين',
  'الثلاثاء',
  'الاربعاء',
  'الخميس'
];

// String replaceArabicNumber(String input) {
//   if(!input.contains('٥')) return input;
//   const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
//   const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
//
//   for (int i = 0; i < english.length; i++) {
//     input = input.replaceAll(arabic[i], english[i]);
//   }
//   return input;
// }

// String replaceSpecialCharacterFromPhone(String value){
//   return value.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '').trim();
// }

// String convertToPhoneNumber(String phoneNumber){
//   if(phoneNumber.startsWith('+'))
//     phoneNumber = phoneNumber.replaceFirst('+', '00');
//   if(phoneNumber.startsWith('5'))
//     phoneNumber = '00966' + phoneNumber;
//   else if(phoneNumber.startsWith('05'))
//     phoneNumber = '00966' + phoneNumber.replaceFirst('0', '');
//   else if (phoneNumber.startsWith('966'))
//     phoneNumber = '00' + phoneNumber;
//   return phoneNumber.trim();
// }

// bool isSaudiNumber(String value){
//   if(value.startsWith('+9665') && value.length == 13)
//     return true;
//   else if(value.startsWith('5') && value.length == 9)
//     return true;
//   else if(value.startsWith('05') && value.length == 10)
//     return true;
//   else if (value.startsWith('009665') && value.length == 14)
//     return true;
//   else if (value.startsWith('9665') && value.length == 12)
//     return true;
//   else
//     return false;
// }

// bool isMessageAPhoneNumber(String message){
//   final trimmedMessage = message.trim();
//   bool value = false;
//   if((trimmedMessage.startsWith('+966') && trimmedMessage.length == 13) || (trimmedMessage.startsWith('00966') && trimmedMessage.length == 14) || (trimmedMessage.startsWith('966') && trimmedMessage.length == 12) || (trimmedMessage.startsWith('05') && trimmedMessage.length == 10) || (trimmedMessage.startsWith('5') && trimmedMessage.length == 9))
//     value = true;
//   else if((trimmedMessage.startsWith('+٩٦٦') && trimmedMessage.length == 13) || (trimmedMessage.startsWith('٠٠٩٦٦') && trimmedMessage.length == 14) || (trimmedMessage.startsWith('٩٦٦') && trimmedMessage.length == 12) || (trimmedMessage.startsWith('٠٥') && trimmedMessage.length == 10) || (trimmedMessage.startsWith('٥') && trimmedMessage.length == 9))
//     value = true;
//   return value;
// }
//
// bool isMessageALink(String message){
//   bool value = false;
//   if (message.contains('http:') || message.contains('https:') || message.contains('www.') || message.contains('.com') || message.contains('.net') || message.contains('.org') || message.contains('.sa') || message.contains('.eg'))
//     value = true;
//   return value;
// }

// String getExtension(String file){
//   if(file.isEmpty) return '';
//   var fileName = (file.split('/').last);
//   String imageExtension = fileName.split('.').last.toLowerCase().replaceAll('}', '');
//   return imageExtension;
// }

String customizeDateTimeFromNow(DateTime time) {
  DateTime now = DateTime.now();
  final difference = time.difference(now).abs();
  if (difference.inMinutes <= 1) {
    return 'الان';
  } else if (difference.inMinutes > 1 && difference.inDays == 0) {
    String formattedTime =
        TimeOfDay.fromDateTime(time).format(RouteManager.currentContext);
    formattedTime = formattedTime.replaceAll('PM', 'م');
    formattedTime = formattedTime.replaceAll('AM', 'ص');
    return formattedTime;
  } else if (difference.inDays < 7) {
    return weekdays[time.weekday]!;
  } else {
    return time.year.toString() +
        '/' +
        time.month.toString().padLeft(2, '0') +
        '/' +
        time.day.toString().padLeft(2, '0');
  }
}

Map<int, String> weekdays = {
  6: "السبت",
  7: "الاحد",
  1: "الاثنين",
  2: "الثلاثاء",
  3: "الاربعاء",
  4: "الخميس",
  5: "الجمعة",
};

String reformatTime(TimeOfDay value) {
  final reformatted = value.hour.toString().padLeft(2, '0') +
      ':' +
      value.minute.toString().padLeft(2, '0') +
      ':00';
  return reformatted;
}

String reformatDate(DateTime? value) {
  if (value == null) return '';
  final reformatted = value.year.toString() +
      '-' +
      value.month.toString().padLeft(2, '0') +
      '-' +
      value.day.toString().padLeft(2, '0');
  return reformatted;
}

String get getCurrentTimeCustomized {
  final now = TimeOfDay.now();
  final time =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
  return time;
}

String get getTodayDateCustomized {
  final now = DateTime.now();
  final date =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return date;
}

// String getFileNameFromURL(String url, String symbol) => url.substring(url.lastIndexOf(symbol) + 1);

const Color kPrimaryColor = Color(0xFF000000);
const Color kPrimary1Color = Color(0xFF000000);
const Color kPrimary2Color = Color(0xFF000000);
final Color kAccentColor = Color(0xFF000000);
const Color kGreyText73 = Color(0xff757373);
const Color activeSwitchColor = Colors.green;

const Color activeButtonColor = Color(0xFF019CF6);

const Color kLightGreyColor = Color(0xFF8E8D8D);
const Color kLightBlackColor = Color(0XFFE7F0FF);
const Color kLightGreyColorB4 = Color(0xFFB6B4B4);
const Color kLightGreyColorEB = Color(0xFFECEBEB);
const Color kGreyColor = Color(0xFFE2E2E2);
const Color kGreyButtonColorD9 = Color(0xFFDAD9D9);
final Color kDarkGreyColor = Color(0xFF727272);
final Color kBackgroundColor = Colors.white;
const Color kLightPurpleColor = Color(0xFFE7EBF6);
const Color kBluePurpleColor = Color(0xFF4566DC);
const Color kAppBArDarkColor = Color(0xFF1E1E26);
const Color kBackgroundCDarkColor = Color(0xFF14141A);

ThemeData lightTheme = ThemeData(
  platform: TargetPlatform.iOS,
  primaryColor: kPrimaryColor,
  // cursorColor: kPrimaryColor,
  canvasColor: kBackgroundColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, unselectedItemColor: kPrimaryColor),
  fontFamily: 'IBMPlexSansArabic',
  scaffoldBackgroundColor: kBackgroundColor,
  appBarTheme: AppBarTheme(
    toolbarHeight: 50,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'IBMPlexSansArabic',
    ),
    elevation: 0,
  ),
  dialogBackgroundColor: Colors.white,
  dialogTheme: DialogTheme(elevation: 0, backgroundColor: Colors.white),
  textButtonTheme: TextButtonThemeData(
    style:
        ButtonStyle(foregroundColor: MaterialStateProperty.all(kPrimaryColor)),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);
ThemeData darkTheme = ThemeData(
  platform: TargetPlatform.iOS,
  primaryColor: Colors.white,
  hintColor: kAccentColor,
  // cursorColor: kPrimaryColor,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  canvasColor: kBluePurpleColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kAppBArDarkColor,
      unselectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedItemColor: Colors.white),
  fontFamily: 'IBMPlexSansArabic',
  dialogTheme: DialogTheme(
    backgroundColor: kPrimaryColor,
  ),
  scaffoldBackgroundColor: Color(0xFF14141A),
  appBarTheme: AppBarTheme(
    toolbarHeight: 50,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Color(0xFF1E1E26),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'IBMPlexSansArabic',
    ),
    elevation: 0,
  ),
  dialogBackgroundColor: kPrimaryColor,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(kBluePurpleColor)),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);

// final containerDecoration = BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     color: Colors.white,
//     border: Border.all(color: Colors.black54, width: 0.2));

void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

TextTheme get getTextTheme => Theme.of(RouteManager.currentContext).textTheme;

double sizeFromHeight(double fraction, {bool removeAppBarSize = true}) {
  MediaQueryData mediaQuery = MediaQuery.of(RouteManager.currentContext);
  fraction = (removeAppBarSize
          ? (mediaQuery.size.height -
              AppBar().preferredSize.height -
              mediaQuery.padding.top)
          : (mediaQuery.size.height - mediaQuery.viewPadding.top)) /
      (fraction == 0 ? 1 : fraction);
  return fraction;
}

double sizeFromWidth(double fraction) {
  fraction = MediaQuery.of(RouteManager.currentContext).size.width /
      (fraction == 0 ? 1 : fraction);
  return fraction;
}

double bottomDevicePadding =
    MediaQuery.of(RouteManager.currentContext).padding.bottom;
double topDevicePadding =
    MediaQuery.of(RouteManager.currentContext).padding.top;

void initializeFirebaseCrashlytics() async {
  // FirebaseCrashlytics.instance.setCustomKey("user_id", AppStorage.isLogged ? AppStorage.customerID.toString() : 'Guest');
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
}
copyText(String text) {
  print("object");
  showSnackBar("نسخ", duration: 500);
  Clipboard.setData(ClipboardData(text: text));
}

String convertSecondsIntoTime(int seconds) {
  Duration duration = Duration(seconds: seconds);
  return "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds - (duration.inMinutes * 60)).toString().padLeft(2, '0')}";
}

const int ONLINE_MINUTES_COUNT_CHECKER = 200;
const EdgeInsets VIEW_PADDING =
    EdgeInsets.symmetric(horizontal: 12, vertical: 2);
const EdgeInsets largeHorizontalPadding = EdgeInsets.symmetric(horizontal: 46);

bool hasTextOverflow({
  required String text,
  double minWidth = 0,
  double maxWidth = double.infinity,
  int maxLines = 1,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}
