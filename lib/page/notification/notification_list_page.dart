import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/page/add_on/background.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});
  static const nameRoute = '/notification-list';
  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {

  final PagingController<int, NotificationModel> _pagingController = PagingController(firstPageKey: 0);

  bool isLoading = true;

  Future<void> _fetchList(int pageKey)async{
    try{

      if(isLoading){
        setState(() {
          isLoading = false;
        });
      }
    }catch(e){
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchList(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?
      ShimmerLoading.listShimmer(context):
      backgroundPage(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              AutoSizeText('Notification', style: CustomFont.headingDuaSemiBold(),),
              const SizedBox(height: 12,),
              Flexible(
                child: PagedListView<int, NotificationModel>(
                  pagingController: _pagingController, 
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (contextList, item, index){
                      return Container(
                        child: Text(item.title, style: CustomFont.headingEmpatSemiBold(),),
                      );
                    }
                  )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}