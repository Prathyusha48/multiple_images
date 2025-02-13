import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaServices {
  Future loadAlbums(RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    //if(permission.isAuth == true) {
      albumList = await PhotoManager.getAssetPathList(
        type: requestType,
        pathFilterOption: const PMPathFilter(),
        filterOption: FilterOptionGroup()
          ..setOption(
            AssetType.image,
            const FilterOption(),
          )
      );
   // } else{
      var status = await Permission.photos.status;
     // Permission.storage.request();
      if(status.isDenied){
        Permission.photos.request();
      }
     // PhotoManager.openSetting();
    //}
    return albumList;
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
        start: 0,
        end: await selectedAlbum.assetCountAsync,
    );
    return assetList;
  }
}