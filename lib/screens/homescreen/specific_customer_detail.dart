import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/models/customer_model.dart';
import 'package:tailor_app/state/customer_state.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late TextEditingController clientNameController;
  late TextEditingController addressController;
  late TextEditingController deliveryDateController;
  late TextEditingController specialInstructionsController;
  late TextEditingController clothTypeController;
  Map<String, TextEditingController> measurementControllers = {};

  bool isEditingMeasurement = false;
  bool isEditingBasic = false;

  @override
  void initState() {
    super.initState();
    clientNameController = TextEditingController(
      text: widget.customer.clientName,
    );
    addressController = TextEditingController(text: widget.customer.address);
    clothTypeController = TextEditingController(
      text: widget.customer.clothType,
    );
    deliveryDateController = TextEditingController(
      text: widget.customer.deliveryDate ?? '',
    );
    specialInstructionsController = TextEditingController(
      text: widget.customer.specialInstructions ?? '',
    );

    for (var measurement in widget.customer.measurements.entries) {
      measurementControllers[measurement.key] = TextEditingController(
        text: measurement.value,
      );
    }
  }

  @override
  void dispose() {
    clientNameController.dispose();
    addressController.dispose();
    clothTypeController.dispose();
    deliveryDateController.dispose();
    specialInstructionsController.dispose();
    for (var controller in measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void saveBasicInfo() async {
    if (clientNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        deliveryDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final customerState = Provider.of<CustomerState>(context, listen: false);

    Map<String, String> measurements = {};
    for (var entry in measurementControllers.entries) {
      measurements[entry.key] = entry.value.text;
    }

    try {
      await customerState.updateCustomer(
        customerId: widget.customer.id,
        clientName: clientNameController.text,
        address: addressController.text,
        clothType: clothTypeController.text,
        measurements: measurements,
        deliveryDate: deliveryDateController.text,
        specialInstructions: specialInstructionsController.text,
      );

      if (mounted) {
        setState(() {
          isEditingBasic = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void saveMeasurements() async {
    final customerState = Provider.of<CustomerState>(context, listen: false);

    Map<String, String> measurements = {};
    for (var entry in measurementControllers.entries) {
      measurements[entry.key] = entry.value.text;
    }

    try {
      await customerState.updateCustomer(
        customerId: widget.customer.id,
        clientName: clientNameController.text,
        address: addressController.text,
        clothType: clothTypeController.text,
        measurements: measurements,
        deliveryDate: deliveryDateController.text,
        specialInstructions: specialInstructionsController.text,
      );

      if (mounted) {
        setState(() {
          isEditingMeasurement = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Measurements updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void deleteCustomer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Customer?'),
          content: const Text('This action cannot be undone'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final customerState = Provider.of<CustomerState>(
                  context,
                  listen: false,
                );
                try {
                  await customerState.deleteCustomer(widget.customer.id);
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Customer deleted'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void updateOrderStatus(String newStatus) async {
    final customerState = Provider.of<CustomerState>(context, listen: false);
    try {
      await customerState.updateOrderStatus(widget.customer.id, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color getStatusColor(String status) {
    if (status.toLowerCase() == 'pending') {
      return Colors.orange;
    } else if (status.toLowerCase() == 'in_progress') {
      return Colors.blue;
    } else if (status.toLowerCase() == 'completed') {
      return Colors.green;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Order Details', style: Apptext.headingtext),
        actions: [
          IconButton(
            onPressed: deleteCustomer,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEditingBasic)
              Text(
                widget.customer.clientName,
                style: Apptext.headingtext.copyWith(fontSize: 22),
              )
            else
              TextField(
                controller: clientNameController,
                decoration: InputDecoration(
                  hintText: 'Client Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.01),

            if (!isEditingBasic)
              Text(
                "Cloth Type: ${widget.customer.clothType}",
                style: Apptext.bodytext.copyWith(fontWeight: FontWeight.w500),
              )
            else
              TextField(
                controller: clothTypeController,
                decoration: InputDecoration(
                  hintText: 'Cloth Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.015),

            if (widget.customer.customerPhotoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.customer.customerPhotoUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: size.height * 0.02),

            Text(
              'Description',
              style: Apptext.bodytext.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: size.height * 0.01),
            if (!isEditingBasic)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  widget.customer.specialInstructions ?? 'No description',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              )
            else
              TextField(
                controller: specialInstructionsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Measurements',
                  style: Apptext.bodytext.copyWith(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    if (isEditingMeasurement) {
                      saveMeasurements();
                    } else {
                      setState(() {
                        isEditingMeasurement = true;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Appcolors.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isEditingMeasurement ? 'Save' : 'Edit',
                          style: Apptext.bodytext.copyWith(
                            color: Appcolors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),

            ...widget.customer.measurements.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(entry.key, style: Apptext.bodytext),
                    ),
                    Expanded(
                      flex: 3,
                      child: isEditingMeasurement
                          ? TextField(
                              controller: measurementControllers[entry.key],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(entry.value, style: Apptext.bodytext),
                            ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      'inc',
                      style: Apptext.bodytext.copyWith(color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: size.height * 0.03),

            Text(
              'Order Date',
              style: Apptext.bodytext.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: size.height * 0.01),
            if (!isEditingBasic)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  widget.customer.deliveryDate ?? 'N/A',
                  style: Apptext.bodytext,
                ),
              )
            else
              TextField(
                controller: deliveryDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                        setState(() {
                          deliveryDateController.text = formattedDate;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      color: Appcolors.primaryColor,
                    ),
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.02),

            if (isEditingBasic)
              ElevatedButton(
                onPressed: saveBasicInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primaryColor,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            SizedBox(height: size.height * 0.02),

            if (!isEditingBasic)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEditingBasic = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.065,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 16, color: Appcolors.primaryColor),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        'Edit All',
                        style: Apptext.bodytext.copyWith(
                          color: Appcolors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.03),

            Text(
              'Order Status',
              style: Apptext.bodytext.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: getStatusColor(
                      widget.customer.orderStatus.toString(),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  widget.customer.orderStatus.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(
                      widget.customer.orderStatus.toString(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),

            Column(
              children: [
                statusButton('Pending', Colors.orange),
                const SizedBox(height: 10),
                statusButton('In Progress', Colors.blue),
                const SizedBox(height: 10),
                statusButton('Completed', Colors.green),
              ],
            ),

            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget statusButton(String status, Color color) {
    bool isSelected =
        widget.customer.orderStatus.toLowerCase() ==
        status.toLowerCase().replaceAll(' ', '_');

    return GestureDetector(
      onTap: () {
        updateOrderStatus(status);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.white,
          border: Border.all(color: color, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
