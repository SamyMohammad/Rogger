part of '../view.dart';

class _EditProfileView extends StatefulWidget {
  final EditProfileCubit cubit;

  const _EditProfileView({Key? key, required this.cubit}) : super(key: key);

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
      ),
      body: Form(
        key: widget.cubit.formKey,
        child: ListView(
          padding: VIEW_PADDING,
          children: [
            InputFormField(
              controller: widget.cubit.nameController,
              upperText: 'الاسم',
              verticalMargin: 10,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (_) => widget.cubit.checkInputsValidity(),
              suffixIcon: Icon(
                FontAwesomeIcons.pen,
                color: kGreyColor,
                size: 16,
              ),
              validator: Validator.name,
            ),
            if (AppStorage.isStore)
              InputFormField(
                controller: widget.cubit.nicknameController,
                upperText: 'اسم المستخدم@',
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (_) => widget.cubit.checkInputsValidity(),
                suffixIcon: Icon(
                  FontAwesomeIcons.pen,
                  color: kGreyColor,
                  size: 16,
                ),
                validator: Validator.username,
              ),
            // if (AppStorage.isStore)
            //   BlocBuilder<CitiesCubit, CitiesStates>(
            //     builder: (context, state) {
            //       if (state is CitiesLoadingState) {
            //         return LoadingIndicator();
            //       }
            //       final countries = CitiesCubit.of(context).citiesModel?.countries ?? [];
            //       if (cubit.countryID == null &&
            //           cubit.countryName != null &&
            //           countries.isNotEmpty) {
            //         cubit.countryID = countries.firstWhere((element) => element.name == cubit.countryName).id;
            //       }
            //       return DropMenu(
            //         upperText: 'حدد المدينة',
            //         isItemsModel: true,
            //         value: cubit.countryID,
            //         items: countries,
            //         onChanged: (v) {
            //           cubit.countryID = (v as Country).id;
            //           cubit.checkInputsValidity();
            //         },
            //       );
            //     },
            //   ),
            if (AppStorage.isStore)
              BlocBuilder(
                bloc: widget.cubit,
                builder: (context, state) {
                  final categories =
                      widget.cubit.mapCategoriesModel?.mapCategories ?? [];
                  if (categories.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return DropMenu(
                    upperText: 'اقسام الخريطة',
                    isItemsModel: true,
                    isMapDepartment: true,
                    value: widget.cubit.selectedMapCategory,
                    items: categories,
                    onChanged: (v) {
                      widget.cubit.selectedMapCategory = v;
                      // widget.cubit.checkInputsValidity();
                    },
                  );
                },
              ),
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
                  color: widget.cubit.areInputsValid
                      ? activeButtonColor
                      : ThemeCubit.of(context).isDark
                          ? Color(0xFF1E1E26)
                          : Color(0xffFAFAFF),
                  // color: cubit.areInputsValid ? activeButtonColor : kGreyColor,
                  onPressed: widget.cubit.areInputsValid
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.cubit.checkInputsValidity();
  }
}
