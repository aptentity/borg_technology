import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:borg_flutter/utils/toast_util.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CachePage extends StatefulWidget {
  static const String routeName = '/page/cache_page';
  static const String name = "CachePage";

  @override
  CachePageState createState() => CachePageState();
}

class CachePageState extends State<CachePage> {
  String cacheSize ="";

  @override
  void initState() {
    super.initState();
    loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CachePage'),
      ),
      body: Column(
        children: <Widget>[
          Text(cacheSize),
          RaisedButton(child: Text('Clean'),onPressed: ()=>_clearCache(),),
          CountryCodePicker(
            initialSelection: 'IT',
            favorite: ['+39','FR'],
            showCountryOnly: false,
            alignLeft: false,
            onChanged: (countryCode){
              print("New Country selected: " + countryCode.toString());
            },
          ),
        ],
      ),
    );
  }

  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        cacheSize = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }


  void _clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      showShortToast('清除缓存成功');
    } catch (e) {
      print(e);
      showShortToast('清除缓存失败');
    } finally {
      //此处隐藏加载loading
    }
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
