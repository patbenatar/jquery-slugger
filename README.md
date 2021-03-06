# jQuery.Slugger

jQuery Slugger is a powerful little tool for creating a slug as your user enters text into an input. It properly allows your user to override the slug manually and cleanses input as they do so.

### Demo

A demo is available [here](http://patbenatar.github.com/jquery-slugger/)

### Features

* Converts typed text in main input into URL-safe slug and displays it in slugInput
* Allows user to edit slugInput
* With safeMode on (default), if the user edits slugInput to a different state than main input, editing main input will no longer override slugInput
* With cleanseSlugInput on (default), input into slugInput is automatically cleansed
* If you include the jquery.caret.js library, caret position will be properly preserved as slugInput is cleansed

#### Supported Browsers

Confirmed to work in the following browsers (haven't tested any others yet):

* Firefox for Mac (Latest)
* Safari for Mac (Latest)
* Chrome for Mac (Latest)
* Internet Explorer 8

### Makes slugs
![Basic usage](http://i.imgur.com/NWfcm.png)

### Allows for manual override of slug
![Manually override slug](http://i.imgur.com/5cVLU.png)

## Installation

1. Grab the latest code from the `lib/` directory
1. If you'd like to have Slugger handle the caret position properly as it cleanses slug input in edit mode, include [jquery.caret.js](https://github.com/DrPheltRight/jquery-caret). A version is included in this repo but it may be out of date.

## Usage

```javascript
$("#your_input").slugger({
  slugInput: $("#your_slug_input")
});
```
## Options (defaults shown)

```javascript
safeMode: true, // Don't override slug field after user has strayed
cleanseSlugInput: true // Cleanse as the user types into the slug input
```

## Utilities

Slugger exposes some of its internal utilities for you to use in the
`Slugger.utils` object.

### Slugger.utils.convert(str)

Takes an input string and converts it to a URI friendly string, including
trimming leading and trailing whitespace.

### Slugger.utils.replace(str)

Takes a string and replaces all non-URI friendly characters with URI-friendly
ones.

### Slugger.utils.ACCENT_MAP

A massive hash mapping accented characters to their URI-friendly representations.

## Caveats

It currently only supports displaying the slug in an input field. You can disable this field if you don't want the user to change it.