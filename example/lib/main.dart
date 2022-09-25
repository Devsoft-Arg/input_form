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
        body: InputFormDecoration(
          data: InputFormDecorationData(
            nullErrorText: 'You must complete the field',
            notValidErrorText: 'Not valid text',
            inputPadding: const EdgeInsets.only(bottom: 12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 2, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 2),
                ),
                filled: true,
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  foregroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                ),
              ),
            ),
            child: InputForm(
              data: {
                'text': 10.0,
                'dropdown': 1,
                'date': DateTime.now(),
                'time': TimeOfDay.now(),
                'files': const ['file1', 'file2'],
                'images': const ['image1', 'image2'],
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                children: [
                  const SizedBox(height: 20),
                  TextInputField<double>(
                    name: 'text',
                    title: 'Text',
                    hint: 'Enter text',
                    icon: Icons.home,
                    type: TextInputType.number,
                  ),
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
                  DateInputField(
                    name: 'date',
                    title: 'Date',
                    hint: 'Enter date',
                    icon: Icons.calendar_month_outlined,
                    dateFormat: DateFormat.yMMMMd(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                  ),
                  const TimeInputField(
                    name: 'time',
                    title: 'Time',
                    hint: 'Enter time',
                    icon: Icons.watch_later_outlined,
                  ),
                  FileInputField(
                    name: 'files',
                    title: 'Files',
                    hint: 'No files selected',
                    minFiles: 2,
                    minFilesErrorText: 'Must contain at least two files',
                    selectedHint: (q) =>
                        'You have selected $q file${q > 1 ? 's' : ''}',
                    icon: Icons.file_copy,
                  ),
                  ImageInputField(
                    name: 'images',
                    title: 'Images',
                    hint: 'There are no selected images',
                    minFiles: 2,
                    minFilesErrorText: 'Must contain at least two images',
                    selectedHint: (q) =>
                        'You have selected $q image${q > 1 ? 's' : ''}',
                    icon: Icons.image,
                  ),
                  const SizedBox(height: 10),
                  const TextFormButton(
                    text: 'Tap',
                    onTap: print,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
