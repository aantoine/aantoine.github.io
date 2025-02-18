Poker Planning! by Agustin Antoine

# Features

MVP:
-[x] Authenticate with Google
-[ ] Logout
-[x] List available Tables (planning rooms)
-[x] Crate a new table
-[ ] Create/delete tickets in a planning session (Host only)
-[ ] Select voting ticket (Host only)
-[ ] Reveal voting result (Host only)
-[ ] Vote a ticket

Desired:
[ ] Edit nickname
[ ] Select profile picture
[ ] Dark/Light theme
[ ] Observer mode
[ ] Reorder/Edit tickets

# Development

## How to get this project running

firestore
real time database
functions

## Run the project

To run the app in debug mode:
```shell
flutter run -d chrome
```

## Code organization

Code is organized based on Clean Architecture.
In `lib/`, you'll therefore find directories such as `application`,
`domain` or `infrastructure`. 

```text
lib
├── application
├── domain
├── infrastructure
├── presentation
│
├── locator.dart
├── main.dart
└── router.dart
```

## State management

## Building for production

To build the app for iOS (and open Xcode when finished):

```shell
flutter build ipa && open build/ios/archive/Runner.xcarchive
```

To build the app for Android (and open the folder with the bundle when finished):

```shell
flutter build appbundle && open build/app/outputs/bundle/release
```

This project is primarily meant for web. The following command requires installing
[`peanut`](https://pub.dev/packages/peanut/install).

```bash
flutter pub global run peanut \
--web-renderer canvaskit \
--extra-args "--base-href=/name_of_your_github_repo/" \
&& git push origin --set-upstream gh-pages
```

The last line of the command above automatically pushes
your newly built web game to GitHub pages, assuming that you have
that set up.

## Settings

The settings page is enabled by default, and accessible both
from the main menu and through the "gear" button in the play session screen.

Settings are saved to local storage using the 
[`shared_preferences`](https://pub.dev/packages/shared_preferences)
package.
To change what preferences are saved and how, edit files in
`lib/src/settings/persistence`.


# Icon

To update the launcher icon, first change the files
`assets/icon-adaptive-foreground.png` and `assets/icon.png`.
Then, run the following:

```bash
flutter pub run flutter_launcher_icons:main
```

You can [configure](https://github.com/fluttercommunity/flutter_launcher_icons#book-guide)
the look of the icon in the `flutter_icons:` section of `pubspec.yaml`.