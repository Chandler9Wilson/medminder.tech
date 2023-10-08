import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medminder/app_theme.dart';
import 'package:medminder/contact/cubit/emergency_contact_cubit.dart';
import 'package:medminder/main.dart';

class SmsButton extends StatefulWidget {
  const SmsButton({super.key});

  @override
  State<SmsButton> createState() => _SmsButtonState();
}

class _SmsButtonState extends State<SmsButton> {

  Widget space() {
    return const SizedBox(
      height: 10,
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send SMS'),
      ),
      body: BlocBuilder<EmergencyContactCubit, EmergencyContactState>(
        builder: (context, state) {
          if (state is EmergencyContactLoaded ||
              state is EmergencyContactInitial) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                        var uname = 'AC1f510a0c118eb6ab0701261e7827e108';
                        var pword = 'TODO';
                        var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

                        var headers = {
                          'Content-Type': 'application/x-www-form-urlencoded',
                          'Authorization': authn,
                        };

                        var data = {
                          'To': '+15125858163',
                          'From': '+18442324983',
                          'Body': 'Check on your loved ones medication',
                        };

                        var url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/AC1f510a0c118eb6ab0701261e7827e108/Messages.json');
                        var res = await http.post(url, headers: headers, body: data);
                        if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
                        print(res.body);
                    },
                    child: Text('TextButton'),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}