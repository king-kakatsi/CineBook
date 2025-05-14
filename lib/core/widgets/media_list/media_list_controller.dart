import 'package:first_project/core/widgets/display_alert.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/services/hive_service.dart';
import 'package:first_project/services/media_getter.dart';
import 'package:first_project/views/media_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MediaListController extends ChangeNotifier {
    
    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    List<Media> initialMediaList = [];
    List<Media> mediaList = [];
    List<String> sortButtons = ["Date", "Title", "Rate"];
    int _currentSortIndex = 0;

    /// Public property that contains the hive box name. 
    /// This is generally provided in the view where the controller is used.
    late String hiveBoxName;
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% INITIALIZE %%%%%%%%%%%%%%%%%%%
    void initialize () async {

        var mediaBox = Hive.box<Media>(hiveBoxName);
        initialMediaList = mediaBox.values.toList();

        mediaList = [...initialMediaList];
        
        mediaList.sort((media1, media2) => 
            media2.lastModificationDate.compareTo(media1.lastModificationDate)
        );

        for (var media in mediaList) {
            media.generateSearchFinder();
        }

        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%% END - INITIALIZE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% SEARCH %%%%%%%%%%%%%%%%%%%%
    void search (String value) {
        try{
            mediaList = initialMediaList
            .where((media) => 
                media.searchFinder.toLowerCase().contains(value.toLowerCase())
            )
            .toList();

            notifyListeners();
        }
        // ignore: empty_catches
        catch (e) {}  
    }
    // %%%%%%%%%%%%%%%%%%%% END - SEARCH %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% SORT LIST %%%%%%%%%%%%%%%%%
    void sortBy (int index, List<String> buttons) {
        
        if (buttons.isEmpty || index >= buttons.length) return;

        _currentSortIndex = index;
        var selectedSortOption = buttons[index].toLowerCase();

        // oooooooooooooooo SORT BY DATE oooooooooooooooooo
        if (selectedSortOption == "date") {

            mediaList.sort((media1, media2) => 
                media2.lastModificationDate.compareTo(media1.lastModificationDate)
            );
        }
        // oooooooooooooooo END - SORT BY DATE oooooooooooooooooo


        // oooooooooooooooo SORT BY TITLE oooooooooooooooooo
        if (selectedSortOption == "title") {

            mediaList.sort((media1, media2) => 
                media1.title.compareTo(media2.title)
            );
        }
        // oooooooooooooooo END - SORT BY TITLE oooooooooooooooooo


        // oooooooooooooooo SORT BY RATE ooooooooooooooooooooo
        if (selectedSortOption == "rate") {

            mediaList.sort((media1, media2) => 
                (media2.rate ?? 0).compareTo(media1.rate ?? 0)
            );
        }
        // oooooooooooooooo END - SORT BY RATE ooooooooooooooooooooo

        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SORT LIST %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% REVERSE LIST %%%%%%%%%%%%%%%%%%%
    void reverseList () {

        if (mediaList.isEmpty) return;

        mediaList = mediaList.reversed.toList();     
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - REVERSE LIST %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% EDIT MEDIA %%%%%%%%%%%%%%%%%%%%%%
    void goToEditMedia (BuildContext context, Media media) {
        Navigator.of(context).pushNamed(
            "/mediaEdit",
            arguments: {
                'title': media.mediaType == Mediatype.series ? 'Edit series' : 'Edit anime',

                'editPageAction': media.mediaType == Mediatype.series
                    ? EditPageAction.editSeries
                    : EditPageAction.editAnime,

                'media': media,
            },
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - EDIT MEDIA %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    void deleteInList (BuildContext context, Media media) async {
        
        var done = await HiveService.delete<Media>(
            hiveBoxName, 

            () => Alert.display(
                context, 
                "DELETE", 
                "Are you sure you want to delete this?", 
                approvalButtonText: "Yes",
                cancellationButtonText: "No",
                barrierDismissible: true,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer
            ), 

            media.uniqueId
        );

        if (done) {
            initialMediaList.removeWhere((media) => media.uniqueId == media.uniqueId);
            mediaList = [...initialMediaList];
            MediaGetter.deleteFromLocalDir(media.imagePath);
            notifyListeners();
        }  
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% DELETE MEDIA FROM DETAILS PAGE %%%%%%%%%%%%%%%%%%%%
    void deleteFromDetailsPage (BuildContext context, Media media) {
        
        deleteInList(context, media);
        Navigator.of(context).pop();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA FROM DETAILS PAGE %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    void addInList (Media media) async {

        var done = await HiveService.addOrUpdate(
            hiveBoxName, 
            media, 
            media.uniqueId
        );

        if (done) {
            initialMediaList.add(media);
            mediaList = [...initialMediaList];
            sortBy(_currentSortIndex, sortButtons); // notifyListeners() is in this method
            notifyListeners();
        }
        
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    void updateInList (Media media) async {

        var done = await HiveService.addOrUpdate(
            hiveBoxName, 
            media, 
            media.uniqueId
        );

        if (done) {
            int mediaIndex = initialMediaList.indexWhere((m) => m.uniqueId == media.uniqueId);
            if (mediaIndex != -1) initialMediaList[mediaIndex] = media;

            mediaList = [...initialMediaList];
            sortBy(_currentSortIndex, sortButtons); // notifyListeners() is in this method
            notifyListeners();
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%

  
}