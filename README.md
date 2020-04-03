# ColorByNumber-iOS
Color by Number: a pixel coloring game on iOS. 

One of the most popular game on iOS in the last 2 years. I wrote the code about 1 year ago and decided to open source it.

## Screenshots

![alt text](https://i.imgur.com/WkheoG2.png)

## Example:
https://apps.apple.com/us/app/color-by-number-coloring-game/id1317978215


## Tools & Programming Language
Spritekit and Swift 4.2

## How does it work?

1. The Pixel Image & its colors are stored in a JSON File [Sample in the code]. \
The JSON file contains an array of String. The String corresponds to the colors of the pixel character. The sample contains a 2-d array with total 32 objects. \
"0x000000" -> represents on no color or empty area. \
Use https://www.piskelapp.com/ to create your pixel objects. It also allows you convert the pixel objects into a JSON array. Use 'Export to C file'.
2. The game uses SKCameraNode to move around the scene. You can pan and zoom into the scene. You need to adjust the zoom according to the size of the JSON array.
3. JSON file array is convert into tiles on the scene which you can color with touch.
4. Progress of current colored art is also saved in Preferences.

## Run the Project?

Just download the project and run it in Xcode.

## Compatibility 

iOS 11.0 and above.

## How to create a JSON file after drawing with Piskel

Follow the wiki: https://github.com/AraibKarim/ColorByNumber-iOS/wiki/How-to-convert-Piskel-files-(.c-files)-into-json-for-usage-in-the-source-code%3F

## Issues & Questions

Please let me know if there are some issues.
Contact me at: http://www.syedaraib.com
