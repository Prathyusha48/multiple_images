
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'media_picker.dart';


class MyHomePage extends StatefulWidget {
  final List<AssetEntity>? selectedAssetList;

  const MyHomePage({super.key,  this.selectedAssetList});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: widget.selectedAssetList!=null
       ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.selectedAssetList?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index){
              AssetEntity assetEntity = widget.selectedAssetList![index];
              Future<String> assetEntityName = getTitle(widget.selectedAssetList![index]);
              print("___name____${assetEntityName}______-");
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:  AssetEntityImage(
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
                    ),
                  ],
                ),
              );
            }
        )
        : Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return const MediaPicker(
                  requestType: RequestType.image, maxCount: 10,
                );
              },),
            );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.image),
        ),
    );
  }

  Future<String> getTitle(
      AssetEntity entity, {
        int subtype = 0,
      }) async {
  //  assert(Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
  //  if (Platform.isAndroid) {
    String name = await PhotoManagerPlugin().getTitleAsync(entity);
    print("title ${name}");
    return name;
   // }
  //  if (Platform.isIOS || Platform.isMacOS) {

    }
    //return '';
}
