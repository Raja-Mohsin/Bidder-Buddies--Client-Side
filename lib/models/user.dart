class User {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String address;
  String imageUrl;
  String status;
  List<String> favorites;

  User(
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.imageUrl,
    this.status,
    this.favorites,
  );
}
