import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lets_chat/utils/constants/colors_constants.dart';
import '../../../models/chat.dart';
import '../controllers/chat_controller.dart';
import 'no_chat.dart';
import '../../../utils/common/widgets/loader.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/constants/string_constants.dart';

class ChatsList extends ConsumerWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.selectContactScreen);
        },
        child: const Icon(Icons.chat_rounded),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: ref.watch(chatControllerProvider).getChatsList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }
          return snapshot.data!.isEmpty
              ? const NoChat()
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Chat chat = snapshot.data![index];
                    return _buildChatListItem(context, index, chat);
                  },
                );
        },
      ),
    );
  }

  Widget _buildChatListItem(BuildContext context, int index, Chat chat) {
    Size size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.chatScreen,
        arguments: <String, Object>{
          StringsConsts.username: chat.name,
          StringsConsts.userId: chat.userId,
          StringsConsts.profilePic: chat.profilePic,
          StringsConsts.isGroupChat: false,
        },
      ),
      title: Text(
        chat.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: size.width * 0.045,
            ),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: size.width * 0.035,
            ),
      ),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          chat.profilePic,
        ),
      ),
      trailing: Text(
        DateFormat.Hm().format(chat.time),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: size.width * 0.030,
            ),
      ),
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
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.settingScreen);
          },
          icon: const Icon(
            Icons.settings_rounded,
            color: AppColors.appBarActionIcon,
          ),
        ),
      ],
    );
  }
}
