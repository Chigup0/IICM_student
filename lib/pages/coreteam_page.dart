import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CoreTeamPage extends StatelessWidget {
  const CoreTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Core Team',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _departmentSection('Overall Coordinators', [
                _TeamMember(
                  name: 'John Doe',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543210',
                  email: 'john@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Jane Smith',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543211',
                  email: 'jane@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Hospitality', [
                _TeamMember(
                  name: 'Alex Johnson',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543212',
                  email: 'alex@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Emma Wilson',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543213',
                  email: 'emma@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Events', [
                _TeamMember(
                  name: 'Chris Brown',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543214',
                  email: 'chris@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Sarah Davis',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543215',
                  email: 'sarah@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Mike Miller',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543216',
                  email: 'mike@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Finance', [
                _TeamMember(
                  name: 'Rachel Green',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543217',
                  email: 'rachel@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'David Lee',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543218',
                  email: 'david@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Show Management', [
                _TeamMember(
                  name: 'Lisa Anderson',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543219',
                  email: 'lisa@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Tom Harris',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543220',
                  email: 'tom@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Marketing', [
                _TeamMember(
                  name: 'Sophie Turner',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543221',
                  email: 'sophie@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'James Martin',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543222',
                  email: 'james@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Public Relations', [
                _TeamMember(
                  name: 'Olivia Martinez',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543223',
                  email: 'olivia@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Ryan Taylor',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543224',
                  email: 'ryan@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Media and Publicity', [
                _TeamMember(
                  name: 'Ava Thompson',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543225',
                  email: 'ava@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Ethan White',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543226',
                  email: 'ethan@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Security', [
                _TeamMember(
                  name: 'Mason Harris',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543227',
                  email: 'mason@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Isabella Clark',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543228',
                  email: 'isabella@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Design', [
                _TeamMember(
                  name: 'Lucas Rodriguez',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543229',
                  email: 'lucas@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Mia Lewis',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543230',
                  email: 'mia@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              _departmentSection('Web and App', [
                _TeamMember(
                  name: 'Noah Walker',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543231',
                  email: 'noah@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Charlotte Hall',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543232',
                  email: 'charlotte@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
                _TeamMember(
                  name: 'Benjamin Young',
                  image: 'https://via.placeholder.com/80',
                  phone: '+91 9876543233',
                  email: 'benjamin@example.com',
                  linkedin: 'https://linkedin.com',
                  instagram: 'https://instagram.com',
                ),
              ]),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _departmentSection(String title, List<_TeamMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryAccent,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...members.map((member) => _teamMemberTile(member)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _teamMemberTile(_TeamMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                member.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primaryAccent,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Name and Contact Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Phone
                  GestureDetector(
                    onTap: () {
                      // Open phone dialer
                      // Can implement with url_launcher package
                    },
                    child: Text(
                      member.phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  GestureDetector(
                    onTap: () {
                      // Open email client
                    },
                    child: Text(
                      member.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Social Media Icons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Open LinkedIn
                  },
                  child: Icon(
                    Icons.link,
                    color: AppColors.primaryAccent.withOpacity(0.7),
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Open Instagram
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.secondaryAccent.withOpacity(0.7),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _TeamMember {
  final String name;
  final String image;
  final String phone;
  final String email;
  final String linkedin;
  final String instagram;

  _TeamMember({
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    required this.linkedin,
    required this.instagram,
  });
}
