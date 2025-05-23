import 'package:first_project/extensions/enum_extensions.dart';
import 'package:first_project/widgets/dynamic_form.dart';
import 'package:first_project/widgets/lottie_animator.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:first_project/services/media_getter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';


enum EditPageAction {
    createSeries,
    editSeries,

    createAnime,
    editAnime,
}



// @@@@@@@@@@@@ STATEFUL @@@@@@@@@@@@@@@@

class MediaEditPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    final String title;
    final EditPageAction editPageAction;
    final Media? media;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%

    const MediaEditPage({
        super.key,
        required this.title,
        required this.editPageAction,
        this.media,
    });

    // %%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<MediaEditPage> createState() => MediaEditPageState();
    // %%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@ END - STATEFUL @@@@@@@@@@@@@@@@






// @@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@
class MediaEditPageState extends State<MediaEditPage> {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    late final List<FormObject> _formObjects;
    late final Map<String, String?> _initialValues;
    final LottieAnimator _lottieAnimator = LottieAnimator();
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        _initialValues = {
            'mediaType': widget.media?.mediaType.name,
            'title': widget.media?.title,
            'description': widget.media?.description,
            'imageUrl': widget.media?.imageUrl,
            'rate': widget.media?.rate.toString(),
            'currentSeasonIndex': widget.media?.currentSeasonIndex.toString(),
            'currentEpisodeIndex': widget.media?.currentEpisodeIndex.toString(),
        };

        if (widget.media != null && widget.media!.mediaGenre != null) _initialValues['mediaGenre'] = widget.media!.mediaGenre!.formattedName;

        if (widget.media != null && widget.media!.watchStatus != null) _initialValues['watchStatus'] = widget.media!.watchStatus!.formattedName;
        


