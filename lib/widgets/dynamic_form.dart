// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:first_project/widgets/picker_field.dart';
import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@@ FORM OBJECT @@@@@@@@@@@@@@@@@@@@

enum FormFieldType {
  text,
  number,
  dropdown,
  textarea,
  picker,
}


class FormObject {

    // %%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    final String id;
    final String title;
    final String? hint;
    final FormFieldType type;
    final double widthFactor;
    final List<String>? options; 
    final bool isRequired; 
    final String? initialValue; 

    FormObject({
        required this.id,
        required this.title,
        this.hint,
        required this.type,
        this.widthFactor = 1.0,
        this.options,
        this.isRequired = false, 
        this.initialValue,
    });
    // %%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@ END - FORM OBJECT @@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@ DYNAMIC FORM PAGE - STATEFUL @@@@@@@@@@@@@@@@@@@

class DynamicFormPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    final List<FormObject> formObjects;
    final void Function(Map<String, String?> results)? onSubmit;
    final double leftPadding;
    final double topPadding;
    final double rightPadding;
    final double bottomPadding;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




  // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
  const DynamicFormPage({

        super.key, 
        required this.formObjects,
        this.onSubmit,
        this.leftPadding = 0.0,
        this.topPadding = 0.0,
        this.rightPadding = 0.0,
        this.bottomPadding = 0.0,
    });
  // %%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%
    @override
    State<DynamicFormPage> createState() => DynamicFormPageState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - DYNAMIC FORM PAGE - STATEFUL @@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@ DYNAMIC FORM PAGE - STATE @@@@@@@@@@@@@@@@@@@
class DynamicFormPageState extends State<DynamicFormPage> {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    final Map<String, TextEditingController> _controllers = {};
    final Map<String, String?> _errors = {};
    TextEditingController? currentlyFocusedController;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        for (var formObject in widget.formObjects) {
            _controllers[formObject.id] = TextEditingController(
                text: formObject.initialValue ?? '',
            );
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%%%
    @override
    void dispose() {

        for (var controller in _controllers.values) {
            controller.dispose();
        }
        super.dispose();
    }
    // %%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% SUBMIT FORM %%%%%%%%%%%%%%%%%%%%
    void _submitForm () {
         
        bool cancelProcess = false;
        Map<String, String?> results = {};
        
        setState(() {
            _errors.clear();
        });

        for (var formObject in widget.formObjects) {
            String? text = _controllers[formObject.id]?.text;

            if (formObject.isRequired && (text == null || text == "" || text.isEmpty)) {
                setState(() {
                    _errors[formObject.id] = "This field is required!";
                });
                cancelProcess = true;
            }
            results[formObject.id] = text;
        }

        if (cancelProcess) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Something went wrong. Please check again your form."),
                )
            );
        } else {
            widget.onSubmit?.call(results);
            _restore();
        }


    }
    // %%%%%%%%%%%%%%%%%% END - SUBMIT FORM %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% CLEAR ALL %%%%%%%%%%%%%%%%%%%%%%
    void _restore () {

        setState(() {
            for (var controller in _controllers.values) {
                controller.clear();
            }
            _errors.clear();
        });
    }
    // %%%%%%%%%%%%%%%%%%% END - CLEAR ALL %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% FIELD WIDGET %%%%%%%%%%%%%%%%%%%%%
    Widget _fieldWidget (FormObject formObject) {

        FocusNode focusNode = FocusNode();
        switch (formObject.type) {

            // oooooooooooooooooo TEXT FIELD oooooooooooooooooo
            case FormFieldType.text:
            case FormFieldType.number:
                return TextField(
                    controller: _controllers[formObject.id],
                    focusNode: focusNode,
                    onTap: () {currentlyFocusedController = _controllers[formObject.id];},

                    decoration: InputDecoration(

                        labelText: formObject.isRequired ? 
                            formObject.title : "${formObject.title} (optional)",

                        hintText: formObject.hint,

                        labelStyle: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                        
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                        ),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                        ),
                            
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                        ),

                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                        ),

                        errorText: _errors[formObject.id],
                    ),

                    keyboardType: formObject.type == FormFieldType.text ?
                        TextInputType.text : TextInputType.number,
                );
            // oooooooooooooooooo END - TEXT FIELD oooooooooooooooooo


            // oooooooooooooooooo TEXT AREA oooooooooooooooooo
            case FormFieldType.textarea:
                return TextField(
                    controller: _controllers[formObject.id],
                    focusNode: focusNode,
                    onTap: () {currentlyFocusedController = _controllers[formObject.id];},

                    decoration: InputDecoration(

                        labelText: formObject.isRequired ? 
                        formObject.title : "${formObject.title} (optional)",
                        hintText: formObject.hint,
                        alignLabelWithHint: true,

                        labelStyle: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                        
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                        ),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                        ),
                            
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
                        ),

                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                        ),

                        errorText: _errors[formObject.id],
                    ),

                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 5,

                );
            // oooooooooooooooooo END - TEXT AREA oooooooooooooooooo


            // oooooooooooooooooo DOPDOWN oooooooooooooooooo
            case FormFieldType.dropdown:
                return DropdownButtonFormField(
                    focusNode: focusNode,
                    onTap: () {currentlyFocusedController = _controllers[formObject.id];},

                    decoration: InputDecoration(
                        labelText: formObject.title,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                        ),
                            
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),

                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                        ),

                        errorText: _errors[formObject.id],
                    ),

                    items: (formObject.options ?? []).map((option) => 
                        DropdownMenuItem(
                            value: option,
                            child: Text(option),
                        )
                    ).toList(), 

                    onChanged: (value) {
                        if (value != null) {
                            setState(() {
                                _controllers[formObject.id]?.text = value;
                                _errors[formObject.id] = null; // enlever l'erreur si corrigé
                            });
                        }
                    },
                );
            // oooooooooooooooooo END - DOPDOWN oooooooooooooooooo


            // ooooooooooooooo PICKER ooooooooooooooooo
            case FormFieldType.picker:
                return PickerField(
                    textController: _controllers[formObject.id],
                    focusNode: focusNode,
                    onTap: () {currentlyFocusedController = null;},

                    label: formObject.title,
                    isRequired: formObject.isRequired,

                    hintText: formObject.hint,
                    options: formObject.options ?? [],
                    initialValue: formObject.initialValue, 

                    errorText: _errors[formObject.id],

                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    foregroundHighColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                );

            // ooooooooooooooo END - PICKER ooooooooooooooooo
        }
    }
