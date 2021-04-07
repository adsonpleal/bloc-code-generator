import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class _EventMethod {
    final String event;
    final String name;
    final MethodElement method;
    
    _EventMethod({required this.name, required this.event, required this.method});
}

class BlocGenerator extends GeneratorForAnnotation<GenerateBloc> {
    @override
    String generateForAnnotatedElement(
        Element element,
        ConstantReader annotation,
        BuildStep buildStep,
        ) {
        
        final eventMethods = _eventMethods(element as ClassElement);
        final stateType = annotation.read('stateType').typeValue;
        return '''
    ${_eventEnum(eventMethods)}
    $_eventClass
    ${_blocClass(eventMethods, stateType)}
    ''';
    }
    
    String _blocClass(List<_EventMethod> eventMethods, DartType stateType) {
        return '''
    abstract class _\$Bloc extends Bloc<_\$Event,${stateType.name}> {\n
      ${_construct(stateType)}
      ${_mapToStateMethod(eventMethods, stateType)}
      ${eventMethods.map(_dispatchMethod).join('\n')}
      ${eventMethods.map((em) => _abstractMethod(em, stateType)).join('\n')}
    }
    ''';
    }
    
    String _construct(DartType stateType) {
        return '''
    _\$Bloc(${stateType.name} initialState) : super(initialState);
    ''';
    }
    
    String _abstractMethod(_EventMethod eventMethod, DartType stateType) {
        final params = eventMethod.method.parameters
            .map((p) => "${p.type.displayName} ${p.name}")
            .join(',');
        return '''
    Stream<${stateType.name}> ${eventMethod.method.name}($params);
    ''';
    }
    
    String _dispatchMethod(_EventMethod eventMethod) {
        final methodParams = eventMethod.method.parameters;
        final params =
        methodParams.map((p) => "${p.type.displayName} ${p.name}").join(',');
        String payload = '';
        if (methodParams.isNotEmpty) {
            final args = methodParams.map((p) => p.name).join(',');
            payload = 'payload: [$args],';
        }
        return '''
    void dispatch${eventMethod.name}Event($params) {
      add(_\$Event(
        type: _\$EventType.${eventMethod.event},
        $payload
      ));
    }
    ''';
    }
    
    String _eventEnum(List<_EventMethod> eventMethods) => '''
    enum _\$EventType {
      ${eventMethods.map((em) => em.event).join(',')}
    }  
  ''';
    
    String get _eventClass => '''
    class _\$Event {
      final _\$EventType? type;
      final List<dynamic>? payload;

      _\$Event({this.type, this.payload});
    }  
  ''';
    
    String _mapToStateMethod(
        List<_EventMethod> eventMethods, DartType stateType) {
        final cases = eventMethods.map((em) {
            final params = em.method.parameters
                .asMap()
                .keys
                .map((index) => 'event.payload![$index]')
                .join(',');
            return '''
        case _\$EventType.${em.event}:
          yield* ${em.method.name}($params);
          break;''';
        }).join('\n');
        return '''
      Stream<${stateType.name}> mapEventToState(_\$Event event) async* {
        switch(event.type) {
          $cases
        }
      }
    ''';
    }
    
    List<_EventMethod> _eventMethods(ClassElement element) {
        final mapMethodRegExp = RegExp(r"_map(.*)ToState");
        final mapMethods = element.methods
            ..removeWhere((m) => !mapMethodRegExp.hasMatch(m.name));
        return mapMethods.map((m) {
            String? name = mapMethodRegExp.firstMatch(m.name)?.group(1);
            if (name != null) {
                final event = name[0].toLowerCase() + name.substring(1);
                return _EventMethod(event: event, method: m, name: name);
            }
            return _EventMethod(event: "", method: m, name: "");
        }).toList();
    }
}
