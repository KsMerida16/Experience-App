import 'package:experience_app/core/environment/env.dart';
import 'package:experience_app/main.dart';

void main(List<String> args) {
  Env.environment = Environment.production;
  runProject();
}
