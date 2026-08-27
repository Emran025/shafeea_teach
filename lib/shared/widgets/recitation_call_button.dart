import 'package:flutter/material.dart';

class RecitationCallButton extends StatelessWidget {
  final VoidCallback onCallRequested;
  final bool isCalling;

  const RecitationCallButton({
    Key? key,
    required this.onCallRequested,
    this.isCalling = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isCalling ? Icons.call_end : Icons.add_ic_call,
        color: isCalling ? Colors.red : Colors.green,
      ),
      tooltip: isCalling ? 'إنهاء الجلسة' : 'بدء جلسة تسميع',
      onPressed: onCallRequested,
    );
  }
}
