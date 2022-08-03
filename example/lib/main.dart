import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';

void main() => runApp(const InputFormApp());

class InputFormApp extends StatelessWidget {
  const InputFormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InputForm App',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('InputForm App'),
        ),
        body: InputForm(
          decoration: InputFormDecoration(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            selectedBorderColor: Colors.lightGreen,
            buttonBackgroundColor: Colors.lightGreen,
            nullErrorText: 'You must complete the field',
            notValidErrorText: 'Not valid text',
          ),
          data: const {
            'text': 10.0,
            'dropdown': 1,
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            children: [
              const SizedBox(height: 12),
              TextInputField<double>(
                name: 'text',
                title: 'Text',
                hint: 'Enter text',
                icon: Icons.home,
                type: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownInputField<int>(
                name: 'dropdown',
                values: [
                  DropdownItem(1, 'Uno'),
                  DropdownItem(2, 'Dos'),
                  DropdownItem(3, 'Tres'),
                ],
                title: 'Dropdown',
                hint: 'Enter any of the options',
                icon: Icons.list_alt,
              ),
              // const SizedBox(height: 12),
              // ImageInputField(
              //   name: 'images',
              //   title: 'Images',
              //   hint: 'There are no selected images',
              //   minFiles: 2,
              //   minFilesErrorText: 'Must contain at least two images',
              //   selectedHint: (q) =>
              //       'You have selected $q image${q > 1 ? 's' : ''}',
              //   icon: Icons.image,
              // ),
              // const SizedBox(height: 12),
              // FileInputField(
              //   name: 'files',
              //   title: 'Files',
              //   hint: 'No files selected',
              //   minFiles: 2,
              //   minFilesErrorText: 'Must contain at least two files',
              //   selectedHint: (q) =>
              //       'You have selected $q file${q > 1 ? 's' : ''}',
              //   icon: Icons.file_copy,
              // ),
              // const SizedBox(height: 22),
              TextFormButton(
                text: 'Tap',
                onTap: (data) => data.forEach((key, value) {
                  print(value.runtimeType);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
