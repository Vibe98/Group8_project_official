import 'package:floor/floor.dart';

@entity 
class ProfileEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final String? surname;
  final String? username;
  final String? password;
  final String? email;
  final bool complete = false;
  final String userID = '';

  ProfileEntity(this.id, this.name, this.surname, this.username, this.password, this.email);

}