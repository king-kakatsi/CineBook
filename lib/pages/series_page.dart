import 'package:first_project/shared_ui/media_list_widget.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@@@@@ STATEFULL @@@@@@@@@@@@@@@@@@@@@@@@@@@@
/// **Series Page Widget for displaying TV series catalog**
///
/// A StatelessWidget that represents the series section of the application.
/// This page is part of a tabbed interface (alongside AnimePage) that composes the HomePage.
/// Unlike AnimePage, this widget doesn't contain hardcoded sample data and relies entirely
/// on the MediaListWidget to manage and display series content from persistent storage.
///
/// The widget serves as a lightweight wrapper around MediaListWidget, configured
/// specifically for TV series content management. All series data is handled through
/// the Hive database via the MediaListWidget's internal logic.
///
/// This page handles:
/// - Display of user's personal TV series catalog
/// - Integration with persistent storage (Hive)
/// - Series-specific UI configuration
// ignore: must_be_immutable
class SeriesPage extends StatelessWidget{


    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    const SeriesPage({super.key});
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%



    
    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return MediaListWidget(
            context: context,
            mediaType: Mediatype.series, 
            pageTitle: "Series",
            hiveBoxName: Mediatype.series.name,
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@