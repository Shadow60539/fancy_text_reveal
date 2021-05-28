# Fancy Text Reveal
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/fancy_text_reveal)   ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)


## Getting Started 🎨

First, add `fancy_text_reveal` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  fancy_text_reveal: any
```


## Demo 👀
![Output sample](images/demo.gif)

## Usage 🎨
To use is simple, just do this:

    @override
      Widget build(BuildContext context) {
        return FancyTextReveal(
          child: Text('You are Awesome!')
        );
      }



#### Properties Parameter
Here, you can pass:
* decoration for custom decoration of reveal container;
* milliseconds in int for animation duration;
* verticalSpacing for spacing;
* horizontalSpacing for spacing;
