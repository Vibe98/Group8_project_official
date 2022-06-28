class Profile{

  String? name;
  String? surname;
  String? username;
  String? password;
  String? email;
  bool complete = false;
  String userID = '';
  String? question;

  Profile(this.name, this.surname, this.username, this.password, this.email, this.question);
}