import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@$ STATEFUL @@@@@@@@@@@@@@$
/// **Custom toggle button group widget that displays a horizontal list of selectable buttons.**
/// 
/// This widget creates a group of outlined buttons where only one can be selected at a time.
/// When a button is pressed, it becomes highlighted and triggers a callback with the selected index.
/// The buttons are displayed in a horizontally scrollable view with rounded corners.
/// 
/// Features:
/// - Single selection mode (radio button behavior)
/// - Horizontal scrolling for overflow handling
/// - Custom styling with theme-based colors
/// - Callback notification on selection change
/// 
/// Example usage:
/// ```dart
/// ToggleButtonGroup(
///   buttons: ['Action', 'Comedy', 'Drama'],
///   initialIndex: 0,
///   onChanged: (index, buttons) {
///     print('Selected: ${buttons[index]}');
///   },
/// )
/// ```
// ignore: must_be_immutable
class ToggleButtonGroup extends StatefulWidget {

    // %%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%
    /// List of button labels to display in the toggle group
    final List<String> buttons;
    
    /// Callback function triggered when a button is selected.
    /// Parameters: selectedIndex (int), buttons (List<String>)
    final void Function(int selectedIndex, List<String> buttons) onChanged;
    
    /// Index of the initially selected button (defaults to 0)
    int initialIndex;
    // %%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%
    ToggleButtonGroup({
        super.key,
        required this.buttons,
        required this.onChanged,
        this.initialIndex = 0,
    });
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%

    @override
    State<StatefulWidget> createState() => ToggleButtonGroupState();

}
// @@@@@@@@@@@@@@$ END - STATEFUL @@@@@@@@@@@@@@$





// @@@@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@@@
/// **State class for ToggleButtonGroup widget.**
/// 
/// Manages the selected button index and handles button press events.
/// Updates the UI when selection changes and notifies parent widget through callback.
class ToggleButtonGroupState extends State<ToggleButtonGroup> {

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    /// Currently selected button index
    late int selectedIndex;
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        // Initialize selected index with the provided initial value
        selectedIndex = widget.initialIndex;
    }
    // %%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% ON PRESSED %%%%%%%%%%%%%%%%%
    /// **Handles button press events and updates selection state.**
    /// 
    /// Updates the selectedIndex, triggers a setState to refresh the UI,
    /// and calls the onChanged callback to notify the parent widget.
    /// 
    /// Parameters:
    /// - index : The index of the pressed button
    void onButtonPressed(int index){
        setState(() {
            selectedIndex = index;
        });
        // Notify parent widget about the selection change
        widget.onChanged(index, widget.buttons);
    }
    // %%%%%%%%%%%%%%%%% END - ON PRESSED %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override Widget build(BuildContext context) {
        
        // Horizontal scrollable container for button overflow handling
        return SingleChildScrollView( 
            scrollDirection: Axis.horizontal,

            child:  Wrap(
                spacing: 10, // Space between buttons
                alignment: WrapAlignment.start,

                children: List.generate(
                    widget.buttons.length, 

                    (index) {
                        // Check if current button is selected for styling
                        final bool isSelected = index == selectedIndex;
                        return OutlinedButton(

                            style: OutlinedButton.styleFrom(
                                // Selected button gets primary color background, unselected is transparent
                                backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,

                                // Selected button gets light text, unselected gets primary color text
                                foregroundColor: isSelected ? Colors.white54 : Theme.of(context).colorScheme.primary,

                                textStyle: Theme.of(context).textTheme.labelLarge,

                                // Primary color border for all buttons
                                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                // Rounded pill-shaped buttons
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            ),

                            onPressed: () => onButtonPressed(index), 
                            child: Text(widget.buttons[index]),
                        );
                    }
                ),
            )
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@@@