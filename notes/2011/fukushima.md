@def title = "Real data on the Fukushima nuclear disaster"
@def published = "16 March 2011"

##### _(this post was adapted from an email I sent to close friends)_

Unfortunately, I've been finding it hard to locate good, unbiased fact-based scientific reporting.  Rumors and fears abound, without much evidence to support or dismiss either.  And the official information stream has been less-than-forthcoming about what is going on inside the plant. Here's my attempt at piecing it all together:

Radioactivity levels in the plant are high [^1]. They have evacuated all but about 50 persons. This group already has an ominous nickname -- the Fukushima 50 [^2]. Two days ago, three workers already had already reported symptoms of acute radiation sickness [^3]. I haven't seen any reports of illness since then, but the radioactivity has only worsened since then. I don't believe anyone has dared to quantify their long-term effects; it's likely to be disastrous. Readings of up to 400mSv per hour have been reported. Acute sicknesses start at around 1000, and there's approximately a 50% mortality rate for a one-time, rapid dose of 7,500mSv (LD50). These are slower rates of radiation, so the body will be more resilient, but I fear and grieve for these people. They're battling their crippled equipment through fatigue, radiation, and explosion after explosion.

Radiation levels off-site are lower but still worrisome [^4] (this is an official pdf from TEPCO in Japanese, as of about 8 hours ago). These readings are gamma-radiation at the main gate of the facility. By my rough calculations, were somebody simply standing at those meters, they wouldn't be close to showing the symptoms of acute poisoning. They would, however, have experienced the equivalent of several CT scans. A CT scan in a 20-year-old woman may increase her lifetime risk of cancer by ~2% [^5]. The levels have been decreasing since the fire was put out yesterday, but are still far from normal.

Elsewhere in Japan, radiation levels have been reported as 10 to 23 times higher than background [^6] [^7]. Note that even were these levels to persist for an entire calendar year, one would still be within OSHA's occupational limits (by my calculations). Unfortunately, this means that radioactive Cesium and Iodine are indeed escaping from the plant (they've measured Cesium in Tokyo) [^8]. Unlike most of the radioactivity that was vented at Three Mile Island, these elements decay slowly and will stick around for much longer than a few hours (months to years) and they are needed in our bodies. I don't think we'll know the full scale of this disaster for quite some time.

