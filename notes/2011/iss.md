@def title = "Tracking the ISS"
@def published = "02 July 2011"


#### _iPhone Geolocation Bookmarklets Part II_

~~~
<p style="float:right">
<img src="/assets/notes/issicon.png" alt="The suite of new MS fonts">
</p>
~~~

Back when I [wrote about creating iPhone bookmarklets that automagically grab GPS location](/notes/2011/webkitzoom/),
I lamented that you’re unable to easily bookmark them within an iOS device or save them as
web apps. A few friends were pestering me about the using the GPS-enabled [Heavens Above](http://heavens-above.com/) link
to track the ISS, so I quickly threw together something here on my website. The webpage
[http://mbauman.com/iss](/iss/) will simply request your location and forward you on to Heavens
Above’s ISS tracking page.

The page itself is extraordinary simple. It uses entirely client-side processing; no data is
logged. I only use your location to point to the correct URL to Heavens Above. The only
little bit of fanciness involved is that it detects if you’re on an iPhone or iPod and then
displays instructions on how to add to your homescreen. There’s a nice homescreen icon to go
along with it. That said, it also works quite nicely with relatively advanced desktop
browsers.

