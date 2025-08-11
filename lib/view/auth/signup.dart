import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_assistance_mobile/componant/myTextFeild.dart';
import 'package:legal_assistance_mobile/view/homepage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int _currentStep = 0;
  String? _selectedGender;

  final formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirnPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bithDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // Birth date controller and variable
  final TextEditingController _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;

  // Pick birth date function
  Future<void> _pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitForm() {
    // You can collect all field values here if needed
    // print("Sign Up Submitted");
    // print("Birth Date: ${_birthDateController.text}");
    // print("Gender: $_selectedGender");

    // Show a simple snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("account_created_successfully".tr),
        backgroundColor: Colors.green,
      ),
    );

    // Reset the stepper or navigate
    Get.to(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final List<Step> steps = [
      Step(
        title: Text('account_info'.tr),
        content: Column(
          children: [
            MyTextFeild(
              textType: TextInputType.name,
              text: "user_name".tr,
              obscureText: false,
              controller: _nameController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            MyTextFeild(
              textType: TextInputType.emailAddress,
              text: "email".tr,
              obscureText: false,
              controller: _emailController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            MyTextFeild(
              textType: TextInputType.visiblePassword,
              text: "password".tr,
              obscureText: true,
              controller: _passwordController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            MyTextFeild(
              textType: TextInputType.visiblePassword,
              text: "confirm_password".tr,
              obscureText: true,
              controller: _confirnPasswordController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            MyTextFeild(
              textType: TextInputType.number,
              text: "phone".tr,
              obscureText: false,
              controller: _phoneController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            SizedBox(height: 10),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: Text('general_info'.tr),
        content: Column(
          children: [
            MyTextFeild(
              textType: TextInputType.number,
              text: "national_number".tr,
              obscureText: false,
              controller: _nationalNumberController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            MyTextFeild(
              textType: TextInputType.text,
              validation: (value) {
                return "field_is_empty".tr;
              },
              text: "address".tr,
              obscureText: false,
              controller: _addressController,
            ),
            SizedBox(height: 10),
            // Birth date input field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "birth_date".tr,
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _pickBirthDate(context),
              ),
            ),
            SizedBox(height: 10),
            MyTextFeild(
              textType: TextInputType.text,
              text: "birth_place".tr,
              obscureText: false,
              controller: _birthPlaceController,
              validation: (value) {
                if (value!.isEmpty) {
                  return "field_is_empty".tr;
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(hintText: "gender".tr),
                items:
                    ['male'.tr, 'female'.tr].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('create_account'.tr)),
      body: Form(
        key: formKey,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Stepper(
            key: ValueKey(_currentStep), // Enables animation
            currentStep: _currentStep,
            type: StepperType.vertical,
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (context, details) {
              final isLastStep = _currentStep == steps.length - 1;
              return Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (isLastStep) {
                        _submitForm();
                      } else {
                        _nextStep();
                      }
                    },
                    child: Text(isLastStep ? 'create_account'.tr : 'next'.tr),
                  ),
                  if (_currentStep != 0)
                    TextButton(
                      onPressed: _previousStep,
                      child: Text('back'.tr),
                    ),
                ],
              );
            },
            steps: steps,
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
}
