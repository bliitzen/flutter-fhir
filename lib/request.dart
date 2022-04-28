import 'package:fhir/dstu2.dart';
import 'package:fhir_auth/dstu2.dart';

Future<Resource?> request(SmartClient client) async {
  await client.login();

  print('Patient launch context Id: ${client.patientId}');

  final request = FhirRequest.read(
    base: client.fhirUri?.value ?? Uri.parse('127.0.0.1'),
    type: Dstu2ResourceType.Patient,
    id: Id(client.patientId),
    client: client,
  );
  try {
    final response = await request.request();
    print(response);
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}