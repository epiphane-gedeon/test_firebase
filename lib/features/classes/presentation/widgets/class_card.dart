import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/class_model.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final VoidCallback? onTap;
  final bool showMenu;

  const ClassCard({
    super.key,
    required this.classModel,
    this.onTap,
    this.showMenu = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getGradeColor(classModel.grade),
          child: Text(
            classModel.grade.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          classModel.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Niveau: ${classModel.grade}'),
            Text(
              'Année: ${classModel.academicYear}-${classModel.academicYear + 1}',
            ),
            Text(
              'Étudiants: ${classModel.studentIds.length}/${classModel.maxStudents}',
            ),
          ],
        ),
        trailing: showMenu
            ? PopupMenuButton<String>(
                onSelected: (value) => _handleMenuSelection(context, value),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 8),
                        Text('Voir détails'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                ],
              )
            : const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'details':
        context.pushNamed(
          'class_detail',
          pathParameters: {'id': classModel.id},
        );
        break;
      case 'edit':
        context.pushNamed('edit_class', pathParameters: {'id': classModel.id});
        break;
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'cp':
      case 'ce1':
      case 'ce2':
        return Colors.green;
      case 'cm1':
      case 'cm2':
        return Colors.blue;
      case '6ème':
      case '5ème':
      case '4ème':
      case '3ème':
        return Colors.orange;
      case 'seconde':
      case 'première':
      case 'terminale':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
