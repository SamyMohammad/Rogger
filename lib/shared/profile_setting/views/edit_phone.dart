part of '../view.dart';

class _EditPhoneView extends StatelessWidget {
  const _EditPhoneView({Key? key, required this.cubit}) : super(key: key);

  final EditProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('رقم الجوال'),
      ),
      body: Form(
        key: cubit.formKey,
        child: ListView(
          padding: VIEW_PADDING,
          children: [
            _PhoneField(cubit: cubit),
            SizedBox(height: 16),
            BlocBuilder(
              bloc: cubit,
              builder: (context, state) {
                if (state is EditProfileLoadingState) return LoadingIndicator();
                return ConfirmButton(
                  title: 'تعديل',
                  color: cubit.areInputsValid ? activeButtonColor : kGreyColor,
                  onPressed: cubit.areInputsValid ? cubit.editProfile : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
