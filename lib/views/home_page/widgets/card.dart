import 'package:first_project/core/themes/color_palette.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

// $$$$$$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$

class MediaCard extends StatefulWidget {

    // %%%%%%%%%%%%%%% PORPERTIES %%%%%%%%%%%%%%%%%
    final Media media;
    // %%%%%%%%%%%%%%% END - PORPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaCard({
        
        super.key, 
        required this.media
    });
    // %%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%

    


    // %%%%%%%%%%%%%%%% STATE %%%%%%%%%%%%%%%%%%
    @override
    State<MediaCard> createState() => MediaCardState();
    // %%%%%%%%%%%%%%%% END - STATE %%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$$$$$ END - STATEFUL $$$$$$$$$$$$$$$$$$$$$$





// $$$$$$$$$$$$$$$$$$ CARD STATE $$$$$$$$$$$$$$$$$$$$
class MediaCardState extends State<MediaCard> {

    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% MODIFY CLICKED %%%%%%%%%%%%%%%%%
    void onModify() {

    }
    // %%%%%%%%%%%%%%%%%%% END - MODIFY CLICKED %%%%%%%%%%%%%%%%%
    
    
    
    
    // %%%%%%%%%%%%%%%%%%% DELETE CLICKED %%%%%%%%%%%%%%%%%
    void onDelete() {

    }
    // %%%%%%%%%%%%%%%%%%% END - DELETE CLICKED %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @ override
    Widget build(BuildContext context) {
    
    
        return Card(
            child: Padding(

                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(

                    children: [

                        // oooooooooooo IMAGE oooooooooooooooo
                        Image.network(
                            widget.media.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image, 
                                size: 80
                            ),
                        ),
                        // oooooooooooo END - IMAGE oooooooooooooooo

                        
                        // oooooooooooooo TITLE ooooooooooooooooooo
                        Text(
                            widget.media.title,  
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // oooooooooooooo END - TITLE ooooooooooooooooooo


                        SizedBox(height: 10),


                        // oooooooooooooo DESCRIPTION ooooooooooooooooooo
                        Text(
                            widget.media.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,

                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                        ),
                        // oooooooooooooo END - DESCRIPTION ooooooooooooooooooo


                        // %%%%%%%%%%%%%%%%% BUTTONS %%%%%%%%%%%%%%% 
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                                // oooooooooooooo MODIFY oooooooooooooo 
                                IconButton(
                                        onPressed: onModify, 
                                        icon: Icon(Icons.edit)
                                    ),
                                // oooooooooooooo END - MODIFY oooooooooooooo 


                                // oooooooooooooo DELETE oooooooooooooo 
                                IconButton(
                                        onPressed: onDelete, 
                                        icon: Icon(Icons.delete),
                                        color: AppColors.deepVineRed,
                                    ),
                                // oooooooooooooo END - DELETE oooooooooooooo 

                            ],
                        )
                        // %%%%%%%%%%%%%%%%% END - BUTTONS %%%%%%%%%%%%%%% 
                    ], 
                ),
            )
        );
    }
    // %%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$ END - CARD STATE $$$$$$$$$$$$$$$$$$$$
