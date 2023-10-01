import 'package:formz/formz.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/inputs.dart';

// Define input validation errors
enum RepeatPasswordError { empty, compare}

// Extend FormzInput and provide the input type and error type.
class RepeatPassword extends FormzInput<String, RepeatPasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  
  // Call super.pure to represent an unmodified form input.
  const RepeatPassword.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const RepeatPassword.dirty(String value) : super.dirty(value);

  //const RepeatPassword.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RepeatPasswordError.empty) return 'Field is required';
    if (displayError == RepeatPasswordError.compare) return 'password does not match';
   

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RepeatPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RepeatPasswordError.empty;
    
  
    return null;
  }
}