Despite the panicked rush on Iodine tablets on the west coast, even in the (newly revised) worst-case scenarios, no such "deadly plume cloud" would reach the US [^9][^10][^15] (this last reference is cool: it's a meteorologist modeling particulate spread). None of the explosions are nuclear in nature, nor will they be. When water is put under enough stress (e.g., heat), the hydrogen and oxygen disassociate, resulting in the extremely flammable mixture that's been causing explosion after explosion. Note, too, that all reports are saying that the primary nuclear reaction has been reduced to a minimum; it should be impossible for reaction to accelerate and cause a super-critical nuclear event. 

Currently, there appear to be two major sources of leaking radioactivity: (The Japanese Atomic Industrial Forum has a great chart summarizing the status; looks like folks are regularly updating from it at Wikipedia [^16])

There was an explosion and fire in the spent fuel storage area outside of Reactor #4 [^11]. It is unclear if the fuel itself was burning.  Spent fuel, despite its somewhat-innocuous-sounding name, is still radioactive and still generates heat as those unstable particles decay [^12].  I presume that this why they are still stored on-site and why thy must be cooled. But, it seems like it was not held in the same sort of containment as the core ("Academics [in London] were perplexed by the idea. 'The fuel pins in the pond should be totally contained,'" said a professor of nuclear safety [^13]). Unfortunately, as system after system fails, it appears as though the cooling systems for these spent fuel rods also failed.

There was a similar explosion last night, but unlike all the others, this one occurred _within_ the containment of Reactor #2 [^13].  The pressure inside this outer containment has equalized with the atmosphere, signifying a leak. As far as I can see, there has been no comment on the status of the other containment levels (the fuel rods and the pressure vessel) in Reactor 2. But it looks bad.

Again, Japan has been reluctant to change the status of the disaster but it is clearly worsening. The French nuclear agency has reassessed the disaster and now rate it as a 6/7 [^14].  TMI was 5; Chernobyl was 7.

Interestingly, the design of these reactors was questioned back in 1972 [^5]. It was dismissed in a memo stating that the PR backlash of requiring the existing plants to be decommissioned "could well be the end of nuclear power."

## March 17 Update: Plots! 

I've aggregated this data from TEPCO's regular releases of radiation readings like [^4] (The west gate - 西門 - at Fukushima Dai-ichi only). The data that I parsed from these PDFs is available [as a CSV](http://pastebin.com/WvLvLvYu).

I've tried to line up spikes in the data with documented events in the news:

[![annotated graph of radiation in microSieverts per hour over time](/assets/notes/rad1.png)](/assets/notes/rad1.png)

## March 18 Update:

This is a slight re-working of the graphic to more clearly note discontinuities: the gaps in the line represent missing data for more than 2.5 hours. The cumulative exposure was simply estimated with a trapezoidal integration of the data. Due to these large discontinuities, it is only a rough estimate — and likely an underestimate. I've annotated this graph with common references for both instantaneous and cumulative exposures, plotted it on a logarithmic scale, and fit an exponential decay line to the most recent segment.

[![](/assets/notes/rad2.png)](/assets/notes/rad2.png)

#### Footnotes

[^1]: [http://www.iaea.org/newscenter/news/tsunamiupdate01.html](http://www.iaea.org/newscenter/news/tsunamiupdate01.html)
[^2]: [http://www.guardian.co.uk/world/2011/mar/15/fukushima-50-workers-nuclear-plant](http://www.guardian.co.uk/world/2011/mar/15/fukushima-50-workers-nuclear-plant)
[^3]: [http://www.nytimes.com/2011/03/14/world/asia/14health.html?_r=1](http://www.nytimes.com/2011/03/14/world/asia/14health.html?_r=1)
[^4]: [http://www.tepco.co.jp/cc/press/betu11_j/images/110315e.pdf](https://web.archive.org/web/20110421020320/http://www.tepco.co.jp/cc/press/betu11_j/images/110315e.pdf)
[^5]: [http://www.nytimes.com/2011/03/16/world/asia/16contain.html?_r=1](http://www.nytimes.com/2011/03/16/world/asia/16contain.html?_r=1)
[^6]: [http://in.reuters.com/article/2011/03/15/idINIndia-55592120110315](http://in.reuters.com/article/2011/03/15/idINIndia-55592120110315)
[^7]: [http://www.marketwatch.com/story/tokyo-radiation-levels-23-times-normal-officials-2011-03-15-04540](http://www.marketwatch.com/story/tokyo-radiation-levels-23-times-normal-officials-2011-03-15-04540)
[^8]: [http://english.kyodonews.jp/news/2011/03/78123.html](http://english.kyodonews.jp/news/2011/03/78123.html)
[^9]: [http://www.jaif.or.jp/english/news_images/pdf/ENGNEWS01_1300189582P.pdf](http://www.jaif.or.jp/english/news_images/pdf/ENGNEWS01_1300189582P.pdf)
[^10]: [http://www.mercurynews.com/science/ci_17614609?source=most_viewed&nclick_check=1](http://www.mercurynews.com/science/ci_17614609?source=most_viewed&nclick_check=1)
[^11]: [http://www.reuters.com/article/2011/03/15/us-japan-nuclear-pools-idUSTRE72E6OL20110315](http://www.reuters.com/article/2011/03/15/us-japan-nuclear-pools-idUSTRE72E6OL20110315)
[^12]: [http://www.thenation.com/article/159234/fukushimas-spent-fuel-rods-pose-grave-danger](http://www.thenation.com/article/159234/fukushimas-spent-fuel-rods-pose-grave-danger)
[^13]: [http://www.bbc.co.uk/news/science-environment-12745186](http://www.bbc.co.uk/news/science-environment-12745186)
[^14]: [http://www.reuters.com/article/2011/03/15/japan-quake-nuclear-france-idUSLDE72E1HX20110315](http://www.reuters.com/article/2011/03/15/japan-quake-nuclear-france-idUSLDE72E1HX20110315)
[^15]: [http://www.wunderground.com/blog/JeffMasters/comment.html?entrynum=1763](http://www.wunderground.com/blog/JeffMasters/comment.html?entrynum=1763)
[^16]: [http://en.wikipedia.org/wiki/Fukushima_I_nuclear_accidents#Reactor_status_summary](http://en.wikipedia.org/wiki/Fukushima_I_nuclear_accidents#Reactor_status_summary)
