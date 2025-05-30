import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

/// 𝐇𝐢𝐯𝐞𝐒𝐞𝐫𝐯𝐢𝐜𝐞 - 𝐀 𝐬𝐞𝐫𝐯𝐢𝐜𝐞 𝐜𝐥𝐚𝐬𝐬 𝐟𝐨𝐫 𝐦𝐚𝐧𝐚𝐠𝐢𝐧𝐠 𝐇𝐢𝐯𝐞 𝐝𝐚𝐭𝐚𝐛𝐚𝐬𝐞 𝐨𝐩𝐞𝐫𝐚𝐭𝐢𝐨𝐧𝐬
///
/// This utility class provides static methods for common Hive database operations
/// including CRUD operations, backup import/export functionality, and data persistence.
/// It handles error management and provides a consistent interface for database interactions
/// across the CineBook application.
///
/// Key features:
/// - Generic type support for flexible data handling
/// - Confirmation dialogs for delete operations
/// - Backup import/export with file system operations
/// - Permission handling for external storage access
class HiveService {

    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// 𝐃𝐞𝐥𝐞𝐭𝐞𝐬 𝐚𝐧 𝐢𝐭𝐞𝐦 𝐟𝐫𝐨𝐦 𝐚 𝐇𝐢𝐯𝐞 𝐛𝐨𝐱 𝐰𝐢𝐭𝐡 𝐮𝐬𝐞𝐫 𝐜𝐨𝐧𝐟𝐢𝐫𝐦𝐚𝐭𝐢𝐨𝐧.
    ///
    /// This method first executes the provided confirmation function to get user approval
    /// before proceeding with the deletion. If confirmed, it removes the item from the
    /// specified Hive box using the provided item ID.
    ///
    /// Parameters:
    /// - `hiveBoxName` : String name of the Hive box containing the item
    /// - `askConfirmation` : Function that returns a Future<bool?> for user confirmation
    /// - `itemId` : String unique identifier of the item to delete
    ///
    /// Returns:
    /// - `Future<bool>` : true if deletion succeeded, false if cancelled or failed
    ///
    /// The method returns false if:
    /// - User cancels the confirmation dialog (result is null or false)
    /// - An exception occurs during the deletion process
    ///
    /// Example usage:
    /// ```dart
    /// bool deleted = await HiveService.delete<Media>(
    ///   'mediaBox',
    ///   () => showConfirmDialog(),
    ///   'unique_media_id'
    /// );
    /// ```
    static Future<bool> delete<T> (
            String hiveBoxName, 
            Future<bool?> Function() askConfirmation, 
            String itemId
        ) async {

        bool? result;
        try{
            // Get user confirmation before proceeding with deletion
            result = await askConfirmation();
            if (result == null || !result) return false;

            // Open the Hive box and delete the item
            var itemBox = Hive.box<T>(hiveBoxName);
            itemBox.delete(itemId);
            return true;

        } catch (e) {
            // Return false if any exception occurs during deletion
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// 𝐀𝐝𝐝𝐬 𝐨𝐫 𝐮𝐩𝐝𝐚𝐭𝐞𝐬 𝐚𝐧 𝐢𝐭𝐞𝐦 𝐢𝐧 𝐚 𝐇𝐢𝐯𝐞 𝐛𝐨𝐱.
    ///
    /// This method performs an upsert operation, either adding a new item or updating
    /// an existing one in the specified Hive box. The operation is identified by the
    /// provided itemId parameter.
    ///
    /// Parameters:
    /// - `hiveBoxName` : String name of the Hive box to store the item
    /// - `item` : Generic type T representing the item to store
    /// - `itemId` : String? unique identifier for the item (can be null for auto-generation)
    ///
    /// Returns:
    /// - `Future<bool>` : true if the operation succeeded, false if an error occurred
    ///
    /// The method handles all exceptions gracefully and returns false if any error
    /// occurs during the storage process.
    ///
    /// Example usage:
    /// ```dart
    /// bool success = await HiveService.addOrUpdate<Media>(
    ///   'mediaBox',
    ///   mediaObject,
    ///   'unique_media_id'
    /// );
    /// ```
    static Future<bool> addOrUpdate<T> (
        String hiveBoxName, 
        T item, 
        String? itemId
    ) async {

        try {
            // Open the Hive box and store the item
            var itemBox = Hive.box<T>(hiveBoxName);
            await itemBox.put(itemId, item); 
            return true;

        } catch (e) {
            // Return false if storage operation fails
            return false;
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%%%
    /// 𝐈𝐦𝐩𝐨𝐫𝐭𝐬 𝐚 𝐛𝐚𝐜𝐤𝐮𝐩 𝐟𝐢𝐥𝐞 𝐚𝐧𝐝 𝐫𝐞𝐬𝐭𝐨𝐫𝐞𝐬 𝐝𝐚𝐭𝐚 𝐭𝐨 𝐚 𝐇𝐢𝐯𝐞 𝐛𝐨𝐱.
    ///
    /// This method reads a JSON backup file and restores its contents to the specified
    /// Hive box. It handles external storage permissions, file validation, and data
    /// transformation from JSON to the target data model.
    ///
    /// Parameters:
    /// - `backupFilePath` : String? path to the backup file (uses default if null)
    /// - `formatJsonToData` : Function to convert JSON Map to data model T
    /// - `getId` : Function to extract unique ID from data model T
    /// - `boxName` : String name of the target Hive box
    ///
    /// Returns:
    /// - `Future<bool>` : true if import succeeded, false otherwise
    ///
    /// The method performs these operations:
    /// 1. Requests external storage permission if needed
    /// 2. Creates default backup directory and file path if not provided
    /// 3. Validates file existence before proceeding
    /// 4. Clears existing data in the target box
    /// 5. Reads and parses JSON content
    /// 6. Converts each JSON item to data model and stores in Hive box
    ///
    /// Default backup location: `/storage/emulated/0/CineBook/{boxName}-backup.json`
    ///
    /// Example usage:
    /// ```dart
    /// bool imported = await HiveService.importBackupFromFile<Media>(
    ///   '/path/to/backup.json',
    ///   Media.fromJson,
    ///   (media) => media.uniqueId,
    ///   'mediaBox'
    /// );
    /// ```
    static Future<bool> importBackupFromFile<T>(
            String? backupFilePath, 
            T Function(Map<String, dynamic>) formatJsonToData, 
            String Function(T) getId,
            String boxName
        ) async {

        try {
            
            // Handle default backup file path and permissions
            if (backupFilePath == null || backupFilePath.isEmpty) {
                var status = await Permission.manageExternalStorage.request();
                if (!status.isGranted) return false;

                final dir = Directory("/storage/emulated/0/CineBook");
                if (!await dir.exists()) await dir.create(recursive: true);
                backupFilePath = "${dir.path}/$boxName-backup.json";
            }

            // Validate backup file existence
            final file = File(backupFilePath);
            var fileExists = await file.exists();
            if (!fileExists) return false;

            // Read and parse JSON content
            final content = await file.readAsString();
            final List<dynamic> data = jsonDecode(content);
            
            // Clear existing data and restore from backup
            final box = Hive.box<T>(boxName);
            await box.clear();

            // Process each item from backup and store in Hive box
            for (var item in data) {
                final model = formatJsonToData(item as Map<String, dynamic>);
                final uniqueId = getId(model);
                await box.put(uniqueId, model);
            }
            return true;

        } catch (_) {
            // Return false if any step in the import process fails
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%% END - IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% EXPORT BACKUP %%%%%%%%%%%%%%%%%
    /// 𝐄𝐱𝐩𝐨𝐫𝐭𝐬 𝐚𝐥𝐥 𝐝𝐚𝐭𝐚 𝐟𝐫𝐨𝐦 𝐚 𝐇𝐢𝐯𝐞 𝐛𝐨𝐱 𝐭𝐨 𝐚 𝐉𝐒𝐎𝐍 𝐛𝐚𝐜𝐤𝐮𝐩 𝐟𝐢𝐥𝐞.
    ///
    /// This method creates a backup of all data from a specified Hive box by
    /// converting each item to JSON format and writing to a backup file.
    /// It handles external storage permissions and file management.
    ///
    /// Parameters:
    /// - `backupFilePath` : String? target path for the backup file (uses default if null)
    /// - `boxName` : String name of the Hive box to backup
    /// - `convertToJson` : Function to convert data model T to JSON Map
    ///
    /// Returns:
    /// - `Future<bool>` : true if export succeeded, false otherwise
    ///
    /// The method performs these operations:
    /// 1. Retrieves all data from the specified Hive box
    /// 2. Converts each item to JSON format using the provided converter function
    /// 3. Requests external storage permission
    /// 4. Creates default backup directory and file path if not provided
    /// 5. Deletes existing backup file if it exists
    /// 6. Writes the JSON data to the backup file
    ///
    /// Default backup location: `/storage/emulated/0/CineBook/{boxName}-backup.json`
    ///
    /// Example usage:
    /// ```dart
    /// bool exported = await HiveService.exportBackupToFile<Media>(
    ///   '/path/to/backup.json',
    ///   'mediaBox',
    ///   (media) => media.toJson()
    /// );
    /// ```
    static Future<bool> exportBackupToFile<T>(
        String? backupFilePath,
        String boxName,
        Map<String, dynamic> Function(T) convertToJson,
    ) async {
        
        try {
            
            // Get all data from Hive box and convert to JSON
            final dataList = Hive.box<T>(boxName).values.toList();
            final jsonList = dataList.map(convertToJson).toList();

            // Request external storage permission
            var status = await Permission.manageExternalStorage.request();
            if (!status.isGranted) return false;

            // Handle default backup file path
            if (backupFilePath == null || backupFilePath.isEmpty) {
                
                final dir = Directory("/storage/emulated/0/CineBook");
                if (!await dir.exists()) await dir.create(recursive: true);
                backupFilePath = "${dir.path}/$boxName-backup.json";
            }

            // Write JSON data to backup file
            final file = File(backupFilePath);
            if (await file.exists()) await file.delete(); // Remove existing backup
            await file.writeAsString(jsonEncode(jsonList));
            return true;
            
        } catch (_) {
            // Return false if any step in the export process fails
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%% END - EXPORT BACKUP %%%%%%%%%%%%%%%%%
}