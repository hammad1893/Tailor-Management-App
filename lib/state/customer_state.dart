import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tailor_app/models/customer_model.dart';

class CustomerState extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;
  bool get isLoading => _loading;

  final List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  void _setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<String?> uploadImage(dynamic imageData) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/darlhfapb/upload");
      final req = http.MultipartRequest("POST", url);
      req.fields['upload_preset'] = 'imageupload';

      if (kIsWeb && imageData is Uint8List) {
        req.files.add(
          http.MultipartFile.fromBytes("file", imageData, filename: "img.jpg"),
        );
      } else if (imageData is File) {
        req.files.add(
          await http.MultipartFile.fromPath("file", imageData.path),
        );
      } else {
        print(" wrong type passed to uploadImage");
      }

      final resp = await req.send();
      if (resp.statusCode == 200) {
        final str = await resp.stream.bytesToString();
        final jsonData = json.decode(str);
        print("Uploaded: ${jsonData['secure_url']}");
        return jsonData['secure_url'];
      } else {
        print("Cloudinary error code: ${resp.statusCode}");
      }
    } catch (e) {
      print("image upload error: $e");
    }

    return null;
  }

  Future<void> addCustomer({
    required String clientName,
    required String phoneNumber,
    required String address,
    required String clothType,
    required Map<String, String> measurements,

    dynamic customerPhotoUrl,
    dynamic clothPhotoUrl,
    String? deliveryDate,
    String? specialInstructions,
  }) async {
    _setLoading(true);

    try {
      String? uploadedCustomer;
      String? uploadedCloth;

      if (customerPhotoUrl != null) {
        uploadedCustomer = await uploadImage(customerPhotoUrl);
      }

      if (clothPhotoUrl != null) {
        uploadedCloth = await uploadImage(clothPhotoUrl);
      }

      final doc = await _firestore.collection("customers").add({
        "clientName": clientName,
        "phoneNumber": phoneNumber,
        "address": address,
        "clothType": clothType,
        "measurements": measurements,
        "customerPhotoUrl": uploadedCustomer,
        "clothPhotoUrl": uploadedCloth,
        "deliveryDate": deliveryDate,
        "specialInstructions": specialInstructions,
        "orderStatus": "Pending",
        "timestamp": DateTime.now(),
      });

      print("Customer saved: ${doc.id}");

      final newCustomer = Customer(
        id: doc.id,
        clientName: clientName,
        phoneNumber: phoneNumber,
        address: address,
        clothType: clothType,
        measurements: measurements,
        customerPhotoUrl: uploadedCustomer,
        clothPhotoUrl: uploadedCloth,
        deliveryDate: deliveryDate,
        remindDate: deliveryDate,
        specialInstructions: specialInstructions,
        orderStatus: "Pending",
      );

      _customers.insert(0, newCustomer);
      notifyListeners();
    } catch (e) {
      print("Add Customer Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCustomers() async {
    _setLoading(true);

    try {
      final snap = await _firestore
          .collection("customers")
          .orderBy("timestamp", descending: true)
          .get();

      _customers.clear();

      for (var doc in snap.docs) {
        try {
          final data = doc.data();
          data["id"] = doc.id;
          final customer = Customer.fromJson(data);
          _customers.add(customer);
        } catch (e) {
          print("Parse error: $e");
        }
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCustomer({
    required String customerId,
    required String clientName,
    required String address,
    required String clothType,
    required Map<String, String> measurements,
    required String deliveryDate,
    required String specialInstructions,
  }) async {
    try {
      await _firestore.collection("customers").doc(customerId).update({
        "clientName": clientName,
        "address": address,
        "clothType": clothType,
        "measurements": measurements,
        "deliveryDate": deliveryDate,
        "specialInstructions": specialInstructions,
      });
      final idx = _customers.indexWhere((c) => c.id == customerId);
      if (idx != -1) {
        final existing = _customers[idx];

        _customers[idx] = Customer(
          id: existing.id,
          clientName: clientName,
          phoneNumber: existing.phoneNumber,
          address: address,
          clothType: clothType,
          measurements: measurements,
          customerPhotoUrl: existing.customerPhotoUrl,
          clothPhotoUrl: existing.clothPhotoUrl,
          deliveryDate: deliveryDate,
          remindDate: existing.remindDate,
          specialInstructions: specialInstructions,
          orderStatus: existing.orderStatus,
        );
      }

      notifyListeners();
    } catch (e) {
      print("update error: $e");
    }
  }

  Future<void> updateOrderStatus(String customerId, String newStatus) async {
    try {
      await _firestore.collection("customers").doc(customerId).update({
        "orderStatus": newStatus,
      });

      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        final old = _customers[index];
        _customers[index] = old.copyWith(orderStatus: newStatus);
      }

      notifyListeners();
    } catch (e) {
      print("status update error: $e");
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await _firestore.collection("customers").doc(customerId).delete();

      _customers.removeWhere((c) => c.id == customerId);
      notifyListeners();

      print("Deleted $customerId");
    } catch (e) {
      print("delete error: $e");
    }
  }
}
