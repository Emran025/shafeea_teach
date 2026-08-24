import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';

class CallNotificationOverlay extends StatelessWidget {
  final String sessionId;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  CallNotificationOverlay({
    Key? key,
    required this.sessionId,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.call, color: Colors.green, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nStrings.AppStrings.incomingCall,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(L10nStrings.AppStrings.studentRecitationRequest),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: onAccept,
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: onReject,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
