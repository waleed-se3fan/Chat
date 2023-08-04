import 'package:chat/cubit/chat_cubit.dart';
import 'package:chat/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()
        ..getUserData()
        ..userName(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('All Chats'),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: 0,
                elevation: .1,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.chat_bubble), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.settings), label: ''),
                ]),
            body: SingleChildScrollView(
              child: FutureBuilder(
                  future: cubit.getLengthOfCart(),
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data == null ? 0 : snapshot.data,
                                  itemBuilder: (c, i) {
                                    return FutureBuilder(
                                        future: cubit.getUserData(),
                                        builder: (context, s) {
                                          return s.data == null
                                              ? const CircularProgressIndicator()
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (c) {
                                                      return ChatScreen(
                                                          s.data![i]['uid']
                                                              .toString(),
                                                          s.data![i]['name']
                                                              .toString());
                                                    }));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading:
                                                            const CircleAvatar(),
                                                        title: Text(snapshot
                                                                    .data ==
                                                                null
                                                            ? 'wait ....'
                                                            : s.data![i]['name']
                                                                .toString()),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      )
                                                    ],
                                                  ),
                                                );
                                        });
                                  })
                            ],
                          );
                  }),
            ),
          );
        },
      ),
    );
  }
}
