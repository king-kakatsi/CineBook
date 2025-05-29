import 'dart:io';

import 'package:first_project/widgets/display_alert.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/services/hive_service.dart';
import 'package:first_project/services/media_getter.dart';
import 'package:first_project/pages/media_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';




/// 𝐌𝐞𝐝𝐢𝐚𝐂𝐨𝐧𝐭𝐫𝐨𝐥𝐥𝐞𝐫 𝐜𝐥𝐚𝐬𝐬
///
/// This class extends [ChangeNotifier] and acts as the main controller
/// for managing a list of [Media] objects in the app.
/// 
/// It handles loading media data from Hive, searching, sorting, adding,
/// updating, deleting media, and backing up/restoring data.
/// 
/// It also supports controlling UI animations during data operations
/// and notifying listeners about state changes.
///
/// 𝐊𝐞𝐲 𝐅𝐞𝐚𝐭𝐮𝐫𝐞𝐬:
/// - Initialization of media list from Hive storage.
/// - Sorting media by date, title or rating.
/// - Searching media based on a custom searchable string.
/// - Backup export/import functionality using HiveService.
/// - Managing first run detection via SharedPreferences.
/// - Updating local cached images when missing.
/// - Navigation helper for editing media entries.
/// - Async operations with UI feedback support via callbacks.
///
/// 𝐔𝐬𝐚𝐠𝐞:
/// Assign the Hive box name before calling initialize(), then
/// use the controller's methods to manipulate media data.
/// The controller notifies its listeners on data changes to update UI.
///
/// 𝐍𝐨𝐭𝐞:
/// This controller depends on external services like HiveService,
/// MediaGetter, and UI widgets such as Alert dialogs.
///
/// Example:
/// ```dart
/// final mediaController = MediaController();
/// mediaController.hiveBoxName = 'mediaBox';
/// await mediaController.initialize();
/// ```
///
/// Listeners can then observe mediaController.mediaList for changes.
class MediaController extends ChangeNotifier {
    
    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%

/// 𝐈𝐧𝐢𝐭𝐢𝐚𝐥 𝐥𝐢𝐬𝐭 𝐨𝐟 𝐌𝐞𝐝𝐢𝐚 𝐨𝐛𝐣𝐞𝐜𝐭𝐬
///
/// This list stores the original media items as loaded from Hive at
/// initialization. It remains unchanged by sorting or filtering,
/// allowing to always restore the initial state if needed.
List<Media> initialMediaList = [];

/// 𝐂𝐮𝐫𝐫𝐞𝐧𝐭 𝐥𝐢𝐬𝐭 𝐨𝐟 𝐌𝐞𝐝𝐢𝐚 𝐭𝐡𝐚𝐭 𝐦𝐚𝐲 𝐛𝐞 𝐬𝐨𝐫𝐭𝐞𝐝 𝐨𝐫 𝐟𝐢𝐥𝐭𝐞𝐫𝐞𝐝
///
/// This list is the active one bound to the UI. It reflects current
/// filters, sorting or search results applied by the user.
List<Media> mediaList = [];

/// 𝐋𝐢𝐬𝐭 𝐨𝐟 𝐬𝐨𝐫𝐭 𝐛𝐮𝐭𝐭𝐨𝐧 𝐥𝐚𝐛𝐞𝐥𝐬
///
/// Defines the sorting criteria available in the UI.
/// The controller uses the current sort index to determine which
/// sorting method to apply on mediaList.
List<String> sortButtons = ["Date", "Title", "Rate"];

/// 𝐂𝐮𝐫𝐫𝐞𝐧𝐭 𝐬𝐨𝐫𝐭 𝐜𝐫𝐢𝐭𝐞𝐫𝐢𝐨 𝐢𝐧𝐝𝐞𝐱
///
/// This private integer stores the index of the currently active sort
/// in the sortButtons list. Used internally to track and toggle sorting.
int _currentSortIndex = 0;

/// 𝐇𝐢𝐯𝐞 𝐛𝐨𝐱 𝐧𝐚𝐦𝐞
///
/// This late-initialized property holds the Hive box name string
/// that identifies the local database container for media objects.
/// It must be set externally before calling initialize or any operation
/// accessing Hive.
///
/// Usually provided by the UI or dependency injection when the controller
/// is created.
late String hiveBoxName;

// %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% INITIALIZE %%%%%%%%%%%%%%%%%%%
    /// 𝐈𝐧𝐢𝐭𝐢𝐚𝐥𝐢𝐳𝐞 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐥𝐢𝐬𝐭𝐬 𝐟𝐫𝐨𝐦 𝐇i𝐯𝐞 𝐝𝐚𝐭𝐚𝐛𝐚𝐬𝐞.
    ///
    /// This asynchronous method loads all `Media` objects from the Hive box
    /// specified by the `hiveBoxName`. It initializes both `initialMediaList`
    /// and `mediaList` with this data.
    ///
    /// It also sorts `mediaList` by `lastModificationDate` in descending order,
    /// so the most recently modified media appear first.
    ///
    /// Then, for each media object, it calls `generateSearchFinder()` which is
    /// assumed to prepare or update search indexing or caching for efficient
    /// searching.
    ///
    /// After updating the lists, it calls `notifyListeners()` to update any
    /// UI or listeners bound to the controller.
    ///
    /// Optional parameters:
    /// - `playAnimation`: a callback invoked at the start, for example to start
    ///   a loading spinner or animation.
    /// - `stopAnimation`: a callback invoked after loading and a 1 second delay,
    ///   to stop the animation.
    ///
    /// Example usage:
    /// ```dart
    /// await controller.initialize(
    ///   playAnimation: () => startLoadingAnimation(),
    ///   stopAnimation: () => stopLoadingAnimation(),
    /// );
    /// ```
    Future<void> initialize ({
        VoidCallback? playAnimation,
        VoidCallback? stopAnimation,
    }) async {
        if (playAnimation != null) playAnimation();

        // Load all media objects from the Hive box and copy them into lists
        initialMediaList = Hive.box<Media>(hiveBoxName).values.toList();
        mediaList = [...initialMediaList];

        // Sort mediaList by lastModificationDate descending (latest first)
        mediaList.sort((media1, media2) =>
            media2.lastModificationDate.compareTo(media1.lastModificationDate)
        );

        // Prepare search indexing on each media object
        for (var media in mediaList) {
            media.generateSearchFinder();
        }

        // Notify UI listeners about data update
        notifyListeners();

        // If a stopAnimation callback is provided, wait 1 second then call it
        if (stopAnimation != null) {
            await Future.delayed(Duration(seconds: 1));
            stopAnimation();
        }
    }
    // %%%%%%%%%%%%%%%%%% END - INITIALIZE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CHECK FIRST RUN STATUS %%%%%%%%%%%%%%%
    /// 𝐂𝐡𝐞𝐜𝐤𝐬 𝐢𝐟 𝐭𝐡𝐞 𝐚𝐩𝐩 𝐡𝐚𝐬 𝐛𝐞𝐞𝐧 𝐥𝐚𝐮𝐧𝐜𝐡𝐞𝐝 𝐛𝐞𝐟𝐨𝐫𝐞.
    ///
    /// This asynchronous method uses `SharedPreferences` to determine if the
    /// application has already been launched at least once since installation.
    ///
    /// It reads a boolean value stored under the key `'alreadyLaunched'`.
    /// - If the key does not exist (first launch), it returns `false` and
    ///   sets `'alreadyLaunched'` to `true` for future calls.
    ///
    /// - If the key exists and is `true`, it returns `true`, indicating
    ///   the app has been launched before.
    ///
    /// This method is useful to display onboarding screens or setup flows
    /// only on the very first run of the app.
    ///
    /// Example usage:
    /// ```dart
    /// bool firstRun = !(await controller.hasAlreadyLaunched());
    /// if (firstRun) {
    ///   showOnboarding();
    /// }
    /// ```
    Future<bool> hasAlreadyLaunched() async {
        final prefs = await SharedPreferences.getInstance();
        final hasAlreadyLaunched = prefs.getBool('alreadyLaunched') ?? false;

        if (!hasAlreadyLaunched) await prefs.setBool('alreadyLaunched', true);
        return hasAlreadyLaunched;
    }
    // %%%%%%%%%%%%%%%%% END - CHECK FIRST RUN STATUS %%%%%%%%%%%%%%%





