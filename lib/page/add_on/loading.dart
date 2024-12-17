import 'package:eportal/assets/color/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading{
  static Widget dashboardShimmer(BuildContext ctx){
    return Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        color: CustomColor.dashboardBackground(),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 25,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Expanded(
              flex: 50,
              child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                    ),
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Expanded(
              flex: 25,
              child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

   static Widget listShimmer(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      color: CustomColor.background(),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 25,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            flex: 75,
            child:
            ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (ctx, index){
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                          const SizedBox(width: 3,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white
                                  ),
                                ),
                                const SizedBox(height: 3,),
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white
                                  ),
                                ),
                                const SizedBox(height: 3,),
                                Container(
                                  width: 96,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white
                                  ),
                                )
                              ],    
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6,)
                    ],
                  ),
                );
              })
            ),
        ],
      ),
    );
  }
}