class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? height;
  String? weight;
  String? description;
  String? phoneNumber; // New optional field
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.height,
    this.weight,
    this.description,
    this.phoneNumber,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      height: json['height'],
      weight: json['weight'],
      description: json['description'],
      phoneNumber: json['phone_number'],
      id: json['id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'height': height,
      'weight': weight,
      'description': description,
      'phone_number': phoneNumber,
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
