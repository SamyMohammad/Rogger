part of '../view.dart';

class _EditPhoneView extends StatefulWidget {
  const _EditPhoneView({Key? key, required this.cubit}) : super(key: key);

  final EditProfileCubit cubit;

  @override
  State<_EditPhoneView> createState() => _EditPhoneViewState();
}

class _EditPhoneViewState extends State<_EditPhoneView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserModel();
  }

  getUserModel() async {
    await getUserAndCache(
        AppStorage.customerID, AppStorage.getUserModel()!.customerGroup!);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "AppStorage.getUserModel()?.modificationInterval${AppStorage.getUserModel()?.modificationInterval}");
    return Scaffold(
      appBar: AppBar(
        title: Text('رقم الجوال'),
      ),
      body: Form(
        key: widget.cubit.formKey,
        child: ListView(
          padding: VIEW_PADDING,
          children: [
            _PhoneField(cubit: widget.cubit),
            SizedBox(height: 16),
            BlocBuilder(
              bloc: widget.cubit,
              builder: (context, state) {
                if (state is EditProfileLoadingState) return LoadingIndicator();
                return ConfirmButton(
                  title: 'تعديل',
                  fontColor: widget.cubit.areInputsValid
                      ? Colors.white
                      : Color(0xFFA1A1A1),
                  color: widget.cubit.areInputsValid && AppStorage.getUserModel()?.modificationInterval==null
                      ? activeButtonColor
                      : ThemeCubit.of(context).isDark
                          ? Color(0xFF1E1E26)
                          : Color(0xffFAFAFF),

                  // color: cubit.areInputsValid ? activeButtonColor : kGreyColor,
                  onPressed: widget.cubit.areInputsValid && AppStorage.getUserModel()?.modificationInterval==null
                      ? widget.cubit.editProfile
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
