import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/overtime_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/lembur/lembur_dialog.dart';
import 'package:eportal/util/checker.dart';
import 'package:flutter/material.dart';

class OvertimePage extends StatefulWidget {
  static const nameRoute = '/overtime';
  const OvertimePage({super.key});

  @override
  State<OvertimePage> createState() => OvertimePageState();
}

class OvertimePageState extends State<OvertimePage> {

  bool isLoading = true;
  List<OvertimeModel> listOvertime = [];
  void getData()async{
    if(isLoading != true){
      setState(() {
        isLoading = false;
      });
    }
    final networkResponse = await NetworkRequest.getOvertime();
    setState(() {
      isLoading = false;
    });
    if(isNotNullOrEmptyList(networkResponse.data)){
      setState(() {
        listOvertime = networkResponse.data!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      floatingActionButton: Container(
        height: 48,
        width: 48,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: CustomColor.primary()
        ),
        child: InkWell(
          onTap: (){
            OvertimeDialog.showOvertimeDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.white, size: 32,)),
      ),
      body: isLoading? 
      ShimmerLoading.listShimmer(context): 
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listOvertime.length,
              itemBuilder: (ctxList, index){
                final data = listOvertime[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.3,
                      color: Colors.grey
                    )
                  ),
                  child: Column(
                    children: [
                      AutoSizeText(data.id)
                    ],
                  ),
                );
              }))
        ],
      ),
    );
  }
}