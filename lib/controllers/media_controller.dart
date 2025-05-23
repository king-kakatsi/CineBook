import 'dart:io';

import 'package:first_project/widgets/display_alert.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/services/hive_service.dart';
import 'package:first_project/services/media_getter.dart';
import 'package:first_project/pages/media_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaController extends ChangeNotifier {
    
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
    Future<void> initialize ({
        VoidCallback? playAnimation,
        VoidCallback? stopAnimation,
    }) async {

        if (playAnimation != null) playAnimation();

        initialMediaList = Hive.box<Media>(hiveBoxName).values.toList();
        mediaList = [...initialMediaList];
        
        mediaList.sort((media1, media2) => 
            media2.lastModificationDate.compareTo(media1.lastModificationDate)
        );

        for (var media in mediaList) {
            media.generateSearchFinder();
        }
        notifyListeners();

        if (stopAnimation != null) {
            await Future.delayed(Duration(seconds: 1));
            stopAnimation();
        }
    }
    // %%%%%%%%%%%%%%%%%% END - INITIALIZE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CHECK FIRST RUN STATUS %%%%%%%%%%%%%%%
    /// Returns true if this is the first run of the application since installation.
    /// Otherwise, it returns false 
    Future<bool> hasAlreadyLaunched() async {
        final prefs = await SharedPreferences.getInstance();
        final hasAlreadyLaunched = prefs.getBool('alreadyLaunched') ?? false;

        if (!hasAlreadyLaunched) await prefs.setBool('alreadyLaunched', true);
        return hasAlreadyLaunched;
    }
    // %%%%%%%%%%%%%%%%% END - CHECK FIRST RUN STATUS %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% EXPORT BACKUP %%%%%%%%%%%%%%%%%%%
    Future<void> exportBackup (
        BuildContext context,
        VoidCallback playAnimation,
        VoidCallback stopAnimation,
    ) async {

        playAnimation(); 
        for (var mediaType in Mediatype.values) {

            var done = await HiveService.exportBackupToFile<Media>(
                null, 
                mediaType.name, 
                (media) => media.toJson()
            );

            if (done) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text("${mediaType.name} backup Successfully exported"),
                        duration: Duration(seconds: 2),
                    ),
                );
                await Future.delayed(Duration(seconds: 3));

            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Operation failed. Try again later."),
                        duration: Duration(seconds: 2),
                    ),
                );
                await Future.delayed(Duration(seconds: 3));
            }
        }
        stopAnimation();
    }
    // %%%%%%%%%%%%%%%%%%%% END - EXPORT BACKUP %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%
    Future<void> importBackup (
        BuildContext context,
        VoidCallback playAnimation,
        VoidCallback stopAnimation,
    ) async {

        playAnimation();
            for (var mediaType in Mediatype.values) {

                var done = await HiveService.importBackupFromFile<Media>(
                    null,
                    (json) => Media.fromJson(json), 
                    (media) => media.uniqueId, 
                    Mediatype.series.name,
                );

                if (done) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("${mediaType.name} backup Successfully imported"),
                            duration: Duration(seconds: 2),
                        ),
                    );
                    await Future.delayed(Duration(seconds: 3));

                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Operation failed. Try again later."),
                            duration: Duration(seconds: 2),
                        ),
                    );
                    await Future.delayed(Duration(seconds: 3));
                }
            }
            stopAnimation();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% IMPORT BACKUP WHEN APP HAS JUST LAUNCHED %%%%%%%%%%%%%%%%%
    Future<void> tryImportBackupAndInitialize (
        BuildContext context,
        VoidCallback playAnimation,
        VoidCallback stopAnimation,
        {bool checkIsFirstLaunch = true}
    ) async {

        if (checkIsFirstLaunch && !await hasAlreadyLaunched()) {

            var response = await Alert.display(
                context, 
                "Check & Import Backup", 
                "Do you want us to check if there's a backup and import it?", 
                approvalButtonText: "Yes",
                cancellationButtonText: "No",
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer
            );

            if (response == null || !response) return;
            
            await importBackup(
                context, 
                playAnimation, 
                stopAnimation
            );
        } else if (!checkIsFirstLaunch) {
            await importBackup(
                context, 
                playAnimation, 
                stopAnimation
            );
        }

        initialize();
    }
    // %%%%%%%%%%%%%%%% END - IMPORT BACKUP WHEN APP HAS JUST LAUNCHED %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% RELOAD MEDIA IMAGES %%%%%%%%%%%%%%%%%%%%%
    Future<void> reloadMediaImages () async {

        final tempMediaList = [...initialMediaList];
        final thisBoxName = hiveBoxName;

        for (var media in tempMediaList) {
            if (media.imageUrl != '' && media.imageUrl.isNotEmpty){
                bool reload = true;

                try {
                    final file = File(media.imagePath);
                    reload = !await file.exists();

                } catch (_) {}

                if (reload) {
                    final tempPath = await MediaGetter.fetchImageFromUrl(media.imageUrl);
                    media.imagePath = tempPath ?? '';
                    await updateInList(media, boxName: thisBoxName);
                }
            }
        }
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%% END - RELOAD MEDIA IMAGES %%%%%%%%%%%%%%%%%%%%%




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
    Future<bool> deleteInList (BuildContext context, Media media) async {
        
        var isDeleted = await HiveService.delete<Media>(
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

        if (isDeleted) {
            initialMediaList.removeWhere((m) => m.uniqueId == media.uniqueId);
            mediaList = [...initialMediaList];
            MediaGetter.deleteFromLocalDir(media.imagePath);
            notifyListeners();
        }  

        return isDeleted;
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% DELETE MEDIA FROM DETAILS PAGE %%%%%%%%%%%%%%%%%%%%
    void deleteFromDetailsPage (BuildContext context, Media media) async {
        
        bool isDeleted = await deleteInList(context, media);
        if (isDeleted) Navigator.of(context).pop();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA FROM DETAILS PAGE %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    Future<bool> addInList (Media media) async {

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
        return done;
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    Future<bool> updateInList (Media media, {String boxName = 'undefined'}) async {

        if (boxName == 'undefined') boxName = hiveBoxName;
        var done = await HiveService.addOrUpdate(
            boxName, 
            media, 
            media.uniqueId
        );

        if (done) {
            int mediaIndex = initialMediaList.indexWhere((m) => m.uniqueId == media.uniqueId);

            if (mediaIndex != -1) {
                initialMediaList[mediaIndex] = media;  
                mediaList = [...initialMediaList];
                sortBy(_currentSortIndex, sortButtons); // notifyListeners() is in this method
            } 
        }  
        return done; 
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%

  
}