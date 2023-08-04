import 'package:chat/cubit/chat_cubit.dart';
import 'package:chat/signup.dart';
import 'package:chat/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return Scaffold(
            body: Container(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 20),
                    child: Text(
                      'You and your friends always connected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    cursorHeight: 13,
                    onChanged: (value) {
                      ChatCubit.signin_emailController.text = value;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextField(
                    cursorHeight: 13,
                    onChanged: (value) {
                      ChatCubit.signin_passwordController.text = value;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await cubit.signin(
                            ChatCubit.signin_emailController.text,
                            ChatCubit.signin_passwordController.text);

                        cubit.lstatus == 'success'
                            // ignore: use_build_context_synchronously
                            ? Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                                return const UserScreen();
                              }))
                            : null;
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return const SignupScreen();
                        }));
                      },
                      child: const Text('Sign up'))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
