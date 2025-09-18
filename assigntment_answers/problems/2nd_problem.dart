
abstract class UserRepository {
  void saveToFireStore();
}

class FireStoreUserRepository implements UserRepository {
  @override
  void saveToFireStore() {
    // TODO: implement saveToFireStore
  }
}

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  void saveUser() => repository.saveToFireStore();

  UserModel updateUser(UserModel user) {
    return UserModel(name: user.name, age: user.age, email: user.email);
  }
}

class UserModel {
  final String name;
  final int age;
  final String email;

  UserModel({required this.name, required this.age, required this.email});
}