    // %%%%%%%%%%%%%%%%%%%% EXPORT BACKUP %%%%%%%%%%%%%%%%%%%
    /// 𝐄𝐱𝐩𝐨𝐫𝐭𝐬 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐝𝐚𝐭𝐚 𝐛𝐚𝐜𝐤𝐮𝐩 𝐭𝐨 𝐟𝐢𝐥𝐞𝐬 𝐟𝐨𝐫 𝐞𝐚𝐜𝐡 𝐦𝐞𝐝𝐢𝐚 𝐭𝐲𝐩𝐞.
    ///
    /// This asynchronous method exports backup files for every media type defined
    /// in the `Mediatype` enum, using the generic `HiveService.exportBackupToFile` method.
    ///
    /// It requires:
    /// - a `BuildContext` to show feedback messages using `ScaffoldMessenger`
    /// - two `VoidCallback` parameters, `playAnimation` and `stopAnimation`, to
    ///   handle UI animation states during the export process.
    ///
    /// For each media type:
    /// 1. Calls the export method to save the data to file, converting each media item to JSON.
    /// 2. Shows a success or failure `SnackBar` accordingly.
    /// 3. Waits a few seconds between each backup to let the user read the message.
    ///
    /// Finally, it stops the animation after processing all media types.
    ///
    /// Example usage:
    /// ```dart
    /// await controller.exportBackup(
    ///   context,
    ///   () => setState(() => isLoading = true),
    ///   () => setState(() => isLoading = false),
    /// );
    /// ```
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
    /// 𝐈𝐦𝐩𝐨𝐫𝐭𝐬 𝐦𝐞𝐝𝐢𝐚 𝐝𝐚𝐭𝐚 𝐟𝐫𝐨𝐦 𝐛𝐚𝐜𝐤𝐮𝐩 𝐟𝐢𝐥𝐞𝐬 𝐟𝐨𝐫 𝐞𝐚𝐜𝐡 𝐦𝐞𝐝𝐢𝐚 𝐭𝐲𝐩𝐞.
    ///
    /// This asynchronous method imports media data from backup files for every
    /// media type defined in the `Mediatype` enum, using the generic
    /// `HiveService.importBackupFromFile` method.
    ///
    /// It requires:
    /// - a `BuildContext` to display user feedback messages via `ScaffoldMessenger`.
    /// - two `VoidCallback` parameters, `playAnimation` and `stopAnimation`, to
    ///   handle UI animation states during the import process.
    ///
    /// For each media type:
    /// 1. Calls the import method, which:
    ///    - Parses each JSON object into a `Media` instance via `Media.fromJson`.
    ///    - Uses `media.uniqueId` as the unique identifier to avoid duplicates.
    ///    - Currently always uses the `Mediatype.series.name` as a fixed media type parameter
    ///      (this may need correction if you want dynamic media types).
    /// 2. Displays a success or failure `SnackBar`.
    /// 3. Waits a few seconds to allow the user to read the message.
    ///
    /// Finally, it stops the animation after processing all media types.
    ///
    /// Example usage:
    /// ```dart
    /// await controller.importBackup(
    ///   context,
    ///   () => setState(() => isLoading = true),
    ///   () => setState(() => isLoading = false),
    /// );
    /// ```
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
                mediaType.name, 
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
    /// 𝐓𝐫𝐢𝐞𝐬 𝐭𝐨 𝐢𝐦𝐩𝐨𝐫𝐭 𝐚 𝐛𝐚𝐜𝐤𝐮𝐩 𝐚𝐧𝐝 𝐢𝐧𝐢𝐭𝐢𝐚𝐥𝐢𝐳𝐞𝐬 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐝𝐚𝐭𝐚.
    ///
    /// This asynchronous method is designed to be called right after the app launches.
    /// It attempts to check if this is the first app launch (unless `checkIsFirstLaunch` is false),
    /// then optionally asks the user if they want to import a backup, performs the import if agreed,
    /// and finally initializes the media data.
    ///
    /// Parameters:
    /// - [context]: The `BuildContext` used to display UI elements like dialogs and snack bars.
    /// - [playAnimation]: A callback triggered to start a loading or transition animation.
    /// - [stopAnimation]: A callback triggered to stop the animation.
    /// - [checkIsFirstLaunch] (optional, default: true): If true, the method checks whether
    ///   this is the app’s first launch and only then prompts for backup import.
    ///
    /// Behavior:
    /// - If `checkIsFirstLaunch` is true and the app has never been launched before,
    ///   it shows a confirmation dialog to the user via `Alert.display`.
    /// - If the user agrees, it calls `importBackup`.
    /// - If `checkIsFirstLaunch` is false, it imports backup without prompting.
    /// - Regardless of the above, it calls `initialize()` at the end to load the media data.
    ///
    /// Example usage:
    /// ```dart
    /// await controller.tryImportBackupAndInitialize(
    ///   context,
    ///   () => setState(() => isLoading = true),
    ///   () => setState(() => isLoading = false),
    /// );
    /// ```
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
    /// 𝐑𝐞𝐥𝐨𝐚𝐝𝐬 𝐥𝐨𝐜𝐚𝐥𝐥𝐲 𝐬𝐭𝐨𝐫𝐞𝐝 𝐦𝐞𝐝𝐢𝐚 𝐢𝐦𝐚𝐠𝐞𝐬 𝐟𝐫𝐨𝐦 𝐭𝐡𝐞𝐢𝐫 𝐨𝐧𝐥𝐢𝐧𝐞 𝐮𝐫𝐥𝐬.
    ///
    /// This asynchronous method refreshes the local cached images for all media in the `initialMediaList`.
    /// For each media item, if it has a non-empty `imageUrl`, the method checks whether the local image
    /// file (pointed to by `imagePath`) still exists:
    /// - If the file does not exist or an error occurs during check, it downloads the image again using
    ///   `MediaGetter.fetchImageFromUrl`.
    /// - The media's `imagePath` is then updated and saved back to Hive via `updateInList`.
    ///
    /// At the end of the process, it calls `notifyListeners()` to update any UI observers.
    ///
    /// Usage example:
    /// ```dart
    /// await controller.reloadMediaImages();
    /// ```
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
    /// 𝐅𝐢𝐥𝐭𝐞𝐫𝐬 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐥𝐢𝐬𝐭 𝐛𝐚𝐬𝐞𝐝 𝐨𝐧 𝐚 𝐬𝐞𝐚𝐫𝐜𝐡 𝐭𝐞𝐫𝐦.
    ///
    /// This method performs a case-insensitive search on the media items' `searchFinder` field,
    /// which should be a preprocessed string representing searchable content of the media (e.g., title, tags).
    ///
    /// It updates `mediaList` to only contain media whose `searchFinder` contains the `value` string.
    ///
    /// After updating, it calls `notifyListeners()` to refresh any UI observers.
    ///
    /// Usage example:
    /// ```dart
    /// controller.search("Naruto");
    /// ```
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
    /// 𝐒𝐨𝐫𝐭𝐬 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐥𝐢𝐬𝐭 𝐛𝐚𝐬𝐞𝐝 𝐨𝐧 𝐚 𝐬𝐞𝐥𝐞𝐜𝐭𝐞𝐝 𝐜𝐫𝐢𝐭𝐞𝐫𝐢𝐨𝐧.
    ///
    /// Takes an integer `index` representing the selected sort option's position
    /// in the provided `buttons` list, which contains the names of the sort criteria.
    ///
    /// The sort criteria supported are:
    /// - "Date" : sorts the list descending by `lastModificationDate`
    /// - "Title" : sorts alphabetically ascending by `title`
    /// - "Rate" : sorts descending by `rate` (if `rate` is null, considered as 0)
    ///
    /// If the `index` is invalid or buttons list is empty, the method returns without doing anything.
    ///
    /// After sorting, `notifyListeners()` is called to update UI observers.
    ///
    /// Example usage:
    /// ```dart
    /// controller.sortBy(1, ["Date", "Title", "Rate"]);
    /// ```
    void sortBy (int index, List<String> buttons) {
        
        if (buttons.isEmpty || index >= buttons.length) return;

        _currentSortIndex = index;
        var selectedSortOption = buttons[index].toLowerCase();

        // Sort by Date descending
        if (selectedSortOption == "date") {
            mediaList.sort((media1, media2) => 
                media2.lastModificationDate.compareTo(media1.lastModificationDate)
            );
        }

        // Sort by Title ascending
        if (selectedSortOption == "title") {
            mediaList.sort((media1, media2) => 
                media1.title.compareTo(media2.title)
            );
        }

        // Sort by Rate descending
        if (selectedSortOption == "rate") {
            mediaList.sort((media1, media2) => 
                (media2.rate ?? 0).compareTo(media1.rate ?? 0)
            );
        }

        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SORT LIST %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% REVERSE LIST %%%%%%%%%%%%%%%%%%%
    /// 𝐑𝐞𝐯𝐞𝐫𝐬𝐞𝐬 𝐭𝐡𝐞 𝐨𝐫𝐝𝐞𝐫 𝐨𝐟 𝐭𝐡𝐞 𝐜𝐮𝐫𝐫𝐞𝐧𝐭 𝐦𝐞𝐝𝐢𝐚 𝐥𝐢𝐬𝐭.
    ///
    /// If the list `mediaList` is empty, the method does nothing.
    ///
    /// After reversing the list order, it calls `notifyListeners()` to inform UI observers of the change.
    ///
    /// Example usage:
    /// ```dart
    /// controller.reverseList();
    /// ```
    void reverseList () {

        if (mediaList.isEmpty) return;

        mediaList = mediaList.reversed.toList();     
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - REVERSE LIST %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% EDIT MEDIA %%%%%%%%%%%%%%%%%%%%%%
    /// 𝐍𝐚𝐯𝐢𝐠𝐚𝐭𝐞𝐬 𝐭𝐨 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐞𝐝𝐢𝐭 𝐩𝐚𝐠𝐞.
    ///
    /// Opens the route "/mediaEdit" passing necessary arguments to identify
    /// whether it’s a series or anime and providing the `media` object to edit.
    ///
    /// Parameters:
    /// - `context` : BuildContext used by Navigator to push a new route.
    /// - `media` : The Media object to be edited.
    ///
    /// The method chooses the title and edit action based on the media type.
    ///
    /// Example usage:
    /// ```dart
    /// controller.goToEditMedia(context, selectedMedia);
    /// ```
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
    /// 𝐃𝐞𝐥𝐞𝐭𝐞𝐬 𝐚 𝐦𝐞𝐝𝐢𝐚 𝐢𝐭𝐞𝐦 𝐟𝐫𝐨𝐦 𝐡𝐢𝐯𝐞 𝐚𝐧𝐝 𝐮𝐩𝐝𝐚𝐭𝐞𝐬 𝐭𝐡𝐞 𝐥𝐢𝐬𝐭.
    ///
    /// This method first prompts the user with a confirmation alert dialog.
    /// If the user approves, it deletes the media item with the specified uniqueId from the Hive box.
    ///
    /// Parameters:
    /// - `context` : BuildContext to show the confirmation dialog and display UI updates.
    /// - `media` : The Media object to be deleted.
    ///
    /// Returns:
    /// - `Future<bool>` : true if deletion succeeded, false otherwise.
    ///
    /// Upon successful deletion, the media is removed from `initialMediaList` and `mediaList`,
    /// the associated local image file is deleted from storage,
    /// and `notifyListeners()` is called to update UI.
    ///
    /// Example usage:
    /// ```dart
    /// bool success = await controller.deleteInList(context, mediaToDelete);
    /// if(success) {
    ///   // update UI or notify user
    /// }
    /// ```
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
    /// 𝐃𝐞𝐥𝐞𝐭𝐞𝐬 𝐚 𝐦𝐞𝐝𝐢𝐚 𝐟𝐫𝐨𝐦 𝐭𝐡𝐞 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 𝐩𝐚𝐠𝐞 𝐚𝐧𝐝 𝐧𝐚𝐯𝐢𝐠𝐚𝐭𝐞𝐬 𝐛𝐚𝐜𝐤.
    ///
    /// Calls `deleteInList` to delete the media object.
    /// If deletion is successful, it pops the current page (usually the details page)
    /// to return to the previous screen.
    ///
    /// Parameters:
    /// - `context` : BuildContext to handle navigation and dialog display.
    /// - `media` : The Media object to be deleted.
    ///
    /// Usage example:
    /// ```dart
    /// controller.deleteFromDetailsPage(context, selectedMedia);
    /// ```
    void deleteFromDetailsPage (BuildContext context, Media media) async {
        
        bool isDeleted = await deleteInList(context, media);
        if (isDeleted) Navigator.of(context).pop();
    }
    // %%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA FROM DETAILS PAGE %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// 𝐀𝐝𝐝𝐬 𝐚 𝐦𝐞𝐝𝐢𝐚 𝐨𝐛𝐣𝐞𝐜𝐭 𝐭𝐨 𝐡𝐢𝐯𝐞 𝐚𝐧𝐝 𝐮𝐩𝐝𝐚𝐭𝐞𝐬 𝐭𝐡𝐞 𝐥𝐢𝐬𝐭.
    ///
    /// This method adds or updates a `Media` object in the Hive box.
    /// On success, the media is appended to `initialMediaList`, 
    /// the visible `mediaList` is updated and sorted according to the current sort index.
    ///
    /// Parameters:
    /// - `media` : The Media object to add or update.
    ///
    /// Returns:
    /// - `Future<bool>` : true if the operation succeeded, false otherwise.
    ///
    /// Notes:
    /// - `sortBy` method includes a `notifyListeners()` call,
    ///   but an additional `notifyListeners()` is also triggered here 
    ///   to ensure UI refresh.
    ///
    /// Usage example:
    /// ```dart
    /// bool success = await controller.addInList(newMedia);
    /// if(success) {
    ///   // UI will update automatically
    /// }
    /// ```
    Future<bool> addInList (Media media) async {

        var done = await HiveService.addOrUpdate(
            hiveBoxName, 
            media, 
            media.uniqueId
        );

        if (done) {
            initialMediaList.add(media);
            mediaList = [...initialMediaList];
            sortBy(_currentSortIndex, sortButtons); // notifyListeners() is inside sortBy
            notifyListeners();
        }
        return done;
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// 𝐔𝐩𝐝𝐚𝐭𝐞𝐬 𝐚 𝐦𝐞𝐝𝐢𝐚 𝐨𝐛𝐣𝐞𝐜𝐭 𝐢𝐧 𝐭𝐡𝐞 𝐋𝐢𝐬𝐭 𝐚𝐧𝐝 𝐢𝐧 𝐭𝐡𝐞 𝐇𝐢𝐯𝐞 𝐝𝐚𝐭𝐚𝐛𝐚𝐬𝐞.
    ///
    /// This method updates an existing `Media` object in the Hive box identified by `boxName` 
    /// and also updates the corresponding item in `initialMediaList`.
    /// After updating the list, it refreshes the filtered `mediaList` and applies the current sorting.
    ///
    /// Parameters:
    /// - `media`: The updated `Media` object to replace the existing one.
    /// - `boxName`: Optional, the Hive box name to update the media in.
    ///   If not provided, it defaults to the controller's `hiveBoxName`.
    ///
    /// Returns:
    /// - `Future<bool>` : true if the update succeeded, false otherwise.
    ///
    /// Behavior:
    /// - If the media exists in `initialMediaList` (matched by `uniqueId`), it is replaced by the new one.
    /// - The visible `mediaList` is reset to the full updated list.
    /// - Sorting is reapplied using the current sorting index (`_currentSortIndex`).
    /// - `notifyListeners()` is called within `sortBy()` to update the UI.
    ///
    /// Usage example:
    /// ```dart
    /// bool updated = await controller.updateInList(updatedMedia);
    /// if(updated) {
    ///   // UI is refreshed automatically
    /// }
    /// ```
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
                sortBy(_currentSortIndex, sortButtons); // notifyListeners() is inside sortBy()
            } 
        }  
        return done; 
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - UPDATE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
  
}