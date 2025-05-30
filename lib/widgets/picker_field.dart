import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@ STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@

/// **Customizable picker field widget with bottom sheet selection**
///
/// This widget creates a read-only text field that opens a modal bottom sheet
/// with selectable options when tapped. It provides a clean interface for
/// single-choice selection with customizable styling and validation.
///
/// Features:
/// - Modal bottom sheet with scrollable options list
/// - Customizable colors for foreground, highlight, and background
/// - Required/optional field indicators in label
/// - Error state handling with custom error text
/// - Selected option highlighting with check icon
/// - Automatic text controller management
/// - Focus node support for navigation
///
/// Parameters:
/// - label : String label text displayed above the field
/// - isRequired : bool indicating if field is required (default: true)
/// - hintText : Optional hint text shown when no value selected
/// - initialValue : Optional initial selected value
/// - foregroundColor : Optional custom foreground text color
/// - foregroundHighColor : Optional custom highlight/accent color
/// - backgroundColor : Optional custom background color for picker sheet
/// - options : List<String> of selectable options to display
/// - selectedValue : Optional currently selected value
/// - onChanged : Optional callback when selection changes
/// - textController : Optional custom TextEditingController
/// - errorText : Optional error message to display
/// - focusNode : Optional FocusNode for navigation control
/// - onTap : Optional callback when field is tapped
///
/// Example usage:
/// ```dart
/// PickerField(
///   label: "Genre",
///   hintText: "Select a genre",
///   options: ["Action", "Comedy", "Drama", "Horror"],
///   onChanged: (value) => setState(() => selectedGenre = value),
///   isRequired: true,
/// )
/// ```
// ignore: must_be_immutable
class PickerField extends StatefulWidget {

    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    /// Label text displayed above the picker field
    final String label;
    /// Indicates if this field is required for form validation
    final bool isRequired;
    /// Hint text shown when no value is selected
    final String? hintText;
    /// Initial value to be selected when widget is first created
    final String? initialValue;
    /// Custom foreground text color (defaults to theme onSurface)
    final Color? foregroundColor;
    /// Custom highlight/accent color (defaults to theme surfaceContainerHighest)
    final Color? foregroundHighColor;
    /// Custom background color for picker sheet (defaults to theme surfaceContainerHigh)
    final Color? backgroundColor;
    /// List of selectable options to display in the picker
    final List<String> options;
    /// Currently selected value (can be used for external state management)
    final String? selectedValue;
    /// Callback function executed when selection changes
    final void Function(String)? onChanged;
    /// Text controller for the input field (auto-created if not provided)
    TextEditingController? textController;
    /// Error text to display below the field
    final String? errorText;
    /// Focus node for navigation control
    final FocusNode? focusNode;
    /// Callback function executed when field is tapped
    final VoidCallback? onTap; 
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    /// Creates a PickerField with required label, hint text, and options
    PickerField({
        super.key,
        required this.label,
        required this.hintText,
        this.initialValue,
        required this.options,
        this.onChanged,
        this.textController,
        this.selectedValue,
        this.errorText,
        this.foregroundColor,
        this.foregroundHighColor,
        this.backgroundColor,
        this.isRequired = true,
        this.focusNode,
        this.onTap,
    });
    // %%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%
    @override State<StatefulWidget> createState() => _PickerFieldState();
    // %%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@ END - STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@@ STATE OF THE STATEFUL WIDGET %%%%%%%%%%%%%%%%%

/// **State management for PickerField widget**
///
/// Handles the selection state, text controller initialization, and picker
/// modal bottom sheet presentation. Manages color theming and user interactions.
class _PickerFieldState extends State<PickerField> {

    // %%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%
    /// Currently selected option value
    late String? selected;
    // %%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();
        // Initialize selected value from widget's initial value
        selected = widget.initialValue;

