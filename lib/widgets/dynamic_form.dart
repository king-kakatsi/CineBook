import 'package:first_project/widgets/picker_field.dart';
import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@@ FORM OBJECT @@@@@@@@@@@@@@@@@@@@

/// **Enumeration defining the available form field types**
/// 
/// This enum specifies the different types of input fields that can be
/// created in the dynamic form system for Cinebook media cataloging.
enum FormFieldType {
 text,
 number,
 dropdown,
 textarea,
 picker,
}


/// **Data model representing a single form field configuration**
/// 
/// This class defines the structure and properties of individual form fields
/// used in the dynamic form generation system. Each FormObject contains all
/// necessary information to render and validate a specific input field.
class FormObject {

   // %%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
   /// Unique identifier for the form field
   final String id;
   /// Display title/label for the form field
   final String title;
   /// Optional hint text to guide user input
   final String? hint;
   /// Type of form field (text, number, dropdown, etc.)
   final FormFieldType type;
   /// Width factor for responsive layout (0.0 to 1.0, default: 1.0)
   final double widthFactor;
   /// List of options for dropdown and picker fields
   final List<String>? options; 
   /// Whether this field is required for form submission
   final bool isRequired; 
   /// Initial/default value for the field
   final String? initialValue; 

   /// **Constructor for FormObject with required and optional parameters**
   /// 
   /// Creates a new form field configuration with the specified properties.
   /// Only id, title, and type are required - all other parameters have sensible defaults.
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

/// **StatefulWidget for creating dynamic forms from FormObject configurations**
/// 
/// This widget generates a complete form interface based on a list of FormObject
/// configurations. It handles form submission, validation, and provides customizable
/// padding for different layout requirements in the Cinebook application.
class DynamicFormPage extends StatefulWidget {

   // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
   /// List of form field configurations to generate
   final List<FormObject> formObjects;
   /// Callback function executed when form is successfully submitted
   final void Function(Map<String, String?> results)? onSubmit;
   /// Left padding for form content
   final double leftPadding;
   /// Top padding for form content
   final double topPadding;
   /// Right padding for form content
   final double rightPadding;
   /// Bottom padding for form content
   final double bottomPadding;
   // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




 // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
 /// **Constructor for DynamicFormPage with required and optional parameters**
 /// 
 /// Creates a dynamic form page with the specified form objects and optional
 /// styling parameters. Padding values default to 0.0 if not specified.
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

/// **State class managing dynamic form logic, validation, and user interactions**
/// 
/// This class handles all the form functionality including field controllers,
/// validation, submission, and UI state management for the DynamicFormPage widget.
class DynamicFormPageState extends State<DynamicFormPage> {

   // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
   /// Map storing TextEditingController instances for each form field
   final Map<String, TextEditingController> _controllers = {};
   /// Map storing validation error messages for each form field
   final Map<String, String?> _errors = {};
   /// Reference to the currently focused text controller
   TextEditingController? currentlyFocusedController;
   // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%%%
   /// **Initializes form controllers and sets up initial values**
   /// 
   /// Creates TextEditingController instances for each form field and
   /// populates them with initial values if provided in FormObject configuration.
   @override
   void initState() {
       super.initState();

       // Create controllers for each form field with initial values
       for (var formObject in widget.formObjects) {
           _controllers[formObject.id] = TextEditingController(
               text: formObject.initialValue ?? '',
           );
       }
   }
   // %%%%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%%%
   /// **Cleans up resources by disposing all TextEditingController instances**
   /// 
   /// Properly disposes of all controllers to prevent memory leaks when
   /// the widget is removed from the widget tree.
   @override
   void dispose() {
       // Dispose all controllers to prevent memory leaks
       for (var controller in _controllers.values) {
           controller.dispose();
       }
       super.dispose();
   }
   // %%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%% SUBMIT FORM %%%%%%%%%%%%%%%%%%%%
   /// **Validates form data and executes submission callback if valid**
   /// 
   /// This method performs comprehensive form validation by checking required fields,
   /// collects all form data into a results map, and either displays error messages
   /// or calls the onSubmit callback with the collected data.
   /// 
   /// Process flow:
   /// 1. Clear previous error states
   /// 2. Validate all required fields
   /// 3. If validation fails, show error snackbar
   /// 4. If validation passes, call onSubmit callback and restore form
   void _submitForm () {     
       bool cancelProcess = false;
       Map<String, String?> results = {};
       
       // Clear previous errors
       setState(() {
           _errors.clear();
       });

       // Validate each form field
       for (var formObject in widget.formObjects) {
           String? text = _controllers[formObject.id]?.text;

           // Check required field validation
           if (formObject.isRequired && (text == null || text == "" || text.isEmpty)) {
               setState(() {
                   _errors[formObject.id] = "This field is required!";
               });
               cancelProcess = true;
           }
           results[formObject.id] = text;
       }

       // Handle validation results
       if (cancelProcess) {
           // Show error message for failed validation
           ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                   content: Text("Something went wrong. Please check again your form."),
               )
           );
       } else {
           // Submit form data and reset form
           widget.onSubmit?.call(results);
           _restore();
       }
   }
   // %%%%%%%%%%%%%%%%%% END - SUBMIT FORM %%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%%% CLEAR ALL %%%%%%%%%%%%%%%%%%%%%%
   /// **Restores form to initial state by clearing all fields and errors**
   /// 
   /// This method resets the entire form by clearing all text controllers
   /// and removing any validation error messages, returning the form to
   /// its pristine state.
   void _restore () {
       setState(() {
           // Clear all input field values
           for (var controller in _controllers.values) {
               controller.clear();
           }
           // Clear all validation errors
           _errors.clear();
       });
   }
   // %%%%%%%%%%%%%%%%%%% END - CLEAR ALL %%%%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%%%%% FIELD WIDGET %%%%%%%%%%%%%%%%%%%%%
   /// **Generates appropriate widget based on FormObject type**
   /// 
   /// This method creates and returns the appropriate Flutter widget for each
   /// form field type (text, number, dropdown, textarea, picker) with consistent
   /// styling and validation error handling.
   /// 
   /// Parameters:
   /// - formObject: The FormObject configuration to render
   /// 
   /// Returns:
   /// - Widget: The appropriate form field widget with styling and validation
   Widget _fieldWidget (FormObject formObject) {

       FocusNode focusNode = FocusNode();
       switch (formObject.type) {

           // oooooooooooooooooo TEXT FIELD oooooooooooooooooo
           case FormFieldType.text:
           case FormFieldType.number:
               return TextField(
                   controller: _controllers[formObject.id],
                   focusNode: focusNode,
                   onTap: () {currentlyFocusedController = _controllers[formObject.id];}, // Track focused field

                   decoration: InputDecoration(

                       // Dynamic label showing required/optional status
                       labelText: formObject.isRequired ? 
                           formObject.title : "${formObject.title} (optional)",

                       hintText: formObject.hint,

                       // Label styling
                       labelStyle: TextStyle(
                           fontSize: 13,
                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
                       ),
                       
                       // Hint text styling
                       hintStyle: TextStyle(
                           color: Theme.of(context).colorScheme.surfaceContainerHigh,
                       ),

                       // Default border styling
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                       ),
                           
                       // Enabled state border
                       enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                       ),

                       // Focused state border
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                       ),

                       // Error state border
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                       ),

