import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/shared/black_list/cubit/cubit.dart';
import 'package:silah/shared/black_list/cubit/states.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';
import '../../widgets/app/profile_avatar.dart';
import 'model.dart';

class BlackListView extends StatelessWidget {
  const BlackListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlackListCubit()..getBlackedList(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('محظورة'),
          ),
          body: BlocBuilder<BlackListCubit, BlackListStates>(
            builder: (context, state) {
              final cubit = BlackListCubit.of(context);
              final blackListData = cubit.blackListModel;
              if (state is BlackListLoadingState) {
                return LoadingIndicator();
              } else if (blackListData == null) {
                return Center(child: Text('لا يوجد اسماء مضافة حاليا'));
              } else
                return ListView.builder(
                  padding: VIEW_PADDING,
                  itemBuilder: (context, index) {
                    return _UserTile(
                      user: blackListData.bannedList![index],
                    );
                  },
                  itemCount: blackListData.bannedList!.length,
                );
            },
          )),
    );
  }
}

class _UserTile extends StatefulWidget {
  const _UserTile({Key? key, required this.user}) : super(key: key);

  final BannedList user;
  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  bool blocked = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ProfileAvatar(
            image: widget.user.icon!,
            userID: widget.user.customerId!,
            height: 55,
            width: 55,
            onlineDotRadius: 5,
          ),
          SizedBox(width: 15),
          Expanded(
              child: Text(
            widget.user.name!,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          )),
          InkWell(
            onTap: () {
              blocked = !blocked;
              setState(() {});
              final cubit = BlackListCubit.of(context);
              if (blocked) {
                cubit.blocUser(widget.user.customerId!);
              } else {
                cubit.unBlockUser(widget.user.customerId!);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
              child: Text(
                blocked ? 'الغاء الحظر' : 'حظر',
                style: TextStyle(
                  color: blocked ? Colors.white : Colors.red,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: blocked ? Colors.red : Colors.white,
                  border: Border.all(
                    color: Colors.red,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
