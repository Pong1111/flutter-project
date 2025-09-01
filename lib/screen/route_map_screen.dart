import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late GoogleMapController _mapController;
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Set<Polyline> _routeLines = {};
  List<LatLng> _routePoints = [];
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    setState(() {});

    // Listen to location updates
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (_isTracking) {
        setState(() {
          _routePoints.add(LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          ));
          _updateRoute();
        });
      }
    });
  }

  void _updateRoute() {
    setState(() {
      _routeLines = {
        Polyline(
          polylineId: PolylineId('route'),
          points: _routePoints,
          color: Color(0xFFFFD700),
          width: 5,
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _moveToCurrentLocation();
  }

  Future<void> _moveToCurrentLocation() async {
    if (_locationData != null) {
      await _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _locationData!.latitude!,
              _locationData!.longitude!,
            ),
            zoom: 17,
          ),
        ),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: color.withOpacity(0.4),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_locationData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
            SizedBox(height: 16),
            Text(
              'Getting your location...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Map
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _locationData!.latitude!,
              _locationData!.longitude!,
            ),
            zoom: 17,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          polylines: _routeLines,
          mapType: MapType.normal,
        ),

        // Top Controls
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFFFFD700)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Route',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isTracking)
                        Text(
                          'Recording your movement...',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.layers,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: Implement map style switcher
                  },
                ),
              ],
            ),
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: _isTracking ? Icons.stop : Icons.play_arrow,
                      label: _isTracking ? 'Stop' : 'Start',
                      onPressed: () {
                        setState(() {
                          _isTracking = !_isTracking;
                          if (!_isTracking) {
                            // TODO: Save route
                          }
                        });
                      },
                      color: _isTracking ? Colors.red : Color(0xFF4CAF50),
                    ),
                    _buildActionButton(
                      icon: Icons.my_location,
                      label: 'Center',
                      onPressed: _moveToCurrentLocation,
                      color: Color(0xFFFFD700),
                    ),
                    _buildActionButton(
                      icon: Icons.refresh,
                      label: 'Clear',
                      onPressed: () {
                        setState(() {
                          _routePoints.clear();
                          _routeLines.clear();
                        });
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
                if (_routePoints.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          icon: Icons.straighten,
                          label: 'Distance',
                          value: '2.5 km',
                        ),
                        _buildStat(
                          icon: Icons.timer,
                          label: 'Duration',
                          value: '15:30',
                        ),
                        _buildStat(
                          icon: Icons.speed,
                          label: 'Avg. Speed',
                          value: '5.2 km/h',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFFFD700), size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
