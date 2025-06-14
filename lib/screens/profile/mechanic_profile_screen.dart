import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/widgets/rating_bar.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';

class MechanicProfileScreen extends StatefulWidget {
=======
import 'package:mechanic_discovery_app/models/user_model.dart';

class MechanicProfileScreen extends StatelessWidget {
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  final UserModel mechanic;
  const MechanicProfileScreen({Key? key, required this.mechanic})
    : super(key: key);

  @override
<<<<<<< HEAD
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  late TextEditingController _specializationController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _specializationController = TextEditingController(
      text: widget.mechanic.specialization ?? '',
    );
    _phoneController = TextEditingController(text: widget.mechanic.phone ?? '');
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isCurrentUser = authProvider.user?.id == widget.mechanic.id;
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mechanic.username),
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditProfileDialog(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.mechanic.avatarUrl != null
                    ? NetworkImage(widget.mechanic.avatarUrl!) as ImageProvider
                    : const AssetImage('assets/default_avatar.png'),
                child: widget.mechanic.avatarUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildProfileSection(context, 'Personal Information', [
              _buildListTile(
                Icons.person,
                'Username',
                widget.mechanic.username,
              ),
              _buildListTile(Icons.email, 'Email', widget.mechanic.email),
              _buildListTile(
                Icons.phone,
                'Phone',
                widget.mechanic.phone ?? 'Not set',
              ),
              _buildListTile(
                Icons.work,
                'Specialization',
                widget.mechanic.specialization ?? 'General Mechanic',
              ),
            ]),

            const SizedBox(height: 24),
            _buildProfileSection(context, 'Professional Stats', [
              _buildStatTile(
                Icons.star_rate_rounded,
                'Rating',
                widget.mechanic.rating?.toStringAsFixed(1) ?? 'N/A',
                widget.mechanic.rating != null
                    ? RatingBar(rating: widget.mechanic.rating!)
                    : null,
              ),
              _buildListTile(
                Icons.location_on,
                'Location',
                locationProvider.currentPosition != null && isCurrentUser
                    ? '${locationProvider.currentPosition!.latitude.toStringAsFixed(4)}, '
                          '${locationProvider.currentPosition!.longitude.toStringAsFixed(4)}'
                    : 'Not set',
              ),
              _buildStatTile(
                Icons.handyman,
                'Services Completed',
                '24', // Would come from backend
                null,
              ),
            ]),

            const SizedBox(height: 24),
            _buildProfileSection(context, 'Availability', [
              _buildAvailabilityStatus('Monday - Friday', '8:00 AM - 6:00 PM'),
              _buildAvailabilityStatus('Saturday', '9:00 AM - 4:00 PM'),
              _buildAvailabilityStatus('Sunday', 'Not Available'),
            ]),

            if (isCurrentUser) ...[
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Update Location'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/update-location'),
                ),
              ),
            ],
=======
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mechanic.username)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mechanic Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('Name: ${mechanic.username}'),
            Text('Email: ${mechanic.email}'),
            Text('Specialization: ${mechanic.specialization ?? 'N/A'}'),
            Text('Rating: ${mechanic.rating?.toStringAsFixed(1) ?? 'N/A'}'),
            // Add more fields as needed
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildProfileSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildStatTile(
    IconData icon,
    String title,
    String value,
    Widget? extra,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value),
          if (extra != null) ...[const SizedBox(height: 4), extra],
        ],
      ),
    );
  }

  Widget _buildAvailabilityStatus(String days, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(days, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(hours, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  hintText: 'e.g., Engine Specialist',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().updateProfile(
                _specializationController.text,
                _phoneController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
}
