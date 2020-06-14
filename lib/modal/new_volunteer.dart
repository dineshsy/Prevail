import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase _firebaseDatabase = new FirebaseDatabase();

class NewVolunteer {
  String name;
  String email;

  NewVolunteer({this.email, this.name});

  save() {
    _firebaseDatabase.reference().child("healthReport").push().set({
      "name": name,
      "email": email,
    });
  }
}
