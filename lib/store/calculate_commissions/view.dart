import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/bank_accounts/view.dart';
import 'package:silah/store/calculate_commissions/commissions_model.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/text_form_field.dart';

class SCalculateCommissionsView extends StatefulWidget {
  const SCalculateCommissionsView({Key? key}) : super(key: key);

  @override
  State<SCalculateCommissionsView> createState() =>
      _SCalculateCommissionsViewState();
}

class _SCalculateCommissionsViewState extends State<SCalculateCommissionsView> {
  bool _isLoading = true;
  late double commissionPercent;
  double? commission;
  String? value;
  double totalCommission = 0;

  @override
  void initState() {
    getCommissionData();
    getCommissions();
    super.initState();
  }

  void getCommissionData() async {
    totalCommission = 0;
    final response = await DioHelper.post('provider/banks/commission');
    commissionPercent =
        double.parse(response.data['commission'].replaceAll('%', ''));
    setState(() => _isLoading = false);
  }

  void calculateCommission() {
    if (this.value == null || this.value!.isEmpty) return;
    final value = double.parse(this.value!);
    commission = value * commissionPercent / 100;
    setState(() {});
  }

  CommissionsModel? commissionsModel;

  Future<void> getCommissions() async {
    toggleLoading(true);
    try {
      totalCommission = 0;
      final response = await DioHelper.post('provider/banks/commission_list',
          data: {'provider_id': AppStorage.customerID});
      commissionsModel = CommissionsModel.fromJson(response.data);
      for (Commission i in commissionsModel?.commissions ?? []) {
        await Future.delayed(Duration(microseconds: 1));
        i.commission =
            (double.parse(i.commissionValue!) * 100 / commissionPercent);
        totalCommission += double.parse(i.commissionValue!);
      }
    } catch (_) {}
    toggleLoading(false);
  }

  Future<void> addCommission() async {
    toggleLoading(true);
    closeKeyboard();
    try {
      await DioHelper.post('provider/banks/add_commission', data: {
        'provider_id': AppStorage.customerID,
        'commission_value': commission,
      });
      commission = null;
      txController.clear();
      getCommissions();
    } catch (_) {}
    toggleLoading(false);
  }

  void toggleLoading(bool value) => setState(() => _isLoading = value);

  TextEditingController txController = TextEditingController();

