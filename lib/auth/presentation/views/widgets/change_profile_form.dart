import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweet_pal/auth/presentation/cubits/profile/profile_cubit.dart';

class ChangeProfileForm extends StatefulWidget {
  const ChangeProfileForm({super.key});

  @override
  State<ChangeProfileForm> createState() => _ChangeProfileFormState();
}

class _ChangeProfileFormState extends State<ChangeProfileForm> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _image != null
                    ? () => cubit.updateProfileImage(_image!)
                    : null,
                child: const Text('تحديث الصورة'),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'كلمة المرور الجديدة'),
                      validator: (value) =>
                          value != null && value.length < 6
                              ? 'كلمة المرور قصيرة'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirm,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                      validator: (value) =>
                          value != _password.text ? 'كلمتا المرور غير متطابقتين' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.changePassword(_password.text);
                        }
                      },
                      child: const Text('تغيير كلمة المرور'),
                    ),
                  ],
                ),
              ),
              if (state is ProfileLoading) const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
