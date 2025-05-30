import 'package:first_project/themes/color_palette.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

// @@@@@@@@@@@@@@@@@@@@@@$ STATEFUL @@@@@@@@@@@@@@@@@@@@@@

/// 𝐌𝐞𝐝𝐢𝐚 𝐜𝐚𝐫𝐝 𝐰𝐢𝐝𝐠𝐞𝐭 𝐟𝐨𝐫 𝐝𝐢𝐬𝐩𝐥𝐚𝐲𝐢𝐧𝐠 𝐦𝐞𝐝𝐢𝐚 𝐢𝐧𝐟𝐨𝐫𝐦𝐚𝐭𝐢𝐨𝐧 𝐢𝐧 𝐂𝐢𝐧𝐞𝐛𝐨𝐨𝐤.
///
/// This stateful widget creates a visually appealing card that displays
/// media information including image, title, description, and action buttons.
/// Used throughout the app to present series and anime information in a
/// consistent and interactive format.
///
/// Features:
/// - Network image display with error handling
/// - Title and description text display
/// - Edit and delete action buttons
/// - Responsive layout with proper spacing
/// - Material Design Card styling
class MediaCard extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐓𝐡𝐞 𝐌𝐞𝐝𝐢𝐚 𝐨𝐛𝐣𝐞𝐜𝐭 𝐜𝐨𝐧𝐭𝐚𝐢𝐧𝐢𝐧𝐠 𝐚𝐥𝐥 𝐢𝐧𝐟𝐨𝐫𝐦𝐚𝐭𝐢𝐨𝐧 𝐭𝐨 𝐝𝐢𝐬𝐩𝐥𝐚𝐲.
    final Media media;
    
    /// 𝐂𝐚𝐥𝐥𝐛𝐚𝐜𝐤 𝐞𝐱𝐞𝐜𝐮𝐭𝐞𝐝 𝐰𝐡𝐞𝐧 𝐮𝐬𝐞𝐫 𝐭𝐚𝐩𝐬 𝐭𝐡𝐞 𝐞𝐝𝐢𝐭 𝐛𝐮𝐭𝐭𝐨𝐧.
    final VoidCallback? onEdit;
    
    /// 𝐂𝐚𝐥𝐥𝐛𝐚𝐜𝐤 𝐞𝐱𝐞𝐜𝐮𝐭𝐞𝐝 𝐰𝐡𝐞𝐧 𝐮𝐬𝐞𝐫 𝐭𝐚𝐩𝐬 𝐭𝐡𝐞 𝐝𝐞𝐥𝐞𝐭𝐞 𝐛𝐮𝐭𝐭𝐨𝐧.
    final VoidCallback? onDelete;
    // %%%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐂𝐨𝐧𝐬𝐭𝐫𝐮𝐜𝐭𝐨𝐫 𝐟𝐨𝐫 𝐜𝐫𝐞𝐚𝐭𝐢𝐧𝐠 𝐚 𝐌𝐞𝐝𝐢𝐚𝐂𝐚𝐫𝐝 𝐰𝐢𝐝𝐠𝐞𝐭.
    ///
    /// Parameters:
    /// - `key` : Optional widget key for identification
    /// - `media` : Required Media object containing display information
    /// - `onEdit` : Optional callback for edit button tap
    /// - `onDelete` : Optional callback for delete button tap
    ///
    /// Example usage:
    /// ```dart
    /// MediaCard(
    ///   media: myMediaObject,
    ///   onEdit: () => editMedia(myMediaObject),
    ///   onDelete: () => deleteMedia(myMediaObject),
    /// )
    /// ```
    const MediaCard({
        
        super.key, 
        required this.media,
        this.onEdit,
        this.onDelete,
    });
    // %%%%%%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%%%%

    


    // %%%%%%%%%%%%%%%%%%%%%%%% STATE %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐂𝐫𝐞𝐚𝐭𝐞𝐬 𝐚𝐧𝐝 𝐫𝐞𝐭𝐮𝐫𝐧𝐬 𝐭𝐡𝐞 𝐦𝐮𝐭𝐚𝐛𝐥𝐞 𝐬𝐭𝐚𝐭𝐞 𝐟𝐨𝐫 𝐭𝐡𝐢𝐬 𝐰𝐢𝐝𝐠𝐞𝐭.
    @override
    State<MediaCard> createState() => MediaCardState();
    // %%%%%%%%%%%%%%%%%%%%%%%% END - STATE %%%%%%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@@@$ END - STATEFUL @@@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ CARD STATE @@@@@@@@@@@@@@@@@@@@

/// 𝐒𝐭𝐚𝐭𝐞 𝐜𝐥𝐚𝐬𝐬 𝐟𝐨𝐫 𝐌𝐞𝐝𝐢𝐚𝐂𝐚𝐫𝐝 𝐡𝐚𝐧𝐝𝐥𝐢𝐧𝐠 𝐮𝐬𝐞𝐫 𝐢𝐧𝐭𝐞𝐫𝐚𝐜𝐭𝐢𝐨𝐧𝐬 𝐚𝐧𝐝 𝐔𝐈 𝐫𝐞𝐧𝐝𝐞𝐫𝐢𝐧𝐠.
///
/// This state class manages the MediaCard widget's lifecycle and user interactions.
/// Currently contains placeholder methods for modify and delete actions that can
/// be extended with specific functionality as needed.
class MediaCardState extends State<MediaCard> {

