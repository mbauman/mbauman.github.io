@def title = "Finer zoom increments in WebKit"
@def published = "07 January 2011"


~~~
<p style="float:right">
<img src="/assets/notes/SafariViewMenu.png" alt="The Safari View menu">
</p>
~~~
I’ve always been annoyed at how large the jumps are between zoom increments in every single
web browser. One click of “Zoom In” and suddenly the text is HUGE. I have found it so
unhelpful in the past that I had completely forgotten about the feature. But then two things
changed:

1. I purchased a high resolution laptop. I really like the display, but it can make text
    on some websites too small to read comfortably.
    
2. Apple made _zoom in_ a built-in gesture on their trackpads. In almost all applications,
    the “pinch” and “stretch” gestures gradually zooms the content in and out. In Safari,
    however, the jump between zoom levels is so large that the zoomed page feels jarringly
    disjointed from the original.
    
Fortunately, WebKit is open source and anyone can download and modify the source code. And
it’s an extremely simple change (as it should be). In file `WebKit/mac/WebView/WebView.mm`,
change

```c
#define ZoomMultiplierRatio 1.2f
```

to:

```c
#define ZoomMultiplierRatio 1.06265857f
```

To be more precise, you may use [this diff file](https://gist.github.com/770529) as a patch.
Why `1.06265857f`? It’s the cube root of 1.2. Since the current zoom level is computed by
multiplying by this ratio, using the cube root effectively makes the zoom increment a third
of what is previously was.

To compile your very own modified WebKit, go to `WebKit/Tools/Scripts` and run `./build-webkit
--release` (it takes a while – about 40 minutes for me). To use it, open and compile
`WebKit/Tools/WebKitLauncher/WebKitLauncher.xcodeproj` in Xcode. This creates the WebKit.app
that is found in the nightly builds. But you’re not done yet. You need to add your
custom-built webkit into this app. Navigate into the build directory and right-click on
WebKit.app to Show Package Contents. You need to create the directory
`Contents/Frameworks/10.6` (or `10.5` if you’re still on Leopard). Finally, copy all the items
from `WebKit/WebKitBuild/Release` into that new folder, and you’re done!

Now if only I could hack Safari to not require such a large gesture to zoom in… but alas
that code resides in Apple’s closed source.
