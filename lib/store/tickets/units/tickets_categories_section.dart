import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared_cubit/category_cubit/cubit.dart';
import 'package:silah/shared_cubit/category_cubit/states.dart';
import 'package:silah/shared_models/categories_model.dart';
import 'package:silah/shared_models/sub_categories_model.dart';
import 'package:silah/store/change_map_activity/units/choose_bottom_sheet.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/drop_menu.dart';
import 'package:silah/widgets/image_picker_form.dart';
import 'package:silah/widgets/snack_bar.dart';

import '../../../widgets/starter_divider.dart';
import '../cubit/cubit.dart';

class TicketsCategoriesSection extends StatefulWidget {
  const TicketsCategoriesSection({
    super.key,
  });

  @override
  State<TicketsCategoriesSection> createState() =>
      _TicketsCategoriesSectionState();
}

class _TicketsCategoriesSectionState extends State<TicketsCategoriesSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final cubit = CategoryCubit.of(context);
    cubit.getSubCategories(cubit.categoriesModel?.categories?.first.id ?? '1');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryStates>(
      listener: (context, state) {
        if (state is RequestVerificationSucessState) {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 5),
                        StarterDivider(),
                        const SizedBox(height: 15),
                        Image.asset(getAsset("success_verification"),
                            height: 85, width: 85),
                        const SizedBox(height: 15),
                        Text("لقد تم إرسال طلبكم بنجاح",
                            style: TextStyle(
                                color: kLightGreyColor,
                                fontSize: 20,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 15),
                        Text("RD-${state.response['subscription_id']}",
                            style: TextStyle(
                                color: kLightGreyColor,
                                fontSize: 14,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 10),
                        Text("الرجاء حفظ رقم الطلب",
                            style: TextStyle(
                                color: kLightGreyColor,
                                fontSize: 14,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        Text("والذي سيتم معالجته في غضون يومي عمل",
                            style: TextStyle(
                                color: kLightGreyColor,
                                fontSize: 14,
                                fontFamily: 'IBMPlexSansArabic',
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              });
        }
        if (state is RequestVerificationErrorState) {
          print('RequestVerificationErrorState');
          if (state.response['error'] ==
              'can not subscrip to the same categorey more than onec') {
            showSnackBar('لا يمكنك الاشتراك في نفس القسم أكثر من مرة',
                errorMessage: true);
          } else {
            showSnackBar("هناك خطأ!", errorMessage: true);
          }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.grey.shade500,
                        spreadRadius: -1),
                    BoxShadow(
                        offset: Offset(1, 0),
                        color: Colors.grey.shade500,
                        blurRadius: 2,
                        spreadRadius: -1),
                  ]),
              margin: EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Text(
                    "أشترك في احد الاقسام وكون منتجاتك",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CategoryCubit, CategoryStates>(
                    builder: (context, state) {
                      final categories = CategoryCubit.of(context)
                          .paidCategoriesModel
                          ?.categories;

                      return ChooseBottomSheet<Category>(
                          title: 'اختيار القسم',
                          items: categories ?? [], // List of MapCategory
                          selectedItem: CategoryCubit.of(context)
                              .selectedCategory, // Initially selected category
                          itemLabelBuilder: (category) =>
                              category.name ??
                              '', // Customize how the category name is shown
                          onItemSelected: (selectedCategory) {
                            print(selectedCategory.name);
                            print(selectedCategory.id);
                            CategoryCubit.of(context).selectedSubCategory = null;
                            CategoryCubit.of(context)
                                .getSubCategories(selectedCategory.id);
                            CategoryCubit.of(context).selectedCategory =
                                selectedCategory;
                            CategoryCubit.of(context).checkInputsValidity();
                            // print(CategoryCubit.of(context)
                            //     .getSubCategory
                            //     ?.categories?[0]
                            //     .name);
                            // cubit.selectedMapCategory =
                            //     selectedCategory;
                            // cubit.updateMapCategory(selectedCategory
                            //     .id!); // Handle selection
                            // setState(() {}); // Update the UI
                          });
                      // return DropMenu(
                      //   isMapDepartment: false,
                      //   hint: 'اختيار القسم',
                      //   items: categories ?? [],
                      //   isItemsModel: true,
                      //   onChanged: (v) {
                      //     print(v.name);
                      //     print(v.id);
                      //     CategoryCubit.of(context).getSubCategories(v.id);
                      //     CategoryCubit.of(context).selectedCategory = v;
                      //     CategoryCubit.of(context).checkInputsValidity();
                      //     // print(CategoryCubit.of(context)
                      //     //     .getSubCategory
                      //     //     ?.categories?[0]
                      //     //     .name);
                      //   },
                      // );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CategoryCubit, CategoryStates>(
                    builder: (context, state) {
                      final subCategories =
                          CategoryCubit.of(context).subCategories;
                      // var seen = Set<Categories>();
                      // List<Categories>? uniquelist = subCategories
                      //     ?.where((country) => seen.add(country))
                      //     .toList();
                      if (CategoryCubit.of(context).isSubCategoryShow) {
                        return ChooseBottomSheet<Categories>(
                          title: 'اختيار نوع القسم',
                          items: subCategories, // List of MapCategory
                          selectedItem: CategoryCubit.of(context)
                              .selectedSubCategory, // Initially selected category
                          itemLabelBuilder: (category) =>
                              category.name ??
                              '', // Customize how the category name is shown
                          onItemSelected: (v) {
                            CategoryCubit.of(context).selectedSubCategory = v;
                            CategoryCubit.of(context).checkInputsValidity();
                          },

                          //  (selectedCategory) {
                          //   print(selectedCategory.name);
                          //   print(selectedCategory.id);
                          //   CategoryCubit.of(context)
                          //       .getSubCategories(selectedCategory.id);
                          //   CategoryCubit.of(context).selectedCategory =
                          //       selectedCategory;
                          //   CategoryCubit.of(context).checkInputsValidity();
                          //   // print(CategoryCubit.of(context)
                          //   //     .getSubCategory
                          //   //     ?.categories?[0]
                          //   //     .name);
                          //   // cubit.selectedMapCategory =
                          //   //     selectedCategory;
                          //   // cubit.updateMapCategory(selectedCategory
                          //   //     .id!); // Handle selection
                          //   // setState(() {}); // Update the UI
                          // }
                        );
                        return DropMenu(
                          hint: 'اختيار نوع القسم',
                          items: subCategories,
                          isItemsModel: true,
                          onChanged: subCategories.length == 0
                              ? null
                              : (v) {
                                  CategoryCubit.of(context)
                                      .selectedSubCategory = v;
                                  CategoryCubit.of(context)
                                      .checkInputsValidity();
                                },
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  const SizedBox(height: 26),
                  Text(
                    "الرسوم السنوية ${TicketsCubit.of(context).settings?['data']['subscription_fee']} ريال",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  ImagePickerForm(
                    onChange: (selectedImage) {
                      CategoryCubit.of(context).selectedCopyOfTransferImage =
                          selectedImage;
                      CategoryCubit.of(context).checkInputsValidity();
                      print(selectedImage?.path);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 30),
            BlocListener<CategoryCubit, CategoryStates>(
                listener: (context, state) {
                  final cubit = CategoryCubit.of(context);
                  // React to state changes here
                  if (state is ValidateState) {
                    // Do something when isValid state changes
                    cubit.isValid = true;
                  }
                },
                child: ConfirmButton(
                  horizontalPadding: 30,
                  title: "طلب",
                  color: state is ValidateState
                      ? state.state == true
                          ? activeButtonColor
                          : kDarkGreyColor
                      : kDarkGreyColor,
                  onPressed: () {
                    CategoryCubit.of(context).requestVerificationCategory();
                  },
                ))
            //  BlocBuilder<CategoryCubit, CategoryStates>(
            //   builder: (context,state) {
            //    final cubit =CategoryCubit.of(context);
            //     return ConfirmButton(
            //       title: "طلب",
            //       color:cubit.isValid?  kPrimaryColor :kGreyButtonColorD9,
            //       onPressed: (){},
            //     );
            //   }
            // )
          ],
        );
      },
    );
  }
}
