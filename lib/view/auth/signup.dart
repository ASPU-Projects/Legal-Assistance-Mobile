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

  @override
  Widget build(BuildContext context) {
    final List<Step> _steps = [
      Step(
        title: Text('Account Info'),
        content: Column(
          children: [
            MyTextFeild(text: "User Name", obscureText: false),
            MyTextFeild(text: "Email", obscureText: false),
            MyTextFeild(text: "Password", obscureText: true),
            MyTextFeild(text: "Confirm Password", obscureText: true),
            MyTextFeild(text: "Phone", obscureText: false),
            SizedBox(height: 10),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: Text('General Info'),
        content: Column(
          children: [
            MyTextFeild(text: "National Number", obscureText: false),
            MyTextFeild(text: "Address", obscureText: false),
            SizedBox(height: 10),
            // Birth date input field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Birth Date",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _pickBirthDate(context),
              ),
            ),
            SizedBox(height: 10),
            MyTextFeild(text: "Birth Place", obscureText: false),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(hintText: "Gender"),
                items:
                    ['Male', 'Female'].map((gender) {
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
      Step(
        title: Text('Complete'),
        content: Text('This is the last step'),
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Stepper(
          key: ValueKey(_currentStep), // Enables animation
          currentStep: _currentStep,
          type: StepperType.vertical,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            final isLastStep = _currentStep == _steps.length - 1;
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
                  child: Text(isLastStep ? 'Sign Up' : 'Next'),
                ),
                if (_currentStep != 0)
                  TextButton(onPressed: _previousStep, child: Text('Back')),
              ],
            );
          },
          steps: _steps,
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

  void _submitForm() {
    // You can collect all field values here if needed
    print("Sign Up Submitted");
    print("Birth Date: ${_birthDateController.text}");
    print("Gender: $_selectedGender");

    // Show a simple snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Account created successfully!")));

    // Reset the stepper or navigate
    Get.to(HomePage());
  }
}
