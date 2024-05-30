import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/bank_accounts/cubit/cubit.dart';
import 'package:silah/store/bank_accounts/cubit/states.dart';
import 'package:silah/widgets/app/bankAccount.dart';
import 'package:silah/widgets/loading_indicator.dart';

class SBankAccountsView extends StatelessWidget {
  const SBankAccountsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankCubit()..getBankData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الحسابات البنكية'),
        ),
        body: BlocBuilder<BankCubit, BankStates>(
          builder: (context, state) {
            if (state is BankLoadingState) {
              return LoadingIndicator();
            }
            final dataBank = BankCubit.of(context).bankModel!.banks;
            return (dataBank == null || dataBank.isEmpty)
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDownBig(
                          duration: Duration(milliseconds: 400),
                          delay: Duration(milliseconds: 200),
                          child: Text(
                            'لا توجد بنوكـ مضافة',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor),
                          )),
                    ],
                  ))
                : Column(
                    children: [
                      // Divider(),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          itemCount: dataBank.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: kGreyColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     IconButton(
                                  //       padding: EdgeInsets.zero,
                                  //       onPressed: (){
                                  //         BankCubit.of(context).deleteBank(index);
                                  //       },
                                  //       icon: Icon(FontAwesomeIcons.trash,size: 18,color: Colors.red,),),
                                  //     IconButton(
                                  //       onPressed: (){},
                                  //       icon: Icon(FontAwesomeIcons.pencilAlt,size: 18,color:kPrimaryColor,),),
                                  //   ],
                                  // ),
                                ),
                                BankAccountDetails(
                                  image: dataBank[index].bankImg,
                                  name: dataBank[index]
                                      .bankAccountName
                                      .toString(),
                                  accountNumber:
                                      dataBank[index].bankAccountNum!,
                                  iban: dataBank[index].bankIpan,
                                ),
                              ],
                            );
                          },
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                    ],
                  );
          },
        ),
        // floatingActionButton: FadeInUpBig(
        //   duration: Duration(milliseconds: 400),
        //   delay: Duration(milliseconds:400),
        //   child: FloatingActionButton(
        //     onPressed: (){
        //       // RouteManager.navigateTo(AddBankView());
        //     },
        //     elevation: 10,
        //     mini: true,
        //     backgroundColor: kPrimaryColor,
        //     tooltip: 'اضافة بنك جديد',
        //     child: Icon(FontAwesomeIcons.plus,size: 14,),
        //   ),
        // ),
      ),
    );
  }
}
