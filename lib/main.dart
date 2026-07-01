import 'package:flutter/material.dart';

void main() {
  runApp(const OrganizadorVidaApp());
}

class OrganizadorVidaApp extends StatelessWidget {
  const OrganizadorVidaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusLife Semanal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const HorarioScreen(),
    );
  }
}

// ==========================================
// MODELO DE DATOS DE ACTIVIDAD
// ==========================================
class Actividad {
  String id;
  String nombre;
  String horaInicio;
  String horaFin;
  bool completado;
  String diaSemana;

  Actividad({
    required this.id,
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    this.completado = false,
    required this.diaSemana,
  });
}

// ==========================================
// PANTALLA PRINCIPAL: HORARIO SEMANAL
// ==========================================
class HorarioScreen extends StatefulWidget {
  const HorarioScreen({Key? key}) : super(key: key);

  @override
  _HorarioScreenState createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  String _diaSeleccionado = 'Lunes'; 
  final List<String> _diasDeLaSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  late List<Actividad> _actividades;

  @override
  void initState() {
    super.initState();
    _cargarActividadesBase();
  }

  void _cargarActividadesBase() {
    _actividades = [];
    int contadorId = 1;
    
    for (var dia in _diasDeLaSemana) {
      _actividades.addAll([
        Actividad(id: 'base_${contadorId++}', nombre: 'Tender la cama', horaInicio: '06:00 AM', horaFin: '06:05 AM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Ventilar el cuarto', horaInicio: '06:05 AM', horaFin: '06:10 AM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Lectio Divina', horaInicio: '06:10 AM', horaFin: '06:30 AM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Desayuno', horaInicio: '07:30 AM', horaFin: '08:00 AM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Estudiar APU / S10 / Project', horaInicio: '08:30 AM', horaFin: '11:30 AM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Almuerzo', horaInicio: '01:00 PM', horaFin: '02:00 PM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Cena', horaInicio: '07:30 PM', horaFin: '08:00 PM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Cambiar ropa interior y medias', horaInicio: '08:00 PM', horaFin: '08:05 PM', diaSemana: dia),
        Actividad(id: 'base_${contadorId++}', nombre: 'Cepillarte antes de dormir', horaInicio: '10:15 PM', horaFin: '10:25 PM', diaSemana: dia),
      ]);

      if (dia == 'Martes' || dia == 'Viernes') {
        _actividades.addAll([
          Actividad(id: 'base_${contadorId++}', nombre: 'Bañarse', horaInicio: '06:35 AM', horaFin: '06:55 AM', diaSemana: dia),
          Actividad(id: 'base_${contadorId++}', nombre: 'Cambiar polo interior', horaInicio: '06:55 AM', horaFin: '07:00 AM', diaSemana: dia),
          Actividad(id: 'base_${contadorId++}', nombre: 'Revisar ropa de casa', horaInicio: '07:00 AM', horaFin: '07:10 AM', diaSemana: dia),
        ]);
      }

      if (dia == 'Domingo') {
        _actividades.addAll([
          Actividad(id: 'base_${contadorId++}', nombre: 'Lavar ropa', horaInicio: '08:00 AM', horaFin: '10:00 AM', diaSemana: dia),
          Actividad(id: 'base_${contadorId++}', nombre: 'Ordenar ropero', horaInicio: '10:00 AM', horaFin: '11:00 AM', diaSemana: dia),
          Actividad(id: 'base_${contadorId++}', nombre: 'Limpiar un poco el cuarto', horaInicio: '11:00 AM', horaFin: '12:00 PM', diaSemana: dia),
        ]);
      }
    }
  }

  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();

  void _guardarActividad(Actividad? actividadAEditar) {
    if (_nombreController.text.isEmpty || _inicioController.text.isEmpty || _finController.text.isEmpty) {
      return;
    }

    setState(() {
      if (actividadAEditar != null) {
        final index = _actividades.indexWhere((element) => element.id == actividadAEditar.id);
        if (index != -1) {
          _actividades[index].nombre = _nombreController.text;
          _actividades[index].horaInicio = _inicioController.text;
          _actividades[index].horaFin = _finController.text;
        }
      } else {
        _actividades.add(
          Actividad(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            nombre: _nombreController.text,
            horaInicio: _inicioController.text,
            horaFin: _finController.text,
            diaSemana: _diaSeleccionado,
          ),
        );
      }
    });

    _nombreController.clear();
    _inicioController.clear();
    _finController.clear();
    Navigator.pop(context);
  }

