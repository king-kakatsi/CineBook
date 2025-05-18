
import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class HiveService {

    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// Deletes element from a hive box.
    /// 
    /// - [hiveBoxName] is the name of the Hive box.
    /// - [askConfirmation] asks a confirmation (maybe with a dialog) before deletion.
    /// - [itemId] is the unique id of the item.
    /// 
    /// Returns `true` if it's successfully done, otherwise `false`.
    static Future<bool> delete<T> (
            String hiveBoxName, 
            Future<bool?> Function() askConfirmation, 
            String itemId
        ) async {

        bool? result;
        try{
            result = await askConfirmation();
            if (result == null || !result) return false;

            var itemBox = Hive.box<T>(hiveBoxName);
            itemBox.delete(itemId);
            return true;

        } catch (e) {
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    /// Adds or update an item in a hive box.
    /// 
    /// - [hiveBoxName] is the name of the Hive box.
    /// - [item] is the element to add or update in the hive box.
    /// - [itemId] is the unique id of the item.
    /// 
    /// Returns `true` if it's successfully done, otherwise `false`.
    static Future<bool> addOrUpdate<T> (
        String hiveBoxName, 
        T item, 
        String? itemId
    ) async {

        try {
            var itemBox = Hive.box<T>(hiveBoxName);
            await itemBox.put(itemId, item); 
            return true;

        } catch (e) {
            return false;
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%%%
    /// Imports JSON data from a backup file into the Hive box.
    ///
    /// - [T] is the model type.
    /// - [backupFilePath] is the path to the JSON file. If this is null it will be automacally generated based on hive box name.
    /// - [formatJsonToData] is the model's `fromJson` function.
    /// - [boxName] is the name of the Hive box.
    ///
    /// Returns `true` if the import was successful, otherwise `false`.
    static Future<bool> importBackupFromFile<T>(
            String? backupFilePath, 
            T Function(Map<String, dynamic>) formatJsonToData, 
            String Function(T) getId,
            String boxName
        ) async {

        try {
            
            if (backupFilePath == null || backupFilePath.isEmpty) {
                var status = await Permission.manageExternalStorage.request();
                if (!status.isGranted) return false;

                final dir = Directory("/storage/emulated/0/CineBook");
                if (!await dir.exists()) await dir.create(recursive: true);
                backupFilePath = "${dir.path}/$boxName-backup.json";
            }

            final file = File(backupFilePath);
            var fileExists = await file.exists();
            if (!fileExists) return false;

            final content = await file.readAsString();
            final List<dynamic> data = jsonDecode(content);
            final box = Hive.box<T>(boxName);
            await box.clear();

            for (var item in data) {
                final model = formatJsonToData(item as Map<String, dynamic>);
                final uniqueId = getId(model);
                await box.put(uniqueId, model);
            }
            return true;

        } catch (_) {
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%% END - IMPORT BACKUP %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% EXPORT BACKUP %%%%%%%%%%%%%%%%%
    /// Exports all Hive data from a box into a JSON backup file.
    ///
    /// - [T] is the model type.
    /// - [backupFilePath] is the target JSON file path.
    /// - [convertToJson] is the model's `toJson` function.
    /// - [boxName] is the name of the Hive box.
    ///
    /// Returns `true` if the export was successful, otherwise `false`.
    static Future<bool> exportBackupToFile<T>(
        String? backupFilePath,
        String boxName,
        Map<String, dynamic> Function(T) convertToJson,
    ) async {
        
        try {
            
            final dataList = Hive.box<T>(boxName).values.toList();
            final jsonList = dataList.map(convertToJson).toList();

            var status = await Permission.manageExternalStorage.request();
            if (!status.isGranted) return false;

            if (backupFilePath == null || backupFilePath.isEmpty) {
                
                final dir = Directory("/storage/emulated/0/CineBook");
                if (!await dir.exists()) await dir.create(recursive: true);
                backupFilePath = "${dir.path}/$boxName-backup.json";
            }

            final file = File(backupFilePath);
            if (await file.exists()) await file.delete();
            await file.writeAsString(jsonEncode(jsonList));
            return true;
            
        } catch (_) {
            return false;
        }
    }
    // %%%%%%%%%%%%%%%%%% END - EXPORT BACKUP %%%%%%%%%%%%%%%%%
}