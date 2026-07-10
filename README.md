# Kasa

A simple personal expense tracker built with Flutter.

Kasa lets you record day-to-day expenses, browse them by category, and keep an eye on your spending total — with light and dark themes.

## Features

- Add expenses with a title, amount, and category
- Swipe to delete an expense
- Filter the list by category
- Running total of the visible expenses
- Light / dark theme toggle

## Requirements

- [FVM](https://fvm.app) with Flutter `3.44.2` (pinned in `.fvmrc`)

## Getting started

```bash
fvm install
fvm flutter pub get
fvm flutter run
```

## Running tests

```bash
fvm flutter test
```

## Project structure

```
lib/
  data/        # data sources
  models/      # domain models
  notifiers/   # app state
  screens/     # screens
  widgets/     # reusable widgets
test/          # unit tests
```
