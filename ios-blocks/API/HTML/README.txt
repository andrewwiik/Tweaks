All widgets contain a Info.plist without fail - without it, my code will assume that it’s to display the default notifications widget.

All you need to do is to name your main HTML file “Widget.html”, and I handle displaying the widget. Anything that goes beyond the bounds of the widget will be cropped, although the web view’s size should be set before anything is loaded. As a result, it should be possible to figure out what size to display things at where needed. Please bare in mind that in the future, different tweaks (e.g. HomeScreenDesigner and Shrink/Bigify) will be able to adjust the size of widgets, so things need to be coded accordingly.

In terms of options in the Info.plist, there are a few:

- usesHTML (boolean) : Self explanatory. A requirement for any widget.
- icon (string) : The filename of a custom small icon in the lower left. e.g., Icon@2x.png is Icon for this.
- customColor (string) : A hex colour for a custom background colouration.
- hasButtons (boolean) : Not yet implemented

Also, make sure to change the CFBundleName and CFBundleIdentifier options too, in the form : com.xxxx.xxxx.ibkwidget

An example widget for the Weather application is provided - the folder naming must be exactly the same as the icon’s bundle identifier.

All widgets are stored in /var/mobile/Library/Curago/Widgets
