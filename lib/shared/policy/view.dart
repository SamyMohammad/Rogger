import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:silah/shared/policy/cubit/cubit.dart';
import 'package:silah/shared/policy/cubit/states.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../constants.dart';

class PolicyView extends StatelessWidget {
  const PolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PolicyCubit()..policy(),
      child: Scaffold(
        appBar: AppBar(title: Text('شروط وسياسة الاستخدام')),
        body: BlocBuilder<PolicyCubit, PolicyStates>(
          builder: (context, state) {
            final policy = PolicyCubit.of(context).policyModel;
            if (state is PolicyLoadingState) {
              return LoadingIndicator();
            } else if (policy == null) {
              return Text('لا يوجد شئ لعرضه حاليا');
            } else {
              return ListView(
                padding: VIEW_PADDING,
                children: [
                  Html(
                    data: policy.description,
                    style: {
                      "div": Style(
                        fontSize: FontSize.large,
                        wordSpacing: 1.5,
                        letterSpacing: 1,
                      ),
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
