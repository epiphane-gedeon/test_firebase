import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/subject_providers.dart';
import '../../data/models/subject_model.dart';
import '../../../../core/providers/class_providers.dart';
import '../../../classes/data/models/class_model.dart';

class AddEditSubjectScreen extends ConsumerStatefulWidget {
  final String? subjectId;

  const AddEditSubjectScreen({super.key, this.subjectId});

  @override
  ConsumerState<AddEditSubjectScreen> createState() =>
      _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends ConsumerState<AddEditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedDepartment = 'Mathématiques';
  int _creditHours = 1;
  ClassModel? _selectedClass;
  bool _isLoading = false;

  final List<String> _departments = [
    'Mathématiques',
    'Sciences',
    'Langues',
    'Histoire-Géographie',
    'Arts',
    'Sport',
    'Informatique',
  ];
  bool get _isEditing => widget.subjectId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadSubjectData();
    }
  }

  void _loadSubjectData() async {
    final subject = await ref.read(
      subjectByIdProvider(widget.subjectId!).future,
    );
    if (subject != null && mounted) {
      setState(() {
        _nameController.text = subject.name;
        _descriptionController.text = subject.description;
        _selectedDepartment = subject.department;
        _creditHours = subject.creditHours;
        // Pour l'instant, nous ne chargeons pas la classe associée
        // car le modèle Subject ne contient pas cette information
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final subject = SubjectModel(
        id: widget.subjectId ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        department: _selectedDepartment,
        creditHours: _creditHours,
        prerequisiteIds: [], // Pour l'instant, pas de prérequis
      );

      if (_isEditing) {
        await ref.read(updateSubjectProvider)(subject);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Matière mise à jour avec succès')),
          );
        }
      } else {
        await ref.read(createSubjectProvider)(subject);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Matière créée avec succès')),
          );
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final classesAsyncValue = ref.watch(classesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la matière' : 'Nouvelle matière'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSubject,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    'Sauvegarder',
                    style: TextStyle(color: Colors.black),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations de la matière',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nom de la matière
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de la matière *',
                        hintText: 'Ex: Algèbre, Géométrie, Grammaire...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le nom de la matière est requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Département
                    DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Département *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _departments.map((department) {
                        return DropdownMenuItem(
                          value: department,
                          child: Text(department),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Classe associée
                    classesAsyncValue.when(
                      loading: () => DropdownButtonFormField<ClassModel>(
                        decoration: const InputDecoration(
                          labelText: 'Classe associée',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                        items: const [],
                        onChanged: null,
                      ),
                      error: (error, stack) => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Erreur lors du chargement des classes',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      data: (classes) => DropdownButtonFormField<ClassModel>(
                        value: _selectedClass,
                        decoration: const InputDecoration(
                          labelText: 'Classe associée',
                          hintText: 'Sélectionnez une classe (optionnel)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                        items: [
                          const DropdownMenuItem<ClassModel>(
                            value: null,
                            child: Text('Aucune classe spécifique'),
                          ),
                          ...classes.map((classModel) {
                            return DropdownMenuItem<ClassModel>(
                              value: classModel,
                              child: Text(
                                '${classModel.name} (${classModel.grade})',
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedClass = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description du contenu de la matière...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Heures de crédit
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Heures de crédit par semaine: $_creditHours h',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: _creditHours > 1
                              ? () => setState(() => _creditHours--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$_creditHours',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: _creditHours < 10
                              ? () => setState(() => _creditHours++)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Informations supplémentaires
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Informations',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• La matière sera disponible pour tous les enseignants du département sélectionné\n'
                      '• Vous pouvez associer une classe spécifique ou laisser disponible pour toutes les classes\n'
                      '• Les heures de crédit correspondent au volume horaire hebdomadaire\n'
                      '• Vous pourrez modifier ces informations plus tard',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
