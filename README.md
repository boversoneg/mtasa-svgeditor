
# MTASA SVG Editor

SVG Editor allows you to edit SVG images right in your MTA:SA Client, from making rounded squares up to waves, backgrounds and a lot more.


## Usage/Examples

To use this editor all what you have to do is just open your local server and turn on script. After editing some SVGs you'll get raw data, you should use your raw data like this:

```lua
local rawData = [[Paste raw data here]]
local width, height = 100, 100
local SVG = svgCreate(width, height, rawData)

function someRender()
    dxDrawImage(0, 0, width, height, SVG)
end
addEventHandler('onClientRender', root, someRender)
```

## Features

- [x]  Rounding squares
- [x]  Support for raw data preview
- [ ]  Rounding rectangles
- [ ]  Background generator
- [ ]  Fully automatic SVG generator
- [ ]  SVG circle generator
## Contributing

Contributions are always welcome!


## Authors

- [bover.](https://www.github.com/boversoneg)

