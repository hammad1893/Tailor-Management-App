import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/screens/authscreen/forget_password_screen.dart';
import 'package:tailor_app/screens/authscreen/signup_screen.dart';
import 'package:tailor_app/screens/homescreen/homepage.dart';
import 'package:tailor_app/state/authstate.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';
import 'package:tailor_app/widget/customelevatedbutton.dart';
import 'package:tailor_app/widget/customtextfied.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authstate>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * .05),
            Image.asset(
              "assets/images/icon.png",
              fit: BoxFit.cover,
              height: size.height * .26,
              width: size.width * .6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * .04),
                  Center(
                    child: Text(
                      "Login into your Account",

                      style: Apptext.headingtext,
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  Center(
                    child: Text(
                      "Welcome back! Please enter your details.",
                      style: Apptext.subheading,
                    ),
                  ),

                  SizedBox(height: size.height * .04),
                  Text("Email", style: Apptext.bodytext),
                  SizedBox(height: size.height * .01),
                  Customtextfied(
                    hintText: 'Enter your Email',
                    controller: emailController,
                  ),
                  SizedBox(height: size.height * .02),
                  Text("Password", style: Apptext.bodytext),
                  SizedBox(height: size.height * .01),
                  Customtextfied(
                    obsecureText: true,
                    hintText: 'Enter Password',
                    controller: passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgetpassword(),
                            ),
                          );
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(color: Appcolors.subHeadingColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .04),
                  SizedBox(
                    height: size.height * .075,
                    width: size.width,
                    child: Customelevatedbutton(
                      title: 'Sign In',
                      onTap: () async {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter email and password"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (!emailController.text.contains("@") &&
                            !emailController.text.contains(".com")) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter valid email"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (passwordController.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password should 8 characters"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        try {
                          await auth.Login(
                            Email: emailController.text,
                            Password: passwordController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Your account not registered"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: size.height * .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account?",
                        style: TextStyle(
                          color: Appcolors.subHeadingColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: size.width * .02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: Apptext.subheading.copyWith(
                            color: Appcolors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
