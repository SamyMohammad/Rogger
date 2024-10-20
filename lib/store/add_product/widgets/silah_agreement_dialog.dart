import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/store/add_product/cubit/cubit.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/starter_divider.dart';

class SilahAgreementDialog extends StatefulWidget {
  const SilahAgreementDialog({
    super.key,
    required this.addProductCubit,
  });

  final AddProductCubit addProductCubit;

  @override
  State<SilahAgreementDialog> createState() => _SilahAgreementDialogState();
}

class _SilahAgreementDialogState extends State<SilahAgreementDialog> {
  late ValueNotifier<bool> _isCheckedNotifier;

  @override
  void initState() {
    _isCheckedNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isCheckedNotifier,
        builder: (context, value, child) {
          return Dialog(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  StarterDivider(height: 6, width: 50),
                  const SizedBox(height: 10),
                  Text(
                    "معاهدة صلة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "بسم الله الرحمن الرحيم قال الله تعالى “وَأَوْفُوا بِعَهْدِ اللَّهِ إِذَا عَاهَدتُّمْ وَلَا تَنقُضُوا الْأَيْمَانَ بَعْدَ تَوْكِيدِهَا وَقَدْ جَعَلْتُمُ اللَّهَ عَلَيْكُمْ كَفِيلً“   صدق الله العظيم.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kGreyText73, height: 1.2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "اتعهد واقسم بالله انا المعلن آن آدفع عمولة الموقع وهي 2% من قيمة البيع سواء تم البيع عبر الموقع او بسببه",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "كما اتعهد بدفع العمولة خلال 3 ايام من استلام مبلغ البيعة",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      // CustomCheckbox(isActive: true),
                      Checkbox(
                        activeColor: Color(0xFF17910D),
                        value: _isCheckedNotifier.value,
                        shape: const CircleBorder(),
                        focusColor: Theme.of(context).primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            _isCheckedNotifier.value = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 0),
                      Text(
                        "أتعهد بذلك",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            height: 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  ConfirmButton(
                    title: "نشر الإعلان",
                    fontColor: Theme.of(context).primaryColor,
                    color: _isCheckedNotifier.value
                        ? activeButtonColor
                        : Colors.grey,
                    onPressed: _isCheckedNotifier.value
                        ? widget.addProductCubit.addProduct
                        : null,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        });
  }
}
