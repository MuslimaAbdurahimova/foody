import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../../component/custom_text_from.dart';
import 'set_avatar.dart';

class SetBioPage extends StatefulWidget {
  const SetBioPage({Key? key}) : super(key: key);

  @override
  State<SetBioPage> createState() => _SetBioPageState();
}

class _SetBioPageState extends State<SetBioPage> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController birthController;
  late TextEditingController passwordController;

  @override
  void initState() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    birthController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bio Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTextFrom(controller: nameController, label: "Name"),
            CustomTextFrom(controller: usernameController, label: "Username"),
            CustomTextFrom(controller: emailController, label: "email"),
            CustomTextFrom(controller: genderController, label: "Gender"),
            CustomTextFrom(controller: birthController, label: "Date of Birth"),
            CustomTextFrom(controller: passwordController, label: "Password"),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthController>().setStateUser(
                      name: nameController.text,
                      username: usernameController.text,
                      password: passwordController.text,
                      email: emailController.text,
                      gender: genderController.text,
                      birth: birthController.text,
                      onSuccess: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => SetAvatar()),
                            (route) => false);
                      });
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
