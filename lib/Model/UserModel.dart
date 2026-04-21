class User {
  final int
  uid; // Assuming int for uid based on schema, but Supabase usually uses UUID string. User said "int uid PK" in mermaid. I will use int.
  final String role;
  final DateTime createdAt;

  User({required this.uid, required this.role, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Customer {
  final int id;
  final int userId;
  final String phone;
  final int? profilePhotoId;

  Customer({
    required this.id,
    required this.userId,
    required this.phone,
    this.profilePhotoId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      userId: json['user_id'],
      phone: json['phone'],
      profilePhotoId: json['PROFILE_PHOTOS'],
    );
  }
}

class Address {
  final int id;
  final int entityId; // customer_id or store_id
  final String regione;
  final String provincia;
  final String via;
  final String civico;
  final String cap;
  final String descrizione;
  final double lat;
  final double lng;

  Address({
    required this.id,
    required this.entityId,
    required this.regione,
    required this.provincia,
    required this.via,
    required this.civico,
    required this.cap,
    required this.descrizione,
    required this.lat,
    required this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json, {bool isStore = false}) {
    return Address(
      id: json['id'],
      entityId: isStore ? json['store_id'] : json['customer_id'],
      regione: json['regione'],
      provincia: json['provincia'],
      via: json['via'],
      civico: json['civico'],
      cap: json['cap'],
      descrizione: json['descrizione'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}

class Contact {
  final int id;
  final int userId;
  final String email;
  final String phone;
  final String type;

  Contact({
    required this.id,
    required this.userId,
    required this.email,
    required this.phone,
    required this.type,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      phone: json['phone'],
      type: json['type'],
    );
  }
}