        // Create text controller if not provided
        if (widget.textController == null) {
            widget.textController = TextEditingController(
                text: selected ?? '',
            );
        } 
    }
    // %%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% SHOW PICKER MODAL %%%%%%%%%%%%%%%%%%%%%%%%%%
    /// **Displays modal bottom sheet with selectable options**
    ///
    /// This method creates and shows a modal bottom sheet containing a scrollable
    /// list of all available options. Each option is displayed as a ListTile with
    /// selection highlighting and a check icon for the currently selected item.
    ///
    /// Features:
    /// - Rounded top corners for modern appearance
    /// - Custom theming with fallback to Material Design colors
    /// - Selected item highlighting with bold text and check icon
    /// - Tap handling that updates selection and closes modal
    /// - Automatic text controller update and onChanged callback execution
    ///
    /// The modal uses theme colors with customizable overrides:
    /// - foreground: Regular option text color
    /// - foregroundHigh: Selected option text and check icon color  
    /// - backgroundHigh: Modal background color
    ///
    /// Upon selection, the method:
    /// 1. Updates the text controller with selected value
    /// 2. Calls onChanged callback if provided
    /// 3. Closes the modal with Navigator.pop()
     void _showPicker() {

        // Get theme colors with custom overrides
        final ColorScheme scheme = Theme.of(context).colorScheme;
        final Color foreground = widget.foregroundColor ?? scheme.onSurface;
        final Color foregroundHigh = widget.foregroundHighColor ?? scheme.surfaceContainerHighest;
        final Color backgroundHigh = widget.backgroundColor ?? scheme.surfaceContainerHigh;

        showModalBottomSheet(
            context: context,
            backgroundColor: backgroundHigh,

            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),

            builder: (context) {
                return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),

                    children: widget.options.map((option) {
                        bool isSelected = option == selected;

                        return InkWell(
                            onTap: () => setState(() => selected = option),

                            child: ListTile(
                          
                                title: Text(
                                    option,
                            
                                    style: TextStyle(
                                        // Highlight selected option with different color and bold text
                                        color: isSelected ? foregroundHigh : foreground,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                ),
                            
                                // Show check icon for selected option
                                trailing: isSelected ? Icon(Icons.check, color: foregroundHigh) : null,
                                
                                onTap: () {
                                    // Update text controller with selected option
                                    setState(() {
                                        widget.textController?.text = option;
                                    });
                                    
                                    // Execute onChanged callback if provided
                                    if (widget.onChanged != null) widget.onChanged!(option);
                                    // Close the picker modal
                                    Navigator.pop(context);
                                },
                            ),
                        );
                    }).toList(),
                );
            },
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - SHOW PICKER MODAL %%%%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
        // Get theme colors for consistent styling
        final ColorScheme scheme = Theme.of(context).colorScheme;

        final Color foreground = widget.foregroundColor ?? scheme.onSurface;
        final Color foregroundHigh = widget.foregroundHighColor ?? scheme.surfaceContainerHighest;

        return TextField(
            focusNode: widget.focusNode,
            controller: widget.textController,
            readOnly: true, // Prevent manual text input
            onTap: () {
                // Show picker modal when field is tapped
                _showPicker();
                // Execute additional onTap callback if provided
                if (widget.onTap != null) widget.onTap!();
            } ,
            
            decoration: InputDecoration(
                    
                    // Dropdown arrow icon to indicate picker functionality
                    suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: foregroundHigh,
                    ),

                    // Label with optional indicator for required fields
                    labelText: widget.isRequired ? 
                        widget.label :
                        "${widget.label} (optional)",

                    hintText: widget.hintText ?? 'Click to select',
                    alignLabelWithHint: true,

                    labelStyle: TextStyle(
                        fontSize: 13,
                        color: foregroundHigh,
                    ),
                    
                    hintStyle: TextStyle(
                        color: foreground,
                    ),

                    // Rounded border styling for modern appearance
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                    ),
                        
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: foregroundHigh),
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: foregroundHigh, width: 2),
                    ),

                    // Error state styling
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                    ),

                    errorText: widget.errorText,
                ),
        );
    }
    // %%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@@@ END - STATE OF THE STATEFUL WIDGET %%%%%%%%%%%%%%%%%