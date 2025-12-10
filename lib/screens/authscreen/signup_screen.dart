import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/screens/authscreen/login_screen.dart';
import 'package:tailor_app/screens/homescreen/homepage.dart';
import 'package:tailor_app/state/authstate.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';
import 'package:tailor_app/widget/customelevatedbutton.dart';
import 'package:tailor_app/widget/customtextfied.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authstate>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Appcolors.backgroundcolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * .05),
              Image.asset(
                "assets/images/icon.png",
                fit: BoxFit.cover,
                height: size.height * .27,
                width: size.width * .6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(height: size.height * .03),
                    Text("Create your Account", style: Apptext.headingtext),
                    Text(
                      "Sign up to get started with Tailor App",
                      style: Apptext.subheading,
                    ),

                    SizedBox(height: size.height * .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text("Full Name", style: Apptext.bodytext)],
                    ),
                    SizedBox(height: size.height * .01),
                    Customtextfied(
                      hintText: 'Enter your Full Name',
                      controller: nameController,
                    ),
                    SizedBox(height: size.height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text("Email", style: Apptext.bodytext)],
                    ),
                    SizedBox(height: size.height * .01),
                    Customtextfied(
                      hintText: 'Enter your Email',
                      controller: emailController,
                      label: 'Email',
                    ),
                    SizedBox(height: size.height * .02),
                    Row(children: [Text("Password", style: Apptext.bodytext)]),
                    SizedBox(height: size.height * .01),
                    Customtextfied(
                      obsecureText: true,
                      hintText: 'Enter Password',
                      controller: passwordController,
                    ),
                    SizedBox(height: size.height * .04),
                    SizedBox(
                      height: size.height * .075,
                      width: size.width,
                      child: Customelevatedbutton(
                        title: 'Get Started',
                        onTap: () async {
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Please fill all the fields"),
                              ),
                            );
                            return;
                          } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(emailController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Please enter valid email"),
                              ),
                            );
                            return;
                          } else if (passwordController.text.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Password must be 8 characters long",
                                ),
                              ),
                            );
                            return;
                          }
                          auth.signup(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          print("User registered");
                          print('name: ${nameController.text}');
                          print("email: ${emailController.text}");
                          print("password: ${passwordController.text}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Your account created successfully",
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * .04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
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
                                builder: (context) => Loginpage(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }
}
