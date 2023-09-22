import 'dart:typed_data';

enum TramaType {
  Encender,
  Apagar,
  STOP,
  MANUALIZ,
  SUBIDA,
  BAJADA,
  IZQUIERDA,
  DERECHA,
  MANUALDE,
  SUBIDAD,
  BAJADAD,
  IZQUIERDAD,
  DERECHAD,
  AUTOMATICO,
  HORIZONTAL,
  VERTICAL,
}

class Trama {
  final List<int> trama;

  Trama(TramaType type) : trama = _tramas[type] ?? [];

  Uint8List toBytes() {
    return Uint8List.fromList(trama);
  }

  static final Map<TramaType, List<int>> _tramas = {
    TramaType.Encender: [36, 49, 49, 49, 49, 49, 35],
    TramaType.Apagar: [36, 48, 48, 48, 48, 48, 35],
    TramaType.STOP: [36, 49, 120, 49, 120, 84, 35],
    TramaType.MANUALIZ: [36,49,77,49,49,120,35],
    TramaType.SUBIDA: [36,49,77,120,49,83,35],
    TramaType.BAJADA: [36,49,77,120,49,66,35],
    TramaType.IZQUIERDA: [36, 49, 77, 120, 49, 73, 35],
    TramaType.DERECHA: [36,49,77,120,49,68,35],
    TramaType.MANUALDE: [36,49,77,49,50,120,35],
    TramaType.SUBIDAD: [36, 49, 77, 120, 50, 83, 35],
    TramaType.BAJADAD: [36,49,77,120,50,66,35],
    TramaType.IZQUIERDAD: [36,49,77,120,50,73,35],
    TramaType.DERECHAD: [36,49,77,120,50,68,35],
    TramaType.AUTOMATICO: [36,49,65,49,120,120,35],
    TramaType.HORIZONTAL: [36,49,65,72,120,120,35],
    TramaType.VERTICAL: [36,49,65,86,120,120,35],
  };
}
/* 
  TRAMA_ENCENDIDO = new Uint8Array([36,49,49,49,49,49,35]);
  TRAMA_APAGADO = new Uint8Array([36,48,48,48,48,48,35]);
  TRAMA_STOP = new Uint8Array([36,49,120,49,120,84,35]);
  
  TRAMA_MANUAL_IZQUIERDA = new Uint8Array([36,49,77,49,49,120,35]);
  TRAMA_MANUAL_IZQUIERDA_ARRIBA = new Uint8Array([36,49,77,120,49,83,35]);
  TRAMA_MANUAL_IZQUIERDA_ABAJO = new Uint8Array([36,49,77,120,49,66,35]);
  TRAMA_MANUAL_IZQUIERDA_IZQUIERDA = new Uint8Array([36,49,77,120,49,73,35]);
  TRAMA_MANUAL_IZQUIERDA_DERECHA = new Uint8Array([36,49,77,120,49,68,35]);

  TRAMA_MANUAL_DERECHA = new Uint8Array([36,49,77,49,50,120,35]);
  TRAMA_MANUAL_DERECHA_ARRIBA = new Uint8Array([36,49,77,120,50,83,35]);
 
 */