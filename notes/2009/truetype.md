@def title = "Minor Truetype Font Editing on a Mac"
@def published = "3 March 2009"

# Minor Truetype Font Editing on a Mac

#### _(also: how to fix Consolas' baseline)_

~~~
<p style="float:left">
<img src="/assets/notes/consolas-suite.png" alt="The suite of new MS fonts">
</p>
~~~
_Update December 5, 2011: Changed download link to the most recent version of Apple Font Tool suite, which is now x86 compatible._

With the release of Windows Vista, Microsoft included six new fonts that they commissioned
for the occasion. They are the new defaults for Vista and Office. They’ve also made them
available for Mac through Office as well as a handful of free (as in beer) utilities. I got
them by following [these instructions](https://web.archive.org/web/20160315092834/http://www.wezm.net/technical/2009/03/install-consolas-mac-osx/).

These new modern fonts are explicitly designed for display on computer screens with
ClearType. Although Apple has a [different philosophy on font rendering](http://www.codinghorror.com/blog/archives/000884.html), the same basic
premise is used in OS X. Besides all that (or, rather, because of it) these fonts are very
pretty.

But there’s a problem, and you can see it in the image above. When packaging these fonts up
for the Mac, Microsoft goofed on the baseline for Consolas. The icon previews below show it
much more obviously.

![Icon previews with baselines](/assets/notes/consolas-baselines.png)

In short: it’s annoying. And wrong. And the fix is after the break.

A bunch of Mac geeks across [the web](http://www.google.com/search?hl=en&rls=en-us&q=consolas+mac)
[have](http://bandes-storch.net/blog/2008/12/21/consolas-controlled/) [run](http://www.command-tab.com/2008/12/16/consolas-cursor-fix/) into this, but nobody has solved it completely.
After stumbling across [an oblique reference](http://bandes-storch.net/blog/2008/12/21/consolas-controlled/#comment-2042) to some sort of metrics table embedded in the
font, I started looking for a way to edit it. That’s when I happened across Apple’s suite of
command line font editing tools. The main “workhorse” of the suite is `ftxdumperfuser`, but it
doesn’t edit the TTF files directly. Rather, it ‘dumps’ the TrueType data into plain text
(xml) tables that you can edit and then ‘fuses’ the changes back into the font. Google has
surprisingly little on this suite… it wasn’t easy to find (Hence this post).

Now, before going any further, a word of warning: Corrupted fonts can be **very very bad**. I
did all this with an uninstalled font outside of the `*/Library/Fonts` directory. OS X is much
more robust with font management than it used to be (Font Book will catch corruption before
installing a font), but a corrupt font can still really mess stuff up. Continue at your own
risk…

Download Apple’s [OS X Font Tools](https://developer.apple.com/downloads/index.action)—it
will install the tools into `/usr/bin` and the documentation into
`/Developer/Documentation/FontTools`.

Fire up Terminal, and navigate to the folder where you moved the Consolas*.ttf fonts. Now,
you want to dump (`-A d`) the height metrics (`hhea`) table (`-t`) into an editable xml file:

```
ftxdumperfuser -t hhea -A d Consolas.ttf
```

This creates an xml file in that directory titled Consolas.hhea.xml. Now the table
parameters are editable! Open that xml file and correct the ascender, descender, and lineGap
metrics:

```xml
<hheaTable
   ...
   ascender="1884"
   descender="-514"
   lineGap="0"
   ...
   />
 ```

And then fuse (`-A f`) it back into the font:

```
ftxdumperfuser -t hhea -A f Consolas.ttf
```

Repeat for each member of the family, and you’re done!

It’s a pretty cool suite. Emboldened by my success, I decided to modify a few glyphs that
had been bugging me. I had previously tried to edit the TTF using the free FontForge, but
never had any success recompiling it back into a complete proper font. The result always
failed Font Book’s validation and often would display gibberish if I overrode it. I believe
that the FontForge’s TTF import implementation isn’t quite complete, so it wasn’t exporting
the complete font information.

With the `'glyf'` table, you can edit the raw hex that describes the contours of each glyph.
So, I edited the glyphs I wanted in FontForge, and exported the TTF. While the font file
didn’t work as a whole it still contained all the proper glyf information. I dumped the
glyph info, grabbed the one I wanted, subbed it into the dump from the original, and fused
it back together. And it worked! Now I have a proper baseline, and a Monaco style ‘l’
without the lower left serif (and the ‘i,’ too, for consistency).

Here’s the Hex data I used (139 is defined as the glyphRefID in the ‘cmap’ table for ‘i’,
and 142 is ‘l’):

Consolas.glyf.xml:

```xml
<glyphData glyphRefID="139" nContours="2" top="1425" left="183" bottom="0" right="955" data="000200B7000003BB05910009001D 0041BC000F01FD0019000401B1400E090109010906071E0409F607510AB80128400A14401014481400F5034F003FEDDE2BED3FED320110D6CD39392F2F10E1D4E13130 01213521112115213D0113321E0215140E0223222E0235343E0201E0FED701D9012BFE253D1D3225151525321D1D322515152532035C90FCA5915A3705001526311D1C3226151526321C1D31261500" />
<!-  <glyphData glyphRefID=”139” nContours=”2” top=”1425” left=”183” bottom=”0” right=”955” data=”000200B7000003BB05910009001D000001213521112115213D0113321E0215140E0223222E0235343E0201E0FED701D9012BFE253D1D3225151525321D1D322515152532035C90FCA5915A3705001526311D1C3226151526321C1D31261500” /> ->
<!-    0 ( 0) 0001 ( 480, 860 ) ->
<!-    1 ( 0) 0001 ( 183, 860 ) ->
<!-    2 ( 0) 0001 ( 183, 1004 ) ->
<!-    3 ( 0) 0001 ( 656, 1004 ) ->
<!-    4 ( 0) 0001 ( 656, 145 ) ->
<!-    5 ( 0) 0001 ( 955, 145 ) ->
<!-    6 ( 0) 0001 ( 955, 0 ) ->
<!-    7 ( 0) 0001 ( 480, 0 ) ->
<!-    8 ( 0) 0001 ( 480, 90 ) ->
<!-    9 ( 0) 0001 ( 480, 145 ) ->
<!-   10 ( 1) 0001 ( 541, 1425 ) ->
<!-   11 ( 1) 0000 ( 570, 1425 ) ->
<!-   12 ( 1) 0000 ( 620, 1404 ) ->
<!-   13 ( 1) 0000 ( 657, 1366 ) ->
<!-   14 ( 1) 0000 ( 678, 1317 ) ->
<!-   15 ( 1) 0001 ( 678, 1288 ) ->
<!-   16 ( 1) 0000 ( 678, 1260 ) ->
<!-   17 ( 1) 0000 ( 657, 1210 ) ->
<!-   18 ( 1) 0000 ( 620, 1172 ) ->
<!-   19 ( 1) 0000 ( 570, 1151 ) ->
<!-   20 ( 1) 0001 ( 541, 1151 ) ->
<!-   21 ( 1) 0000 ( 512, 1151 ) ->
<!-   22 ( 1) 0000 ( 462, 1172 ) ->
<!-   23 ( 1) 0000 ( 425, 1210 ) ->
<!-   24 ( 1) 0000 ( 404, 1260 ) ->
<!-   25 ( 1) 0001 ( 404, 1288 ) ->
<!-   26 ( 1) 0000 ( 404, 1317 ) ->
<!-   27 ( 1) 0000 ( 425, 1366 ) ->
<!-   28 ( 1) 0000 ( 462, 1404 ) ->
<!-   29 ( 1) 0000 ( 512, 1425 ) ->
```

...

```xml
<glyphData glyphRefID="142" nContours="1" top="1413" left="153" bottom="0" right="983" data="00010099000003D705850009 004FB10102435558B40202090803B80211400F0609090A0B0409FA075100FA40025300183F1A4DED3FED32111201392FCDFDC411392F31301B400A0409FA075100FA40025300183F1A4DED3FED32313059 01213521112115213D0101B8FEE102190125FDE104C7BEFB39BE7C42000000" />
<!-  <glyphData glyphRefID=”142” nContours=”1” top=”1413” left=”153” bottom=”0” right=”983” data=”00010099000003D705850009000001213521112115213D0101B8FEE102190125FDE104C7BEFB39BE7C42000000” />  ->
<!-    0 ( 0) 0001 ( 440, 1223 ) ->
<!-    1 ( 0) 0001 ( 153, 1223 ) ->
<!-    2 ( 0) 0001 ( 153, 1413 ) ->
<!-    3 ( 0) 0001 ( 690, 1413 ) ->
<!-    4 ( 0) 0001 ( 690, 190 ) ->
<!-    5 ( 0) 0001 ( 983, 190 ) ->
<!-    6 ( 0) 0001 ( 983, 0 ) ->
<!-    7 ( 0) 0001 ( 440, 0 ) ->
<!-    8 ( 0) 0001 ( 440, 124 ) ->
<!-    9 ( 0) 0001 ( 440, 190 ) ->
```

Consolas Bold.glyf.xml:
```xml
<glyphData glyphRefID="139" nContours="2" top="1454" left="153" bottom="0" right="983" data="00020099000003D705AE0013001D 007FB10102435558BC000A023C00000018021140121D1C151D19191D151C041E1F181DFA1B510FB8014B400D0F051F050218030514FA40164F00183F1A4DEDDE5F5E5DED3FED3211120117392F2F2F2F10FDD4ED31301BB5181DFA1B510FB8014B400D0F051F050218030514FA40164F00183F1A4DEDDE5F5E5DED3FED32313059 01140E0223222E0235343E0233321E0201213521112115213D0102C6182B3A22223B2B18182B3B22223A2B18FEF2FEE102190125FDE1050E213A2B19192B3A21213A2C19192C3AFE0BBEFCC6BEAA140000" />
<!-  <glyphData glyphRefID=”139” nContours=”2” top=”1454” left=”153” bottom=”0” right=”983” data=”00020099000003D705AE0013001D000001140E0223222E0235343E0233321E0201213521112115213D0102C6182B3A22223B2B18182B3B22223A2B18FEF2FEE102190125FDE1050E213A2B19192B3A21213A2C19192C3AFE0BBEFCC6BEAA140000” />   ->
<!-    0 ( 0) 0001 ( 710, 1294 ) ->
<!-    1 ( 0) 0000 ( 710, 1261 ) ->
<!-    2 ( 0) 0000 ( 686, 1203 ) ->
<!-    3 ( 0) 0000 ( 643, 1160 ) ->
<!-    4 ( 0) 0000 ( 585, 1135 ) ->
<!-    5 ( 0) 0001 ( 551, 1135 ) ->
<!-    6 ( 0) 0000 ( 517, 1135 ) ->
<!-    7 ( 0) 0000 ( 458, 1160 ) ->
<!-    8 ( 0) 0000 ( 415, 1203 ) ->
<!-    9 ( 0) 0000 ( 391, 1261 ) ->
<!-   10 ( 0) 0001 ( 391, 1294 ) ->
<!-   11 ( 0) 0000 ( 391, 1327 ) ->
<!-   12 ( 0) 0000 ( 415, 1385 ) ->
<!-   13 ( 0) 0000 ( 458, 1429 ) ->
<!-   14 ( 0) 0000 ( 517, 1454 ) ->
<!-   15 ( 0) 0001 ( 551, 1454 ) ->
<!-   16 ( 0) 0000 ( 585, 1454 ) ->
<!-   17 ( 0) 0000 ( 643, 1429 ) ->
<!-   18 ( 0) 0000 ( 686, 1385 ) ->
<!-   19 ( 0) 0000 ( 710, 1327 ) ->
<!-   20 ( 1) 0001 ( 440, 826 ) ->
<!-   21 ( 1) 0001 ( 153, 826 ) ->
<!-   22 ( 1) 0001 ( 153, 1016 ) ->
<!-   23 ( 1) 0001 ( 690, 1016 ) ->
<!-   24 ( 1) 0001 ( 690, 190 ) ->
<!-   25 ( 1) 0001 ( 983, 190 ) ->
<!-   26 ( 1) 0001 ( 983, 0 ) ->
<!-   27 ( 1) 0001 ( 440, 0 ) ->
<!-   28 ( 1) 0001 ( 440, 170 ) ->
<!-   29 ( 1) 0001 ( 440, 190 ) ->
```

...

```xml
<glyphData glyphRefID="142" nContours="1" top="1413" left="183" bottom="0" right="955" data="000100B7000003BB05850009 002AB9000401B14011090109010906070A0409F6075100D50353003FED3FED320110D6CD39392F2F10E13130 01213521112115213D0101E0FED701D9012BFE2504F68FFB0C91464B" />
<!-  <glyphData glyphRefID=”142” nContours=”1” top=”1413” left=”183” bottom=”0” right=”955” data=”000100B7000003BB05850009000001213521112115213D0101E0FED701D9012BFE2504F68FFB0C91464B” />  ->
<!-    0 ( 0) 0001 ( 480, 1270 ) ->
<!-    1 ( 0) 0001 ( 183, 1270 ) ->
<!-    2 ( 0) 0001 ( 183, 1413 ) ->
<!-    3 ( 0) 0001 ( 656, 1413 ) ->
<!-    4 ( 0) 0001 ( 656, 145 ) ->
<!-    5 ( 0) 0001 ( 955, 145 ) ->
<!-    6 ( 0) 0001 ( 955, 0 ) ->
<!-    7 ( 0) 0001 ( 480, 0 ) ->
<!-    8 ( 0) 0001 ( 480, 70 ) ->
<!-    9 ( 0) 0001 ( 480, 145 ) ->
```