                       // Focused error state border
                       focusedErrorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                       ),

                       // Display validation errors
                       errorText: _errors[formObject.id],
                   ),

                   // Set appropriate keyboard type
                   keyboardType: formObject.type == FormFieldType.text ?
                       TextInputType.text : TextInputType.number,
               );
           // oooooooooooooooooo END - TEXT FIELD oooooooooooooooooo


           // oooooooooooooooooo TEXT AREA oooooooooooooooooo
           case FormFieldType.textarea:
               return TextField(
                   controller: _controllers[formObject.id],
                   focusNode: focusNode,
                   onTap: () {currentlyFocusedController = _controllers[formObject.id];}, // Track focused field

                   decoration: InputDecoration(

                       // Dynamic label showing required/optional status
                       labelText: formObject.isRequired ? 
                       formObject.title : "${formObject.title} (optional)",
                       hintText: formObject.hint,
                       alignLabelWithHint: true, // Align label with multiline content

                       // Label styling
                       labelStyle: TextStyle(
                           fontSize: 13,
                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
                       ),
                       
                       // Hint text styling
                       hintStyle: TextStyle(
                           color: Theme.of(context).colorScheme.surfaceContainerHigh,
                       ),

                       // Default border styling
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                       ),
                           
                       // Enabled state border
                       enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                       ),

                       // Focused state border
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 2),
                       ),

                       // Error state border
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                       ),

                       // Focused error state border
                       focusedErrorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                       ),

                       // Display validation errors
                       errorText: _errors[formObject.id],
                   ),

                   // Multiline configuration for textarea
                   keyboardType: TextInputType.multiline,
                   minLines: 3,
                   maxLines: 5,

               );
           // oooooooooooooooooo END - TEXT AREA oooooooooooooooooo


           // oooooooooooooooooo DOPDOWN oooooooooooooooooo
           case FormFieldType.dropdown:
               return DropdownButtonFormField(
                   focusNode: focusNode,
                   onTap: () {currentlyFocusedController = _controllers[formObject.id];}, // Track focused field

                   decoration: InputDecoration(
                       labelText: formObject.title,

                       // Default border styling
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                       ),
                           
                       // Enabled state border
                       enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                       ),

                       // Focused state border
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                       ),

                       // Error state border
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                       ),

                       // Focused error state border
                       focusedErrorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                       ),

                       // Display validation errors
                       errorText: _errors[formObject.id],
                   ),

                   // Generate dropdown items from options
                   items: (formObject.options ?? []).map((option) => 
                       DropdownMenuItem(
                           value: option,
                           child: Text(option),
                       )
                   ).toList(), 

                   // Handle dropdown selection changes
                   onChanged: (value) {
                       if (value != null) {
                           setState(() {
                               _controllers[formObject.id]?.text = value;
                               _errors[formObject.id] = null; // Clear error when corrected
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
                   onTap: () {currentlyFocusedController = null;}, // Clear focus for picker

                   label: formObject.title,
                   isRequired: formObject.isRequired,

                   hintText: formObject.hint,
                   options: formObject.options ?? [],
                   initialValue: formObject.initialValue, 

                   errorText: _errors[formObject.id],

                   // Theme-based color configuration
                   foregroundColor: Theme.of(context).colorScheme.onSurface,
                   backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                   foregroundHighColor: Theme.of(context).colorScheme.surfaceContainerHighest,
               );

           // ooooooooooooooo END - PICKER ooooooooooooooooo
       }
   }
// %%%%%%%%%%%%%%%%%%%%% END - FIELD WIDGET %%%%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
   /// **Builds the complete dynamic form interface**
   /// 
   /// This method constructs the full form UI including all form fields,
   /// action buttons, and proper spacing. It uses responsive design principles
   /// with the widthFactor property to control field layouts.
   @override
   Widget build(BuildContext context) {

       return Scaffold(

           body: SingleChildScrollView(
               // Apply custom padding from widget properties
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
                       // Responsive form field layout
                       Wrap(
                           runSpacing: 20, // Vertical spacing between rows

                           children: widget.formObjects.map((formObject) {

                               // Calculate responsive width based on widthFactor
                               double fullWidth = MediaQuery.of(context).size.width;
                               double itemWidth = (fullWidth * formObject.widthFactor);

                               return SizedBox(
                                   width: itemWidth,
                                   child: _fieldWidget(formObject),
                               );
                           }).toList(),
                       ),
                       // °°°°°°°°°°°°°°°°° END - FILEDS °°°°°°°°°°°°°°°°°°°°°

                       const SizedBox(height: 30,), // Spacing before buttons

                       // °°°°°°°°°°°°°°°° EDIT AND DELETE BUTTONS °°°°°°°°°°°°°°°°°°°
                       Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           spacing: 20,
                           children: [

                               // =============== RESTORE BUTTON ===================
                               // Button to clear form and reset to initial state
                               Expanded(
                                   child: OutlinedButton(
                                       onPressed: _restore,

                                       style: OutlinedButton.styleFrom(
                                           side: BorderSide(
                                               color: Theme.of(context).colorScheme.primary,
                                           ),
                                           foregroundColor: Theme.of(context).colorScheme.primary,
                                           shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(30), // Rounded corners
                                           ),
                                           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                       ),

                                       child: Text('Restore'),
                                   ),
                               ),
                               // =============== END - RESTORE BUTTON ===================


                               // ========== SUBMIT BUTTON ===================
                               // Primary button to submit form data
                               Expanded(
                                   child: ElevatedButton(
                                       onPressed: _submitForm,

                                       style: ElevatedButton.styleFrom(
                                           backgroundColor: Theme.of(context).colorScheme.primary,
                                           foregroundColor: Theme.of(context).colorScheme.onPrimary, // White text on colored background
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(30), // Rounded corners
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
