import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/store/store_profile/comments_model.dart';
import 'package:silah/store/store_profile/store_info_model.dart';
import 'package:silah/store/store_profile/units/comments_bottom_sheet_widget.dart';

class FollowersAndRatingsCount extends StatelessWidget {
  const FollowersAndRatingsCount({
    super.key,
    required this.storeInfo,
    required this.commentsModel,
    required this.isFollowing,
  });
  final CommentsModel? commentsModel;
  final StoreInfoModel? storeInfo;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.translate(
            offset: Offset(0, -10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  storeInfo?.totalFollowerCount ?? '0',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                if (AppStorage.isLogged && isFollowing)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      getIcon('follow'),
                      color: Theme.of(context).primaryColor,
                      width: 16,
                      height: 16,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return CommentsBottomSheetWidget(
                      commentsModel: commentsModel,
                    );
                  });
            },
            child: Transform.translate(
                offset: Offset(0, -8),
                child: Text(
                  '${commentsModel?.data?.length ?? 0}',
                  style: TextStyle(
                      color: kBluePurpleColor, fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}
