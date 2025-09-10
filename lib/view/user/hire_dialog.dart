import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:legal_assistance_mobile/controller/usercontroller.dart';

class HireDialog extends StatefulWidget {
  final String lawyerId;

  const HireDialog({super.key, required this.lawyerId});

  @override
  State<HireDialog> createState() => _HireDialogState();
}

class _HireDialogState extends State<HireDialog> {
  final _formKey = GlobalKey<FormState>();
  String _agencyType = 'public'.tr;
  final _reasonController = TextEditingController();
  final _authorizationsController = TextEditingController();
  final _exceptionsController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingOptions = false;

  final List<String> _agencyTypes = ['public'.tr, 'private'.tr, 'legal'.tr];

  // قائمة خيارات التفويضات من الـ API
  List<String> _authorizationsOptions = [];

  // قائمة خيارات الاستثناءات من الـ API
  List<String> _exceptionsOptions = [];

  // القيم المختارة للتفويضات
  List<String> _selectedAuthorizations = [];

  // القيم المختارة للاستثناءات
  List<String> _selectedExceptions = [];

  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _authorizationsController.dispose();
    _exceptionsController.dispose();
    super.dispose();
  }

  Future<void> _fetchOptions() async {
    setState(() {
      _isLoadingOptions = true;
    });

    try {
      String token = Get.find<SignInController>().token.value;

      // جلب التفويضات
      final authResponse = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/web/byUser/authorizations"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // جلب الاستثناءات
      final excResponse = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/v1/web/byUser/exceptions"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(authResponse.body);
      print(excResponse.body);

      if (authResponse.statusCode == 200) {
        final authData = jsonDecode(authResponse.body);
        if (authData['status'] == true && authData['data'] != null) {
          // تحويل البيانات إلى قائمة نصية
          _authorizationsOptions = List<String>.from(
            authData['data'].map(
              (item) => item['name']?.toString() ?? item.toString(),
            ),
          );
        }
      }

      if (excResponse.statusCode == 200) {
        final excData = jsonDecode(excResponse.body);
        if (excData['status'] == true && excData['data'] != null) {
          // تحويل البيانات إلى قائمة نصية
          _exceptionsOptions = List<String>.from(
            excData['data'].map(
              (item) => item['name']?.toString() ?? item.toString(),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching options: $e");
    } finally {
      setState(() {
        _isLoadingOptions = false;
      });
    }
  }

  Future<void> _submitHireRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String token = Get.find<SignInController>().token.value;

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'lawyer_id': widget.lawyerId,
        'type': _agencyType,
      };

      // Add additional fields if not public
      if (_agencyType != 'public') {
        requestBody.addAll({
          'reason': _reasonController.text,
          'authorizations': _selectedAuthorizations.join(', '),
          'exceptions': _selectedExceptions.join(', '),
        });
      }

      // Send the request
      final response = await http.post(
        Uri.parse("http://osamanaser2003-21041.portmap.host:21041/api/v1/web/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "success".tr,
          "hire_request_sent".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "error".tr,
          "failed_to_send_request".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "error_occurred".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAuthorizationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("select_authorizations".tr),
              content: Container(
                width: double.maxFinite,
                child:
                    _isLoadingOptions
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _authorizationsOptions.length,
                          itemBuilder: (context, index) {
                            final option = _authorizationsOptions[index];
                            final isSelected = _selectedAuthorizations.contains(
                              option,
                            );

                            return CheckboxListTile(
                              title: Text(option),
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _selectedAuthorizations.add(option);
                                  } else {
                                    _selectedAuthorizations.remove(option);
                                  }
                                  // تحديث حقل النص
                                  _authorizationsController.text =
                                      _selectedAuthorizations.join(', ');
                                });
                              },
                            );
                          },
                        ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("cancel".tr),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // تحديث حالة النافذة الرئيسية
                    this.setState(() {});
                  },
                  child: Text("ok".tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showExceptionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("select_exceptions".tr),
              content: SizedBox(
                width: double.maxFinite,
                child:
                    _isLoadingOptions
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _exceptionsOptions.length,
                          itemBuilder: (context, index) {
                            final option = _exceptionsOptions[index];
                            final isSelected = _selectedExceptions.contains(
                              option,
                            );

                            return CheckboxListTile(
                              title: Text(option),
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _selectedExceptions.add(option);
                                  } else {
                                    _selectedExceptions.remove(option);
                                  }
                                  // تحديث حقل النص
                                  _exceptionsController
                                      .text = _selectedExceptions.join(', ');
                                });
                              },
                            );
                          },
                        ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("cancel".tr),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // تحديث حالة النافذة الرئيسية
                    this.setState(() {});
                  },
                  child: Text("ok".tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "hire_lawyer".tr,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              // Agency Type Dropdown
              DropdownButtonFormField<String>(
                value: _agencyType,
                decoration: InputDecoration(
                  labelText: "agency_type".tr,
                  border: OutlineInputBorder(),
                ),
                items:
                    _agencyTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type.tr),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _agencyType = value!;
                    // إعادة تعيين الحقول عند تغيير النوع
                    if (_agencyType == 'public') {
                      _selectedAuthorizations.clear();
                      _selectedExceptions.clear();
                      _authorizationsController.clear();
                      _exceptionsController.clear();
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please_select_agency_type".tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Conditionally show additional fields
              if (_agencyType != 'public') ...[
                // Reason Field
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: "reason".tr,
                    border: OutlineInputBorder(),
                    hintText: "enter_reason".tr,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please_enter_reason".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Authorizations Field
                InkWell(
                  onTap: _isLoadingOptions ? null : _showAuthorizationsDialog,
                  borderRadius: BorderRadius.circular(4),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _authorizationsController,
                      decoration: InputDecoration(
                        labelText: "authorizations".tr,
                        border: OutlineInputBorder(),
                        hintText:
                            _isLoadingOptions
                                ? "loading_options".tr
                                : "select_authorizations".tr,
                        suffixIcon:
                            _isLoadingOptions
                                ? Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                                : Icon(Icons.arrow_drop_down),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_select_authorizations".tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Exceptions Field
                InkWell(
                  onTap: _isLoadingOptions ? null : _showExceptionsDialog,
                  borderRadius: BorderRadius.circular(4),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _exceptionsController,
                      decoration: InputDecoration(
                        labelText: "exceptions".tr,
                        border: OutlineInputBorder(),
                        hintText:
                            _isLoadingOptions
                                ? "loading_options".tr
                                : "select_exceptions".tr,
                        suffixIcon:
                            _isLoadingOptions
                                ? Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                                : Icon(Icons.arrow_drop_down),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_select_exceptions".tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("cancel".tr),
                  ),
                  SizedBox(width: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _submitHireRequest,
                        child: Text("send_request".tr),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
