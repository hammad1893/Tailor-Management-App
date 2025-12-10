import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_app/state/authstate.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';
import 'package:tailor_app/widget/customelevatedbutton.dart';
import 'package:tailor_app/widget/customtextfied.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolors.backgroundcolor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Appcolors.headingColor),
          ),
        ),
        backgroundColor: Appcolors.backgroundcolor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .02),
                Image.asset(
                  "assets/images/icon.png",
                  height: size.height * .27,
                  width: size.width * .6,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: size.height * .04),
                Text("Forget Your Password?", style: Apptext.headingtext),
                SizedBox(height: size.height * .01),
                Text(
                  "We’ll help you get back into your\naccount. Just enter the email\nyou used to sign up.",
                  style: Apptext.bodytext,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("Email", style: Apptext.bodytext)],
                ),
                SizedBox(height: size.height * .01),
                Customtextfied(
                  controller: _emailController,
                  hintText: "Enter Your Email",
                  label: "Email",
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: size.height * .04),
                SizedBox(
                  height: size.height * .06,
                  width: size.width,
                  child: Customelevatedbutton(
                    title: "Send",
                    onTap: () {
                      _resetPassword();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    final authState = Provider.of<Authstate>(context, listen: false);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your email')));
      return;
    }

    try {
      await authState.resetPassword(email: email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password reset email sent!')));
      print('Password reset email sent to $email');
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      print('Error sending reset email: $e');
    }
  }
}
