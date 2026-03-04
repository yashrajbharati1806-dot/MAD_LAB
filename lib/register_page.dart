import 'package:flutter/material.dart';
import 'package:mad_lab/configurations.dart';
import 'package:mad_lab/utility.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController useridcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  void validate() {
    if (useridcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty) {
      if (!Utility.validateCredentials(userId: useridcontroller.text)) {
        Configurations.credentials.add({
          'userid': useridcontroller.text,
          'password': passwordcontroller.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text("Registration Successful")),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text("User already exists")),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: useridcontroller,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      bool exists = Utility.validateCredentials(
                          userId: useridcontroller.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(exists
                              ? 'User ID already exists'
                              : 'User ID is available')));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Check'),
                    ),
                  ),
                  labelText: 'User ID',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            ElevatedButton(onPressed: validate, child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}
