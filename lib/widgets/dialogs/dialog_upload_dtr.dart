import 'package:flutter/material.dart';
import 'package:hksa/constant/colors.dart';

class DialogUploadDTR {
  final VoidCallback callback;

  DialogUploadDTR(this.callback);

  buildUploadDTr(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorPalette.primary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 375,
                width: 275,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload_file_rounded,
                      color: ColorPalette.accentWhite,
                      size: 200,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Upload Old DTR",
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Important note:\nPlease rename your OLD DTR!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "e.g. DELA_CRUZ_JUAN_HK25/FACI_OLD_DTR.png",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.accentWhite,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        callback();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorPalette.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                      ),
                      child: const Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            color: ColorPalette.accentWhite,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
