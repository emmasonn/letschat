import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/common/widgets/helper_widgets.dart';
import '../../../utils/constants/colors_constants.dart';
import '../controllers/auth_controller.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  late String? verificationId;
  late Size _size;
  int _start = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    verificationId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            addVerticalSpace(_size.width * 0.3),
            _buildInfoText(),
            addVerticalSpace(_size.width * 0.08),
            _buildNumberTF(),
            addVerticalSpace(_size.width * 0.08),
            _buildInfoResend()
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter verification code',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.black,
                    fontSize: _size.width * 0.06,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: RichText(
                text: TextSpan(
                    text: 'Enter verification sent to',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.lightBlack.withOpacity(0.7),
                          fontSize: _size.width * 0.03,
                        ),
                    children: [
                      TextSpan(
                        text: ' +234 8122 8493 932',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.lightBlack.withOpacity(0.7),
                                  fontSize: _size.width * 0.04,
                                ),
                      ),
                      TextSpan(
                        text: '\nor ',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.lightBlack.withOpacity(0.7),
                                  fontSize: _size.width * 0.03,
                                ),
                      ),
                      TextSpan(
                        text: 'Change number.',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: _size.width * 0.03,
                                ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoResend() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'If you don\'t get the code, resend it in',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.lightBlack.withOpacity(0.7),
                      fontSize: _size.width * 0.03,
                    ),
                children: [
                  TextSpan(
                    text: ' 0:$_start ',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary.withOpacity(0.6),
                          fontSize: _size.width * 0.035,
                        ),
                  ),
                  TextSpan(
                    text: 'secs',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.lightBlack.withOpacity(0.7),
                          fontSize: _size.width * 0.03,
                        ),
                  ),
                ]),
          ),
          if (_start == 0) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                'Resend code',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontSize: _size.width * 0.03,
                    ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildNumberTF() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _size.width * 0.5,
          child: TextField(
            maxLines: 1,
            minLines: 1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (String otp) {
              if (otp.length == 6) {
                FocusManager.instance.primaryFocus?.unfocus();
                verifyOTP(otp);
              }
            },
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '- - - - - -',
              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.grey,
                    fontSize: _size.width * 0.08,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.black,
                  fontSize: _size.width * 0.08,
                ),
          ),
        ),
      ],
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void verifyOTP(String smsCode) async {
    await ref.watch<AuthController>(authControllerProvider).verifyOTP(
          context,
          mounted,
          verificationId: verificationId!,
          smsCode: smsCode,
        );
  }
}
