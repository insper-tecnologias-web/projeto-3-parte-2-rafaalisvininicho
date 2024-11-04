import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projeto/colors.dart';
import 'package:toastification/toastification.dart';

extension LayoutUtils on Widget {
  Widget withPadding([EdgeInsetsGeometry padding = const EdgeInsets.all(8)]) {
    return Padding(padding: padding, child: this);
  }

  Widget withSize({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget withCenter() {
    return Center(child: this);
  }
}

extension SnackBarHelpers on BuildContext {
  void successSnackBar(String message, {String? description}) {
    toastification.show(
      context: this,
      icon: const Icon(
        Icons.check_circle_outline_outlined,
        color: Colors.white,
        size: 24,
      ),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  void errorSnackBar(String message, {String? description}) {
    toastification.show(
      context: this,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.white,
        size: 24,
      ),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  void redirectErrorSnackBar(
    String message, {
    required String prefix,
    required String field,
    required String fieldSufix,
    required String sufix,
    required String buttonText,
    required Function() onPressed,
  }) {
    toastification.show(
      context: this,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      description: RichText(
        text: TextSpan(
          text: prefix,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: field,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: fieldSufix,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: buttonText,
              style: const TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                color: green,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onPressed();
                },
            ),
            TextSpan(
              text: sufix,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  void loadingErrorSnackBar(String message,
      {String? description, Function()? onPressed}) {
    toastification.show(
      context: this,
      icon: const Icon(
        Icons.error_outline_outlined,
        color: Colors.red,
        size: 24,
      ),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      dragToClose: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          ElevatedButton(
            onPressed: () {
              toastification.dismissAll();
              onPressed!();
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 8.0,
                      cornerSmoothing: 0.6,
                    ),
                  ),
                ),
              ),
            ),
            child: const Text(
              "Recarregar",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: false,
      boxShadow: highModeShadow,
      closeButtonShowType: CloseButtonShowType.onHover,
      applyBlurEffect: true,
    );
  }

  void warningSnackBar(String message, {String? description}) {
    toastification.show(
      context: this,
      icon: const Icon(
        Icons.warning_amber_outlined,
        color: Colors.white,
        size: 24,
      ),
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      primaryColor: orange,
      title: Text(message),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  void infoSnackBar(String message, {String? description}) {
    toastification.show(
      context: this,
      icon: const Icon(
        Icons.info_outlined,
        color: Colors.white,
        size: 24,
      ),
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }
}
