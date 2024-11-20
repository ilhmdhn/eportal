import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/provider/location_provider.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/calculate.dart';
import 'package:eportal/util/location_dummy.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GpsAttendancePage extends StatefulWidget {
  static const nameRoute = '/gps-attendance';
  const GpsAttendancePage({super.key});

  @override
  State<GpsAttendancePage> createState() => _GpsAttendancePageState();
}

class _GpsAttendancePageState extends State<GpsAttendancePage> {

  List<String> nameOutletList = [];
  final _mapController = MapController();
  double _currentZoom = 18.0;
  final Distance distance = Distance();
  Location nearest = Location(brand: '1', name: 'Happy Puppy', outletLat: 0, outletLong: 0);
  List<Location> locations = [];
  List<Marker> markerz = [];


  @override
  void initState() {
    super.initState();

      _mapController.mapEventStream.listen((event) {
        _currentZoom = event.camera.zoom;
      });
      
      loadLocations().then((loadedLocations) {
        locations.addAll(loadedLocations);
        getMarker(loadedLocations);
      });
  }

  void getMarker(List<Location> locations){
      for (var element in locations) {
        nameOutletList.add(element.name);
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
    setState(() {
      markerz;
    });
  }


  void nearestOutlet(LatLng currentLocation){
      double currentDistance = 0;
      locations.asMap().forEach((index, value){
        final dstnc = distance.as(LengthUnit.Meter, currentLocation , LatLng(value.outletLat, value.outletLong));
        locations[index].distance = dstnc;
        if(currentDistance == 0){
          nearest = value;
          currentDistance = dstnc;
        } else if(currentDistance > dstnc){
          nearest = value;
          currentDistance = dstnc;
        }
      });
  
  }

  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);
    LatLng currentLocation = LatLng((locationProvider.currentLocation?.latitude ?? 0.0), (locationProvider.currentLocation?.longitude ??0.0));
    double accuration = locationProvider.currentLocation?.accuracy??100;
    nearestOutlet(currentLocation);

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
                  : Stack(
                    children: [
                      
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: SizedBox(
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
                                      radius: accuration / pow(2, -(_currentZoom - 18)),
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
                        bottom: ScreenSize.setHeightPercent(context, 36),
                        right: 10,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: CustomColor.primary(),
                                        border: Border.all(
                                            width: 2, color: Colors.white)),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                              ),
                            InkWell(
                              onTap: (){
                                _mapController.move(currentLocation, 18);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: CustomColor.primary(),
                                  border: Border.all(width: 2, color: Colors.white)
                                ),
                                child: const Icon(Icons.gps_fixed, color: Colors.white, size: 26,)),
                            ),
                          ],
                        ),
                        ),
                    ],
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
                                    AutoSizeText(
                                        'Akurasi ${(locationProvider.currentLocation?.accuracy ?? 0).toStringAsFixed(2)}m',
                                        style: CustomFont.locationAccuration()),
                                ],
                              ),
                              const SizedBox(height: 12,),
                              AutoSizeText(nearest.name + nearest.distance.toString(),
                                style: CustomFont.location()),
                            ],
                          ),
                          Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DropdownSearch<Location>(
                              items: (filter, InfiniteScrollProps) => locations,
                              // mode: Mode.form,
                              itemAsString: (Location? location)=> '${location?.name} ${location?.distance}m',
                              popupProps: PopupProps.menu(
                                title: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Text('Nearest Outlet'),
                                      InkWell(
                                        child: Icon(Icons.close),
                                      ),
                                    ],
                                  )),
                                itemBuilder: (ctx, item, isDisable, isSelected){
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(item.brand),
                                  );
                                }
                              ),
                              dropdownBuilder: (context, selectedItem) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white
                                  ),
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        selectedItem?.name??'',
                                        style: CustomFont.standartFont(),
                                      ),
                                      AutoSizeText(
                                        Calculate.meterToUp(selectedItem?.distance??0),
                                        style: CustomFont.standartFont(),
                                      )
                                    ],
                                  ),
                                );
                              },
                              compareFn: (Location? a, Location? b) => a?.outletLat == b?.outletLat && a?.outletLong == b?.outletLong,
                              onChanged: (Location? selectedLocation){
                                if(selectedLocation != null){
                                  _mapController.move(LatLng(selectedLocation.outletLat, selectedLocation.outletLong), 18);
                                }
                              },
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
                  ),
                )
          ],
        ),
      ),
    );
  }
}
