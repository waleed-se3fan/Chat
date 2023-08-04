import 'package:chat/cubit/chat_cubit.dart';

import 'package:chat/signin.dart';
import 'package:chat/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 20),
                      child: Text(
                        'Find your all friends in one place by signing the apps easly',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        ChatCubit.signup_nameController.text = value;
                      },
                      decoration: const InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Your name',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Colors.black,
                        ),
                      ),
                      cursorHeight: 13,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextField(
                      cursorHeight: 13,
                      onChanged: (value) {
                        ChatCubit.signup_PhoneNumber.text = value;
                      },
                      decoration: const InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Phone number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.lock_outline,
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
                        ChatCubit.signup_emailController.text = value;
                      },
                      controller: ChatCubit.signup_emailController,
                      decoration: const InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
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
                        ChatCubit.signup_passwordController.text = value;
                      },
                      decoration: const InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await cubit.signup(
                            ChatCubit.signup_emailController.text,
                            ChatCubit.signup_emailController.text,
                          );

                          cubit.storeData(
                            ChatCubit.signup_nameController.text,
                            ChatCubit.signup_PhoneNumber.text,
                            ChatCubit.signup_emailController.text,
                            ChatCubit.signup_passwordController.text,
                          );

                          cubit.status == 'success'
                              // ignore: use_build_context_synchronously
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
                                  return const UserScreen();
                                }))
                              : null;
                        },
                        child: const Text('Sign up')),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) {
                            return const SigninScreen();
                          }));
                        },
                        child: const Text('Log in')),
                    ElevatedButton(
                        onPressed: () async {
                          cubit.getAddedUsers();
                          // final FirebaseFirestore firestore =
                          //     FirebaseFirestore.instance;

                          // QuerySnapshot x = await firestore
                          //     .collection('User')
                          //     .where('phone', isEqualTo: '01029673915')
                          //     .get();
                          // print(x.docs[0]['email']);
                        },
                        child: const Text('Enter'))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
