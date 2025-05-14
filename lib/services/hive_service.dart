
import 'package:hive/hive.dart';

class HiveService {

    // %%%%%%%%%%%%%%%%%%%%%%%% DELETE MEDIA IN LIST %%%%%%%%%%%%%%%%%%
    static Future<bool> delete<T> (String hiveBoxName, Future<bool?> Function() askConfirmation, String itemId) async {

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
    static Future<bool> addOrUpdate<T> (String hiveBoxName, T item, String? itemId) async {
        try {
            var itemBox = Hive.box<T>(hiveBoxName);
            await itemBox.put(itemId, item); 
            return true;

        } catch (e) {
            return false;
        }   
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - ADD MEDIA IN LIST %%%%%%%%%%%%%%%%%%
}