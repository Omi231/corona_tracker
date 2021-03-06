// import 'dart:async';

// import 'package:coronatracker/widgets/active_cases.dart';
// import 'package:coronatracker/widgets/new_deaths.dart';
// import 'package:coronatracker/widgets/serious_critical.dart';
// import 'package:coronatracker/widgets/total_cases.dart';
// import 'package:coronatracker/widgets/total_deaths.dart';
// import 'package:coronatracker/widgets/total_recovered.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'models/results.dart';

// class CoronaMaps extends StatefulWidget {
//   final List<Country> resultData;
//   final List<Placemark> placemarKData;

//   CoronaMaps({this.resultData, this.placemarKData});

//   @override
//   _CoronaMapsState createState() => _CoronaMapsState();
// }

// class _CoronaMapsState extends State<CoronaMaps> {
//   String mapStyle;
//   Set<Marker> markers = Set();

//   // new markers
//   Map<MarkerId, Marker> newMarkers = <MarkerId, Marker>{};
//   Country tappedText = Country(
//     countryName: 'Select a Marker',
//     info: CountryInfo(
//       newCases: '0',
//       newDeaths: '0',
//       totalCases: '0',
//       totalDeaths: '0',
//       totalRecovered: '0',
//       activeCases: '0',
//       seriousCritical: 'NONE',
//     ),
//   );
//   LatLng tappedPos;
//   double tapZoom = 4.0;

//   bool loading = false;
//   bool displayData = false;
//   Timer load;
//   int counter = 0;
//   GoogleMapController _mapController;
//   Completer<GoogleMapController> completer = Completer();

//   getMarkers(Country data) {
//     widget.placemarKData.forEach((pm) {
//       if (pm.country.contains(data.countryName)) {
//         print("Data: ${data.countryName}; Placemark: ${pm.country}");
//         Marker markers = Marker(
//             markerId: MarkerId(pm.country),
//             position: LatLng(pm.position.latitude, pm.position.longitude),
//             consumeTapEvents: true,
//             onTap: () {
//               print('${data.info.totalCases}');
//               setState(() {
//                 tappedPos = LatLng(pm.position.latitude, pm.position.longitude);
//                 tappedText = data;
//               });
//               _mapController.animateCamera(CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                   zoom: tapZoom,
//                   target: LatLng(
//                     pm.position.latitude,
//                     pm.position.longitude,
//                   ),
//                 ),
//               ));
//             });
//         setState(() {
//           newMarkers[MarkerId(pm.country)] = markers;
//         });
//       }
//     });
//   }

//   loadData() {
//     print('hello');
//     Timer.run(() {
//       setState(() {
//         loading = true;
//       });
//     });

//     widget.resultData.forEach((data) {
//       print(data.countryName);
//     });

//     widget.resultData.forEach((data) => getMarkers(data));

//     Timer(Duration(seconds: 5), () {
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     rootBundle.loadString('assets/maps/dark_maps.txt').then((string) {
//       mapStyle = string;
//     });
//     loadData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     load.cancel();
//     markers.clear();
//     newMarkers.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color lightBlue = Color(0xff203053);
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               Timer.run(() {
//                 setState(() {
//                   loading = true;
//                   loadData();
//                 });
//               });
//               print(widget.placemarKData.length);
//               print(widget.resultData.length);
//               Timer(Duration(seconds: 2), () {
//                 setState(() {
//                   loading = false;
//                 });
//               });
//             },
//           )
//         ],
//         backgroundColor: Color(0xff1d2c4d),
//         centerTitle: true,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Current Cases: ${widget.resultData.length}',
//               style: TextStyle(
//                 fontSize: 13.0,
//               ),
//             ),
//             Text(
//               'Markers: ${widget.placemarKData.length}',
//               style: TextStyle(
//                 fontSize: 13.0,
//               ),
//             ),
//             Text(
//               'Takes a while to load the markers',
//               style: TextStyle(
//                 fontSize: 13.0,
//                 color: Colors.greenAccent,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: double.infinity,
//         color: Color(0xff1d2c4d),
//         child: loading
//             ? Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                   backgroundColor: Color(0xff29606e),
//                 ),
//               )
//             : Column(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 3,
//                     child: GoogleMap(
//                       onMapCreated: (GoogleMapController controller) {
//                         _mapController = controller;
//                         _mapController.setMapStyle(mapStyle);
//                       },
//                       initialCameraPosition:
//                           CameraPosition(target: LatLng(12, 121)),
//                       myLocationButtonEnabled: false,
//                       myLocationEnabled: true,
//                       tiltGesturesEnabled: false,
//                       rotateGesturesEnabled: false,
//                       markers: Set<Marker>.of(newMarkers.values),
//                       onCameraMove: (CameraPosition pos) {
//                         setState(() {
//                           tapZoom = pos.zoom;
//                         });
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       width: double.infinity,
//                       color: lightBlue,
//                       margin: EdgeInsets.symmetric(
//                         vertical: 0.0,
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Icon(
//                                         Icons.location_on,
//                                         color: Colors.red,
//                                         size: 30.0,
//                                       ),
//                                       SizedBox(
//                                         width: 10.0,
//                                       ),
//                                       Text(
//                                         '${tappedText.countryName}',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 30.0,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 tappedText.info.totalCases == '0'
//                                     ? Text('')
//                                     : Expanded(
//                                         flex: 4,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 TotalCases(
//                                                   data: tappedText
//                                                       .info.totalCases,
//                                                   type: 'Total Cases',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                   isMaps: true,
//                                                 ),
//                                                 TotalRecovered(
//                                                   data: tappedText
//                                                       .info.totalRecovered,
//                                                   type: 'Total Recovered',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                 ),
//                                                 ActiveCases(
//                                                   data: tappedText
//                                                       .info.activeCases,
//                                                   type: 'Active Cases',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Row(
//                                               children: <Widget>[
//                                                 TotalDeaths(
//                                                   data: tappedText
//                                                       .info.totalDeaths,
//                                                   type: 'Total Deaths',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                   isMaps: true,
//                                                 ),
//                                                 NewDeaths(
//                                                   data:
//                                                       tappedText.info.newDeaths,
//                                                   type: 'New Deaths',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                 ),
//                                                 SeriousCritical(
//                                                   data: tappedText
//                                                       .info.seriousCritical,
//                                                   type: 'Serious ',
//                                                   dataSize: 20,
//                                                   textSize: 12,
//                                                   isRow: false,
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Row(
//                                               children: <Widget>[],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
