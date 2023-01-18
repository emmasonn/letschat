import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lets_chat/screens/status/controllers/status_controller.dart';
import 'package:lets_chat/utils/common/widgets/round_button.dart';
import 'package:lets_chat/utils/constants/colors_constants.dart';
import 'package:lets_chat/utils/constants/string_constants.dart';
import '../../../models/status.dart';
import '../../../utils/common/widgets/loader.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../chat/widgets/no_chat.dart';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  late Size _size;
  late TextEditingController _nameController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: _buildAppBar(context),
        body: _buildBody(context));
  }

  //builds the body of the incident
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.white),
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [_buildNameTF()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RoundButton(
              color: AppColors.white,
              text: 'Submit',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.phoneLoginScreen,
                );
              },
            ),
          ),
        ],
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
      elevation: 0.0,
      title: Text(
        StringsConsts.incident,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
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

  Widget _buildNameTF() {
    return TextField(
      controller: _nameController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Full name',
        hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.grey,
              fontSize: _size.width * 0.05,
              fontWeight: FontWeight.normal,
            ),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.black,
            fontSize: _size.width * 0.05,
          ),
    );
  }
}
