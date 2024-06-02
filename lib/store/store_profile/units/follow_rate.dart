import 'package:flutter/material.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/store/store_profile/units/rate_dialog.dart';
import 'package:silah/user/followers/cubit/cubit.dart';

import '../../../user/followers/model.dart';

class FollowAndRate extends StatefulWidget {
  const FollowAndRate({Key? key}) : super(key: key);

  @override
  State<FollowAndRate> createState() => _FollowAndRateState();
}

class _FollowAndRateState extends State<FollowAndRate> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final cubit = StoreProfileCubit.of(context);
    final storeId = cubit.storeId;
    final storeName = cubit.storeInfoModel?.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              isFollowing = !isFollowing;
              setState(() {});
              if (isFollowing) {
                cubit.followStore();
              } else {
                FollowersCubit()
                    .unfollowStore(FollowingList(advertizerId: storeId));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 30,
              ),
              child: Text(
                isFollowing ? 'الغاء المتابعة' : 'متابعة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isFollowing ? Colors.black : Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: isFollowing ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          InkWell(
            onTap: () => showRateDialog(storeId: storeId,storeName:  storeName ?? '',
                rate: cubit.getRateModel?.rating != null
                    ? double.parse(cubit.getRateModel!.rating!.rating!)
                    : null,rateId: cubit.getRateModel?.rating?.ratingId),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 40,
              ),
              child: Text(
                'تقييم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
