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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        const FormWidget(),
        const SizedBox(height: 25),
        _DescriptionWidget(),
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
          ),
          const SizedBox(height: 10),
          const Text('Password', style: textStyle),
          const SizedBox(height: 5),
          TextField(
            controller: read?.passwordController,
            decoration: inputDecoration,
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
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
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
// )))))))) ... всего то не сделал () =>, а просто read?.auth(context),
// ипосыпались ошибко в моделе на notifyListeners(); - типа строится виджет а вы перестраиваите КАПЕЦ...
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

class _DescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return RichText(
          textAlign: TextAlign.start,
          text: const TextSpan(
            children: [
              TextSpan(
                text: Constants.textDescription,
                style: Constants.textStyleDiscription,
              ),
              TextSpan(
                text: Constants.textDescriptionVPN,
                style: Constants.textStyleDiscriptionVPN,
              ),
              TextSpan(
                text: Constants.textDescription2,
                style: Constants.textStyleDiscription,
              ),
            ],
          ));
    });
  }
}
