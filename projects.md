# Some things I've built

\toc

## US County-Level Covid-19 Dashboard

[~~~<i class="fab fa-github" title="Source code"></i>~~~ Source (https://github.com/mbauman/CovidCountyDash.jl)][CovidCountyDash.jl]

[~~~<i class="fas fa-external-link-alt"></i>~~~ Website (covid-county-dash.mbauman.com)](http://covid-county-dash.mbauman.com)

Back in the Spring of 2020, I wanted a quick and easy way to compare virus prevalence
between specific _counties_. The NYT built and has maintained a robust dataset that includes
all counties, and they generate [lots of their graphics] from it, but their graphs aren't
terribly interactive. At the same time, I wanted to test out the new [Plotly Dash]
integration (which was [Dashboards.jl] at the time and is now officially supported as
[Dash.jl]). Thus was born [CovidCountyDash.jl][CovidCountyDash.jl]:

![example screenshot from covid-county-dash.herokuapp.com](/assets/projects/covid-county-gif.gif)

I've slowly continued iterating on it since then; some recent features include the ability
to automatically choose states (by region) or counties (by population percentile).

## Guerrilla traffic speed monitoring to inform and push for change

[~~~<i class="fab fa-github" title="Source code"></i>~~~ Source (https://github.com/mbauman/TrafficSpeed)][TrafficSpeed]

[~~~<i class="far fa-newspaper"></i>~~~ Reporting in Pittsburgh Post-Gazette](https://www.post-gazette.com/news/transportation/2015/11/19/Pitt-student-s-study-on-Oakland-traffic-patterns-sparks-citywide-safety-effort/stories/201511180023)

October 2015 was a tragic month for the Oakland community in Pittsburgh. Two pedestrians and a
cyclist were killed in car crashes within four days of each other. While the collisions are
still under investigation, I have a strong suspicion that speed was a major factor in both.
The survivability of a crash decreases very dramatically as speed increases from 20 to 40
miles per hour [1](http://humantransport.org/sidewalks/SpeedKills.htm).

There's been a number of calls for traffic calming measures along Forbes Avenue, which is
one of the few routes east for both cars and cyclists. I was curious what the current
average traffic speed is, and if we could strengthen these calls with some real data. Even
though there's no public data and I don't have a radar gun, it's possible to collect this
myself with just a high vantage point, a cell phone video, and basic computer vision
techniques.

The stretch of Forbes Avenue that I'd like to focus on is between Pitt and CMU:

![Map of Forbes Ave between Pitt and CMU](/assets/projects/overviewmap.png)

It's here that the road and surrounding area "opens up." The previous 8-10 blocks go through
the tightly packed Oakland business district, with timed traffic lights (matching the 25MPH
speed limit) at every intersection. Once you reach Schenley Plaza, though, the buildings
recede away and there's a sense of freedom. I also believe that the timings of lights change
at this point, too, allowing you to exceed 25MPH for the first time since the highway exit.
Once you get to the Natural History museum, a fourth travel lane is added on the left and
the right lane turns into an unmarked 20ft wide luxury lane. The right side of this lane is
intended as a bus stop, but the lack of markings makes it a bit of a free-for-all when there
aren't any busses. I believe that all these things contribute to an overall increase in
speed.

I don't have a radar gun, but I do have a cell phone and access to the Cathedral of
Learning. At about 3:15pm on Friday afternoon, I recorded 10 minutes of traffic on Forbes
Ave. The [full movie is available on YouTube]. Here's a snippet of what this looked like:

![Video of cars on Forbes Ave from the Cathedral of Learning](/assets/projects/movieclip.gif)

You can see Dippy the Dino on the top left, with Schenley Plaza on the top right, and the
intersection with Schenley Drive Extension in between. Unfortunately the trees obscure the
section of the road where I think traffic moves the fastest, but there's a great view of
about 300ft of the road. I rotated and cropped the image, used basic image processing
techniques to detect objects and their locations, converted pixels to real distances, and
computed their speeds. The full analysis is documented in [this IJulia/Jupyter notebook] as a
mini-tutorial. It worked surprisingly well:

![Video of cars on Forbes Ave from the Cathedral of Learning annotated with bounding boxes and speeds](/assets/projects/processedclip.gif)

Now we can see how fast traffic can move! See the [full ten minutes of annotated traffic] at
YouTube. I've exported the detected positions and speeds of all the vehicles as a CSV file,
also posted within this repository. Here's the maximum speeds of all vehicles which got
tracked for more than two seconds:

![Histogram of maximum speeds](/assets/projects/max_speeds.png)

Two drivers were caught going over 40 miles per hour in this 25MPH zone. Ten others were
between 35-40 miles per hour. And [one oblivious driver ran the red light]. Assuming this
random 10-minute segment is representative of afternoon traffic, one out of every twenty
vehicles exceeds 34 MPH (bootstrapped 95% confidence interval is 33-37 MPH). Were any of
these drivers to hit a pedestrian or cyclist, regardless of the fault, there is a
significantly greater chance of serious harm or death than if they were following the speed
limit. This is strong evidence that the university and city need to work harder at reducing
speeds throughout this busy corridor to keep students, pedestrians, cyclists, and drivers
alike safe. Working towards comprehensive solutions over the next two to three years is a
great goal, but there are small steps that they can take today to make this street a safer
place. I think a great first step will be to increase speed awareness with more signs and
enforcement.


[lots of their graphics]: https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html
[Plotly Dash]: https://dash.plotly.com
[Dashboards.jl]: https://github.com/waralex/Dashboards.jl
[Dash.jl]: https://github.com/plotly/dash.jl
[CovidCountyDash.jl]: https://github.com/mbauman/CovidCountyDash.jl
[full movie is available on YouTube]: https://youtu.be/R8jttmhTTUE
[this IJulia/Jupyter notebook]: https://nbviewer.jupyter.org/github/mbauman/TrafficSpeed/blob/master/TrafficSpeed.ipynb
[full ten minutes of annotated traffic]: https://youtu.be/jwVxQ7OcNyk
[one oblivious driver ran the red light]: https://www.youtube.com/watch?v=jwVxQ7OcNyk#t=46
[TrafficSpeed]: https://github.com/mbauman/TrafficSpeed
