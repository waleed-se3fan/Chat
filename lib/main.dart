import 'dart:convert';

import 'package:chat/cubit/chat_cubit.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/model.dart';
import 'package:chat/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class Trial extends StatefulWidget {
  const Trial({super.key});

  @override
  State<Trial> createState() => _TrialState();
}

List myData = [];

class _TrialState extends State<Trial> {
  getData() async {
    var response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data.toString());
      for (Map<String, dynamic> index in data) {
        myData.add(AutoGenerate.fromJson(index));
      }
      return myData;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder(
              future: getData(),
              builder: (c, s) {
                return s.data == null
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () {}, child: Text(myData[0].title.toString()));
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String title;
  final String name;
  ChatScreen(this.title, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()..getCurrentUser(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var check;
          var cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: Column(
              children: [
                Flexible(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc('chat')
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, int index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];
                            final Timestamp timestamp =
                                document['timestamp'] as Timestamp;
                            final DateTime dateTime = timestamp.toDate();
                            String m = '';
                            cubit.dd = m;
                            dateTime.minute < 10
                                ? m = '0' + dateTime.minute.toString()
                                : m = dateTime.minute.toString();
                            check = document['to'];
                            final isCurrentUser =
                                document['uid'] == ChatCubit.uid;
                            return (document['to'] == title &&
                                        document['from'] == ChatCubit.from) ||
                                    (document['from'] == title &&
                                        document['to'] == ChatCubit.from)
                                ? Container(
                                    alignment: isCurrentUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            document['message'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text('${dateTime.hour}:$m')
                                        ],
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: cubit.textController,
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'Send a message'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              cubit.handleSubmitted(
                                  cubit.textController.text, title);
                              print(check);
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