    // %%%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%
    // Reserved for future state properties if needed
    // %%%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% MODIFY CLICKED %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐇𝐚𝐧𝐝𝐥𝐞𝐬 𝐦𝐨𝐝𝐢𝐟𝐲/𝐞𝐝𝐢𝐭 𝐛𝐮𝐭𝐭𝐨𝐧 𝐜𝐥𝐢𝐜𝐤 𝐞𝐯𝐞𝐧𝐭.
    ///
    /// Currently a placeholder method that can be extended to handle
    /// internal modify logic before calling the parent's onEdit callback.
    /// Can be used for validation, state changes, or analytics tracking.
    ///
    /// Example usage within this class:
    /// ```dart
    /// void onModify() {
    ///   // Add validation or state changes here
    ///   widget.onEdit?.call();
    /// }
    /// ```
    void onModify() {
        // TODO: Add modify logic here if needed
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - MODIFY CLICKED %%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE CLICKED %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐇𝐚𝐧𝐝𝐥𝐞𝐬 𝐝𝐞𝐥𝐞𝐭𝐞 𝐛𝐮𝐭𝐭𝐨𝐧 𝐜𝐥𝐢𝐜𝐤 𝐞𝐯𝐞𝐧𝐭.
    ///
    /// Currently a placeholder method that can be extended to handle
    /// internal delete logic before calling the parent's onDelete callback.
    /// Can be used for confirmation dialogs, state cleanup, or logging.
    ///
    /// Example usage within this class:
    /// ```dart
    /// void onDelete() {
    ///   // Add confirmation or cleanup logic here
    ///   widget.onDelete?.call();
    /// }
    /// ```
    void onDelete() {
        // TODO: Add delete logic here if needed
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE CLICKED %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐁𝐮𝐢𝐥𝐝𝐬 𝐚𝐧𝐝 𝐫𝐞𝐭𝐮𝐫𝐧𝐬 𝐭𝐡𝐞 𝐌𝐞𝐝𝐢𝐚𝐂𝐚𝐫𝐝 𝐔𝐈 𝐰𝐢𝐝𝐠𝐞𝐭.
    ///
    /// Creates a Material Design card with:
    /// - Network image with error handling (120px height)
    /// - Media title using theme's titleLarge style
    /// - Description text (max 3 lines with ellipsis)
    /// - Action buttons (edit and delete) aligned to the right
    ///
    /// The card uses symmetric padding (15px horizontal, 10px vertical)
    /// and proper spacing between elements for optimal visual hierarchy.
    ///
    /// Returns:
    /// - `Widget` : A fully constructed Card widget with media information
    @ override
    Widget build(BuildContext context) {
    
    
        return Card(
            child: Padding(

                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(

                    children: [

                        // oooooooooooooooooo IMAGE oooooooooooooooooo
                        // Network image display with rounded corners and error fallback
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                widget.media.imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                // Show broken image icon if network image fails to load
                                errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.broken_image, 
                                    size: 80
                                ),
                            ),
                        ),
                        // oooooooooooooooooo END - IMAGE oooooooooooooooooo


                        SizedBox(height: 10,),
                        
                        // oooooooooooooooooo TITLE oooooooooooooooooo
                        // Media title using theme's large title style
                        Text(
                            widget.media.title,  
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // oooooooooooooooooo END - TITLE oooooooooooooooooo


                        SizedBox(height: 10),


                        // oooooooooooooooooo DESCRIPTION oooooooooooooooooo
                        // Description text with 3-line limit and ellipsis overflow
                        Text(
                            widget.media.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,

                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                        ),
                        // oooooooooooooooooo END - DESCRIPTION oooooooooooooooooo


                        // %%%%%%%%%%%%%%%%%%%%%%%% BUTTONS %%%%%%%%%%%%%%%%%%%%%%%% 
                        // Action buttons row aligned to the right
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                                // oooooooooooooooooo MODIFY oooooooooooooooooo 
                                // Edit button with standard edit icon
                                IconButton(
                                    onPressed: widget.onEdit, 
                                    icon: Icon(Icons.edit)
                                ),
                                // oooooooooooooooooo END - MODIFY oooooooooooooooooo 


                                // oooooooooooooooooo DELETE oooooooooooooooooo 
                                // Delete button with custom red color from app palette
                                IconButton(
                                    onPressed: widget.onDelete, 
                                    icon: Icon(Icons.delete),
                                    color: AppColors.deepVineRed,
                                ),
                                // oooooooooooooooooo END - DELETE oooooooooooooooooo 

                            ],
                        )
                        // %%%%%%%%%%%%%%%%%%%%%%%% END - BUTTONS %%%%%%%%%%%%%%%%%%%%%%%% 
                    ], 
                ),
            )
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - CARD STATE @@@@@@@@@@@@@@@@@@@@