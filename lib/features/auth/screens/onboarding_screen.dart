/// onboarding_screen.dart
/// Écran d'onboarding pour présenter l'app et ses fonctionnalités.
/// Propose plusieurs slides, un bouton "Commencer", et la connexion rapide via Google/GitHub.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      imageAsset: 'assets/images/illustrations/onboarding1.png',
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/illustrations/onboarding2.png',
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/illustrations/onboarding3.png',
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/illustrations/onboarding4.png',
      titleKey: 'onboarding_title_4',
      descriptionKey: 'onboarding_desc_4',
    ),
  ];

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      context.go('/home'); // pour une navigation "remplacement";
    } catch (e) {
      setState(() => _errorMessage = 'Erreur Google sign-in : $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loginWithGithub() async {
    setState(() => _isLoading = true);
    try {
      final githubProvider = GithubAuthProvider();
      await FirebaseAuth.instance.signInWithProvider(githubProvider);
      if (!mounted) return;
      context.go('/home'); // pour une navigation "remplacement"
    } catch (e) {
      setState(() => _errorMessage = 'Erreur GitHub sign-in : $e');
    }
    setState(() => _isLoading = false);
  }

  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _currentIndex == _pages.length - 1;
    final locale = context.locale;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: locale,
                  icon: const Icon(Icons.language),
                  items: [
                    DropdownMenuItem(
                      value: const Locale('fr'),
                      child:
                          Text('Français', style: theme.textTheme.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text('English', style: theme.textTheme.bodyMedium),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) _changeLanguage(value);
                  },
                ),
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) => _pages[index],
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (idx) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == idx ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == idx
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isLast) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                context.go('/signup');
                              },
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text('onboarding_get_started'.tr()),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Séparateur avec texte centré
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "onboarding_or_continue_with"
                                .tr(), // ou "Ou continuer avec"
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Boutons sociaux côte à côte
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Image.asset('assets/icons/google_logo.png',
                                height: 24),
                            label: const Text("Google"),
                            onPressed: _isLoading ? null : _loginWithGoogle,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Image.asset('assets/icons/github_logo.png',
                                height: 24),
                            label: const Text("Github"),
                            onPressed: _isLoading ? null : _loginWithGithub,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              context.go('/login');
                            },
                      child: Text('onboarding_already_account'.tr()),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex < _pages.length - 1) {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease);
                          }
                        },
                        child: Text('onboarding_next'.tr()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_currentIndex > 0 && !isLast)
              Positioned(
                top: 20,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String titleKey;
  final String descriptionKey;

  const _OnboardingPage({
    required this.imageAsset,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 160,
            child: Image.asset(imageAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 32),
          Text(
            titleKey.tr(),
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            descriptionKey.tr(),
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
