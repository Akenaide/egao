import 'package:angular/angular.dart';
import 'package:egao/app_component.template.dart' as ng;

import 'package:egao/pwa/shim_client.dart';

void main() {
  installServiceWorker();

  runApp(ng.AppComponentNgFactory);
}
