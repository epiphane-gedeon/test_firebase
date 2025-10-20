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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: _getColorByClass(student.classId),
                child: Text(
                  student.firstName[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Classe: ${student.classId}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    if (student.parentEmail != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Parent: ${student.parentEmail!}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Menu contextuel
              _buildContextMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenu(BuildContext context) {
    return PopupMenuButton<String>(
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
    );
  }

  Color _getColorByClass(String classId) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    
    final index = classId.hashCode % colors.length;
    return colors[index];
  }
}