import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final newPassword = _passwordController.text.trim();
      // Met à jour le mot de passe de l'utilisateur connecté (après avoir cliqué sur le lien reçu par email)
      await Supabase.instance.client.auth.updateUser(UserAttributes(password: newPassword));
      setState(() {
        _successMessage = "reset_password_success".tr(); // Utiliser la clé de localisation
      });
      // Rediriger vers la page de connexion après un court délai
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.goNamed('login');
        }
      });
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "error_unknown".tr(args: [e.toString()]); // Utiliser la clé de localisation
        debugPrint('ResetPasswordScreen Error: $e'); // Logger l'erreur pour le débogage
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('reset_title'.tr()),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: context.locale,
              icon: const Icon(Icons.language),
              items: [
                DropdownMenuItem(
                  value: const Locale('fr'),
                  child: Text('Français', style: theme.textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text('English', style: theme.textTheme.bodyMedium),
                ),
              ],
              onChanged: (value) {
                if (value != null) context.setLocale(value);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'reset_headline'.tr(),
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'reset_subtitle'.tr(),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'reset_password'.tr(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'reset_password_required'.tr();
                        }
                        if (value.length < 6) {
                          return 'reset_password_length'.tr();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordConfirmController,
                      decoration: InputDecoration(
                        labelText: 'reset_password_confirm'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      obscureText: _obscureConfirm,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'reset_password_confirm_required'.tr();
                        }
                        if (value != _passwordController.text) {
                          return 'reset_passwords_no_match'.tr();
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 18),
                    if (_successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _successMessage!,
                          style: const TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.lock_reset),
                        label: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text('reset_button'.tr()),
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _resetPassword();
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('reset_back_to'.tr()),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  context.goNamed('login'); // Utiliser la route nommée
                                },
                          child: Text('reset_login'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}