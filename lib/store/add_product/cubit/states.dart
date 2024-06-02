abstract class AddProductStates {}

class AddProductInitState extends AddProductStates {}

class AddProductImagesLoadingState extends AddProductStates {}

class AddProductLoadingState extends AddProductStates {}

class FormValidityState extends AddProductStates {
  bool? isValid;
  FormValidityState({this.isValid});
}
