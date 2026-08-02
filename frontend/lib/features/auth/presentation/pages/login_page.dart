import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final FocusNode _passwordFocusNode;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    TextInput.finishAutofillContext();

    context.read<AuthBloc>().add(
      LoginRequested(
        loginRequest: LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.sm,
                    ),
                  ),
                );
            }
            if (state is AuthAuthenticated) {
              context.go(RouteNames.dashboard);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome back", style: AppTypography.heading1),
                          const SizedBox(height: AppSpacing.s),
                          Text(
                            "Sign in to continue managing your construction projects.",
                            style: AppTypography.bodySecondary,
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          Text("Email", style: AppTypography.inputLabel),
                          const SizedBox(height: AppSpacing.s),
                          TextFormField(
                            controller: _emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.email,
                              AutofillHints.name,
                            ],
                            style: AppTypography.bodyPrimary,
                            decoration: const InputDecoration(
                              hintText: "example@gmail.com",
                              prefixIcon: Icon(Icons.email_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email is required";
                              }
                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          const SizedBox(height: AppSpacing.l),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Password", style: AppTypography.inputLabel),
                              TextButton(
                                onPressed: isLoading ? null : () {
                                  // TODO: navigate to forgot password flow
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: AppTypography.bodySecondary.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            focusNode: _passwordFocusNode,
                            enabled: !isLoading,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            style: AppTypography.bodyPrimary,
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                ),
                                onPressed: isLoading ? null : () {
                                  setState(
                                        () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              if (!isLoading) _onLoginPressed();
                            },
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onLoginPressed,
                              child: isLoading
                                  ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.m),
                                  const Text(
                                    "Signing In...",
                                    style: AppTypography.buttonLabel,
                                  ),
                                ],
                              )
                                  : Text(
                                "Sign In",
                                style: AppTypography.buttonLabel,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              const SizedBox(width: AppSpacing.s),
                              TextButton(
                                onPressed: isLoading ? null : () {
                                  context.go(RouteNames.register);
                                },
                                child: const Text("Create one"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}