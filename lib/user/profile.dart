class Profile {
  String id;
  String name;
  String phone;

  Profile({
    this.id,
    this.name,
    this.phone,
  });

  static final String kEntity = 'Profile';
  static final String kId = 'user_id';
  static final String kName = 'name';
  static final String kPhone = 'phone';
}
