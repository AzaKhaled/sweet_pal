import 'package:flutter/material.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0xFFDCDEDE))),
          SizedBox(width: 18),
          Text(
            'OR Continue with',
            textAlign: TextAlign.center,
            style: TextStyles.montserrat400_10_black,
          ),
          SizedBox(width: 18),
          Expanded(child: Divider(color: Color(0xFFDCDEDE))),
        ],
      ),
    );
  }
}
