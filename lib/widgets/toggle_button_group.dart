import 'package:flutter/material.dart';


// $$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$
// ignore: must_be_immutable
class ToggleButtonGroup extends StatefulWidget {

    // %%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%
    final List<String> buttons;
    final void Function(int selectedIndex, List<String> buttons) onChanged;
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
// $$$$$$$$$$$$$$$ END - STATEFUL $$$$$$$$$$$$$$$





// $$$$$$$$$$$$$$$$$$$$$ STATE $$$$$$$$$$$$$$$$$$$
class ToggleButtonGroupState extends State<ToggleButtonGroup> {

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    late int selectedIndex;
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        selectedIndex = widget.initialIndex;
    }
    // %%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% ON PRESSED %%%%%%%%%%%%%%%%%
    void onButtonPressed(int index){
        setState(() {
            selectedIndex = index;
        });
        widget.onChanged(index, widget.buttons);
    }
    // %%%%%%%%%%%%%%%%% END - ON PRESSED %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override Widget build(BuildContext context) {
        
        return SingleChildScrollView( 
            scrollDirection: Axis.horizontal,

            child:  Wrap(
                spacing: 10,
                alignment: WrapAlignment.start,

                children: List.generate(
                    widget.buttons.length, 

                    (index) {
                        final bool isSelected = index == selectedIndex;
                        return OutlinedButton(

                            style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,

                                foregroundColor: isSelected ? Colors.white54 : Theme.of(context).colorScheme.primary,

                                textStyle: Theme.of(context).textTheme.labelLarge,

                                side: BorderSide(color: Theme.of(context).colorScheme.primary),
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
// $$$$$$$$$$$$$$$$$$$$$ END - STATE $$$$$$$$$$$$$$$$$$$