  void deleteCommission(String id) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('هل قمت بدفع العمولة'),
        actions: [
          CupertinoButton(
            child: Text(
              'لا',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: RouteManager.pop,
          ),
          CupertinoButton(
            child: Text(
              'نعم',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () async {
              RouteManager.pop();
              await DioHelper.post('provider/banks/delete_commission', data: {
                'commission_id': id,
              });
              getCommissions();
            },
          ),
        ],
      ),
    );
  }

  void deleteAllCommissions() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('هل قمت بدفع جميع العمولات ؟'),
        actions: [
          CupertinoButton(
            child: Text(
              'لا',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: RouteManager.pop,
          ),
          CupertinoButton(
            child: Text(
              'نعم',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () async {
              RouteManager.pop();
              await DioHelper.post('provider/banks/delete_all_commission',
                  data: {
                    'provider_id': AppStorage.customerID,
                  });
              getCommissions();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'حسابات العمولة',
      ),
      body: Padding(
        padding: VIEW_PADDING,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InputFormField(
              controller: txController,
              // upperText: 'ادخل سعر البيع',
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: GestureDetector(
                  onTap:
                      _isLoading || commission == null ? null : addCommission,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: _isLoading || commission == null
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    child: _isLoading
                        ? LoadingIndicator()
                        : Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                  ),
                ),
              ),
              // fillColor: Colors.white,
              isNext: false,
              isNumber: true,
              hasLabel: true,
              hint: 'ادخل سعر البيع',
              onChanged: (v) {
                value = v;
                if (value!.isEmpty) {
                  commission = null;
                }
                setState(() {});
                calculateCommission();
              },
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       child: InputFormField(
            //         controller: txController,
            //         // upperText: 'ادخل سعر البيع',
            //         suffixIcon: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 8, horizontal: 8),
            //           child: GestureDetector(
            //             onTap: _isLoading || commission == null
            //                 ? null
            //                 : addCommission,
            //             child: CircleAvatar(
            //               radius: 20,
            //               backgroundColor: _isLoading || commission == null
            //                   ? Colors.grey
            //                   : kPrimaryColor,
            //               child: _isLoading
            //                   ? LoadingIndicator()
            //                   : Icon(
            //                       Icons.arrow_forward,
            //                       color: Colors.white,
            //                     ),
            //             ),
            //           ),
            //         ),
            //         // fillColor: Colors.white,
            //         isNext: false,
            //         isNumber: true,
            //         hasLabel: true,
            //         hint: 'ادخل سعر البيع',
            //         onChanged: (v) {
            //           value = v;
            //           if (value!.isEmpty) {
            //
            //             commission = null;
            //           }
            //           setState(() {});
            //           calculateCommission();
            //         },
            //       ),
            //     ),
            //     // if (commission != null)
            //     //   Padding(
            //     //     padding: const EdgeInsets.only(top: 30),
            //     //     child: GestureDetector(
            //     //       onTap: _isLoading || commission == null
            //     //           ? null
            //     //           : addCommission,
            //     //       child: CircleAvatar(
            //     //         radius: 20,
            //     //         backgroundColor: kPrimaryColor,
            //     //         child: _isLoading
            //     //             ? LoadingIndicator()
            //     //             : Icon(
            //     //                 Icons.arrow_forward,
            //     //                 color: Colors.white,
            //     //               ),
            //     //       ),
            //     //     ),
            //     //   ),
            //   ],
            // ),
            if (commission != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('العمولة المستحقة : ' + '$commission S.R'),
              ),
            ConfirmButton(
              title: 'الحسابات البنكية',
              verticalMargin: 10,
              border: true,
              onPressed: () => RouteManager.navigateTo(SBankAccountsView()),
            ),
            SizedBox(height: 10),
            _isLoading
                ? LoadingIndicator()
                : Expanded(
                    child: (commissionsModel?.commissions?.length ?? 0) == 0
                        ? Center(
                            child: Text('لا توجد عمولات مستحقة'),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                commissionsModel?.commissions?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item =
                                  commissionsModel!.commissions![index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kGreyColor),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Icon(FontAwesomeIcons.moneyBill1,
                                        //     color: kDarkGreyColor, size: 20),
                                        SizedBox(width: 5),
                                        Text(
                                          item.dateAdded!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: kDarkGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      'سعر البيع',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: kDarkGreyColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      item.commission?.floor().toString() ??
                                          '0',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'ريال',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: kLightGreyColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.close,
                                          color: kLightGreyColor,
                                          size: 15,
                                        ),
                                      ),
                                      onTap: () =>
                                          deleteCommission(item.commissionId!),
                                      borderRadius: BorderRadius.circular(200),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
            if (totalCommission != 0)
              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      'العمولة المستحقة',
                      style: TextStyle(
                        color: kDarkGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      totalCommission.floor().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'ريال',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: kLightGreyColor,
                        fontSize: 10,
                      ),
                    ),

                    // Spacer(),
                    // Text(
                    //   totalCommission.floor().toString(),
                    //   style: TextStyle(
                    //     color: kPrimaryColor,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(width: 5),
                    // Text(
                    //   'ر.س',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.normal,
                    //     color: kAccentColor,
                    //     fontSize: 12,
                    //   ),
                    // ),
                    // SizedBox(width: 5),
                    Spacer(),
                    if ((commissionsModel?.commissions?.length ?? 0) != 0)
                      InkWell(
                        onTap: () {
                          deleteAllCommissions();
                        },
                        child: Image.asset(
                          'assets/icons/trash_bin_icon-icons 2.png',
                          color: Theme.of(context).primaryColor,
                          width: 40,
                          height: 40,
                        ),
                        borderRadius: BorderRadius.circular(200),
                      )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        spreadRadius: 2,
                      )
                    ]),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// CommissionTile(),
// CommissionTile(),
// CommissionTile(),
// SizedBox(height: 100),
// Container(
//   margin: EdgeInsets.symmetric(vertical: 5),
//   padding: EdgeInsets.all(12),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     border: Border.all(color: kGreyColor),
//   ),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Row(
//         children: [
//           Text(
//             'العموله المستحقه',
//             style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 color: kDarkGreyColor,
//                 fontSize: 12),
//           )
//         ],
//       ),
//       Row(
//         children: [
//           Text(
//             '150',
//             style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 color: kPrimaryColor,
//                 fontSize: 16),
//           ),
//           SizedBox(width: 5),
//           Text(
//             'SAR',
//             style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 color: kAccentColor,
//                 fontSize: 12),
//           ),
//         ],
//       )
//     ],
//   ),
// ),
