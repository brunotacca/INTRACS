import './en_US/en_US.dart';
import './pt_BR/pt_BR.dart';

abstract class Languages {
  static Map<String, Map<String, String>> translations = {
    'en_US': enUS,
    'pt_BR': ptBR,
  };
}
