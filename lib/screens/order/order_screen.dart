
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:call_tukang/constants/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:call_tukang/actions/action_presenter.dart';
import 'package:call_tukang/models/user.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:call_tukang/screens/widgets/formfield.dart';

class Order extends StatefulWidget {
  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<Order> implements ActionScreenContract  {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<dynamic> _merchantData = [];
  static LatLng _initialPosition;
  static LatLng _lastMapPosition = _initialPosition;
  ActionScreenPresenter _presenter;
  bool _isLoading = true;
  String _token;
  int _userid;
  int _markersLength = 0;
  BitmapDescriptor pinLocationIcon;
  final formKey = new GlobalKey<FormState>();
  TextEditingController _noteController = TextEditingController();
  BuildContext _context;

  OrderState() {
    _presenter = new ActionScreenPresenter(this);
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void onActionError(dynamic error) {
    if (error["message"] != null) {
      _showDialog("Opssss",error["message"]);
      final userModel = Provider.of<UserModel>(context);
      userModel.logout();
      Navigator.of(_context).pushNamed(SIGN_IN);
    }else{
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void setCustomMapPin() async {
      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/map.png');
   }
  void _onMarkerTapped(int markerId) {
    showOrderForm(_context, markerId);
  }
  void showOrderForm(BuildContext context, int markerId) {
    dynamic merchantSelected = _merchantData[markerId];
    final emailField = CustomTextField(maxLines: 3, keyboardType: TextInputType.emailAddress, textEditingController:_noteController, hint: "Catatan untuk Tukang Services", );
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: const Radius.circular(12.0), topRight: const Radius.circular(12.0)),
                color: Colors.blue[300]
              ),
              child: Text(
                merchantSelected["name"].toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Address: ${merchantSelected["address"]}",
                    style: GoogleFonts.openSans(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    merchantSelected["price"] != null ? "Price: ${merchantSelected["price"]}" : "Price: Custom Price",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child:
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      emailField,
                      SizedBox(height:10),
                    ]
                  ),
                ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
  void onActionSuccess(dynamic merchants) {
    final List<dynamic> jsonData = merchants["merchants"];
    _merchantData = jsonData;
    jsonData.forEach((v) {
      // print(v);
      int index = jsonData.indexOf(v);
      _markersLength++;
      final MarkerId markerId = MarkerId(v["id"].toString());
      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(double.parse(v["lattitudes"]), double.parse(v["longitudes"])),
          // infoWindow: InfoWindow(title: v["name"]),
          icon: pinLocationIcon,
          onTap: () {
            _onMarkerTapped(index);
          },
        )
      );
    });
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
     setCustomMapPin();
    _getUserLocation();
    super.initState();
  }
  double zoomVal=14.0;

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
     final userModel = Provider.of<UserModel>(context);
    _context = context;
    _token = userModel.token;
    _userid = userModel.user.userId;
    if (_markersLength < 1) {
      _presenter.getService(_token);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2a83d0),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft,size: 20.0),
          onPressed: () {
            Navigator.of(context).pop(HOME);
          }),
          title: Text("Order Service di Sekitar Anda")
      ),
      body: Stack(
        children: <Widget>[
          _isLoading ? new CircularProgressIndicator() : _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          // _buildContainer(),
        ],
      ),
    );
  }

 Widget _zoomminusfunction() {

    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchMinus,color:Color(0xff01A0C7)),
            onPressed: () {
              zoomVal--;
             _minus(zoomVal);
            }),
    );
 }
 Widget _zoomplusfunction() {
   
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchPlus,color:Color(0xff01A0C7)),
            onPressed: () {
              zoomVal++;
              _plus(zoomVal);
            }),
    );
 }

 Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: zoomVal)));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: _initialPosition, zoom: zoomVal),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers
      ),
    );
  }

  // Future<void> _gotoLocation(double lat,double long) async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
  //     bearing: 45.0,)));
  // }
}