import 'package:first_project/core/widgets/display_alert.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MediaListViewModel extends ChangeNotifier {
    
    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    List<Media> initialMediaList = [];
    List<Media> mediaList = [];
    List<String> sortButtons = ["Date", "Title", "Rate"];
    int _currentSortIndex = 0;
    late String hiveBoxName;
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% INITIALIZE %%%%%%%%%%%%%%%%%%%
    void initialize () async {

        var mediaBox = await Hive.openBox<Media>(hiveBoxName);
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




    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    void deleteInList (BuildContext context, String mediaId) async {
        var result = await Alert.display(

            context, 
            "DELETE", 
            "Are you sure you want to delete this?", 
            approvalButtonText: "Yes",
            cancellationButtonText: "No",
            barrierDismissible: true,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer
        );

        if (result == null || !result) return;

        var mediaBox = await Hive.openBox<Media>(hiveBoxName);
        mediaBox.delete(mediaId);

        initialMediaList.removeWhere((media) => media.uniqueId == mediaId);
        mediaList = [...initialMediaList];
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    void addInList (Media media) async {

        var mediaBox = await Hive.openBox<Media>(hiveBoxName);
        await mediaBox.put(media.uniqueId, media);

        initialMediaList.add(media);
        mediaList = [...initialMediaList];
        sortBy(_currentSortIndex, sortButtons); // notifyListeners() is in this method
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%

  
}