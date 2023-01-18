import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/screens/contact/controllers/select_receiver_contacts_controller.dart';
import 'package:lets_chat/utils/constants/routes_constants.dart';
import 'package:lets_chat/utils/image_processor.dart';
import '../../../utils/common/widgets/loader.dart';
import '../../../utils/constants/colors_constants.dart';
import '../state/contacts_list_state_notifier.dart';
import 'package:lets_chat/models/user.dart' as app;

class UserContactsScreen extends ConsumerStatefulWidget {
  const UserContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserContactsScreenState();
}

class _UserContactsScreenState extends ConsumerState<UserContactsScreen> {
  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: AppColors.onPrimary,
          ),
      title: Text(
        'Select Contact',
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              color: AppColors.onPrimary,
              fontSize: 18.0,
            ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.selectContactScreen);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
        future: ref
            .watch(selectReceiverContactControllerProvider)
            .getRegisteredUsers(context),
        builder: (context, snaphsot) {
          List<app.User> members = [];

          if (snaphsot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else if (snaphsot.hasData) {
            members = snaphsot.data ?? [];
          } else {
            return const Loader();
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    shrinkWrap: true,
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final user = members[index];
                      return ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          radius: 40,
                          child: user.profilePic != null &&
                                  user.profilePic!.isNotEmpty
                              ? loadImageWidget(user.profilePic!)
                              : const Icon(
                                  Iconsax.user,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                        ),
                        horizontalTitleGap: 5.0,
                        title: Text(
                          user.name,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: _size.width * 0.04,
                                  ),
                        ),
                        subtitle: Text(
                          user.phoneNumber,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: AppColors.grey,
                                    fontSize: _size.width * 0.04,
                                  ),
                        ),
                      );
                    },
                  ),
                )
              ]);
        });
  }

  void _onChangedText(String value) {
    ref
        .read(contactsListStateProvider(context).notifier)
        .getSearchedContactsList(value);
  }
}
