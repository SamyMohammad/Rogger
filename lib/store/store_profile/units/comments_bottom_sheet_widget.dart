import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/store_profile/comments_model.dart';
import 'package:silah/widgets/rate_widget.dart';

class CommentsBottomSheetWidget extends StatelessWidget {
  final CommentsModel? commentsModel;
  const CommentsBottomSheetWidget({
    this.commentsModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      height: MediaQuery.sizeOf(context).height * 0.9,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Column(children: [
        Container(
          height: 8,
          width: 100,
          decoration: BoxDecoration(
              color: kGreyButtonColorD9,
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              "تعليقات (${commentsModel?.data?.length ?? 0})",
              style: TextStyle(
                  color: kGreyButtonColorD9,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final comment = commentsModel?.data?[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(9, 9, 18, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(getAsset("pro"),
                                height: 52, width: 52),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment?.name ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RateWidget(
                                          rate: double.parse(
                                              comment?.rating ?? ''),
                                          hItemPadding: 0,
                                          vItemPadding: 0,
                                        ),
                                        Text(
                                            DateFormat('yyyy-MM-dd', 'en')
                                                .format(DateTime.parse(
                                                    comment?.dateAdded ?? '')),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: kDarkGreyColor))
                                      ],
                                    ),
                                  ],
                                ),
                                ReadMoreText(
                                  comment?.comment ?? '',
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: "عرض المزيد",
                                  trimExpandedText: " عرض أقل",
                                  lessStyle: TextStyle(
                                      fontSize: 14,
                                      color: kBluePurpleColor,
                                      fontWeight: FontWeight.bold),
                                  moreStyle: TextStyle(
                                      fontSize: 14,
                                      color: kBluePurpleColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemCount: commentsModel?.data?.length ?? 0))
      ]),
    );
  }
}
