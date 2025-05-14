

import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaGetter {

    // %%%%%%%%%%%%%%%%%%% GET FROM DEVICE %%%%%%%%%%%%%%%%%%%
    static Future<String?> getImageFromDevice({ImageSource source = ImageSource.gallery}) async {

        final picker = ImagePicker();
        var pickedImage = await picker.pickImage(source: source);

        if (pickedImage == null) return null;
        var imageFile = File(pickedImage.path);
        return await saveInLocalAndReturnPath(imageFile);
    }
    // %%%%%%%%%%%%%%%%%%% END - GET FROM DEVICE %%%%%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%% FETCH FROM URL %%%%%%%%%%%%%%%%%%%%%%%
    static Future<String?> fetchImageFromUrl(String url) async {
        try {
            final response = await HttpClient().getUrl(Uri.parse(url));
            final imageStream = await response.close();

            if (imageStream.statusCode != 200) return null;

            final bytes = await consolidateHttpClientResponseBytes(imageStream);
            final fileName = basename(url);
            final dir = await getTemporaryDirectory();
            final filePath = join(dir.path, 'temp_image', fileName);
            final imageFile = File(filePath);
            await imageFile.create(recursive: true);
            await imageFile.writeAsBytes(bytes);
            
            final savedPath = await saveInLocalAndReturnPath(imageFile);
            if (await imageFile.exists()) await imageFile.delete(); // Clean up temp file
            return savedPath;

        } catch (e) { 
            return null;
        }  
    }
    // %%%%%%%%%%%%%%%% END - FETCH FROM URL %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% SAVE IN LOCAL AND RETURN PATH %%%%%%%%%%%%%%%%%%%
    static Future<String?> saveInLocalAndReturnPath(File imageFile) async {

        try{
            final directory = await getApplicationDocumentsDirectory();
            final fileName = 'img_${Uuid().v4()}${extension(imageFile.path)}';
            final imagePath = join(directory.path, fileName);
            final image = await imageFile.copy(imagePath);
            return image.path;

        } catch (e) {
            return null;
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SAVE IN LOCAL AND RETURN PATH %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% DELETE FROM LOCAL %%%%%%%%%%%%%%%%%%%%%
    static Future<bool> deleteFromLocalDir (String filePath) async {

        try{
            final imageFile = File(filePath);
            await imageFile.delete(); 
            return true;

        } catch (e) {
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - DELETE FROM LOCAL %%%%%%%%%%%%%%%%%%%%%
}