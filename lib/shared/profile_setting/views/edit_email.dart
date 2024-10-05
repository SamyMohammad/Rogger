part of '../view.dart';

class _EditEmailView extends StatelessWidget {
  const _EditEmailView({Key? key, required this.cubit}) : super(key: key);

  final EditProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('البريد الالكتروني'),
      ),
      body: Form(
        key: cubit.formKey,
        child: ListView(
          padding: VIEW_PADDING,
          children: [
            InputFormField(
              controller: cubit.emailController,
              upperText: 'البريد الالكتروني',
              verticalMargin: 10,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (v) => cubit.checkInputsValidity(),
              suffixIcon: Icon(
                FontAwesomeIcons.pen,
                color: kGreyColor,
                size: 16,
              ),
            ),
            SizedBox(height: 16),
            BlocBuilder(
              bloc: cubit,
              builder: (context, state) {
                final isValid = cubit.areInputsValid &&
                    cubit.emailController.text.isNotEmpty;
                if (state is EditProfileLoadingState) return LoadingIndicator();
                return ConfirmButton(
                  title: 'تعديل',
                  fontColor: isValid ? Colors.white : Color(0xFFA1A1A1),
                  color: isValid
                      ? activeButtonColor
                      : ThemeCubit.of(context).isDark
                          ? Color(0xFF1E1E26)
                          : Color(0xffFAFAFF),
                  onPressed: isValid ? cubit.editProfile : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
