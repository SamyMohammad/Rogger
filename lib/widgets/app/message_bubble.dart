import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/chat/model.dart';

// import 'package:silah/shared/product_details/view.dart';

import '../../../constants.dart';
import '../../shared/location_view/view.dart';
import '../../shared/product_details/view.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String? message;
  final String date;
  final String senderName;
  final String? attachment;
  final ProductInfo? productInfo;
  final bool isRead;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.date,
    required this.senderName,
    required this.attachment,
    required this.productInfo,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 6,
          right: isMe ? 4 : null,
          left: !isMe ? 4 : null,
          child: Transform.rotate(
            angle: isMe ? (pi / 1.4) : (pi / -1.4),
            child: CustomPaint(
              size: Size(20, 20),
              painter: _TrianglePainter(
                  strokeColor: isMe ? Color(0xFF395C82) : kGreyColor,
                  // strokeColor: Colors.black,
                  paintingStyle: PaintingStyle.fill),
            ),
          ),
        ),
        Align(
          alignment: !isMe ? Alignment.topLeft : Alignment.topRight,
          child: UnconstrainedBox(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: sizeFromWidth(3.5),
                maxWidth: sizeFromWidth(1.3),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(senderName, style: TextStyle(fontWeight: FontWeight.w900,color: isMe ? Colors.white : Colors.black),),
                        if (productInfo != null)
                          GestureDetector(
                            onTap: () =>
                                RouteManager.navigateTo(ProductDetailsView(
                              productId: productInfo!.productId!,
                            )),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      productInfo!.image!,
                                      fit: BoxFit.fill,
                                      width: sizeFromWidth(1.3),
                                      height: sizeFromHeight(5),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      productInfo!.name!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: message == null || message!.isEmpty
                              ? GestureDetector(
                                  child: Image.network(attachment!),
                                  onTap: zoomImage)
                              : HtmlEncodedText(
                                  encodedText: message!,
                                  textStyle: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),

                          // Text(
                          //         message!,
                          //         style: TextStyle(
                          //             color: isMe ? Colors.white : Colors.black,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 18),
                          //       ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(date,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.grey,
                                  fontSize: 12)),
                          if (isRead && isMe)
                            Icon(
                              FontAwesomeIcons.checkDouble,
                              size: 12,
                              color:
                                  isMe ? Color(0xFF9cd192) : Color(0xFF395C82),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(!isMe ? 12 : 12),
                    topRight: Radius.circular(!isMe ? 12 : 12),
                  ),
                  color: isMe ? Color(0xFF395C82) : kGreyColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  zoomImage() => showDialog(
        context: RouteManager.currentContext,
        barrierDismissible: true,
        builder: (context) => GestureDetector(
          child: InteractiveViewer(child: Image.network(attachment!)),
          onTap: RouteManager.pop,
        ),
      );
}

class LocationBubble extends StatelessWidget {
  const LocationBubble(
      {Key? key,
      required this.location,
      required this.isMe,
      required this.date})
      : super(key: key);

  final LatLng location;
  final bool isMe;
  final String date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => RouteManager.navigateTo(LocationView(
        viewOnly: true,
        location: location,
      )),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          UnconstrainedBox(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        color: isMe ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'موقع مرسل ( اضغط للعرض )',
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(date,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.grey,
                          fontSize: 12)),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isMe ? Color(0xFF395C82) : kGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;

  _TrianglePainter(
      {this.strokeColor = Colors.black,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 3
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle;
  }
}

class HtmlEncodedText extends StatelessWidget {
  final String encodedText;
  final TextStyle textStyle;

  const HtmlEncodedText({required this.encodedText, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    print('encodedText$encodedText');
    // Decode HTML entities

    final decodedText = parse(encodedText).documentElement!.text;

    return RichText(
      text: TextSpan(
        children: _getStyledMessage(decodedText),
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );

    // Text(
    //   decodedText,
    //   style: textStyle,
    // );
  }

  List<TextSpan> _getStyledMessage(String message) {
    final List<TextSpan> spans = [];
    // final RegExp regex = RegExp(r'\d+'); // Detect the number
    // final RegExp phoneRegExp = RegExp(r'(\+?\d{1,3}[-.\s]??\d{1,4}[-.\s]??\d{1,4}[-.\s]??\d{1,9})');
    final RegExp phoneRegExp = RegExp(
        r'^(?:\+?(\d{1,3}))?[-.\s]?((\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,9}))$');
    final match =
        phoneRegExp.firstMatch(message); // Get the first match of number

    if (match != null) {
      // Add text before the number
      if (match.start > 0) {
        spans.add(TextSpan(text: message.substring(0, match.start)));
      }

      // Add the number with blue color
      spans.add(
        TextSpan(
          text: message.substring(match.start, match.end),
          style: TextStyle(color: Colors.blue),
        ),
      );

      // Add text after the number
      if (match.end < message.length) {
        spans.add(TextSpan(text: message.substring(match.end)));
      }
    } else {
      // If no number is found, just return the entire message as regular text
      spans.add(TextSpan(text: message));
    }

    return spans;
  }
}
