import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foody/view/pages/auth/verfy_page.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../../component/custom_text_from.dart';
import '../home/home_page.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Sign Up"),
            CustomTextFrom(
              controller: controller,
              label: "Phone",
              keyboardType: TextInputType.phone,
            ),
            context.watch<AuthController>().errorText != null
                ? Text(context.watch<AuthController>().errorText ?? "")
                : const SizedBox.shrink(),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthController>().sendSms(controller.text, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const VerifyPage()));
                  });
                },
                child: context.watch<AuthController>().isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text("Sign up")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: const Text("Sign In Page")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      context.read<AuthController>().loginGoogle(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false);
                      });
                    },
                    child: context.watch<AuthController>().isGoogleLoading
                        ? const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Google")),
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthController>().loginFacebook(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                                (route) => false);
                      });
                    },
                    child: context.watch<AuthController>().isFacebookLoading
                        ? const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Facebook")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
