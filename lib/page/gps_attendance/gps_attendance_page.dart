import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/provider/location_provider.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/location_dummy.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';

class GpsAttendancePage extends StatefulWidget {
  static const nameRoute = '/gps-attendance';
  const GpsAttendancePage({super.key});

  @override
  State<GpsAttendancePage> createState() => _GpsAttendancePageState();
}

class _GpsAttendancePageState extends State<GpsAttendancePage> {
  // GoogleMapController? _mapController;
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
        loadLocations().then((loadedLocations) {
      setState(() {
        locations = loadedLocations;
      });
        });
  }

  List<Marker> markerz = [];

  void getMarker(){
      for (var element in locations) {
        markerz.add(
          Marker(
            width: 100,
            point: LatLng(element.outletLat, element.outletLong),
            child: 
              element.brand == '1'?
              SizedBox(child: Image.asset('assets/image/happup.png')):
              element.brand == '2'?
              Image.asset('assets/image/happy_puppy.png'):
              element.brand == '3'?
              Image.asset('assets/image/qq.png'):
              element.brand == '4'?
              Image.asset('assets/image/suka_suka.png'):
              element.brand == '5'?
              Image.asset('assets/image/blackhole.png'):
              const SizedBox()
            )
        );
      }
  }

  final _mapController = MapController();
  double _currentZoom = 18.0;



  @override
  Widget build(BuildContext context) {

  _mapController.mapEventStream.listen((event){
    _currentZoom = event.camera.zoom;
  });

    final locationProvider = Provider.of<LocationProvider>(context);
    getMarker();
    LatLng currentLocation = LatLng((locationProvider.currentLocation?.latitude ?? 0.0), (locationProvider.currentLocation?.longitude ??0.0));
    
    double accuration = locationProvider.currentLocation?.accuracy??100;
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              child: locationProvider.currentLocation == null
                  ? SizedBox(
                      width: double.infinity,
                      height: ScreenSize.setHeightPercent(context, 60),
                    child: Center(
                      child: SizedBox(
                        height: 56,
                        width: 56,
                        child: CircularProgressIndicator(
                            color: CustomColor.primary(),
                          ),
                      ),
                    ),
                  )
                  : SizedBox(
                      width: double.infinity,
                      height: ScreenSize.setHeightPercent(context, 65),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          backgroundColor: CustomColor.background(),
                          initialCenter: currentLocation, // Jakarta
                          initialZoom: 18.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: currentLocation,
                                color: Colors.blue.withOpacity(0.3),
                                borderStrokeWidth: 2,
                                borderColor: Colors.blue,
                                radius: accuration * pow(2, -(_currentZoom - 18)),
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: 
                            [
                              Marker(
                                point: currentLocation,
                                width: 20,
                                height: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CustomColor.primary(),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            Colors.white, // Warna border putih
                                        width: 3.0, // Ketebalan border
                                      ),
                                  ),
                                )
                              ),
                              ...markerz
                            ],
                          )
                        ],
                      ),
                  
                      ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: ScreenSize.setHeightPercent(context, 35),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText('Lokasimu saat ini', style: CustomFont.urLocation()),
                                InkWell(onTap: (){
                                  _mapController.move(currentLocation, 18);
                                }, child: SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Icon(Icons.gps_fixed)))
                              ],
                            ),
                              AutoSizeText('Happy Puppy Kantor Pusat Simohilir',
                                style: CustomFont.urLocation()
                              ),
                          ],
                        ),
                        InkWell(onTap: (){

                        }, child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: CustomContainer.buttonPrimary(),
                          child: Center(child: AutoSizeText('Absen', style: CustomFont.buttonSecondary()))))
                      ],
                    ),
                  )
                ))
          ],
        ),
      ),
    );
  }
}
