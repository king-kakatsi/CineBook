import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// 𝐌𝐞𝐝𝐢𝐚𝐆𝐞𝐭𝐭𝐞𝐫 - 𝐀 𝐮𝐭𝐢𝐥𝐢𝐭𝐲 𝐜𝐥𝐚𝐬𝐬 𝐟𝐨𝐫 𝐢𝐦𝐚𝐠𝐞 𝐦𝐚𝐧𝐚𝐠𝐞𝐦𝐞𝐧𝐭 𝐨𝐩𝐞𝐫𝐚𝐭𝐢𝐨𝐧𝐬
///
/// This service class provides comprehensive image handling capabilities for the CineBook
/// application, including image acquisition from multiple sources, local storage management,
/// and file cleanup operations.
///
/// Key features:
/// - Image picking from device gallery or camera
/// - Image downloading from remote URLs
/// - Local storage with unique file naming using UUID
/// - File cleanup and deletion utilities
/// - Automatic temporary file management
/// - Error handling for all operations
///
/// All images are saved to the application's documents directory with unique identifiers
/// to prevent conflicts and ensure proper organization.
class MediaGetter {

    // %%%%%%%%%%%%%%%%%%% GET FROM DEVICE %%%%%%%%%%%%%%%%%%%
    /// 𝐏𝐢𝐜𝐤𝐬 𝐚𝐧 𝐢𝐦𝐚𝐠𝐞 𝐟𝐫𝐨𝐦 𝐭𝐡𝐞 𝐝𝐞𝐯𝐢𝐜𝐞 𝐚𝐧𝐝 𝐬𝐚𝐯𝐞𝐬 𝐢𝐭 𝐥𝐨𝐜𝐚𝐥𝐥𝐲.
    ///
    /// This method uses the device's native image picking interface to allow users
    /// to select an image from their gallery or take a new photo with the camera.
    /// The selected image is automatically saved to local storage with a unique filename.
    ///
    /// Parameters:
    /// - `source` : ImageSource specifying the image source (defaults to gallery)
    ///   - ImageSource.gallery: Pick from device photo gallery
    ///   - ImageSource.camera: Take a new photo with camera
    ///
    /// Returns:
    /// - `Future<String?>` : Local file path of the saved image, null if operation failed
    ///
    /// The method returns null if:
    /// - User cancels the image picker
    /// - Image saving operation fails
    /// - Any exception occurs during the process
    ///
    /// Example usage:
    /// ```dart
    /// // Pick from gallery
    /// String? imagePath = await MediaGetter.getImageFromDevice();
    /// 
    /// // Take photo with camera
    /// String? imagePath = await MediaGetter.getImageFromDevice(
    ///   source: ImageSource.camera
    /// );
    /// ```
    static Future<String?> getImageFromDevice({ImageSource source = ImageSource.gallery}) async {

        // Initialize image picker and get user selection
        final picker = ImagePicker();
        var pickedImage = await picker.pickImage(source: source);

        // Return null if user cancelled the picker
        if (pickedImage == null) return null;
        
        // Convert picked image to File and save locally
        var imageFile = File(pickedImage.path);
        return await saveInLocalAndReturnPath(imageFile);
    }
    // %%%%%%%%%%%%%%%%%%% END - GET FROM DEVICE %%%%%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%% FETCH FROM URL %%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐃𝐨𝐰𝐧𝐥𝐨𝐚𝐝𝐬 𝐚𝐧 𝐢𝐦𝐚𝐠𝐞 𝐟𝐫𝐨𝐦 𝐚 𝐫𝐞𝐦𝐨𝐭𝐞 𝐔𝐑𝐋 𝐚𝐧𝐝 𝐬𝐚𝐯𝐞𝐬 𝐢𝐭 𝐥𝐨𝐜𝐚𝐥𝐥𝐲.
    ///
    /// This method downloads an image from the provided URL, temporarily stores it,
    /// then saves it to the application's local storage with a unique filename.
    /// It handles HTTP requests, file operations, and cleanup of temporary files.
    ///
    /// Parameters:
    /// - `url` : String URL of the image to download
    ///
    /// Returns:
    /// - `Future<String?>` : Local file path of the saved image, null if operation failed
    ///
    /// The method performs these operations:
    /// 1. Makes HTTP GET request to the provided URL
    /// 2. Validates HTTP response status (must be 200)
    /// 3. Downloads image bytes and saves to temporary directory
    /// 4. Copies image to permanent local storage with unique filename
    /// 5. Cleans up temporary file
    ///
    /// Returns null if:
    /// - HTTP request fails or returns non-200 status
    /// - Network connectivity issues
    /// - Invalid URL format
    /// - File system operations fail
    ///
    /// Example usage:
    /// ```dart
    /// String? imagePath = await MediaGetter.fetchImageFromUrl(
    ///   'https://example.com/poster.jpg'
    /// );
    /// if (imagePath != null) {
    ///   // Image successfully downloaded and saved
    /// }
    /// ```
    static Future<String?> fetchImageFromUrl(String url) async {
        try {
            // Create HTTP client and make GET request
            final response = await HttpClient().getUrl(Uri.parse(url));
            final imageStream = await response.close();

            // Validate HTTP response status
            if (imageStream.statusCode != 200) return null;

            // Download image bytes
            final bytes = await consolidateHttpClientResponseBytes(imageStream);
            
            // Create temporary file for downloaded image
            final fileName = basename(url);
            final dir = await getTemporaryDirectory();
            final filePath = join(dir.path, 'temp_image', fileName);
            final imageFile = File(filePath);
            await imageFile.create(recursive: true);
            await imageFile.writeAsBytes(bytes);
            
            // Save to permanent local storage and cleanup temp file
            final savedPath = await saveInLocalAndReturnPath(imageFile);
            if (await imageFile.exists()) await imageFile.delete(); // Clean up temp file
            return savedPath;

        } catch (e) { 
            // Return null if any step in the download process fails
            return null;
        }  
    }
    // %%%%%%%%%%%%%%%% END - FETCH FROM URL %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% SAVE IN LOCAL AND RETURN PATH %%%%%%%%%%%%%%%%%%%
    /// 𝐒𝐚𝐯𝐞𝐬 𝐚𝐧 𝐢𝐦𝐚𝐠𝐞 𝐟𝐢𝐥𝐞 𝐭𝐨 𝐥𝐨𝐜𝐚𝐥 𝐬𝐭𝐨𝐫𝐚𝐠𝐞 𝐰𝐢𝐭𝐡 𝐚 𝐮𝐧𝐢𝐪𝐮𝐞 𝐟𝐢𝐥𝐞𝐧𝐚𝐦𝐞.
    ///
    /// This method copies an image file to the application's documents directory
    /// and generates a unique filename using UUID to prevent conflicts.
    /// It preserves the original file extension while ensuring uniqueness.
    ///
    /// Parameters:
    /// - `imageFile` : File object representing the source image to save
    ///
    /// Returns:
    /// - `Future<String?>` : Local file path of the saved image, null if operation failed
    ///
    /// The method performs these operations:
    /// 1. Gets the application's documents directory
    /// 2. Generates unique filename with pattern: 'img_{UUID}{original_extension}'
    /// 3. Copies the source file to the new location
    /// 4. Returns the full path of the saved file
    ///
    /// Filename format: `img_12345678-1234-1234-1234-123456789abc.jpg`
    /// - Prefix: 'img_' for easy identification
    /// - UUID: Universally unique identifier to prevent conflicts
    /// - Extension: Preserved from original file
    ///
    /// Returns null if:
    /// - File copy operation fails
    /// - Directory access issues
    /// - Insufficient storage space
    ///
    /// Example usage:
    /// ```dart
    /// File sourceImage = File('/path/to/image.jpg');
    /// String? savedPath = await MediaGetter.saveInLocalAndReturnPath(sourceImage);
    /// ```
    static Future<String?> saveInLocalAndReturnPath(File imageFile) async {

        try{
            // Get application documents directory for permanent storage
            final directory = await getApplicationDocumentsDirectory();
            
            // Generate unique filename preserving original extension
            final fileName = 'img_${Uuid().v4()}${extension(imageFile.path)}';
            final imagePath = join(directory.path, fileName);
            
            // Copy file to permanent location
            final image = await imageFile.copy(imagePath);
            return image.path;

        } catch (e) {
            // Return null if file operation fails
            return null;
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SAVE IN LOCAL AND RETURN PATH %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% DELETE FROM LOCAL %%%%%%%%%%%%%%%%%%%%%
    /// 𝐃𝐞𝐥𝐞𝐭𝐞𝐬 𝐚𝐧 𝐢𝐦𝐚𝐠𝐞 𝐟𝐢𝐥𝐞 𝐟𝐫𝐨𝐦 𝐥𝐨𝐜𝐚𝐥 𝐬𝐭𝐨𝐫𝐚𝐠𝐞.
    ///
    /// This method removes an image file from the local file system using the
    /// provided file path. It's commonly used for cleanup operations when
    /// media items are removed from the application.
    ///
    /// Parameters:
    /// - `filePath` : String path to the image file to delete
    ///
    /// Returns:
    /// - `Future<bool>` : true if deletion succeeded, false if operation failed
    ///
    /// The method performs these operations:
    /// 1. Creates a File object from the provided path
    /// 2. Attempts to delete the file from the file system
    /// 3. Returns success status
    ///
    /// Returns false if:
    /// - File doesn't exist at the specified path
    /// - Permission issues prevent deletion
    /// - File is currently in use by another process
    /// - Any file system error occurs
    ///
    /// This method is typically called when:
    /// - Media items are deleted from the database
    /// - Cleanup operations during app maintenance
    /// - Replacing existing images with new ones
    ///
    /// Example usage:
    /// ```dart
    /// bool deleted = await MediaGetter.deleteFromLocalDir(
    ///   '/path/to/img_12345678-1234-1234-1234-123456789abc.jpg'
    /// );
    /// if (deleted) {
    ///   // File successfully removed
    /// }
    /// ```
    static Future<bool> deleteFromLocalDir (String filePath) async {

        try{
            // Create File object and attempt deletion
            final imageFile = File(filePath);
            await imageFile.delete(); 
            return true;

        } catch (e) {
            // Return false if deletion fails for any reason
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - DELETE FROM LOCAL %%%%%%%%%%%%%%%%%%%%%
}