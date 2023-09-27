import 'package:acroworld/components/wrapper/loggin_wrapper.dart';
import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoWifePage extends StatefulWidget {
  const NoWifePage({Key? key, this.followUpWidget}) : super(key: key);

  final Widget? followUpWidget;

  @override
  State<NoWifePage> createState() => _NoWifePageState();
}

class _NoWifePageState extends State<NoWifePage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "No connection to the internet",
              style: H16W7,
            ),
            const SizedBox(
              height: 20,
            ),
            StandartButton(
              text: "reload",
              onPressed: () => onReload(),
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }

  onReload() async {
    setState(() {
      loading = true;
    });
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.followUpWidget == null
                ? const LogginWrapper()
                : widget.followUpWidget!,
          ),
        );
      });
    } else {
      Fluttertoast.showToast(
          msg: "Still no connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          fontSize: 16.0);
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loading = false;
    });
  }
}
