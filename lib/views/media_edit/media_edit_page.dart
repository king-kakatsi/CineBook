import 'package:first_project/core/widgets/dynamic_form.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewmodel.dart';
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
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        _initialValues = {
            'title': widget.media?.title,
            'description': widget.media?.description,
            'imageUrl': widget.media?.imageUrl,
            'rate': widget.media?.rate.toString(),
            'numberOfSeasons': widget.media?.numberOfSeasons.toString(),
            'currentSeasonIndex': widget.media?.currentSeasonIndex.toString(),
            'currentEpisodeIndex': widget.media?.currentEpisodeIndex.toString(),
            'mediaType': widget.media?.mediaType.name,
        };


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
                id: 'description',
                title: 'Description',
                hint: 'Enter the media description',
                type: FormFieldType.textarea,
                widthFactor: 1.0,
                initialValue: _initialValues['description'],
                isRequired: true,
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
                hint: 'Enter the rate (0-10)',
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

        try{

            final viewModel = GetIt.instance<MediaListViewModel>();

            if (widget.media == null) {
                // Create new media
                final newMedia = Media(
                    mediaType: mediaType,
                    title: results['title'] ?? '',
                );
                // Set optional fields if available
                newMedia.uniqueId = Uuid().v4();
                newMedia.currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "");
                newMedia.currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '');
                newMedia.description = results['description'] ?? '';
                newMedia.rate = double.tryParse(results['rate'] ?? '');
                newMedia.imageUrl = results['imageUrl'] ?? '';
                newMedia.creationDate = DateTime.now();
                newMedia.lastModificationDate = DateTime.now();
                newMedia.generateSearchFinder();
                
                viewModel.addInList(newMedia);

            } else {
                // Modify existing media
                widget.media!
                    ..title = results['title'] ?? widget.media!.title
                    ..description = results['description'] ?? widget.media!.description
                    ..imageUrl = results['imageUrl'] ?? widget.media!.imageUrl
                    ..rate = double.tryParse(results['rate'] ?? '')
                    ..currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "")
                    ..currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '')
                    ..mediaType = mediaType;
                
                widget.media!.lastModificationDate = DateTime.now();

                widget.media!.generateSearchFinder();
                viewModel.addInList(widget.media!);
            }

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Successfully done"),
                )
            );


        } catch (e) {
            // final context = navigatorKey.currentContext;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Something went wrong. Try again later"),
                )
            );

        }

        // pop here
        // Navigator.of(context).pop();
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

                    child: DynamicFormPage(
                        formObjects: _formObjects,
                        onSubmit: _handleSubmit,
                    ),
                ) 
                // ooooooooooooooo END - BODY ooooooooooooooooooo
            )
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@