import 'package:first_project/models/media.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewmodel.dart';
import 'package:get_it/get_it.dart';

class MediaListController {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;

    // VIEW MODEL
    final viewModel = GetIt.instance<MediaListViewModel>();
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% CONTRUCTOR %%%%%%%%%%%%%%%%%
    MediaListController(this.mediaType);
    // %%%%%%%%%%%%%%%%%%%%%% END - CONTRUCTOR %%%%%%%%%%%%%%%%%



    
    // %%%%%%%%%%%%%%%% GO TO ADD NEW MEDIA %%%%%%%%%%%%%%%%%%
    void goToAddNewMedia() {

    }
    // %%%%%%%%%%%%%%%% END - GO TO ADD NEW MEDIA %%%%%%%%%%%%%%%%%%
}