import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/class_providers.dart';
import '../../data/models/class_model.dart';

class AddEditClassScreen extends ConsumerStatefulWidget {
  final String? classId;

  const AddEditClassScreen({super.key, this.classId});

  @override
  ConsumerState<AddEditClassScreen> createState() => _AddEditClassScreenState();
}

class _AddEditClassScreenState extends ConsumerState<AddEditClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _maxStudentsController = TextEditingController();

  String _selectedGrade = 'CP';
  int _academicYear = DateTime.now().year;
  bool _isLoading = false;

  final List<String> _grades = [
    'CP',
    'CE1',
    'CE2',
    'CM1',
    'CM2',
    '6ème',
    '5ème',
    '4ème',
    '3ème',
    'Seconde',
    'Première',
    'Terminale',
  ];

  bool get isEditing => widget.classId != null;

  @override
  void initState() {
    super.initState();
    _maxStudentsController.text = '30';

    // Si on édite, charger les données de la classe
    if (isEditing) {
      _loadClassData();
    }
  }

  Future<void> _loadClassData() async {
    try {
      final repository = ref.read(classRepositoryProvider);
      final classModel = await repository.getClassById(widget.classId!);

      if (classModel != null && mounted) {
        setState(() {
          _nameController.text = classModel.name;
          _selectedGrade = classModel.grade;
          _academicYear = classModel.academicYear;
          _maxStudentsController.text = classModel.maxStudents.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _maxStudentsController.dispose();
    super.dispose();
  }

  Future<void> _saveClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(classRepositoryProvider);

      final classModel = ClassModel(
        id:
            widget.classId ??
            FirebaseFirestore.instance.collection('classes').doc().id,
        name: _nameController.text.trim(),
        grade: _selectedGrade,
        academicYear: _academicYear,
        maxStudents: int.parse(_maxStudentsController.text),
        studentIds: [], // Pour une nouvelle classe, pas d'étudiants
        courseIds: [], // Pour une nouvelle classe, pas de cours
      );

      if (isEditing) {
        await repository.updateClass(classModel);
      } else {
        await repository.createClass(classModel);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Classe modifiée avec succès !'
                  : 'Classe créée avec succès !',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    // Vérifier que l'utilisateur est admin
    if (currentUser?.role.name != 'admin') {
      return Scaffold(
        appBar: AppBar(title: const Text('Accès refusé')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Seuls les administrateurs peuvent gérer les classes',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la classe' : 'Créer une classe'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations de la classe',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Nom de la classe
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de la classe *',
                          hintText: 'Ex: CP-A, 6ème-1, Terminale S1',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom de la classe est obligatoire';
                          }
                          if (value.length < 2) {
                            return 'Le nom doit contenir au moins 2 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Niveau/Grade
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGrade,
                        decoration: const InputDecoration(
                          labelText: 'Niveau *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.school),
                        ),
                        items: _grades.map((grade) {
                          return DropdownMenuItem(
                            value: grade,
                            child: Text(grade),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGrade = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Année académique
                      DropdownButtonFormField<int>(
                        initialValue: _academicYear,
                        decoration: const InputDecoration(
                          labelText: 'Année académique *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: List.generate(5, (index) {
                          final year = DateTime.now().year - 2 + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year-${year + 1}'),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _academicYear = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nombre maximum d'étudiants
                      TextFormField(
                        controller: _maxStudentsController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre maximum d\'étudiants *',
                          hintText: '30',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nombre maximum d\'étudiants est obligatoire';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Veuillez entrer un nombre valide';
                          }
                          if (number > 50) {
                            return 'Le nombre maximum ne peut pas dépasser 50';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveClass,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Modifier' : 'Créer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
