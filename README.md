# Input Form
Form with support for text, dropdowns, images and files.

Form inputs support null inputs, validators, and visibility based on conditions.

## Features

- 📋 All data in a text button
- 👁️ Show according to conditions
- 🔲 Outlined input support
- 📷 Video asset support
- 📂 File asset support
- 🎨 Fully customizable theme
- 📱 Android & iOS support

## Getting started


For text, dropdown and file inputs there is no configuration required.

Instead, for image entries there are certain requirements to get started

### Android

Required permissions: `READ_EXTERNAL_STORAGE` (declared already).
Optional permissions: `WRITE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`.

If you're targeting Android SDK 29+,
you must declare `requestLegacyExternalStorage`
at the `<application>` node of `AndroidManifest.xml`.
See the example for the detailed usage.

If you found some warning logs with `Glide` appearing,
then the main project needs an implementation of `AppGlideModule`.
See [Generated API docs][].

### iOS

1. Platform version has to be at least *9.0*.
   Modify `ios/Podfile` and update accordingly.
```ruby
platform :ios, '9.0'
```

2. Add the following content to `info.plist`.
```plist
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>Replace with your permission description.</string>
```

## Usage

First, put [Input Form] in the widget tree with theme settings

```dart
Scaffold(
   body: InputForm(
      decoration: InputFormDecoration(
         backgroundColor: Colors.white,
         borderRadius: BorderRadius.circular(8),
         selectedBorderColor: Colors.lightGreen,
         buttonBackgroundColor: Colors.lightGreen,
         borderColor: Colors.yellow,
      ),
      child: ...,
   ),
)
```

Under the [Input Form] place a [TextInputField] and a [TextFormButton]

```dart
ListView(
  children: [
   const TextInputField(
      name: 'name',
      title: 'Name',
      hint: 'Enter the name',
      icon: Icons.person,
   ),
   const TextFormButton(
      text: 'Tap',
      onTap: (data) {
        print(data)
      },
   ),
  ]
)
```