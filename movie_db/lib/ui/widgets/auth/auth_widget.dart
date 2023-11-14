import 'package:flutter/material.dart';

import '../../theme/constats.dart';
import 'auth_widget_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({
    super.key,
  });

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  //final _modelAuth = AuthWidgetModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login to your account')),
        ),
        body: ListView(children: const [HederWidget()]));
  }
}

class HederWidget extends StatelessWidget {
  const HederWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //const textStyle = Constants.textStyleHader;
    const text1 = Constants.text1;
    const text2 = Constants.text2;

    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        FormWidget(),
        SizedBox(height: 25),
        text1,
        SizedBox(height: 25),
        text2,
      ]),
    );
  }
}

//-----------------------------------------------------------------------
class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final read = AuthWidgetModelProvider.read(context)?.model;

    const inputDecoration = Constants.inputDecorationForm;
    const textStyle = Constants.textStyleHader;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ErrorMessageWidget(),
          const Text('Username', style: textStyle),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: read?.loginController,
            decoration: inputDecoration,
            //maxLength: 8,
            //obscureText: true,
          ),
          const SizedBox(height: 10),
          const Text('Password', style: textStyle),
          const SizedBox(height: 5),
          TextField(
            controller: read?.passwordController,

            decoration: inputDecoration,
            //maxLength: 8,
            obscureText: true,
          ),
          const SizedBox(width: 25),
          Row(
            children: [
              const _AuthButtonWidget(),
              const SizedBox(width: 16),
              TextButton(
                onPressed: read?.resetPassword,
                style: const ButtonStyle(
                  //overlayColor: MaterialStatePropertyAll(Colors.red),// color araund bottom
                  foregroundColor:
                      MaterialStatePropertyAll(Colors.red), //color text
                ),
                child: const Text('Details'),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget();

  @override
  Widget build(BuildContext context) {
    final watch = AuthWidgetModelProvider.watch(context)?.model;
    final read = AuthWidgetModelProvider.read(context)?.model;
    final onPressed = watch?.canAuth == true ? () => read?.auth(context) : null;
//!!!!!!!!!!!!!!! бля)))))))) ... всего то не сделал () =>, а просто read?.auth(context),
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ипосыпались ошибко в моделе на notifyListeners(); - типа строится виджет а вы перестраиваите
    final colorsButton =
        watch?.isAuthProgress == false ? Colors.blue : Colors.grey[300];
    final textButton = watch?.isAuthProgress == false
        ? const Text('Autorization',
            style: TextStyle(fontWeight: FontWeight.w900))
        : const Row(
            children: [
              SizedBox(width: 32),
              SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 32),
            ],
          );
    return ElevatedButton(
      onPressed: onPressed,
      //() => read?.auth(context),
      //onPressed,
      //navigation;

      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(colorsButton),
          overlayColor: const MaterialStatePropertyAll(Colors.green),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 25, vertical: 8))),
      child: textButton,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget();

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        AuthWidgetModelProvider.watch(context)?.model.errorText;
    if (errorMessage == null) return const SizedBox.shrink();

    return Text(
      errorMessage,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }
}
