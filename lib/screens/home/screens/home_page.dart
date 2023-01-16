import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/screens/incidents/screens/incident_screen.dart';
import '../../../utils/constants/colors_constants.dart';
import '../../../utils/constants/string_constants.dart';
import '../../chat/widgets/chats_list.dart';
import '../../call/screens/calls_screen.dart';
import '../../sender_info/controllers/sender_user_data_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int index = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        ref.watch(senderUserDataControllerProvider).setSenderUserState(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.watch(senderUserDataControllerProvider).setSenderUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: const [
        CallsScreen(),
        ChatsList(),
        StatusScreen(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          unselectedItemColor: AppColors.grey,
          selectedLabelStyle: Theme.of(context).textTheme.labelMedium,
          unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.call5),
              label: 'Call',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.messages_15,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report_rounded),
              label: 'Incident report',
            ),
          ]),
    );
  }

  /// AppBar of the home screen
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
      ),
      title: Text(
        StringsConsts.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: AppColors.appBarActionIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.settings_rounded,
            color: AppColors.appBarActionIcon,
          ),
        ),
        // PopupMenuButton(
        //   icon: const Icon(Icons.settings),
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //       child: const Text('Logout'),
        //       onTap: () {
        //         FirebaseAuth.instance.signOut();
        //         Future(
        //           () => Navigator.pushReplacementNamed(
        //             context,
        //             AppRoutes.landingScreen,
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
