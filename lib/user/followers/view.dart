import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/user/followers/cubit/cubit.dart';
import 'package:silah/user/followers/cubit/states.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';
import '../../widgets/app/profile_avatar.dart';

class FollowersView extends StatelessWidget {
  const FollowersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowersCubit()..getAllFollowers(),
      child: Scaffold(
        appBar: appBar(title: 'المتابعين'),
        body: BlocBuilder<FollowersCubit, FollowersStates>(
          builder: (context, state) {
            final cubit = FollowersCubit.of(context);
            final followerData = cubit.followersModel?.followingList;
            if (state is FollowersLoadingState) {
              return LoadingIndicator();
            }
            if (followerData == null) {
              return Center(child: Text('لا يوجد متابعين'));
            }
            return ListView.builder(
              padding: VIEW_PADDING,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => RouteManager.navigateTo(StoreProfileView(
                      storeId: followerData[index].advertizerId!)),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ProfileAvatar(
                          image:
                              followerData[index].advertizerProfile.toString(),
                          userID: followerData[index].advertizerId!,
                          height: 55,
                          width: 55,
                          onlineDotRadius: 5,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            followerData[index].advertizerName.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            bool isFollowing =
                                followerData[index].isFollowing ?? true;
                            return Material(
                              color: Colors
                                  .transparent, // Make Material transparent

                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  isFollowing = !isFollowing;
                                  followerData[index]
                                    ..isFollowing = isFollowing;
                                  setState(() {});
                                  if (isFollowing) {
                                    cubit.followStore(followerData[index]);
                                  } else {
                                    cubit.unfollowStore(followerData[index]);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    isFollowing ? 'الغاء المتابعة' : "متابعة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: !isFollowing
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isFollowing
                                          ? Theme.of(context)
                                              .scaffoldBackgroundColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: isFollowing
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    // color: kLightGreyColorEB,
                                    // borderRadius: BorderRadius.circular(20),
                                  ),

                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   border: Border.all(
                                  //     color: isFollowing
                                  //         ? Theme.of(context).scaffoldBackgroundColor
                                  //         : Theme.of(context).primaryColor,
                                  //   ),
                                  //   color:
                                  //       isFollowing ? Colors.black : Colors.white,
                                  // ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: followerData.length,
            );
          },
        ),
      ),
    );
  }
}