// %%%%%%%%%%%%%%%%%%%%% END - FIELD WIDGET %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: widget.leftPadding,
                    top: widget.topPadding,
                    right: widget.rightPadding,
                    bottom: widget.bottomPadding,
                ),

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    // °°°°°°°°°°°°°°°°° FILEDS °°°°°°°°°°°°°°°°°°°°°
                    children: [ 
                        Wrap(
                            runSpacing: 20,

                            children: widget.formObjects.map((formObject) {

                                double fullWidth = MediaQuery.of(context).size.width;
                                double itemWidth = (fullWidth * formObject.widthFactor);

                                return SizedBox(
                                    width: itemWidth,
                                    child: _fieldWidget(formObject),
                                );
                            }).toList(),
                        ),
                        // °°°°°°°°°°°°°°°°° END - FILEDS °°°°°°°°°°°°°°°°°°°°°

                        const SizedBox(height: 30,),

                        // °°°°°°°°°°°°°°°° EDIT AND DELETE BUTTONS °°°°°°°°°°°°°°°°°°°
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            spacing: 20,
                            children: [

                                // =============== RESTORE BUTTON ===================
                                Expanded(
                                    child: OutlinedButton(
                                        onPressed: _restore,

                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Theme.of(context).colorScheme.primary,
                                            ),
                                            foregroundColor: Theme.of(context).colorScheme.primary,
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30), // bien arrondi
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        ),

                                        child: Text('Restore'),
                                    ),
                                ),
                                // =============== END - RESTORE BUTTON ===================


                                // ========== SUBMIT BUTTON ===================
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: _submitForm,

                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Theme.of(context).colorScheme.onPrimary, // texte blanc sur fond coloré
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30), // bien arrondi
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        ),
                                        child: Text('Submit'),
                                    ),
                                ),
                                // ========== END - SUBMIT BUTTON ===================
                            ],
                        ),
                        // °°°°°°°°°°°°°°°° END - EDIT AND DELETE BUTTONS °°°°°°°°°°°°°°°°°°°
                    ]
                ),
            )
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - DYNAMIC FORM PAGE - STATE @@@@@@@@@@@@@@@@@@@







