// lib/data/sample_pharmacies.dart
import 'package:latlong2/latlong.dart';
import '../screens/map_screen.dart'; // Or wherever the Pharmacy class is, or re-define it here

final List<Pharmacy> samplePharmacies = [
  Pharmacy(
    id: 'P001',
    name: 'Saturn Drugstore',
    address: '123 Main St',
    contact: '0999‑888‑7777',
    hours: '08:00‑21:00',
    location: LatLng(14.5995, 120.9842),
  ),
  Pharmacy(
    id: 'P002',
    name: 'Sample Store',
    address: '456 Avenue Rd',
    contact: '0999‑111‑2222',
    hours: '09:00‑18:00',
    location: LatLng(14.6010, 120.9850),
  ),
  Pharmacy(
    id: 'P003',
    name: 'Sample Stpre',
    address: '789 Street Ln',
    contact: '0987‑654‑3210',
    hours: '24/7',
    location: LatLng(14.5980, 120.9820),
  ),
];
