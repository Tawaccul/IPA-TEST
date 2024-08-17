import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/auth/pages/register.dart';
import 'package:quranapp/auth/pages/update_pass.dart';
import 'package:quranapp/auth/services/auth_service.dart';
import 'package:quranapp/components/my_button.dart';
import 'package:quranapp/components/my_textfield.dart';
import 'package:quranapp/consts/colors.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png', width: 270),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Изучайте Коран бесплатно и без ограничений!',
                      style: GoogleFonts.rubik(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 150),
                  MyTextField(
                    controller: widget.emailController,
                    hintText: 'Email',
                    obscureText: false,
                    icon: const Icon(Icons.person_rounded),
                    onChanged: (String) {},
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: widget.passController,
                    hintText: 'Пароль',
                    obscureText: !_passwordVisible,
                    icon: Icon(Icons.key_rounded),
                    onChanged: (String) {},
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Показать пароль'),
                      ),
                      Checkbox(
                        value: _passwordVisible,
                        checkColor: Colors.white,
                        splashRadius: 18,
                        focusColor: Colors.white,
                        activeColor: mainGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => _passwordVisible == true
                              ? BorderSide(width: 1.0, color: mainGreen)
                              : BorderSide(width: 1.0, color: mainGrey),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _passwordVisible = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: MyButton(
                      onTap: () {
                        if (widget.formKey.currentState!.validate()) {
                          AuthServices.login(
                            context,
                            widget.emailController.text,
                            widget.passController.text,
                          );
                        }
                      },
                      title: 'Войти',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPass()),
                      );
                    },
                    child: const Text(
                      "Сбросить пароль",
                      style: TextStyle(color: mainGreen),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Нет аккаунта?'),
                        SizedBox(width: 4),
                        TextButton(
                          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          child: const Text(
                            "Зарегистрироваться",
                            style: TextStyle(color: mainGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
