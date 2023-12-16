import 'package:flutter/material.dart';
import '../constants/constants.dart';


class RoundedButton extends StatelessWidget {
  final String btnText;
  final VoidCallback? onBtnPressed; // Change the type to VoidCallback

  const RoundedButton({
    Key? key,
    required this.btnText,
    required this.onBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: AutiTrackColor,
      borderRadius: BorderRadius.circular(30),
      child: SizedBox( // Wrap MaterialButton in SizedBox to constrain its size
        width: 320,
        height: 60,
        child: MaterialButton(
          onPressed: onBtnPressed,
          child: Text(
            btnText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}