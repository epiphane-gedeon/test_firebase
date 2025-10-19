import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/student_providers.dart';
import '../../data/models/student_model.dart';
import '../../domain/entities/student_entity.dart';

class AddEditStudentScreen extends ConsumerStatefulWidget {
  final StudentEntity? student;

  const AddEditStudentScreen({super.key, this.student});

  bool get isEditing => student != null;

  @override
  ConsumerState<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends ConsumerState<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _parentEmailController = TextEditingController();
  final _classIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  DateTime? _selectedEnrollmentDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _fillFormWithStudentData();
    } else {
      _selectedEnrollmentDate = DateTime.now();
    }
  }

  void _fillFormWithStudentData() {
    final student = widget.student!;
    _firstNameController.text = student.firstName;
    _lastNameController.text = student.lastName;
    _parentEmailController.text = student.parentEmail ?? '';
    _classIdController.text = student.classId;
    _phoneNumberController.text = student.phoneNumber ?? '';
    _addressController.text = student.address ?? '';
    _selectedDateOfBirth = student.dateOfBirth;
    _selectedEnrollmentDate = student.enrollmentDate;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _parentEmailController.dispose();
    _classIdController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repository = ref.read(studentRepositoryProvider);
    final studentId = widget.isEditing ? widget.student!.id : DateTime.now().millisecondsSinceEpoch.toString();

    final student = StudentModel(
      id: studentId,
      userId: widget.isEditing ? widget.student!.userId : '', // Dans un vrai projet, lier à un User
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      parentEmail: _parentEmailController.text.trim().isEmpty ? null : _parentEmailController.text.trim(),
      classId: _classIdController.text.trim(),
      enrollmentDate: _selectedEnrollmentDate!,
      dateOfBirth: _selectedDateOfBirth,
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim(),
    );

    final result = widget.isEditing
        ? await repository.updateStudent(student)
        : await repository.createStudent(student);

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $error')),
        );
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditing 
                ? 'Étudiant modifié avec succès' 
                : 'Étudiant créé avec succès'),
          ),
        );
        context.pop();
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final initialDate = isBirthDate 
        ? _selectedDateOfBirth ?? DateTime(DateTime.now().year - 15)
        : _selectedEnrollmentDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isBirthDate ? DateTime(1900) : DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _selectedDateOfBirth = picked;
        } else {
          _selectedEnrollmentDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier l\'étudiant' : 'Ajouter un étudiant'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteStudent,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextFormField(
                      controller: _firstNameController,
                      label: 'Prénom *',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le prénom est obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _lastNameController,
                      label: 'Nom *',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom est obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _parentEmailController,
                      label: 'Email du parent',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && !value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _classIdController,
                      label: 'Classe *',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La classe est obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      label: 'Date de naissance',
                      date: _selectedDateOfBirth,
                      onTap: () => _selectDate(context, true),
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      label: "Date d'inscription *",
                      date: _selectedEnrollmentDate,
                      onTap: () => _selectDate(context, false),
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _phoneNumberController,
                      label: 'Numéro de téléphone',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _addressController,
                      label: 'Adresse',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(widget.isEditing ? 'Modifier' : 'Créer'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date != null 
              ? '${date.day}/${date.month}/${date.year}'
              : 'Sélectionner une date',
          style: TextStyle(
            color: date != null ? Colors.black87 : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteStudent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet étudiant ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      
      final repository = ref.read(studentRepositoryProvider);
      final result = await repository.deleteStudent(widget.student!.id);

      setState(() => _isLoading = false);

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $error')),
          );
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Étudiant supprimé avec succès')),
          );
          context.pop();
        },
      );
    }
  }
}