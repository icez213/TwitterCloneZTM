import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:twitter_clone/pages/create.dart';
import 'package:twitter_clone/pages/settings.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';

import '../models/tweet.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool clicked = false;
  SMIInput<bool>? _pressed;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'Button');
    artboard.addController(controller!);
    _pressed = controller.findInput("Press");
  }

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        title: const FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.blue,
          size: 50,
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            key: const ValueKey("profilePic"),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    currentUser.user.profilePic),
              ),
            ),
          );
        }),
        actions: [
          AnimatedOpacity(
            opacity: clicked ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: CircleAvatar(
                radius: 60,
                child: Image.asset("assets/mars.png"),
              ),
            ),
          )
        ],
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(
                      color: Colors.black,
                    ),
                itemCount: tweets.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(
                          tweets[index].profilePic),
                    ),
                    title: Text(
                      tweets[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tweets[index].tweet,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }));
          },
          error: (error, stackTrace) => const Center(
                child: Text('error'),
              ),
          loading: () {
            return const CircularProgressIndicator();
          }),
      drawer: Drawer(
          child: Column(
        children: [
          Image.network(currentUser.user.profilePic),
          ListTile(
            title: Text(
              "Hello, ${currentUser.user.name}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Settings()));
            },
          ),
          ListTile(
            key: const ValueKey("signOut"),
            title: const Text("Sign Out"),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      )),
      floatingActionButton: AnimatedContainer(
        padding: const EdgeInsets.only(top: 90),
        alignment: clicked
            ? Alignment.topRight
            : Alignment.bottomRight,
        duration: const Duration(seconds: 1),
        child: SizedBox(
          width: 100,
          height: 100,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                clicked = true;
              });
              _pressed?.value = true;
              Future.delayed(const Duration(seconds: 2),
                  () {
                setState(() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) {
                      return const CreateTweet();
                    },
                  ));
                  setState(() {
                    clicked = false;
                  });
                });
              });
            },
            onTapCancel: () {
              _pressed?.value = false;
            },
            onTapUp: (_) {
              _pressed?.value = false;
            },
            child: RiveAnimation.asset(
              'assets/rocket.riv',
              onInit: _onRiveInit,
            ),
          ),
        ),
      ),
    );
  }
}
