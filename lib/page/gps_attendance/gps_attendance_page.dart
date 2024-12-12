import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/gps_attendance/camera_dialog.dart';
import 'package:eportal/page/permission/permission_page.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/calculate.dart';
import 'package:eportal/util/location_dummy.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

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
  final Distance distance = const Distance();
  LocationModel nearest = LocationModel(brand: '1', name: 'Happy Puppy', outletLat: 0, outletLong: 0);
  List<LocationModel> locations = [];
  List<Marker> markerz = [];
  final Location _location = Location();
  bool _serviceEnabled = false;
  bool _permissionEnabled = false;
  bool initCamera = false;
  
  StreamController<LocationData> locationStream = StreamController<LocationData>.broadcast();

  @override
  void initState() {
    super.initState();
    initLocation();

    _mapController.mapEventStream.listen((event) {
      _currentZoom = event.camera.zoom;
    });
    
    loadLocations().then((loadedLocations) {
      locations.addAll(loadedLocations);
      getMarker(loadedLocations);
    });
  }

  void initLocation()async{
    PermissionStatus permissionGranted = await _location.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      permissionGranted = await _location.requestPermission();
      if(permissionGranted != PermissionStatus.granted){
        ShowToast.error('Izinkan akses lokasi terlebih dulu');
        return;
      }
    }else{
      _permissionEnabled = true;
    }

    _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();

      if (!_serviceEnabled) {
        ShowToast.wawrningLong('Lokasi tidak aktif');
        return;
      }
    }

    setState(() {
      _serviceEnabled;
      _permissionEnabled;
    });

    _location.onLocationChanged.listen((LocationData currentLoc) {
      if(locationStream.isClosed){
        locationStream = StreamController<LocationData>.broadcast();
      }
        locationStream.add(currentLoc);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: SizedBox(
        height: double.maxFinite,
        child: StreamBuilder<LocationData>(
          stream: locationStream.stream,
          builder: (context, snapshot) {
            bool locationSuccess = false;
            if(snapshot.hasData){
              locationSuccess = true;
              if(!initCamera){
                _mapController.move(LatLng(snapshot.data?.latitude?? 0, snapshot.data?.longitude?? 0), 18);
                initCamera = true;
              }
                nearestOutlet(LatLng(snapshot.data?.latitude ?? -7.4085933, snapshot.data?.longitude ?? 111.4349469));
            }
            LatLng currentLocation = LatLng(snapshot.data?.latitude?? -7.4085933, snapshot.data?.longitude?? 111.4349469);
            double accuration = snapshot.data?.accuracy??10;
            
            return Stack(
              children: [
                Positioned(
                  child: Stack(
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
                                    initialCenter: currentLocation,
                                    initialZoom: 23.0,
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
                                    const SizedBox(),
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
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _permissionEnabled == false?
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText('Izinkan akses lokasi', style: CustomFont.headingTigaSemiBold(),),
                                            Align(
                                              alignment: Alignment.center,
                                              child: InkWell(
                                                onTap: ()async {
                                                  await PH.openAppSettings();
                                                  setState(() {
                                                    
                                                  });
                                                  initLocation();
                                                },
                                                child: Container(
                                                  decoration: CustomContainer.buttonPrimary(),
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: Text('Buka Pengaturan', style: CustomFont.buttonSecondary()),
                                                ),
                                              ),
                                            )
                                          ],
                                        ):
                                        _serviceEnabled == false?
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText('Aktifkan lokasi terkini', style: CustomFont.headingTigaSemiBold(),),
                                            Align(
                                              alignment: Alignment.center,
                                              child: InkWell(
                                                onTap: ()async {
                                                  await _location.requestService();
                                                  setState(() {
                                                    
                                                  });
                                                  initLocation();
                                                },
                                                child: Container(
                                                  decoration: CustomContainer.buttonPrimary(),
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: Text('Buka Pengaturan', style: CustomFont.buttonSecondary()),
                                                ),
                                              ),
                                            )
                                          ],
                                        ):
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                    nearest.distance > 50
                                                        ? 'Outlet terdekat'
                                                        : 'Kamu berada di',
                                                    style: CustomFont
                                                        .urLocation()),
                                                AutoSizeText(
                                                    'Akurasi ${accuration.toStringAsFixed(2)}m',
                                                    style: CustomFont
                                                        .locationAccuration()),
                                              ],
                                            ),
                                            AutoSizeText(
                                                nearest.brand == '1' ? 'Happup'
                                              : nearest.brand == '2' ? 'Happy Puppy'
                                              : nearest.brand == '3' ? 'QQ'
                                              : nearest.brand == '4' ? 'Suka - Suka'
                                              : nearest.brand == '5' ? 'Blackhole'
                                              : 'Office',
                                              style: CustomFont.headingDuaBold(),
                                              maxLines: 1,
                                              minFontSize: 6,
                                            ),
                                            AutoSizeText(nearest.name, style: CustomFont.headingTiga()),
                                            AutoSizeText('Jarak: ${Calculate.meterToUp(nearest.distance)}', style: CustomFont.headingEmpat(),),
                                          ],
                                        ),    
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0,),
                                              child: Text('Lihat lokasi outlet lain', style: CustomFont.headingEmpat()),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.symmetric(horizontal: 0),
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              child: DropdownSearch<LocationModel>(
                                                decoratorProps: const DropDownDecoratorProps(
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none
                                                  )
                                                ),
                                                items: (filter, a) => locations,
                                                itemAsString: (LocationModel? location)=> '${location?.name} ${location?.distance}m',
                                                popupProps: PopupProps.menu(
                                                  title: Container(
                                                    color: Colors.white,
                                                    height: 36,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                              height: 26,
                                                              width: 26,
                                                            ),
                                                        Text('Nearest Outlet', style: CustomFont.headingTiga(),),
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                          },
                                                          child: const SizedBox(
                                                            height: 26,
                                                            width: 26,
                                                            child: Icon(Icons.close)),
                                                        ),
                                                      ],
                                                    )),
                                                  itemBuilder: (ctx, item, isDisable, isSelected){
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color:  isSelected? Colors.amber: Colors.white,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 26,
                                                                  child: item.brand == '1'? SizedBox(
                                                                    child: Image.asset('assets/image/happup.png'))
                                                                      : item.brand == '2'
                                                                        ? Image.asset('assets/image/happy_puppy.png')
                                                                      : item.brand == '3'
                                                                        ? Image.asset('assets/image/qq.png')
                                                                      : item.brand =='4'
                                                                        ? Image.asset('assets/image/suka_suka.png')
                                                                      : item.brand == '5'
                                                                        ? Image.asset('assets/image/blackhole.png')
                                                                      : const SizedBox(),
                                                                ),
                                                                AutoSizeText(item.name, style: CustomFont.headingEmpatBold(),),
                                                                Text('Jarak :${Calculate.meterToUp(item.distance)}', style: CustomFont.headingEmpat(),),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            width: double.infinity,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                ),
                                                dropdownBuilder: (context, selectedItem) {
                                                  return Container(
                                                    margin: const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AutoSizeText(
                                                          (selectedItem?.brand??nearest.brand) == '1'?
                                                          'Happup':
                                                          (selectedItem?.brand??nearest.brand) == '2'?
                                                          'Happy Puppy':
                                                          (selectedItem?.brand??nearest.brand) == '3'?
                                                          'QQ':
                                                          (selectedItem?.brand??nearest.brand) == '4'?
                                                          'Suka - Suka':
                                                          (selectedItem?.brand??nearest.brand) == '2'?
                                                          'Blackhole':
                                                          'Office',
                                                          style: CustomFont.headingTigaBold(),
                                                          maxLines: 1,
                                                          minFontSize: 6,
                                                        ),
                                                        AutoSizeText(
                                                          selectedItem?.name??nearest.name,
                                                          style: CustomFont.headingEmpat(), maxLines: 1, minFontSize: 6,
                                                        ),
                                                        AutoSizeText(
                                                          Calculate.meterToUp(selectedItem?.distance??nearest.distance),
                                                          style: CustomFont.headingLima(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                                compareFn: (LocationModel? a, LocationModel? b) => a?.outletLat == b?.outletLat && a?.outletLong == b?.outletLong,
                                                onChanged: (LocationModel? selectedLocation){
                                                  if(selectedLocation != null){
                                                    _mapController.move(LatLng(selectedLocation.outletLat, selectedLocation.outletLong), 18);
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin:
                                                  const EdgeInsets.symmetric(horizontal: 0),
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 12,)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(onTap: ()async{
                              if(nearest.distance>5000){
                                ShowToast.error('Jarak ke outlet harus dibawah 50 meter');
                                return;
                              }
                                  
                              CameraDialog.showCameraDialog(context, nearest.distance, nearest.name);
                              
                            }, child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: CustomContainer.buttonPrimary(),
                              child: Center(child: AutoSizeText('Absen', style: CustomFont.buttonSecondary()))))
                          ],
                        )
                      ),
                    )
              ],
            );
          }
        ),
      ),
    );
  }

  void getMarker(List<LocationModel> locations) {
    for (var element in locations) {
      nameOutletList.add(element.name);
      markerz.add(Marker(
          width: 100,
          point: LatLng(element.outletLat, element.outletLong),
          child: element.brand == '1'
              ? SizedBox(child: Image.asset('assets/image/happup.png'))
              : element.brand == '2'
                  ? Image.asset('assets/image/happy_puppy.png')
                  : element.brand == '3'
                      ? Image.asset('assets/image/qq.png')
                      : element.brand == '4'
                          ? Image.asset('assets/image/suka_suka.png')
                          : element.brand == '5'
                              ? Image.asset('assets/image/blackhole.png')
                              : const SizedBox()));
    }
      setState(() {
        markerz;
      });
    
  }

  void nearestOutlet(LatLng currentLocation) {
    double currentDistance = 0;
    locations.asMap().forEach((index, value) {
      final dstnc = distance.as(LengthUnit.Meter, currentLocation,
          LatLng(value.outletLat, value.outletLong));
      locations[index].distance = dstnc;
      if (currentDistance == 0) {
        nearest = value;
        currentDistance = dstnc;
      } else if (currentDistance > dstnc) {
        nearest = value;
        currentDistance = dstnc;
      }
    });
    locations.sort((a, b) => a.distance.compareTo(b.distance));
  }

  @override
  void dispose() {
    _mapController.dispose();
    locationStream.close();
    super.dispose();
  }
}
