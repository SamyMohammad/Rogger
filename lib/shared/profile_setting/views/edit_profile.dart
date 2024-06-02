part of '../view.dart';

class _EditProfileView extends StatelessWidget {
  const _EditProfileView({Key? key, required this.cubit}) : super(key: key);

  final EditProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
      ),
      body: Form(
        key: cubit.formKey,
        child: ListView(
          padding: VIEW_PADDING,
          children: [
            InputFormField(
              controller: cubit.nameController,
              upperText: 'الاسم',
              verticalMargin: 10,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (_) => cubit.checkInputsValidity(),
              suffixIcon: Icon(
                FontAwesomeIcons.pen,
                color: kGreyColor,
                size: 16,
              ),
              validator: Validator.name,
            ),
            if (AppStorage.isStore)
              InputFormField(
                controller: cubit.nicknameController,
                upperText: 'اسم المستخدم@',
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (_) => cubit.checkInputsValidity(),
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
                bloc: cubit,
                builder: (context, state) {
                  final categories =
                      cubit.mapCategoriesModel?.mapCategories ?? [];
                  if (categories.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return DropMenu(
                    upperText: 'اقسام الخريطة',
                    isItemsModel: true,
                    isMapDepartment: true,
                    value: cubit.selectedMapCategory,
                    items: categories,
                    onChanged: (v) {
                      cubit.selectedMapCategory = v;
                      cubit.checkInputsValidity();
                    },
                  );
                },
              ),
            SizedBox(height: 16),
            BlocBuilder(
              bloc: cubit,
              builder: (context, state) {
                if (state is EditProfileLoadingState) return LoadingIndicator();
                return ConfirmButton(
                  title: 'تعديل',
                  color: cubit.areInputsValid ? kPrimaryColor : kGreyColor,
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
