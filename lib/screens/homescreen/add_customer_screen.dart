import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tailor_app/state/customer_state.dart';
import 'dart:io';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/widget/customelevatedbutton.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();
  TextEditingController remindDateController = TextEditingController();
  TextEditingController specialInstructionsController = TextEditingController();

  Map<String, TextEditingController> measurementControllers = {};

  bool isUrgent = false;
  dynamic customerImage;
  dynamic clothImage;

  String? selectedClothType;

  final Map<String, List<String>> clothMeasurements = {
    'Kurta': [
      'Length',
      'Shoulder',
      'Chest',
      'Waist',
      'Hip',
      'Arm Length',
      'Wrist',
      'Collar',
    ],
    'Shalwar': ['Length', 'Waist', 'Hip', 'Around Leg'],
    'Both': [
      'Length',
      'Shoulder',
      'Chest',
      'Waist',
      'Hip',
      'Arm Length',
      'Wrist',
      'Collar',
      'Around Leg',
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeMeasurementControllers();
  }

  void _initializeMeasurementControllers() {
    for (var measurements in clothMeasurements.values) {
      for (var measurement in measurements) {
        measurementControllers[measurement] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    clientNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    deliveryDateController.dispose();
    remindDateController.dispose();
    specialInstructionsController.dispose();
    for (var controller in measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage(bool isCustomerPhoto) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        if (kIsWeb) {
          Uint8List? bytes = file.bytes;
          if (bytes != null) {
            setState(() {
              if (isCustomerPhoto) {
                customerImage = bytes;
              } else {
                clothImage = bytes;
              }
            });
          }
        } else {
          if (file.path != null) {
            setState(() {
              if (isCustomerPhoto) {
                customerImage = File(file.path!);
              } else {
                clothImage = File(file.path!);
              }
            });
          }
        }
      }
    } catch (e) {
      print(' Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  Future<String?> uploadImageToCloudinary(dynamic imageData) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/darlhfapb/upload");
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'imageupload';

      if (kIsWeb && imageData is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageData,
            filename: 'image.jpg',
          ),
        );
      } else if (imageData is File) {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageData.path),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final jsonMap = json.decode(resStr);
        print('Image uploaded: ${jsonMap['secure_url']}');
        return jsonMap['secure_url'];
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(' Error uploading image: $e');
      return null;
    }
  }

  List<Widget> buildMeasurementFields(String clothType) {
    List<String> measurements = clothMeasurements[clothType] ?? [];
    List<Widget> widgets = [];

    for (int i = 0; i < measurements.length; i++) {
      widgets.add(
        measurementField(
          measurements[i],
          measurementControllers[measurements[i]]!,
        ),
      );
      if (i < measurements.length - 1) {
        widgets.add(SizedBox(height: MediaQuery.of(context).size.height * .03));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<CustomerState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add Client",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * .03),
            formText("Client Details"),

            SizedBox(height: size.height * .03),
            formText("Client Name"),
            SizedBox(height: size.height * .01),
            textFieldWidget("Enter Client Name", clientNameController),
            SizedBox(height: size.height * .03),
            formText("Phone Number"),
            SizedBox(height: size.height * .01),
            textFieldWidget("0310000000", phoneController),
            SizedBox(height: size.height * .03),
            formText("Address"),
            SizedBox(height: size.height * .01),
            textFieldWidget("Enter your Address", addressController),

            SizedBox(height: size.height * .04),
            formText("Cloth Images"),
            SizedBox(height: size.height * .02),
            Row(
              children: [
                Expanded(
                  child: imagePickerCard(
                    "Customer Photo",
                    customerImage,
                    () => pickImage(true),
                    size,
                  ),
                ),
                SizedBox(width: size.width * .03),
                Expanded(
                  child: imagePickerCard(
                    "Cloth Photo",
                    clothImage,
                    () => pickImage(false),
                    size,
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * .04),
            formText("Cloth Type"),
            SizedBox(height: size.height * .02),
            DropdownButtonFormField<String>(
              value: selectedClothType,
              hint: Text("Select Cloth Type"),
              items: ['Kurta', 'Shalwar', 'Both'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClothType = value;
                  print(" Cloth type changed: $selectedClothType");
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),

            if (selectedClothType != null) ...[
              SizedBox(height: size.height * .04),
              formText("Measurements"),
              SizedBox(height: size.height * .03),
              ...buildMeasurementFields(selectedClothType!),
            ],

            SizedBox(height: size.height * .04),
            formText("Delivery & Reminder Dates"),
            SizedBox(height: size.height * .03),
            textFieldWidget(
              "Delivery Date",
              deliveryDateController,
              suffixIcon: Icons.calendar_month_outlined,
              onSuffixTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  deliveryDateController.text =
                      "${picked.year}-${picked.month}-${picked.day}";
                }
              },
            ),
            SizedBox(height: size.height * .03),
            textFieldWidget(
              "Remind Date",
              remindDateController,
              suffixIcon: Icons.calendar_month_outlined,
              onSuffixTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  remindDateController.text =
                      "${picked.year}-${picked.month}-${picked.day}";
                }
              },
            ),

            SizedBox(height: size.height * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formText("Mark as Urgent"),
                Switch(
                  activeColor: Appcolors.primaryColor,
                  value: isUrgent,
                  onChanged: (value) {
                    setState(() {
                      isUrgent = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: size.height * .05),
            formText("Special Instructions"),
            SizedBox(height: size.height * .03),
            TextField(
              controller: specialInstructionsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add any special instructions or notes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),

            SizedBox(height: size.height * .04),
            SizedBox(
              width: double.infinity,
              child: Customelevatedbutton(
                title: "Save",
                onTap: () async {
                  if (clientNameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }

                  if (selectedClothType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select cloth type")),
                    );
                    return;
                  }

                  String? customerImage = await uploadImageToCloudinary(
                    this.customerImage,
                  );
                  String? clothImage = await uploadImageToCloudinary(
                    this.clothImage,
                  );
                  if (customerImage != null) {
                    print(' Customer image uploaded: $customerImage');
                  }

                  if (clothImage != null) {
                    print(' Cloth image uploaded: $clothImage');
                  }
                  Map<String, String> measurements = {};
                  for (var measurement
                      in clothMeasurements[selectedClothType]!) {
                    String value =
                        measurementControllers[measurement]?.text ?? '';
                    if (value.isNotEmpty) {
                      measurements[measurement] = value;
                    }
                  }
                  customer.addCustomer(
                    clientName: clientNameController.text,
                    phoneNumber: phoneController.text,
                    address: addressController.text,
                    clothType: selectedClothType!,
                    measurements: measurements,
                    customerPhotoUrl: customerImage,
                    clothPhotoUrl: clothImage,
                    deliveryDate: deliveryDateController.text,
                    specialInstructions: specialInstructionsController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Customer added successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),

            SizedBox(height: size.height * .05),
          ],
        ),
      ),
    );
  }

  Widget imagePickerCard(
    String title,
    dynamic image,
    VoidCallback onTap,
    Size size,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * .15,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: _buildImageDisplay(image, title, size),
      ),
    );
  }

  Widget _buildImageDisplay(dynamic image, String title, Size size) {
    if (image == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 40, color: Colors.grey[400]),
          SizedBox(height: size.height * .01),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: kIsWeb && image is Uint8List
          ? Image.memory(image, fit: BoxFit.cover)
          : image is File
          ? Image.file(image, fit: BoxFit.cover)
          : null,
    );
  }

  Widget textFieldWidget(
    String hintText,
    TextEditingController controller, {
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixTap,
                icon: Icon(
                  suffixIcon,
                  size: 20,
                  color: Appcolors.subHeadingColor,
                ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }

  Widget measurementField(String label, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: size.width * .01),
        Text("inc", style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget formText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
