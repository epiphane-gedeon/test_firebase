import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/teacher_providers.dart';
import '../../data/models/teacher_model.dart';

class AddEditTeacherScreen extends ConsumerStatefulWidget {
  final String? teacherId;

  const AddEditTeacherScreen({super.key, this.teacherId});

  @override
  ConsumerState<AddEditTeacherScreen> createState() =>
      _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends ConsumerState<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _officeController = TextEditingController();

  String? _selectedDepartment;
  DateTime? _hireDate;
  bool _isLoading = false;

  final List<String> _departments = [
    'Mathématiques',
    'Français',
    'Sciences',
    'Histoire-Géographie',
    'Langues',
    'Arts',
    'Sport',
    'Informatique',
  ];

  bool get isEditing => widget.teacherId != null;

  @override
  void initState() {
    super.initState();
    _hireDate = DateTime.now();

    if (isEditing) {
      _loadTeacherData();
    }
  }

  Future<void> _loadTeacherData() async {
    try {
      final repository = ref.read(teacherRepositoryProvider);
      final teacher = await repository.getTeacherById(widget.teacherId!);

      if (teacher != null && mounted) {
        setState(() {
          _firstNameController.text = teacher.firstName;
          _lastNameController.text = teacher.lastName;
          _emailController.text = teacher.email;
          _phoneController.text = teacher.phoneNumber ?? '';
          _officeController.text = teacher.office ?? '';
          _selectedDepartment = teacher.department;
          _hireDate = teacher.hireDate;
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _officeController.dispose();
    super.dispose();
  }

  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(teacherRepositoryProvider);

      final teacher = TeacherModel(
        id:
            widget.teacherId ??
            FirebaseFirestore.instance.collection('teachers').doc().id,
        userId: widget.teacherId ?? '', // TODO: Générer un userId approprié
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        office: _officeController.text.trim().isEmpty
            ? null
            : _officeController.text.trim(),
        department: _selectedDepartment,
        hireDate: _hireDate!,
        subjectIds: [], // TODO: Permettre la sélection des matières
        classIds: [], // TODO: Permettre la sélection des classes
      );

      if (isEditing) {
        await repository.updateTeacher(teacher);
      } else {
        await repository.createTeacher(teacher);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Enseignant modifié avec succès !'
                  : 'Enseignant créé avec succès !',
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

  Future<void> _selectHireDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _hireDate) {
      setState(() {
        _hireDate = picked;
      });
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
                'Seuls les administrateurs peuvent gérer les enseignants',
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
        title: Text(
          isEditing ? 'Modifier l\'enseignant' : 'Créer un enseignant',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
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
                        'Informations Personnelles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Prénom
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le prénom est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nom
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'L\'email est obligatoire';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Format d\'email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Téléphone
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations Professionnelles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Département
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDepartment,
                        decoration: const InputDecoration(
                          labelText: 'Département',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: _departments.map((department) {
                          return DropdownMenuItem(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bureau
                      TextFormField(
                        controller: _officeController,
                        decoration: const InputDecoration(
                          labelText: 'Bureau',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.room),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date d'embauche
                      InkWell(
                        onTap: _selectHireDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date d\'embauche *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _hireDate != null
                                ? '${_hireDate!.day}/${_hireDate!.month}/${_hireDate!.year}'
                                : 'Sélectionner une date',
                          ),
                        ),
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
                      onPressed: _isLoading ? null : _saveTeacher,
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
