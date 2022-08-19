import 'package:flutter/material.dart';

class NoDataText extends StatelessWidget {
  const NoDataText({Key? key,this.text='داده ای یافت نشد!'}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(text),
    );
  }
}
