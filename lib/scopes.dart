import 'package:fhir/r4.dart';
import 'package:fhir_auth/dstu2.dart';

/// FHIR Scopes
final scopes = Scopes(
  clinicalScopes: [
    ClinicalScope(
        Role.patient,
        R4ResourceType.Patient,
        Interaction.any)
  ],
  openid: true,
  offlineAccess: true,
  ehrLaunch: true,
);