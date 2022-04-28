import 'package:flutter/material.dart';
import 'package:fhir/dstu2.dart';
import 'package:fhir_auth/dstu2.dart';

import 'scopes.dart';
import 'request.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static bool switchWidget = false;

  @override
  Widget build(BuildContext context) {
    final currentUri = Uri.base;
    final fhirCallback = Uri(
      host: currentUri.host,
      scheme: currentUri.scheme,
      port: currentUri.port,
      path: '/redirect.html',
    );
    print(fhirCallback);

    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        // home: const RandomWords(),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Smart on FHIR'),
            ),
            body: Container(
              child: FhirWidget(),
              // child: (switchWidget)
              //     ? fireConnector()
              //     : myButton(),
            )
        )
    );
  }
}

class FhirWidget extends StatefulWidget {
  const FhirWidget({Key? key}) : super(key: key);

  @override
  State<FhirWidget> createState() => _FhirWidgetState();
}

class _FhirWidgetState extends State<FhirWidget> {
  int _count = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    setState(() => {
                      _count = 1
                    }),
                    print(_count)
                  },
                  child: const Text('Connect'),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: fireConnector(_count),
                ),
              ],
            )
        )
    );
  }

  Widget fireConnector(int count) {
    if(count == 0) {
      return const Text('Please Connect');
    } else if (count == 1) {
      // From Vars
      const clientId = CLIENT_ID;
      const iss = ISS;

      final currentUri = Uri.base;
      final fhirCallback = Uri(
        host: currentUri.host,
        scheme: currentUri.scheme,
        port: currentUri.port,
        path: '',
      );
      print('Redirect: $fhirCallback');

      if (clientId == null) {
        return const MaterialApp(
            home: Scaffold(
                body: Padding(
                    padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                    child: Text('No Client ID was supplied'))));
      } else {
        final client = SmartClient.getSmartClient(
          fhirUri: FhirUri(iss),
          clientId: clientId,
          redirectUri: FhirUri(fhirCallback),
          scopes: scopes.scopesList(),
        );
        final result = request(client);
        return MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16,30,16,0),
              child: FutureBuilder<Resource?>(
                  future: result,
                  builder: (BuildContext context, AsyncSnapshot<Resource?> snapshot) {
                    List<Widget> children;
                    if(snapshot.hasData && snapshot.data is Patient) {
                      children = <Widget>[
                        const Text('Request was successful'),
                        Text(
                            'Last Name: ${(snapshot.data as Patient).name?[0].family}'),
                        Text(
                            'Given Names: ${(snapshot.data as Patient).name?[0].given?.join(" ")}'),
                        Text('ID: ${(snapshot.data as Patient).id}'),
                        const Text('ISS: $iss'),
                      ];
                    } else if (iss == null){
                      children = [
                        const Text('App Was Not Launched from an EHR'),
                      ];
                    } else  {
                      children = [
                        const Text('Please login'),
                        const CircularProgressIndicator(),
                      ];
                    }
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: children,
                        )
                    );
                  }
              ),
            ),
          ),
        );
      }
    } else {
      return Container();
    }

  }
}