  void _eliminarActividad(String id) {
    setState(() {
      _actividades.removeWhere((act) => act.id == id);
    });
  }

  void _moverActividad(int indexActual, int desplazamiento, List<Actividad> listaFiltrada) {
    int nuevoIndex = indexActual + desplazamiento;
    if (nuevoIndex < 0 || nuevoIndex >= listaFiltrada.length) return;

    setState(() {
      final item = listaFiltrada.removeAt(indexActual);
      listaFiltrada.insert(nuevoIndex, item);

      final deOtrosDias = _actividades.where((act) => act.diaSemana != _diaSeleccionado).toList();
      _actividades = [...deOtrosDias, ...listaFiltrada];
    });
  }

  void _reiniciarSemana() {
    setState(() {
      for (var act in _actividades) {
        act.completado = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Progreso reseteado! Los checks vuelven a cero.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actividadesDelDia = _actividades.where((act) => act.diaSemana == _diaSeleccionado).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MI RITMO SEMANAL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            tooltip: 'Reiniciar progreso',
            onPressed: _reiniciarSemana,
          )
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              children: _diasDeLaSemana.map((dia) {
                final esSeleccionado = _diaSeleccionado == dia;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(dia, style: TextStyle(color: esSeleccionado ? Colors.black : Colors.white)),
                    selected: esSeleccionado,
                    selectedColor: const Color(0xFFFFD700),
                    backgroundColor: const Color(0xFF1E1E1E),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _diaSeleccionado = dia;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: actividadesDelDia.isEmpty
                ? const Center(child: Text('Día libre.', style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: actividadesDelDia.length,
                    itemBuilder: (context, index) {
                      final actividad = actividadesDelDia[index];
                      return Dismissible(
                        key: Key(actividad.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          child: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _eliminarActividad(actividad.id),
                        child: Card(
                          color: const Color(0xFF1E1E1E),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: actividad.completado,
                                  activeColor: const Color(0xFFFFD700),
                                  checkColor: Colors.black,
                                  onChanged: (bool? valor) {
                                    setState(() {
                                      actividad.completado = valor ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_upward, size: 16, color: Colors.white38),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: index == 0 ? null : () => _moverActividad(index, -1, actividadesDelDia),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_downward, size: 16, color: Colors.white38),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: index == actividadesDelDia.length - 1 ? null : () => _moverActividad(index, 1, actividadesDelDia),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        actividad.nombre,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decoration: actividad.completado ? TextDecoration.lineThrough : null,
                                          color: actividad.completado ? Colors.white38 : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF121212),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Text(
                                    '${actividad.horaInicio} - ${actividad.horaFin}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: Colors.white54),
                                  onPressed: () => _mostrarModalFormulario(context, actividad),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () => _mostrarModalFormulario(context, null),
      ),
    );
  }

  void _mostrarModalFormulario(BuildContext context, Actividad? actividadAEditar) {
    if (actividadAEditar != null) {
      _nombreController.text = actividadAEditar.nombre;
      _inicioController.text = actividadAEditar.horaInicio;
      _finController.text = actividadAEditar.horaFin;
    } else {
      _nombreController.clear();
      _inicioController.clear();
      _finController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                actividadAEditar != null ? 'Editar Actividad' : 'Nueva Actividad para: $_diaSeleccionado',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la actividad', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inicioController,
                      decoration: const InputDecoration(labelText: 'Hora Inicio (Ej: 06:15 AM)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _finController,
                      decoration: const InputDecoration(labelText: 'Hora Fin (Ej: 06:30 AM)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _guardarActividad(actividadAEditar),
                child: Text(
                  actividadAEditar != null ? 'Actualizar Cambios' : 'Guardar Actividad', 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}