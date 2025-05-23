import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@ STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@
// ignore: must_be_immutable
class PickerField extends StatefulWidget {

    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    final String label;
    final bool isRequired;
    final String? hintText;
    final String? initialValue;
    final Color? foregroundColor;
    final Color? foregroundHighColor;
    final Color? backgroundColor;
    final List<String> options;
    final String? selectedValue;
    final void Function(String)? onChanged;
    TextEditingController? textController;
    final String? errorText;
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
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
    });
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%
    @override State<StatefulWidget> createState() => _PickerFieldState();
    // %%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@ END - STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@@ STATE OF THE STATEFUL WIDGET %%%%%%%%%%%%%%%%%
class _PickerFieldState extends State<PickerField> {

    // %%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%
    late String? selected;
    // %%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();
        selected = widget.initialValue;

        if (widget.textController == null) {
            widget.textController = TextEditingController(
                text: selected ?? '',
            );
        } 
    }
    // %%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% SHOW PICKER %%%%%%%%%%%%%%%%%
     void _showPicker() {

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
                                        color: isSelected ? foregroundHigh : foreground,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                ),
                            
                                trailing: isSelected ? Icon(Icons.check, color: foregroundHigh) : null,
                                
                                onTap: () {
                                    setState(() {
                                        widget.textController?.text = option;
                                    });
                                    
                                    if (widget.onChanged != null) widget.onChanged!(option);
                                    Navigator.pop(context);
                                },
                            ),
                        );
                    }).toList(),
                );
            },
        );
    }
    // %%%%%%%%%%%%%%%%% END - SHOW PICKER %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
        final ColorScheme scheme = Theme.of(context).colorScheme;

        final Color foreground = widget.foregroundColor ?? scheme.onSurface;
        final Color foregroundHigh = widget.foregroundHighColor ?? scheme.surfaceContainerHighest;

        return TextField(
                controller: widget.textController,
                readOnly: true,
                onTap: _showPicker,
                
                decoration: InputDecoration(
                    
                    suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: foregroundHigh,
                    ),

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
// @@@@@@@@@@@@@@@@@@@@@@ STATE OF THE STATEFUL WIDGET %%%%%%%%%%%%%%%%%
