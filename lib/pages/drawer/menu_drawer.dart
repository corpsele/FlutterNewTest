import 'package:flutter_sliding_drawer/flutter_sliding_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final sliderDrawerKey = GlobalKey<SlidingDrawerState>();

class PageBuild {
  static Widget getSliderDrawer(Widget? widget, String? sliderPageTitle) {
      // 当前页面标题
  String _currentPage = '';
  // 抽屉菜单项
  late List<Map<String, dynamic>> _menuItems = [
      {'icon': Icons.home, 'label': "Home"},
      {'icon': Icons.settings, 'label': "Setting"},
      {'icon': Icons.info, 'label': "About"},
    ];

    return SlidingDrawer(
      key: sliderDrawerKey,
      contentBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                sliderDrawerKey.open();
              },
            ),
            title: Text(sliderPageTitle ?? "首页"),
          ),
          body: Center(child: widget ?? const Text('占位'),),
          resizeToAvoidBottomInset: false,
        );
      },
      drawerBuilder: (context) {
        return Material(
          color: Colors.deepPurple.shade50,
          child: SafeArea(
            child: Column(
              children: [
                // 抽屉头部
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Flutter Sliding Drawer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2.0.0 complete demo',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // 菜单项
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _currentPage == item['label'];

                      return ListTile(
                        leading: Icon(
                          item['icon'],
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.grey[700],
                        ),
                        title: Text(
                          item['label'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onTap: () {
                          // 处理菜单点击
                          
                            _currentPage = item['label'];


                          // 关闭抽屉
                          sliderDrawerKey.close();
                        },
                      );
                    },
                  ),
                ),

                // 底部退出按钮
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Close Drawer',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () => sliderDrawerKey.close(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}