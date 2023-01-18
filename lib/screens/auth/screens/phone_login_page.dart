import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/utils/constants/dimension_constants.dart';
import '../../../utils/common/widgets/helper_widgets.dart';
import '../../../utils/common/widgets/round_button.dart';
import '../../../utils/constants/colors_constants.dart';
import '../controllers/auth_controller.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  late Size _size;
  String? _countryCode = '234';
  late final TextEditingController _phoneNoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneNoController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: _size.width,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          addVerticalSpace(_size.width * 0.3),
          _buildInfoText(),
          addVerticalSpace(_size.width * 0.02),
          _buildNumberTF(),
          const Expanded(child: SizedBox()),
          if (_isLoading)
            const CircularProgressIndicator(
              color: AppColors.black,
            ),
          const Expanded(child: SizedBox()),
          RoundButton(
            text: 'Continue',
            onPressed: _sendOTP,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter phone number to \nContinue',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.black,
                fontSize: _size.width * 0.05,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Enter a mobile number to continue with sign in / sign up. we will send a code.',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.lightBlack.withOpacity(0.7),
                fontSize: _size.width * 0.03,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Phone Number',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.black,
                fontSize: _size.width * 0.04,
              ),
        ),
      ],
    );
  }

  Widget _buildNumberTF() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextField(
        controller: _phoneNoController,
        enabled: true,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'^0')),
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 35,
                  child: Image.asset(
                    'assets/images/ng.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  '+234',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.black,
                        fontSize: _size.width * 0.04,
                      ),
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.cornerRadius,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              DimensionConstants.cornerRadius,
            ),
          ),
          hintText: '812 849 233',
          hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.grey,
                fontSize: _size.width * 0.05,
                fontWeight: FontWeight.normal,
              ),
          contentPadding: const EdgeInsets.all(0),
        ),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.black,
              fontSize: _size.width * 0.04,
            ),
      ),
    );
  }

  void chooseCountryCode() {
    showCountryPicker(
      context: context,
      onSelect: (Country value) {
        setState(() {
          _countryCode = '+${value.phoneCode}';
        });
      },
    );
  }

  /// invoke to send otp to the user.
  void _sendOTP() async {
    if (_phoneNoController.text.isNotEmpty && _countryCode != null) {
      setState(() => _isLoading = true);

      final authController = ref.read<AuthController>(authControllerProvider);

      authController
          .signInWithPhone(context,
              phoneNumber: '+$_countryCode${_phoneNoController.text}')
          .whenComplete(() {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          setState(() => _isLoading = false);
          showSnackBar(
            context,
            content: 'An error occurred, try again',
          );
        }
      });
      // log('+$_countryCode${_phoneNoController.text}');
    } else {
      showSnackBar(
        context,
        content: 'Please fill the phone number correctly',
      );
    }
  }
}
