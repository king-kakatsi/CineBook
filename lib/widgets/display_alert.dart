import 'package:flutter/material.dart';

class Alert {

    // %%%%%%%%%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%%%%%%%%%%%
    static Future<bool?> display (BuildContext context, String title, String message, {String approvalButtonText = "OK", String? cancellationButtonText, bool barrierDismissible = false, Color? foregroundColor, Color? backgroundColor}) {

        return showDialog<bool>(
            context: context, 
            barrierDismissible: barrierDismissible,

            builder: (context) => AlertDialog(

                title: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                    ),     
                ),

                content: Text(
                    message, 
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                    ), 
                ),

                backgroundColor: backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,

                actions: [
                    if (cancellationButtonText != null && cancellationButtonText.trim().isNotEmpty)
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false), 
                            child: Text(
                                cancellationButtonText,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                                ), 
                            )
                        ),
                    
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true), 
                        child: Text(
                            approvalButtonText,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                            ),
                        )
                    ),
                ],
            ),
        );
    }
    // %%%%%%%%%%%%%%%%%%%%% END - DISPLAY %%%%%%%%%%%%%%%%%%%%%%%
}