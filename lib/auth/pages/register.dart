import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quranapp/auth/pages/login.dart';
import 'package:quranapp/auth/services/auth_service.dart';
import 'package:quranapp/components/my_button.dart';
import 'package:quranapp/components/my_textfield.dart';
import 'package:quranapp/consts/colors.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

    final formKey = GlobalKey<FormState>();
  final MaleFemaleController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

    @override
      RegisterPageState createState()=> RegisterPageState();


}

class RegisterPageState extends State<RegisterPage>{
 

 
  bool _passwordVisible = true;


  @override

  void initState() {
   super.initState();
 
    // Ваш код, использующий MediaQuery, например:
    // Здесь можно безопасно использовать screenWidth
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
                  child: Image.asset('assets/images/logo.png', width: 250)
                ,),
                                const SizedBox(height: 10),
              
                Center(
                  child: Text('Изучайте Коран бесплатно и без ограничений!', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 150),
              
                                 MyTextField(
                controller: widget.nameController, hintText: 'Имя', obscureText: false,
                icon: const Icon(Icons.fingerprint_outlined, color: titleColor,), onChanged: (String ) {  },
              
                ),

              
                                  const SizedBox(height: 10),
              
                                 MyTextField(
                controller: widget.emailController, hintText: 'Email', obscureText: false,
                icon: const Icon(Icons.person_rounded, color: titleColor),onChanged: (String ) {  },
              
                ),
                                const SizedBox(height: 10),
              
                  
                                 MyTextField(
                controller: widget.passController, hintText: 'Пароль', obscureText: !_passwordVisible, icon: Icon(Icons.key_rounded, color: titleColor),
                    onChanged: (String ) {  },
              
              ),
                              const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Показать пароль',)),
                            Checkbox(
                              value: _passwordVisible, 
                              checkColor: Colors.white,
                              splashRadius: 18,
                              focusColor: Colors.white,
                              activeColor: mainGreen,
                              
                               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                side: WidgetStateBorderSide.resolveWith(
                    (states) => _passwordVisible == true ?  BorderSide(width: 1.0, color: mainGreen) : BorderSide(width: 1.0, color: mainGrey),
                ),
                              onChanged: ( value ){setState(() {
                                               _passwordVisible = !_passwordVisible!;
                                           }); }),
                          ],
                        ),
                             
                              const SizedBox(height: 20),
              
              
                  Center(
                    child: MyButton(onTap: () {
                      if (widget.formKey.currentState!.validate()) {
                      AuthServices.createUser(
                        context,
                        widget.nameController.text,
                        widget.emailController.text,
                        widget.passController.text
                      );
                    }
                    }, title: 'Зарегистрироваться',)
                     
                    ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Уже есть аккаунт?'),
                        SizedBox( width: 4,),
                        TextButton(
                          style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          ),
                          child: const Text("Войти", style: TextStyle(color: mainGreen,),),
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






