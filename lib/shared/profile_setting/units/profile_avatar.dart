part of '../view.dart';

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = EditProfileCubit.of(context);
    return Center(
      child: BlocBuilder(
        bloc: cubit,
        builder: (context, state) {
          final profileImage = AppStorage.getUserModel()?.profileImage ?? '';
          final coverImage = AppStorage.getUserModel()?.profileCover ?? '';
          late ImageProvider profileImageProvider =
              AssetImage(getAsset('edit_profile_placeholder'));
          late ImageProvider coverImageProvider =
              AssetImage(getAsset('edit_profile_cover_placeholder'));
          if (!profileImage.endsWith('user_image.png')) {
            profileImageProvider = NetworkImage(profileImage);
          }
          if (coverImage.isNotEmpty) {
            coverImageProvider = NetworkImage(coverImage);
          }
          return Column(
            children: [
              if (AppStorage.isStore)
                GestureDetector(
                  onTap: cubit.updateCover,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 150,
                        child: Image(
                          image: coverImageProvider,
                          fit: BoxFit.fill,
                          height: 230,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        child: Container(
                          width: 70,
                          height: 70,
                          child: Center(
                            child: SvgPicture.asset("assets/icons/camera.svg",
                                height: 15, color: Colors.white),
                          ),
                          //  Icon(
                          //   FontAwesomeIcons.camera,
                          //   size: 34,
                          //   color: Colors.white,
                          // ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            )),
                      ),
                      if (state is EditProfileCoverLoadingState)
                        Container(
                          width: double.infinity,
                          height: 230,
                          child: LoadingIndicator(),
                          color: Colors.white.withOpacity(0.8),
                        ),
                    ],
                  ),
                ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: profileImageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  if (state is EditProfileAvatarLoadingState)
                    Container(
                      width: 70,
                      height: 70,
                      child: LoadingIndicator(),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  if (state is! EditProfileAvatarLoadingState)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: cubit.updateImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: SvgPicture.asset("assets/icons/camera.svg",
                                height: 15, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      // child: InkWell(
                      //   onTap: cubit.updateImage,
                      //   child: CircleAvatar(
                      //     radius: 18,
                      //     backgroundColor: kPrimaryColor,
                      //     foregroundColor: Colors.white,
                      //     child: Icon(FontAwesomeIcons.pen, size: 15),
                      //   ),
                      // ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
