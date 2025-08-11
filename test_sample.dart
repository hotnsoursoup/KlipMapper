// Sample Flutter/Dart code for testing the new TreeSitter architecture
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserModel {
  final String name;
  final int age;
  
  UserModel({required this.name, required this.age});
  
  @override
  String toString() => 'UserModel(name: $name, age: $age)';
}

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  
  UserModel? get user => _user;
  
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

@widget
class UserProfileWidget extends StatelessWidget {
  final UserModel user;
  
  const UserProfileWidget({Key? key, required this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Age: ${user.age}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('User Profile'),
          ),
          body: userProvider.user != null 
            ? UserProfileWidget(user: userProvider.user!)
            : Center(child: Text('No user selected')),
        );
      },
    );
  }
}