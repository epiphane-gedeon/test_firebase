import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/student_entity.dart';

class StudentCard extends StatelessWidget {
  final StudentEntity student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            student.firstName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Classe: ${student.classId}'),
            if (student.parentEmail != null)
              Text('Parent: ${student.parentEmail}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              context.pushNamed('edit_student', pathParameters: {'id': student.id});
            } else if (value == 'view') {
              context.pushNamed('student_detail', pathParameters: {'id': student.id});
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'view',
              child: ListTile(
                leading: Icon(Icons.visibility),
                title: Text('Voir détails'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Modifier'),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}