import 'package:pwa/worker.dart';

import 'package:egao/pwa/offline_urls.g.dart' as offline;

var defaultBaseUrl = "/";

void setupWorkerCache() {
  final cache = DynamicCache('hacker-news-service');
  Worker()
    ..offlineUrls = offline.offlineUrls
    ..router.registerGetUrl(defaultBaseUrl, cache.networkFirst)
    ..run(version: offline.lastModified);
}
