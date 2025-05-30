import 'package:flutter/material.dart';

/// **Alert utility class for displaying confirmation and information dialogs**
/// 
/// This class provides static methods to show customizable alert dialogs
/// throughout the Cinebook application for user confirmations and notifications.
class Alert {

   // %%%%%%%%%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%%%%%%%%%%%
   /// **Displays a customizable alert dialog with optional confirmation buttons**
   /// 
   /// This method creates and shows an AlertDialog with configurable title, message,
   /// and button options. It supports both single-button (information) and two-button
   /// (confirmation) dialog modes.
   /// 
   /// Parameters:
   /// - context: BuildContext required to show the dialog
   /// - title: String displayed as the dialog header
   /// - message: String displayed as the dialog content/body
   /// - approvalButtonText: Text for the primary/approval button (default: "OK")
   /// - cancellationButtonText: Optional text for cancel button (if null, only approval button shows)
   /// - barrierDismissible: Whether dialog can be dismissed by tapping outside (default: false)
   /// - foregroundColor: Optional custom color for text elements
   /// - backgroundColor: Optional custom background color for the dialog
   /// 
   /// Returns:
   /// - Future<bool?> : true if approval button pressed, false if cancel pressed, null if dismissed
   /// 
   /// Example usage:
   /// ```dart
   /// bool? result = await Alert.display(
   ///   context, 
   ///   "Confirm Delete", 
   ///   "Are you sure you want to delete this media?",
   ///   approvalButtonText: "Delete",
   ///   cancellationButtonText: "Cancel"
   /// );
   /// ```
   static Future<bool?> display (BuildContext context, String title, String message, {String approvalButtonText = "OK", String? cancellationButtonText, bool barrierDismissible = false, Color? foregroundColor, Color? backgroundColor}) {

       return showDialog<bool>(
           context: context, 
           barrierDismissible: barrierDismissible,

           builder: (context) => AlertDialog(

               // Dialog title with custom styling
               title: Text(
                   title,
                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                       color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                   ),     
               ),

               // Dialog content/message with custom styling
               content: Text(
                   message, 
                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                       color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                   ), 
               ),

               // Custom background color or theme default
               backgroundColor: backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,

               actions: [
                   // Optional cancellation button (only shows if text provided)
                   if (cancellationButtonText != null && cancellationButtonText.trim().isNotEmpty)
                       TextButton(
                           onPressed: () => Navigator.of(context).pop(false), // Returns false
                           child: Text(
                               cancellationButtonText,
                               style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                   color: foregroundColor ?? Theme.of(context).colorScheme.onSurface
                               ), 
                           )
                       ),
                   
                   // Primary approval button (always present)
                   TextButton(
                       onPressed: () => Navigator.of(context).pop(true), // Returns true
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