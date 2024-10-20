import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared/product_details/units/delete_product_dialog.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../widgets/app/profile_avatar.dart';
import '../status_details/model.dart';
import '../status_details/view.dart';

class ManageMyStatusView extends StatefulWidget {
  const ManageMyStatusView({Key? key, required this.statusModel})
      : super(key: key);

  final StatusModel statusModel;

  @override
  State<ManageMyStatusView> createState() => _ManageMyStatusViewState();
}

class _ManageMyStatusViewState extends State<ManageMyStatusView> {
  List<Status> status = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      status = widget.statusModel.stories ?? [];
      setState(() {});
    });
    super.initState();
  }

  void deleteStatus(int index) async {
    final delete = await showDeleteProductDialog();
    if (delete) {
      final status = this.status[index];
      this.status.remove(status);
      setState(() {});
      try {
        final response = await DioHelper.post(
          'provider/story/delete',
          data: {
            'provider_id': AppStorage.customerID,
            'story_id': status.storyId!,
          },
        );
        if (response.data['success']) {
          showSnackBar('تم الحذف');
        } else {
          throw Exception();
        }
      } catch (_) {
        showSnackBar('فشلت حذف الحالة', errorMessage: true);
        this.status.insert(index, status);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "حالاتي",
      ),
      body: ListView.separated(
        padding: VIEW_PADDING,
        itemCount: widget.statusModel.stories?.length ?? 0,
        itemBuilder: (context, index) {
          final i = widget.statusModel.stories![index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 28,
              child: i.attachmentType == 'image'
                  ? null
                  : Icon(FontAwesomeIcons.video),
              backgroundImage: i.attachmentType == 'image'
                  ? NetworkImage(
                      i.attachment!,
                    )
                  : null,
              backgroundColor: Colors.white,
              foregroundColor: kAccentColor,
            ),
            title: Text(
              Jiffy.parseFromDateTime(i.dateAdded!).fromNow(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              ImageViewerPageRoute(
                  builder: (context) =>
                      StatusDetailsView(status: status, initialIndex: index)),
            ),
            trailing: IconButton(
              icon: Icon(FontAwesomeIcons.trash),
              color: Colors.red,
              iconSize: 17,
              onPressed: () => deleteStatus(index),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
