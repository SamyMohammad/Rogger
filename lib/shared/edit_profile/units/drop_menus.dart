// part of '../view.dart';
//
// class _DropMenus extends StatelessWidget {
//   const _DropMenus({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = EditProfileCubit.of(context);
//     return Column(
//       children: [
//         // BlocBuilder<CitiesCubit , CitiesStates>(
//         //   builder: (context, state) {
//         //     return DropMenu(
//         //       upperText: 'المدينه',
//         //       value: CitiesCubit.of(context).citiesModel!.countries?.firstWhere((element) => element.countryId == AppStorage.getUserModel()?.address?.countryId),
//         //       hint:AppStorage.getUserModel()!.address!.country,
//         //       isItemsModel: true,
//         //       items: state is CitiesLoadingState ? [] : CitiesCubit.of(context).citiesModel!.countries!,
//         //       onChanged: (v) {
//         //         cubit.countryId = (v as Country).countryId;
//         //         // print((v as Country).name);
//         //         // print(cubit.countryId);
//         //       },
//         //     );
//         //   },
//         // ),
//         if (AppStorage.isStore)
//           BlocBuilder<CitiesCubit, CitiesStates>(
//             builder: (context, state) {
//               if (state is CitiesLoadingState) {
//                 return LoadingIndicator();
//               }
//               final countries =
//                   CitiesCubit.of(context).citiesModel?.countries ??
//                       [];
//               if (cubit.countryID == null &&
//                   cubit.countryName != null &&
//                   countries.isNotEmpty) {
//                 cubit.countryID = countries
//                     .firstWhere((element) =>
//                 element.name == cubit.countryName)
//                     .id;
//               }
//               return DropMenu(
//                 upperText: 'حدد المدينة',
//                 isItemsModel: true,
//                 value: cubit.countryID,
//                 items: countries,
//                 onChanged: (v) {
//                   cubit.countryID = (v as Country).id;
//                 },
//               );
//             },
//           ),
//         if (AppStorage.isStore)
//           BlocBuilder(
//             bloc: cubit,
//             builder: (context, state) {
//               final categories =
//                   cubit.mapCategoriesModel?.mapCategories ?? [];
//               if (categories.isEmpty) {
//                 return SizedBox.shrink();
//               }
//               return DropMenu(
//                 upperText: 'اقسام الخريطة',
//                 isItemsModel: true,
//                 value: cubit.selectedMapCategory?.id,
//                 items: categories,
//                 onChanged: (v) {
//                   cubit.selectedMapCategory = v;
//                 },
//               );
//             },
//           ),
//       ],
//     );
//   }
// }
