import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';

Future<bool> showDeleteProductDialog() async {
  final delete = await showCupertinoModalPopup<bool>(
    context: RouteManager.currentContext,
    barrierDismissible: false,
    builder: (context) {
      return _Sheet();
    },
  );
  return delete ?? false;
}

class _Sheet extends StatelessWidget {
  const _Sheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Column(
        children: [
          Icon(
            Icons.delete,
            color: Colors.red.shade700,
            size: 50,
          ),
          SizedBox(height: 10),
          Text(
            'سيتم الحذف نهائيا ؟',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      cancelButton: CupertinoButton(
        child: Text("الغاء"),
        onPressed: () => Navigator.pop(context, false),
      ),
      actions: [
        CupertinoButton(
          child: Text(
            "حذف",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
