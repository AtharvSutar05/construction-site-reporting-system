import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

http.Client getPlatformHttpClient() {
  final client = BrowserClient();
  client.withCredentials = true; // Tells the browser to include/store cookies
  return client;
}