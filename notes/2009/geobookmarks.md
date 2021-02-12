@def title = "iPhone Geolocation Bookmarklets"
@def published = "06 August 2009"


#### _Create direct links to GPS location-specific webpages_

![Heaven's Above tracking the ISS on an iPhone](/assets/notes/geobookmark.png)

Very few websites have implemented the new javascript GPS geolocation features that were
intruduced with HTML 5. However, there are a few sites that use latitude and longitude
directly in their URLs.

I first wanted a quick way to get my current latitude and longitude while looking at
[Heavens Above](http://heavens-above.com/). It’s a great site that allows you to find
visible satellites based upon your current location. Here’s [the bookmarklet](javascript:navigator.geolocation.getCurrentPosition(function(g){c=g.coords;z=c.altitude;z=z?z:0;d=new%20Date(2009,0,1,0,0,0,0).toLocaleString().substr(-3,3);window.location='http://www.heavens-above.com/?lat='+c.latitude+'&lng='+c.longitude+'&alt='+z+'&loc=iPhone&tz='+d;},function(){alert('Permission%20denied.')});) that I created:

```javascript
javascript:navigator.geolocation.getCurrentPosition(function(g){c=g.coords;z=c.altitude;z=z?z:0;d=newDate(2009,0,1,0,0,0,0).toLocaleString().substr(-3,3);window.location="http://www.heavens-above.com/?lat="+c.latitude+"&lng="+c.longitude+"&alt="+z+"&loc=iPhone&tz="+d;},function(){alert("Permission denied.")});
```

Copy [this link to your bookmarks](javascript:navigator.geolocation.getCurrentPosition(function(g){c=g.coords;z=c.altitude;z=z?z:0;d=new%20Date(2009,0,1,0,0,0,0).toLocaleString().substr(-3,3);window.location='http://www.heavens-above.com/?lat='+c.latitude+'&lng='+c.longitude+'&alt='+z+'&loc=iPhone&tz='+d;},function(){alert('Permission%20denied.')});) and when accessed on an iPhone or
location-aware web browser, it will directly load the site with your current location
entered!

I had to jump through several hoops here. When the altitude is not available (when only
using cell-tower triangulation), the javascript code returns `null`. The website only supports
numeric values, so `z=z?z:0` replaces the `null` with a `0`. Secondly, the website needs the local
timezone, but unfortunately it only accepts a small subset of the three letter codes (and
not the numeric offset from UTC). Even worse, the daylight savings version of the code
(EDT/CDT/MDT/PDT) are unsupported – the site just assumes that you follow the trend (sorry
Arizona). So I grab the code from January 1, 2009 (when daylight savings is not in effect),
and parse the three letter code from that string.

For most sites, you’d only need something of the form ([The NOAA’s weather forecast](javascript:navigator.geolocation.getCurrentPosition(function(g){c=g.coords;window.location='http://forecast.weather.gov/MapClick.php?lat='+c.latitude+'&lon='+c.longitude;},function(){alert('Permission%20denied.')});), for
example):

```javascript
javascript:navigator.geolocation.getCurrentPosition(function(g){c=g.coords;window.location="http://forecast.weather.gov/MapClick.php?lat="+c.latitude+"&lon="+c.longitude;},function(){alert("Permission denied.")});
```

Now if only I could find a way to save the javascript bookmark
to the Home Screen, I’d be set!