        _formObjects = [
            FormObject(
                id: 'title',
                title: 'Title',
                hint: 'Enter the media title',
                type: FormFieldType.text,
                widthFactor: 1.0,
                initialValue: _initialValues['title'],
                isRequired: true,
            ),
            FormObject(
                id: 'mediaGenre',
                title: 'Genre',
                hint: 'Select the genre',
                type: FormFieldType.picker,
                options: MediaGenre.values.map((val) => val.formattedName).toList(),
                widthFactor: 1.0,
                initialValue: _initialValues['mediaGenre'],
                isRequired: false,
            ),
            FormObject(
                id: 'description',
                title: 'Description',
                hint: 'Enter the media description',
                type: FormFieldType.textarea,
                widthFactor: 1.0,
                initialValue: _initialValues['description'],
                isRequired: true,
            ),
            FormObject(
                id: 'watchStatus',
                title: 'Watch Status',
                hint: 'Select the watch status',
                type: FormFieldType.picker,
                options: WatchStatus.values.map((val) => val.formattedName).toList(),
                widthFactor: 1.0,
                initialValue: _initialValues['watchStatus'],
                isRequired: false,
            ),
            FormObject(
                id: 'imageUrl',
                title: 'Image URL',
                hint: 'Enter the image URL',
                type: FormFieldType.text,
                widthFactor: 1.0,
                initialValue: _initialValues['imageUrl'],
                isRequired: false,
            ),
            FormObject(
                id: 'rate',
                title: 'Rate',
                hint: 'Enter the rate (0-5)',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['rate'],
                isRequired: false,
            ),
            FormObject(
                id: 'currentSeasonIndex',
                title: 'Current Season',
                hint: 'Season you are currently on',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['currentSeasonIndex'],
                isRequired: false,
            ),
            FormObject(
                id: 'currentEpisodeIndex',
                title: 'Current Episode',
                hint: 'Episode you are currently on',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['currentEpisodeIndex'],
                isRequired: false,
            ),
        ];
    }
    // %%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% HANDLE SUBMIT %%%%%%%%%%%%%%%%%%%%
    void _handleSubmit (Map<String, String?> results) async {

        // Play await Anim
        _lottieAnimator.play();

        // °°°°°°°°°°°°°°° INIT MEDIA TYPE °°°°°°°°°°°°°°°
        Mediatype mediaType;
        switch (widget.editPageAction) {
            case EditPageAction.createSeries:
            case EditPageAction.editSeries:
                mediaType = Mediatype.series;
                break;
            case EditPageAction.createAnime:
            case EditPageAction.editAnime:
                mediaType = Mediatype.anime;
                break;
        }
        // °°°°°°°°°°°°°°° END - INIT MEDIA TYPE °°°°°°°°°°°°°°°

        bool done = true;
        try{

            final mediaController = GetIt.instance<MediaController>();

            if (widget.media == null) {
                // °°°°°°°°°°°°°°° CREATE NEW MEDIA °°°°°°°°°°°°°°°° 
                final newMedia = Media(
                    mediaType: mediaType,
                    title: results['title'] ?? '',
                );
                // Set optional fields if available
                newMedia.uniqueId = Uuid().v4();
                newMedia.currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "");
                newMedia.currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '');


                newMedia.mediaGenre = enumFromFormatted<MediaGenre>(MediaGenre.values, results['mediaGenre'] ?? '');
                newMedia.watchStatus = enumFromFormatted<WatchStatus>(WatchStatus.values, results['watchStatus'] ?? '');

                newMedia.description = results['description'] ?? '';
                newMedia.rate = double.tryParse(results['rate'] ?? '');

                // ============ FETCH THE IMAGE ================
                newMedia.imageUrl = results['imageUrl'] ?? '';
                newMedia.imagePath = '';
                if (newMedia.imageUrl != '' && newMedia.imageUrl.isNotEmpty){
                    final tempPath = await MediaGetter.fetchImageFromUrl(newMedia.imageUrl);
                    newMedia.imagePath = tempPath ?? '';
                }
                // ============ END - FETCH THE IMAGE ================

                newMedia.creationDate = DateTime.now();
                newMedia.lastModificationDate = DateTime.now();
                newMedia.generateSearchFinder();
                
                done = await mediaController.addInList(newMedia);

                // °°°°°°°°°°°°°°° END - CREATE NEW MEDIA °°°°°°°°°°°°°°°° 

            } else {
                // °°°°°°°°°°°°°° MODIFY EXISTING MEDIA °°°°°°°°°°°°°°°°°°
                final prevUrl = widget.media!.imageUrl;
                final prevPath = widget.media!.imagePath;
                widget.media!
                    ..title = results['title'] ?? widget.media!.title
                    ..description = results['description'] ?? widget.media!.description
                    ..imageUrl = results['imageUrl'] ?? widget.media!.imageUrl
                    ..rate = double.tryParse(results['rate'] ?? '')

                    ..currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "")
                    ..currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '')

                    ..mediaGenre = enumFromFormatted<MediaGenre>(MediaGenre.values, results['mediaGenre'] ?? '')
                    ..watchStatus = enumFromFormatted<WatchStatus>(WatchStatus.values, results['watchStatus'] ?? '')

                    ..mediaType = mediaType;
                
                widget.media!.lastModificationDate = DateTime.now();

                // ============ FETCH THE IMAGE ================
                widget.media!.imageUrl = results['imageUrl'] ?? '';
                if (prevUrl != widget.media!.imageUrl){

                    if (widget.media!.imageUrl != '' && widget.media!.imageUrl.isNotEmpty) {
                        final tempPath = await MediaGetter.fetchImageFromUrl(widget.media!.imageUrl);
                        widget.media!.imagePath = tempPath ?? '';
                    }
                    MediaGetter.deleteFromLocalDir(prevPath);
                }
                // ============ END - FETCH THE IMAGE ================

                widget.media!.generateSearchFinder();
                done = await mediaController.updateInList(widget.media!);
                // °°°°°°°°°°°°°° END - MODIFY EXISTING MEDIA °°°°°°°°°°°°°°°°°°
            }

        } catch (e) {
            done = false;
        }

        // Stop await Anim
        await Future.delayed(Duration(seconds: 1));
        _lottieAnimator.stop();

        if (done) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Successfully done"),
                )
            );
            await Future.delayed(Duration(seconds: 1));
            Navigator.of(context).pop();

        } else {
            // final context = navigatorKey.currentContext;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Something went wrong. Try again later"),
                )
            );
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - HANDLE SUBMIT %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),

            child: Scaffold(

                // ooooooooooooo APP BAR ooooooooooooooooo
                appBar: AppBar(
                    title: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    leading: IconButton(
                        onPressed: () => Navigator.pop(context), 
                        icon: Icon(Icons.arrow_back_ios_new),
                    ),
                ),
                // ooooooooooooo END - APP BAR ooooooooooooooooo


                // ooooooooooooooo BODY ooooooooooooooooooo
                body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),

                    child: _lottieAnimator.builder(
                        lottieFilePath: "assets/lottie/loading_anim.json",  
                        backgroundColor: Theme.of(context).colorScheme.onSurface, 
                        width: 100, 
                        height: 100,

                        child: DynamicFormPage(
                            formObjects: _formObjects,
                            onSubmit: _handleSubmit,
                        ),
                    ),
                         
                ) 
                // ooooooooooooooo END - BODY ooooooooooooooooooo
            )
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@