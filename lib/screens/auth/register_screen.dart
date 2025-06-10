import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  String _userType = 'car_owner';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              DropdownButtonFormField<String>(
                value: _userType,
                items: const [
                  DropdownMenuItem(
                    value: 'car_owner',
                    child: Text('Car Owner'),
                  ),
                  DropdownMenuItem(value: 'mechanic', child: Text('Mechanic')),
                ],
                onChanged: (value) => setState(() => _userType = value!),
                decoration: const InputDecoration(labelText: 'User Type'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Register'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<AuthProvider>().register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _userType,
        _phoneController.text.trim(),
      );

      if (!mounted) return;

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ Delay slightly so user sees confirmation
      await Future.delayed(const Duration(milliseconds: 1200));
      
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return; 

      final cleanMessage = _extractCleanMessage(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $cleanMessage'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractCleanMessage(String error) {
    const prefix = 'Exception: ';
    return error.startsWith(prefix) ? error.substring(prefix.length) : error;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
