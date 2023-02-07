import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../../component/custom_text_from.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text("Login"),
            ),
            CustomTextFrom(controller: phoneController, label: "Phone"),
            CustomTextFrom(controller: passwordController, label: "Password",isObscure: true,),
            context.watch<AuthController>().errorText != null
                ? Text(context.watch<AuthController>().errorText ?? "")
                : const SizedBox.shrink(),
            ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthController>()
                      .login(phoneController.text, passwordController.text, () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false);
                  });
                },
                child: context.watch<AuthController>().isLoading ? const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ) : const Text("Login"))
          ],
        ),
      ),
    );
  }
}
