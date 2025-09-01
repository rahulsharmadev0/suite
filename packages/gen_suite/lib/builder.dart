import 'package:build/build.dart';
import 'src/singleton_generator.dart';
import 'package:source_gen/source_gen.dart';


Builder singletonBuilder(BuilderOptions options) =>
    SharedPartBuilder(const [SingletonGenerator()], 'singleton');
