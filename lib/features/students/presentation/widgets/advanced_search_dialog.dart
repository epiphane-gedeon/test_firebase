import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_search_provider.dart';

class AdvancedSearchDialog extends ConsumerStatefulWidget {
  const AdvancedSearchDialog({super.key});

  @override
  ConsumerState<AdvancedSearchDialog> createState() => _AdvancedSearchDialogState();
}

class _AdvancedSearchDialogState extends ConsumerState<AdvancedSearchDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String? _selectedClass;

  @override
  void initState() {
    super.initState();
    final searchState = ref.read(studentSearchProvider);
    _nameController = TextEditingController(text: searchState.searchQuery);
    _emailController = TextEditingController();
    _selectedClass = searchState.selectedClass;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableClasses = ref.watch(availableClassesProvider);
    final searchState = ref.watch(studentSearchProvider);

    return AlertDialog(
      title: const Text('Recherche Avancée'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom ou prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email du parent',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: searchState.selectedClass,
              decoration: InputDecoration(
                hintText: 'Toutes les classes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Toutes les classes'),
                ),
                ...availableClasses.map((classId) {
                  return DropdownMenuItem(
                    value: classId,
                    child: Text(classId),
                  );
                }),
              ],
              onChanged: (value) {
                ref.read(studentSearchProvider.notifier).updateClass(value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            _applyAdvancedSearch();
            Navigator.of(context).pop();
          },
          child: const Text('Appliquer'),
        ),
      ],
    );
  }


  void _applyAdvancedSearch() {
    final searchQuery = _nameController.text;
    
    final notifier = ref.read(studentSearchProvider.notifier);
    notifier.updateSearch(searchQuery);
    notifier.updateClass(_selectedClass);
  }
}