import 'package:flutter/material.dart';
import 'package:lets_chat/utils/constants/colors_constants.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 65,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: size.width * 0.05,
          // left: size.width * 0.05,
          // right: size.width * 0.05,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: color != null ? AppColors.primary : AppColors.white,
                  fontSize: size.width * 0.04,
                ),
          ),
        ),
      ),
    );
  }
}
