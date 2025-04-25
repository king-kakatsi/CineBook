import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

class MediaListViewModel extends ChangeNotifier {
    
    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    List<Media> mediaList = [];
    List<String> sortButtons = ["Title", "Date", "Rate"];
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% SORT LIST %%%%%%%%%%%%%%%%%
    void sortBy (int index, List<String> buttons) {
        
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SORT LIST %%%%%%%%%%%%%%%%%

  
}