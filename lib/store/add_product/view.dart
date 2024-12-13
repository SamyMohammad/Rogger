import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/validator/validation.dart';
import 'package:silah/shared/product_details/model.dart';
import 'package:silah/store/add_product/categories_in_add_product.dart';
import 'package:silah/store/add_product/cubit/cubit.dart';
import 'package:silah/store/add_product/cubit/states.dart';
import 'package:silah/store/add_product/widgets/image_widget.dart';
import 'package:silah/store/add_product/widgets/silah_agreement_dialog.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/text_form_field.dart';
import 'package:silah/widgets/video_bubble.dart';

import '../../shared_cubit/theme_cubit/cubit.dart';
import '../change_map_activity/units/choose_bottom_sheet.dart';

class SAddProductView extends StatefulWidget {
  const SAddProductView({Key? key, this.productsDetailsModel})
      : super(key: key);
  final BaseModel? productsDetailsModel;

  @override
  State<SAddProductView> createState() => _SAddProductViewState();
}

class _SAddProductViewState extends State<SAddProductView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(widget.productsDetailsModel)..init(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.productsDetailsModel == null
                ? 'أضف اعلان'
                : 'تعديل الاعلان')),
        body: BlocBuilder<AddProductCubit, AddProductStates>(
            builder: (context, state) {
          final addProductCubit = AddProductCubit.of(context);

          return Form(
            key: addProductCubit.formKey,
            child: ValueListenableBuilder(
              valueListenable: addProductCubit.categoryID,
              builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: addProductCubit.nameController,
                  builder: (context, value, child) {
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      children: [
                        Wrap(
                          children: [
                            ...addProductCubit.images
                                .map((e) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: ImageWidget(
                                        image: e,
                                        index:
                                            addProductCubit.images.indexOf(e),
                                        onEdit: () => addProductCubit.editImage(
                                            addProductCubit.images.indexOf(e)),
                                        onDelete: () =>
                                            addProductCubit.removeImage(e),
                                      ),
                                    ))
                                .toList(),
                            if (addProductCubit.images.length != 5)
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: GestureDetector(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: kLightGreyColorEB,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        getIcon("image"),
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  onTap: addProductCubit.pickImages,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            height: addProductCubit.video != null ||
                                    widget.productsDetailsModel?.video != null
                                ? 100
                                : 100,
                            width: addProductCubit.video != null ||
                                    widget.productsDetailsModel?.video != null
                                ? null
                                : 100,
                            child: GestureDetector(
                              child: addProductCubit.video == null
                                  ? widget.productsDetailsModel?.video !=
                                              null &&
                                          widget.productsDetailsModel!.video!
                                              .isNotEmpty
                                      ? VideoBubble(
                                          url: widget
                                              .productsDetailsModel?.video,
                                          file: addProductCubit.video,
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: kLightGreyColorEB,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: SvgPicture.asset(
                                            getIcon("video"),
                                            height: 40,
                                          )),
                                        )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: kLightGreyColorEB,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SvgPicture.asset(getIcon("video")),
                                    ),
                              onTap: addProductCubit.pickVideo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<AddProductCubit, AddProductStates>(
                          builder: (context, state) {
                            final categories = AddProductCubit.of(context)
                                .categoriesInAddProduct
                                ?.data;
                            return ChooseBottomSheet<CategoryInAddProduct>(
                              items: categories ?? [],
                              title: 'القسم',
                              itemLabelBuilder: (category) =>
                                  category.name ?? '',
                              selectedItem:
                                  addProductCubit.categoryInAddProduct,
                              onItemSelected: (selectedItem) {
                                addProductCubit.categoryInAddProduct =
                                    selectedItem;
                                addProductCubit.categoryID.value =
                                    addProductCubit.categoryInAddProduct?.id;
                                addProductCubit.checkInputsValidity();
                              },
                            );
                            // DropMenu(
                            //     upperText: 'القسم*',
                            //     hint: 'اختر القسم',
                            //     value: addProductCubit.categoryInAddProduct,
                            //     items: categories ?? [],
                            //     isItemsModel: true,
                            //     onChanged: (v) {
                            //       addProductCubit.categoryInAddProduct =
                            //           (v as CategoryInAddProduct);
                            //       addProductCubit.categoryID.value =
                            //           addProductCubit.categoryInAddProduct?.id;
                            //       addProductCubit.checkInputsValidity();
                            //     });
                          },
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InputFormField(
                                // upperText: 'اسم اعلان',
                                hint: 'اسم الاعلان',
                                hasLabel: true,
                                hasBorder: true,
                                validator: Validator.name,
                                isNext: false,
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                onChanged: (a) =>
                                    addProductCubit.checkInputsValidity(),
                                controller: addProductCubit.nameController,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: InputFormField(
                                // upperText: 'السعر',
                                hint: 'السعر',
                                hasLabel: true,

                                hasBorder: true,
                                isNumber: true,
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                controller: addProductCubit.priceController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        InputFormField(
                          // upperText: 'الوصف',
                          hasBorder: true,
                          hint: 'كتابة الوصف',
                          isNext: false,
                          multiLine: true,
                          maxLines: 2,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          controller: addProductCubit.descriptionController,
                        ),
                        state is AddProductLoadingState
                            ? LoadingIndicator()
                            : ConfirmButton(
                                title: widget.productsDetailsModel != null
                                    ? 'تعديل'
                                    : 'إضافة',
                                fontColor: addProductCubit.nameController.value
                                            .text.isNotEmpty &&
                                        addProductCubit.categoryID.value !=
                                            null &&
                                        addProductCubit.images.isNotEmpty
                                    ? Colors.white
                                    : Color(0xFFA1A1A1),
                                color: addProductCubit.nameController.value.text
                                            .isNotEmpty &&
                                        addProductCubit.categoryID.value !=
                                            null &&
                                        addProductCubit.images.isNotEmpty
                                    ? activeButtonColor
                                    : ThemeCubit.of(context).isDark
                                        ? Color(0xFF1E1E26)
                                        : Color(0xffFAFAFF),
                                // color: addProductCubit.nameController.value.text
                                //             .isNotEmpty &&
                                //         addProductCubit.categoryID.value !=
                                //             null &&
                                //         addProductCubit.images.isNotEmpty
                                //     ? activeButtonColor
                                //     : kDarkGreyColor,
                                verticalMargin: 20,
                                onPressed: addProductCubit.nameController.value
                                            .text.isNotEmpty &&
                                        addProductCubit.categoryID.value !=
                                            null &&
                                        addProductCubit.images.isNotEmpty
                                    ? widget.productsDetailsModel == null
                                        ? () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SilahAgreementDialog(
                                                      addProductCubit:
                                                          addProductCubit);
                                                });
                                          }
                                        // ? addProductCubit.addProduct
                                        : addProductCubit.updateProduct
                                    : null,
                              ),
                      ],
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }
}
