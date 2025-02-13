import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'home.dart';
import 'media_services.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';


class MediaPicker extends StatefulWidget {
  final int maxCount;
  final RequestType requestType;

  const MediaPicker({
    super.key,
    required this.requestType,
    required this.maxCount
  });

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
    AssetPathEntity? selectedAlbum;
    List<AssetPathEntity> albumList = [];
    List<AssetEntity> assetList = [];
    List<AssetEntity> selectedAssetList = [];

  @override
  void initState(){
    MediaServices().loadAlbums(RequestType.image).then((value){
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      MediaServices().loadAssets(selectedAlbum!).then((value){
        setState(() {
          assetList = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              title: DropdownButton<AssetPathEntity>(
                value: selectedAlbum,
                onChanged: (AssetPathEntity? value){
                  setState(() {
                    selectedAlbum = value;
                  });
                  MediaServices().loadAssets(selectedAlbum!).then((value){
                    setState(() {
                      assetList = value;
                    });
                  });
                },
                items:
                  albumList.map<DropdownMenuItem<AssetPathEntity>>(
                      (AssetPathEntity album){
                       // if(album.assetCountAsync. > 0)
                        return DropdownMenuItem<AssetPathEntity>(
                          value: album,
                          child: Text("${album.name}"),
                        );
                      }
                  ).toList(),
              ),
              actions: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context,selectedAssetList);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return MyHomePage(
                          selectedAssetList: selectedAssetList,
                        );
                      },),
                    );
                  },
                  child: const Center(
                    child: Padding(padding: EdgeInsets.only(right: 15),
                    child: Text("OK",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),),
                    ),
                  ),
                )
              ],
            ),
            body: assetList.isEmpty
              ? Container()
                : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: assetList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    AssetEntity assetEntity = assetList[index];
                    return Padding(
                        padding: const EdgeInsets.all(2),
                      child: assetWidget(assetEntity),
                    );
                  },
            ),
    );
  }

    Widget assetWidget(AssetEntity assetEntity){
      return Stack(
        children: [
          Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(
                    selectedAssetList.contains(assetEntity) == true ? 15 : 0
                ),
                child: AssetEntityImage(
                    assetEntity,
                    isOriginal: false,
                    thumbnailSize: const ThumbnailSize.square(250),
                    thumbnailFormat: ThumbnailFormat.jpeg,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace){
                      return const Center(
                        child : Icon(
                          Icons.error,
                          color : Colors.red,
                        ),
                      );
                    }
                ),
              )
          ),
          Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: (){
                    selectAsset(assetEntity: assetEntity);
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: selectedAssetList.contains(assetEntity) == true
                                ? Colors.blue
                                : Colors.black12,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${selectedAssetList.indexOf(assetEntity) + 1}",
                            style: TextStyle(
                              color: selectedAssetList.contains(assetEntity) == true
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              )
          ),
        ],
      );
    }

  void selectAsset({
  required AssetEntity assetEntity,
}){
    if(selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else if(selectedAssetList.length < widget.maxCount){
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }

}
