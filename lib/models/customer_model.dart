class Customer {
  final String id;
  final String clientName;
  final String phoneNumber;
  final String address;
  final String clothType;
  final Map<String, String> measurements;
  final String? customerPhotoUrl;
  final String? clothPhotoUrl;
  final String? deliveryDate;
  final String? remindDate;
  final bool isUrgent;
  final String? specialInstructions;
  final String orderStatus;

  Customer({
    required this.id,
    required this.clientName,
    required this.phoneNumber,
    required this.address,
    required this.clothType,
    required this.measurements,
    this.customerPhotoUrl,
    this.clothPhotoUrl,
    this.deliveryDate,
    this.remindDate,
    this.isUrgent = false,
    this.specialInstructions,
    this.orderStatus = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'phoneNumber': phoneNumber,
      'address': address,
      'clothType': clothType,
      'measurements': measurements,
      'customerPhotoUrl': customerPhotoUrl,
      'clothPhotoUrl': clothPhotoUrl,
      'deliveryDate': deliveryDate,
      'remindDate': remindDate,
      'isUrgent': isUrgent,
      'specialInstructions': specialInstructions,
      'orderStatus': orderStatus,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      clothType: json['clothType'] ?? '',
      measurements: Map<String, String>.from(json['measurements'] ?? {}),
      customerPhotoUrl: json['customerPhotoUrl'],
      clothPhotoUrl: json['clothPhotoUrl'],
      deliveryDate: json['deliveryDate'],
      remindDate: json['remindDate'],
      isUrgent: json['isUrgent'] ?? false,
      specialInstructions: json['specialInstructions'],
      orderStatus: json['orderStatus'] ?? 'Pending',
    );
  }

  Customer copyWith({
    String? id,
    String? clientName,
    String? phoneNumber,
    String? address,
    String? clothType,
    Map<String, String>? measurements,
    String? customerPhotoUrl,
    String? clothPhotoUrl,
    String? deliveryDate,
    String? remindDate,
    bool? isUrgent,
    String? specialInstructions,
    String? orderStatus,
  }) {
    return Customer(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      clothType: clothType ?? this.clothType,
      measurements: measurements ?? this.measurements,
      customerPhotoUrl: customerPhotoUrl ?? this.customerPhotoUrl,
      clothPhotoUrl: clothPhotoUrl ?? this.clothPhotoUrl,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      remindDate: remindDate ?? this.remindDate,
      isUrgent: isUrgent ?? this.isUrgent,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}
