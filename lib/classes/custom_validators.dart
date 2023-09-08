import 'package:form_field_validator/form_field_validator.dart';

class BooleanValidator extends TextFieldValidator {
  final bool isFieldValid;

  BooleanValidator(this.isFieldValid, {required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) {
    return !isFieldValid;
  }
}
