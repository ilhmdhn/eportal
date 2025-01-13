import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/page/add_on/background.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/notification/notification_detail.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});
  static const nameRoute = '/notification-list';
  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {

  final PagingController<int, NotificationModel> _pagingController = PagingController(firstPageKey: 1);

  bool isLoading = true;

  Future<void> _fetchList(int pageKey)async{
    try{
      final networkRequest = await NetworkRequest.getNotifPaging(pageKey);
      if(isLoading){
        setState(() {
          isLoading = false;
        });
      }

      if(networkRequest.state != true){
        _pagingController.error(networkRequest.message);
        return;
      }

      if(!isNotNullOrEmptyList(networkRequest.data)){
        _pagingController.appendLastPage([]);
        return;
      }

      if((networkRequest.data?.length??0)<10){
        _pagingController.appendLastPage(networkRequest.data!);
      }else{
        _pagingController.appendPage(networkRequest.data!, pageKey+1);
      }

    }catch(e){
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
      _pagingController.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchList(pageKey);
    });
    _fetchList(1);
  }

  @override
  void dispose(){
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?
      ShimmerLoading.listShimmer(context):
      backgroundPage(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6
                        ),
                        margin: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.3
                          )
                        ),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              item.isViewed = true;
                            });
                            NavigationService.moveWithData(NotificationDetailPage.nameRoute, item);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, 
                                      style: 
                                      item.isViewed ?CustomFont.headingEmpatSemiBoldGrey(): CustomFont.headingEmpatSemiBold()
                                    ,),
                                    const SizedBox(height: 4,),
                                    AutoSizeText(item.content, style: item.isViewed? CustomFont.headingLimaGrey(): CustomFont.headingLima(), maxLines: 2, textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 3,),
                              AutoSizeText(CustomConverter.ago(item.time), style: CustomFont.headingLimaGrey(),)
                            ],
                          ),
                        ),
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