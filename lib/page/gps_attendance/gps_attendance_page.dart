import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/gps_attendance/camera_dialog.dart';
import 'package:eportal/provider/location_provider.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/calculate.dart';
import 'package:eportal/util/location_dummy.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:camera/camera.dart';

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
  Location nearest = Location(brand: '1', name: 'Happy Puppy', outletLat: 0, outletLong: 0);
  List<Location> locations = [];
  List<Marker> markerz = [];
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;


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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(nearest.distance>50?'Outlet terdekat':'Kamu berada di', style: CustomFont.urLocation()),
                                AutoSizeText('Akurasi ${(locationProvider.currentLocation?.accuracy ?? 0).toStringAsFixed(2)}m', style: CustomFont.locationAccuration()),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      nearest.brand == '1'
                                        ? 'Happup'
                                          : nearest.brand == '2'
                                        ? 'Happy Puppy'
                                          : nearest.brand == '3'
                                        ? 'QQ'
                                          : nearest.brand == '4'
                                        ? 'Suka - Suka'
                                          : nearest.brand == '2'
                                        ? 'Blackhole'
                                          : 'Office',
                                      style: CustomFont.headingDuaBold(),
                                      maxLines: 1,
                                      minFontSize: 6,
                                    ),
                                    AutoSizeText(nearest.name, style: CustomFont.headingTiga()),
                                    AutoSizeText('Jarak: ${Calculate.meterToUp(nearest.distance)}', style: CustomFont.headingEmpat(),),
                                  ],
                                ),
                              ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24,),
                                    child: Text('Lihat lokasi outlet lain', style: CustomFont.headingEmpat()),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(horizontal: 24),
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    child: DropdownSearch<Location>(
                                      decoratorProps: const DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          border: InputBorder.none
                                        )
                                      ),
                                      items: (filter, a) => locations,
                                      // mode: Mode.form,
                                      itemAsString: (Location? location)=> '${location?.name} ${location?.distance}m',
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
                                            horizontal: 24,
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
                                      compareFn: (Location? a, Location? b) => a?.outletLat == b?.outletLat && a?.outletLong == b?.outletLong,
                                      onChanged: (Location? selectedLocation){
                                        if(selectedLocation != null){
                                          _mapController.move(LatLng(selectedLocation.outletLat, selectedLocation.outletLong), 18);
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 24),
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 12,)
                                ],
                              ),
                            ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                            child: InkWell(onTap: ()async{
                              if(nearest.distance>50){
                                ShowToast.error('Jarak ke outlet harus dibawah 50 meter');
                                return;
                              }
                                await _initializeCamera();

                              if(_cameraController.value.isInitialized && context.mounted){
                                CameraDialog.showCameraDialog(context, _cameraController, nearest.distance);
                              }else{
                                ShowToast.warning('Kamera Belum siap');
                              }
                            }, child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: CustomContainer.buttonPrimary(),
                              child: Center(child: AutoSizeText('Absen', style: CustomFont.buttonSecondary())))),
                          )
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


  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);

    try {
      await _cameraController.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
    return;
  }

  void getMarker(List<Location> locations) {
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
    super.dispose();
  }
}
