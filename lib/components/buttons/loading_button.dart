import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton(
      {Key? key,
      required this.isLoading,
      required this.onPressed,
      required this.buttonContent})
      : super(key: key);

  final bool isLoading;
  final void Function() onPressed;
  final Widget buttonContent;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : buttonContent
          // child: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: isLoading
          //       ? [
          //           const SizedBox(
          //             width: 20,
          //             height: 20,
          //             child: CircularProgressIndicator(),
          //           )
          //         ]
          //       : [
          //           isUserParticipating
          //               ? const Icon(Icons.remove,
          //                   color: Colors.black54)
          //               : const Icon(Icons.add,
          //                   color: Colors.black54),
          //           const SizedBox(width: 8),
          //           Text(
          //             isUserParticipating
          //                 ? "Leave"
          //                 : "Participate",
          //             maxLines: 10,
          //             style: const TextStyle(
          //                 fontSize: 16.0,
          //                 color: Colors.black54),
          //           ),
          //         ],
          // ),
          ),
    );
  }
}
