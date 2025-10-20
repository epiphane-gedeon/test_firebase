import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final TeacherModel teacher;
  final VoidCallback? onTap;
  final bool showMenu;

  const TeacherCard({
    super.key,
    required this.teacher,
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
          backgroundColor: _getDepartmentColor(teacher.department),
          child: Text(
            _getInitials(teacher.fullName),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          teacher.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (teacher.department != null)
              Text('Département: ${teacher.department}'),
            Text('Classes: ${teacher.classIds.length}'),
            Text('Email: ${teacher.email}'),
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

  String _getInitials(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  Color _getDepartmentColor(String? department) {
    if (department == null) return Colors.grey;

    switch (department.toLowerCase()) {
      case 'mathématiques':
      case 'maths':
        return Colors.blue;
      case 'français':
      case 'littérature':
        return Colors.green;
      case 'sciences':
      case 'physique':
      case 'chimie':
        return Colors.orange;
      case 'histoire':
      case 'géographie':
        return Colors.brown;
      case 'langues':
      case 'anglais':
      case 'espagnol':
        return Colors.purple;
      case 'arts':
      case 'musique':
        return Colors.pink;
      case 'sport':
      case 'eps':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'details':
        context.pushNamed('teacher_detail', pathParameters: {'id': teacher.id});
        break;
      case 'edit':
        context.pushNamed('edit_teacher', pathParameters: {'id': teacher.id});
        break;
    }
  }
}
