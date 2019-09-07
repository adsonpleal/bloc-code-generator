library source_gen_example.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/bloc_generator.dart';

Builder blocBuilder(BuilderOptions options) => SharedPartBuilder(
      [BlocGenerator()],
      'bloc',
    );
