import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/tickets/cubit/cubit.dart';
import 'package:silah/store/tickets/units/verification_method_widget.dart';
import 'package:silah/widgets/confirm_button.dart';

class ChooseVerificationMethodSection extends StatefulWidget {
  const ChooseVerificationMethodSection({super.key});

  @override
  State<ChooseVerificationMethodSection> createState() =>
      _ChooseVerificationMethodSectionState();
}

class _ChooseVerificationMethodSectionState
    extends State<ChooseVerificationMethodSection> {
  int? selectedIndex; // To track the selected widget

  @override
  Widget build(BuildContext context) {
    final cubit = TicketsCubit.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        VerificationMethodWidget(
          isGuranteed: true,
          icon: "verified",
          isVerificationContainer: true,
          price: null,
          isActivated: false,
          isAnyMethodVerified: true,
          name: "حساب مضمون",
          isChoosen: selectedIndex == 0, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              selectedIndex = selectedIndex == 0 ? null : 0;
            });
          },
        ),
        const SizedBox(height: 20),
        // First VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[0],
          price: 20,
          isActivated: false,

          isVerificationContainer: false,
          name: "السجل التجاري",
          isChoosen: selectedIndex == 1, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              selectedIndex = selectedIndex == 1 ? null : 1;
            });
          },
        ),
        const SizedBox(height: 10),
        // Second VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[1],
          price: 20,
          isActivated: false,
          isVerificationContainer: false,
          name: "شهادة معروف",
          isChoosen: selectedIndex == 2, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              selectedIndex = selectedIndex == 2 ? null : 2;
            });
          },
        ),
        const SizedBox(height: 10),
        // Third VerificationMethodWidget
        VerificationMethodWidget(
          icon: cubit.icons[2],
          price: 20,
          isActivated: false,
          isVerificationContainer: false,
          name: "وثيقة ممارس حر",
          isChoosen: selectedIndex == 3, // Highlight if selected
          onTap: () {
            setState(() {
              // Toggle selection: if already selected, deselect it
              selectedIndex = selectedIndex == 3 ? null : 3;
            });
          },
        ),
        const SizedBox(height: 10),
        // Continue Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ConfirmButton(
            onPressed: selectedIndex != null
                ? () {
                    // Handle the action when a method is selected
                    print('Selected method index: $selectedIndex');
                  }
                : null, // Disable button when no method is selected
            isExpanded: true,
            title: 'استمرار',
            color: selectedIndex != null ? activeButtonColor : kGreyColor,
          ),
        ),
      ],
    );
  }
}
