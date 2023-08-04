import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(contex) => BlocProvider.of(contex);

  static var signup_nameController = TextEditingController();
  static var signup_emailController = TextEditingController();
  static var signup_passwordController = TextEditingController();
  static var signup_PhoneNumber = TextEditingController();

  static var signin_emailController = TextEditingController();
  static var signin_passwordController = TextEditingController();

  var dd;

  static var uid;
  String? status;

  String? lstatus;

  Future signup(email, password) async {
    var fireauth = FirebaseAuth.instance;
    try {
      await fireauth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        uid = value.user!.uid;
        status = 'success';
        print(uid);
      });
    } catch (e) {
      status = 'fail';
      print(e.toString());
    }
  }

  storeData(name, phone, email, password) async {
    var firestore = FirebaseFirestore.instance;

    await firestore.collection('User').doc(uid).set({
      'name': name.toString(),
      'email': email.toString(),
      'phone': phone.toString(),
      'password': password.toString(),
      'uid': uid
    }).then((value) {
      print('**************************************************');
    }).catchError((e) {
      print(e.toString());
    });
  }

  signin(email, password) async {
    var fireauth = FirebaseAuth.instance;
    try {
      await fireauth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        uid = value.user!.uid;
        print(value.toString());
      });
      lstatus = 'success';
    } catch (e) {
      lstatus = 'fail';
      print(e.toString());
    }
    fireauth.authStateChanges().listen((event) {
      print('----------------------------------------');
      //  print(event.toString());
    });
  }

  static int n = 0;
  Future<int> getLengthOfCart() async {
    await FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((value) async {
      n = value.docs.length;
    });
    print(n);
    return n;
  }

/**/
  static int addedLenght = 0;
  Future<int> addedUserLenght() async {
    await FirebaseFirestore.instance.collection('uid').get().then((value) {
      addedLenght = value.docs.length;
    });
    print(addedLenght);
    return addedLenght;
  }

  getAddedUsers() async {
    await FirebaseFirestore.instance
        .collection('User')
        .where('phone', isEqualTo: '01029673915')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance.collection(uid).doc().set({
          'name': element.data()['name'],
          'email': element.data()['email'],
          'uid': element.data()['uid'],
          'phone': element.data()['phone']
        });
        print(element.data().toString());
      });
    });
  }

  Future<List<Map>> ll() async {
    //.where('phone',isEqualTo: '01029673915')
    List<Map> data = [];
    await FirebaseFirestore.instance.collection(uid).get().then((value) {
      value.docs.forEach((element) {
        data.add(element.data());
      });
      return data;
    }).catchError((e) {
      print(e.toString());
    });
    return data;
  }

  Future<List<Map>> getUserData() async {
    //.where('phone',isEqualTo: '01029673915')
    List<Map> data = [];
    await FirebaseFirestore.instance.collection('User').get().then((value) {
      value.docs.forEach((element) {
        data.add(element.data());
      });
      return data;
    }).catchError((e) {
      print(e.toString());
    });
    return data;
  }

  static String from = '';
  userName() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .get()
        .then((value) => {from = value['uid']});
    return from;
  }

/* ------------------*/ /* ----------------------*/

  final TextEditingController textController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference? messagesCollection;
  void initial() {
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await auth.currentUser;

    messagesCollection =
        await firestore.collection('chats').doc('chat').collection('messages');
  }

  Future handleSubmitted(
    String message,
    String title,
  ) async {
    textController.clear();
    await messagesCollection!.add({
      'message': message,
      'from': from,
      'timestamp': DateTime.now(),
      'to': title,
      'uid': uid
    });
  }
}
