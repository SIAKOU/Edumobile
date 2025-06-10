/// notification_service.dart
/// Service pour la gestion des notifications push (inscription, désinscription, récupération, envoi, etc.)
/// À adapter selon la solution utilisée (Firebase Cloud Messaging, OneSignal, etc.).
/// Ici, exemple générique compatible avec une API REST backend pour notifications.
// ignore_for_file: implementation_imports

library;

import 'dart:convert';
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'package:gestion_ecole/core/services/api/api_client.dart';
import 'package:gestion_ecole/core/services/api/api_endpoints.dart';



class NotificationService {
  final ApiClient apiClient;

  NotificationService({required this.apiClient, required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin});

  /// Inscription de l'appareil à la réception des notifications push
  Future<bool> registerDevice(String deviceToken) async {
    final response = await apiClient.post(
      ApiEndpoints.pushRegister,
      body: {'device_token': deviceToken},
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// Désinscription de l'appareil
  Future<bool> unregisterDevice(String deviceToken) async {
    final response = await apiClient.post(
      ApiEndpoints.pushUnregister,
      body: {'device_token': deviceToken},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// Récupère la liste des notifications reçues par l'utilisateur (avec pagination)
  Future<List<Map<String, dynamic>>> getNotifications({
    int? page,
    int? pageSize,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    final response = await apiClient.get(ApiEndpoints.notifications, params: params);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return (data as List).cast<Map<String, dynamic>>();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  /// Marque une notification comme lue
  Future<bool> markAsRead(String notificationId) async {
    final response = await apiClient.post(
      '${ApiEndpoints.notifications}/$notificationId/read',
    );
    return response.statusCode == 200;
  }

  /// Envoie une notification manuellement (pour admin ou test)
  Future<bool> sendNotification(Map<String, dynamic> notificationData) async {
    final response = await apiClient.post(
      ApiEndpoints.sendNotification,
      body: notificationData,
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {}

  void showNotificationFromFirebase(RemoteMessage message) {}


}