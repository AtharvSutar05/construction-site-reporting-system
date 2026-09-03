import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/enums/site_status.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/sites/data/models/create_site_model.dart';
import 'package:frontend/features/sites/presentation/bloc/create_site/create_site_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/create_site/create_site_event.dart';
import 'package:frontend/features/sites/presentation/bloc/create_site/create_site_state.dart';
import 'package:go_router/go_router.dart';

class CreateSiteScreen extends StatefulWidget {
  const CreateSiteScreen({super.key});

  @override
  State<CreateSiteScreen> createState() => _CreateSiteScreenState();
}

class _CreateSiteScreenState extends State<CreateSiteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  SiteStatus _status = SiteStatus.active;

  late final FocusNode _codeFocusNode;
  late final FocusNode _descriptionFocusNode;
  late final FocusNode _statusFocusNode;
  late final FocusNode _addressFocusNode;
  late final FocusNode _cityFocusNode;
  late final FocusNode _stateFocusNode;

  @override
  void initState() {
    super.initState();
    _codeFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _statusFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _stateFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    _codeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _statusFocusNode.dispose();
    _addressFocusNode.dispose();
    _cityFocusNode.dispose();
    _stateFocusNode.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final site = CreateSiteModel(
      name: _nameController.text.trim(),
      code: _codeController.text.trim().toUpperCase(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: "India",
      latitude: _latitudeController.text.trim().isEmpty
          ? null
          : double.tryParse(_latitudeController.text.trim()),
      longitude: _longitudeController.text.trim().isEmpty
          ? null
          : double.tryParse(_longitudeController.text.trim()),
      status: _status,
    );
    context.read<CreateSiteBloc>().add(CreateSiteRequested(site: site));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateSiteBloc, CreateSiteState>(
      listener: (context, state) {
        if (state is CreateSiteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site created successfully'),
            ),
          );

          context.goNamed(RouteNames.siteDetail,
            pathParameters: {
              'siteId': state.siteId,
            },
          );
        }

        if (state is CreateSiteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Basic Information", style: AppTypography.heading2),
                const SizedBox(height: AppSpacing.s),
                _customCard(child: _basicInformationForm()),
                const SizedBox(height: AppSpacing.m),
                Text("Location", style: AppTypography.heading2),
                const SizedBox(height: AppSpacing.s),
                _customCard(child: _locationForm()),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  height: 64,
                  child: BlocBuilder<CreateSiteBloc, CreateSiteState>(
                    builder: (context, state) {
                      final isLoading = state is CreateSiteLoading ? true : false;
                      return FilledButton(
                        onPressed: isLoading ? null : () => _submit(),
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
                              "Creating Site...",
                            ),
                          ],
                        )
                        : Text(
                          "Create Site",
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _basicInformationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel("Site Name"),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyPrimary,
          decoration: const InputDecoration(hintText: "Riverside Tower"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Site name is required";
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_codeFocusNode);
          },
        ),
        const SizedBox(height: AppSpacing.m),
        _requiredLabel("Site Code"),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyPrimary,
          decoration: const InputDecoration(hintText: "SITE-01"),
          validator: (v) {
            final value = v?.trim() ?? '';
            if (value.isEmpty) {
              return 'Site code is required';
            }
            if (value.length > 50) {
              return 'Site code cannot exceed 50 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_descriptionFocusNode);
          },
        ),
        const SizedBox(height: AppSpacing.m),
        Text("Description", style: AppTypography.inputLabel),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          scrollPhysics: ScrollPhysics(),
          keyboardType: TextInputType.text,
          maxLines: 3,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyPrimary,
          decoration: const InputDecoration(
            hintText: "Brief description of the site",
          ),
          validator: (v) {
            final value = v?.trim() ?? '';
            if (value.length > 500) {
              return 'Description cannot exceed 500 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_statusFocusNode);
          },
        ),
        const SizedBox(height: AppSpacing.m),

        _requiredLabel("Status"),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<SiteStatus>(
          initialValue: _status,
          focusNode: _statusFocusNode,
          items: SiteStatus.values
              .map(
                (s) => DropdownMenuItem(value: s, child: Text(s.displayName)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _status = value);
          },
        ),
      ],
    );
  }

  Widget _locationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel("Address"),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: _addressController,
          keyboardType: TextInputType.name,
          focusNode: _addressFocusNode,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyPrimary,
          decoration: const InputDecoration(hintText: "Street address"),
          validator: (v) {
            final value = v?.trim() ?? '';
            if (value.length < 5) {
              return 'Address is required';
            }
            if (value.length > 500) {
              return 'Address cannot exceed 500 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_cityFocusNode);
          },
        ),
        const SizedBox(height: AppSpacing.m),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredLabel("City"),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _cityController,
                    keyboardType: TextInputType.name,
                    focusNode: _cityFocusNode,
                    textInputAction: TextInputAction.next,
                    style: AppTypography.bodyPrimary,
                    decoration: const InputDecoration(hintText: "eg. Mumbai"),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_stateFocusNode);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredLabel("State"),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _stateController,
                    keyboardType: TextInputType.name,
                    focusNode: _stateFocusNode,
                    textInputAction: TextInputAction.next,
                    style: AppTypography.bodyPrimary,
                    decoration: const InputDecoration(
                      hintText: "eg. Maharashtra",
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        _requiredLabel("Country"),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          initialValue: "India",
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyPrimary,
        ),
        const SizedBox(height: AppSpacing.m),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude", style: AppTypography.inputLabel),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                    style: AppTypography.bodyPrimary,
                    decoration: const InputDecoration(hintText: "-90 to 90"),
                    validator: (v) =>
                        _coordinateValidator(v, -90, 90, 'Latitude'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Longitude", style: AppTypography.inputLabel),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                    style: AppTypography.bodyPrimary,
                    decoration: const InputDecoration(hintText: "-180 to 180"),
                    validator: (v) =>
                        _coordinateValidator(v, -180, 180, 'Longitude'),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _requiredLabel(String text) {
    return Text.rich(
      TextSpan(
        text: text,
        style: AppTypography.inputLabel,
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  String? _coordinateValidator(
    String? v,
    double min,
    double max,
    String label,
  ) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; // optional field
    final parsed = double.tryParse(value);
    if (parsed == null) return 'Enter a valid number';
    if (parsed < min || parsed > max) {
      return '$label must be between $min and $max';
    }
    return null;
  }

  Widget _customCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.all(AppSpacing.m),
      child: child,
    );
  }
}
