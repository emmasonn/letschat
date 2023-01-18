import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/models/user.dart' as app;
import 'package:lets_chat/screens/sender_info/controllers/sender_user_data_controller.dart';
import 'package:lets_chat/utils/constants/colors_constants.dart';
import 'package:lets_chat/utils/constants/routes_constants.dart';
import 'package:lets_chat/utils/constants/string_constants.dart';
import 'package:lets_chat/utils/image_processor.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  app.User? userData;
  late Size size;

  @override
  Widget build(BuildContext context) {
    // userData =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder<app.User?>(
          stream:
              ref.watch(senderUserDataControllerProvider).getUserDataStream(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              userData = snapshot.data;
            }
            return _buildBody(context);
          }),
    );
  }

  /// AppBar of the home screen
  AppBar _buildAppBar(BuildContext context) {
    size = MediaQuery.of(context).size;
    return AppBar(
      centerTitle: false,
      leadingWidth: 20,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
      ),
      title: Text(
        StringsConsts.settings,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _profileBody() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.8),
        minRadius: 35,
        maxRadius: 45,
        child: userData != null && userData!.profilePic != null
            ? loadImageWidget(userData!.profilePic!)
            : const Icon(
                Iconsax.user,
                color: AppColors.primary,
                size: 36,
              ),
      ),
      horizontalTitleGap: 5.0,
      title: Text(
        userData?.name ?? '',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: size.width * 0.04,
            ),
      ),
      subtitle: Text(
        userData?.phoneNumber ?? '',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: AppColors.grey,
              fontSize: size.width * 0.04,
            ),
      ),
      trailing: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.editAccount);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.edit5,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              'Edit',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: AppColors.primary,
                    fontSize: size.width * 0.03,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        _profileBody(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          child: Divider(
            color: AppColors.grey,
          ),
        ),
        SizedBox(
          height: size.width * 0.03,
        ),
        _settingsItem(
          startIcon: Iconsax.message,
          title: 'Contact Admin',
          onTap: () {},
        ),
        _settingsItem(
          startIcon: Iconsax.security_user,
          title: 'Help & Support',
          onTap: () {},
        ),
        _settingsItem(
          startIcon: Icons.error_outline_rounded,
          title: 'Privacy & Policy',
          onTap: () {},
        ),
        _settingsItem(
          startIcon: Icons.error_outline_rounded,
          title: 'Terms & Condition',
          onTap: () {},
        ),
        _settingsItem(
          startIcon: Iconsax.logout,
          title: 'Logout',
          onTap: () {},
        ),
      ],
    ));
  }

  Widget _settingsItem({
    required IconData startIcon,
    required String title,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: onTap,
        horizontalTitleGap: 10.0,
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0)),
          child: Icon(
            startIcon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: size.width * 0.04,
              ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 24,
        ),
      ),
    );
  }
}
