import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/core/widgets/custom_text_field.dart';
import 'package:lets_chat/screens/sender_info/controllers/sender_user_data_controller.dart';
import 'package:lets_chat/utils/constants/string_constants.dart';
import 'package:lets_chat/utils/image_processor.dart';
import '../../../utils/common/widgets/helper_widgets.dart';
import '../../../utils/common/helper_methods/util_methods.dart';
import '../../../utils/constants/colors_constants.dart';
import 'package:lets_chat/models/user.dart' as app;

class UserEditScreen extends ConsumerStatefulWidget {
  const UserEditScreen({super.key});

  @override
  ConsumerState<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends ConsumerState<UserEditScreen> {
  late TextEditingController _nameController;
  late Size _size;
  File? _imageFile;
  app.User? userData;

  bool _isLoading = false;

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
      appBar: _buildAppBar(context),
      body: StreamBuilder<app.User?>(
          stream:
              ref.watch(senderUserDataControllerProvider).getUserDataStream(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              userData = snapshot.data;
            }
            return _buildBody();
          }),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: _size.width * 0.8,
            height: _size.height,
            child: userData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      addVerticalSpace(_size.width * 0.2),
                      _buildProfileImage(),
                      addVerticalSpace(_size.width * 0.1),
                      CustomTextField(
                        hint: 'Name',
                        prefix: Icons.person,
                        value: userData?.name,
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hint: 'Phone number',
                        value: userData?.phoneNumber,
                        readOnly: true,
                        prefix: Iconsax.call,
                        onChanged: (value) {},
                      ),
                      const Expanded(child: SizedBox()),
                      if (_isLoading)
                        const CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  /// AppBar of the home screen
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leadingWidth: 20,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
      ),
      title: Text(
        StringsConsts.editAccount,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        TextButton(
            onPressed: _saveUserInfo,
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: _size.width * 0.04,
                  ),
            ))
      ],
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _imageFile != null
            ? CircleAvatar(
                backgroundImage: FileImage(_imageFile!),
                radius: _size.width * 0.2,
                backgroundColor: AppColors.white,
              )
            : CircleAvatar(
                radius: _size.width * 0.2,
                backgroundColor: AppColors.primary.withOpacity(
                  0.5,
                ),
                child: CircleAvatar(
                  radius: (_size.width * 0.2) - 4,
                  backgroundImage:
                      userData != null && userData!.profilePic != null
                          ? getImage(userData!.profilePic!)
                          : null,
                  child: userData != null && userData!.profilePic != null
                      ? null
                      : const Icon(
                          Iconsax.user,
                          color: AppColors.primary,
                          size: 36,
                        ),
                ),
              ),
        Positioned(
          top: (_size.width * 0.5) * 0.55,
          left: (_size.width * 0.5) * 0.55,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: _selectImage,
              icon: Icon(
                Iconsax.camera5,
                color: AppColors.white,
                size: _size.width * 0.06,
              ),
            ),
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
        hintText: 'Name',
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

  void _saveUserInfo() async {
    setState(() => _isLoading = true);
    if (_nameController.text.isNotEmpty) {
      await ref
          .read(senderUserDataControllerProvider)
          .saveSenderUserDataToFirebase(
            context,
            mounted,
            userName: _nameController.text,
            imageFile: _imageFile,
          );
    } else {
      showSnackBar(context, content: 'Please Enter Name');
    }
    setState(() => _isLoading = false);
  }

  void _selectImage() async {
    _imageFile = await pickImageFromGallery(context);
    setState(() {});
  }
}
