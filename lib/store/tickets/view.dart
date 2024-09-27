import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/store/tickets/choose_verification_method_view.dart';
import 'package:silah/store/tickets/cubit/cubit.dart';
import 'package:silah/store/tickets/cubit/states.dart';
import 'package:silah/store/tickets/units/tickets_categories_section.dart';
import 'package:silah/widgets/custom_tabview.dart';

class TicketsView extends StatelessWidget {
  const TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تذاكر الاشتراك"),
      ),
      body: BlocProvider(
        create: (context) => TicketsCubit()
          ..getStatusTicketsVerification()
          ..getSettings()
          ..getModelIndexOfVerificatio('Commercial Register')
          ..isAnyRequestInTypeVerification('Commercial Register'),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Divider(thickness: 5, height: 0.5, color: kLightGreyColorB4),
              Builder(builder: (context) {
                final cubit = TicketsCubit.of(context);
                return CustomTabview(
                  firstTabTitle: "توثيق",
                  secondTabTitle: "أقسام",
                  onTap: cubit.toggleIsFirstSelected,
                );
              }),
              BlocBuilder<TicketsCubit, TicketsStates>(
                  builder: (context, state) {
                final ticketsCubit = TicketsCubit.of(context);
                //  ticketsCubit
                //       .getModelIndexOfVerificatio('Commercial Register');
                //   ticketsCubit
                //       .isAnyRequestInTypeVerification('Commercial Register');
                return ticketsCubit.isFirstSelected
                    ? ChooseVerificationMethodSection()
                    : TicketsCategoriesSection();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
