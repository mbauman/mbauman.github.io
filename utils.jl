import Unicode: ispunct
import TOML
import Dates: Year

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

# Font awesome icons
const ICONS = Dict(
    "papers"=>"""<i class="far fa-file-alt" title="Paper" style="width:1.5em"></i>""",
    "proceedings"=>"""<i class="far fa-sticky-note" title="Proceeding" style="width:1.5em"></i>""",
    "whitepapers"=>"""<i class="far fa-file" title="Whitepaper" style="width:1.5em"></i>""",
    "presentations"=>"""<i class="fas fa-tv" title="Presentation" style="width:1.5em"></i>""",
    "chapters"=>"""<i class="far fa-bookmark" title="Book chapter" style="width:1.5em"></i>""",
    "posters"=>"""<i class="far fa-map" title="Poster" style="width:1.5em"></i>""",
    )
const PDF = """<i class="far fa-file-pdf" title="Linked PDF"></i>"""
const YOUTUBE = """<i class="fab fa-youtube" title="Watch the presentation"></i>"""
const SRC = """<i class="fab fa-github" title="Source code"></i>"""

"""
    {{researchitems}}

Create a list from the research/papers.toml file.
"""
function hfun_researchitems()
    groups = open(TOML.parse, "research/papers.toml")
    ord = sort!([(item["date"], g, i) for (g,arr) in groups for (i, item) in pairs(arr)], rev=true)
    io = IOBuffer()
    println(io, "~~~", ICONS["papers"], "~~~ Published and peer-reviewed papers\n")
    println(io, "~~~", ICONS["proceedings"], "~~~ Published and peer-reviewed conference proceedings\n")
    println(io, "~~~", ICONS["whitepapers"], "~~~ Whitepapers\n")
    println(io, "~~~", ICONS["presentations"], "~~~ Presentations\n")
    println(io, "~~~", ICONS["chapters"], "~~~ Book chapters\n")
    println(io, "~~~", ICONS["posters"], "~~~ Conference Posters\n")
    for (_, g, i) in ord
        elt = groups[g][i]
        print(io, "* ")
        print(io, "~~~", ICONS[g], "~~~ ")
        print(io, elt["authors"], ' ')
        print(io, "(~~~<span title=\"", elt["date"], "\">", Year(elt["date"]).value, "</span>~~~). ")
        haskey(elt, "url") && print(io, "[")
        print(io, elt["title"])
        haskey(elt, "url") && print(io, "](", elt["url"], ")")
        haskey(elt, "publication") && print(io, ". ")
        g == "chapters" && print(io, "In _")
        print(io, get(elt, "publication", ""))
        g == "chapters" && print(io, "_, edited by ", elt["editor"])
        any(haskey.([elt], ["volume", "number"])) && print(io, ", ")
        print(io, get(elt, "volume", ""))
        haskey(elt, "number") && print(io, "(", elt["number"], ")")
        haskey(elt, "pages") && print(io, ", ", elt["pages"])
        print(io, ". ")
        print(io, get(elt, "conference", ""))
        haskey(elt, "location") && print(io, ", ", elt["location"], ". ")
        haskey(elt, "doi") && print(io, "doi:", elt["doi"], " ")
        haskey(elt, "pdf") && print(io, "[~~~", PDF, "~~~](/assets/research/", elt["pdf"], ") ")
        haskey(elt, "source") && print(io, "[~~~", SRC, "~~~](/assets/research/", elt["source"], ") ")
        haskey(elt, "video") && print(io, "[~~~", YOUTUBE, "~~~](/assets/research/", elt["video"], ") ")
        println(io)
        println(io)
    end
    r = Franklin.fd2html(String(take!(io)), internal=true)
    return r
end

"""
    {{blogposts}}
Plug in the list of blog posts contained in the `/notes/` folder. (adapted from www.julialang.org)
"""
function hfun_blogposts()
    curyear = year(Dates.today())
    io = IOBuffer()
    for year in filter!(x->all(isdigit, x), readdir("notes"))
        ys = "$year"
        base = joinpath("notes", ys)
        isdir(base) || continue
        posts = filter!(p -> endswith(p, ".md"), readdir(base))
        dates = Date[]
        lines = String[]
        for post in posts
            ps  = splitext(post)[1]
            url = "/notes/$ys/$ps/"
            surl = strip(url, '/')
            title = strip(ispunct, pagevar(surl, :title))
            pubdate = pagevar(surl, :published)
            isnothing(pubdate) && continue
            date = Date(pubdate, dateformat"d U Y")
            date > Dates.today() && continue
            push!(dates, date)
            push!(lines, "\n* [$title]($url), $date\n")
        end
        # sort by date
        foreach(line -> write(io, line), lines[sortperm(dates, rev=true)])
    end
    # markdown conversion adds `<p>` beginning and end but
    # we want to  avoid this to avoid an empty separator
    r = Franklin.fd2html(String(take!(io)), internal=true)
    return r
end

"""
    {{recentblogposts}}

Input the 3 latest blog posts. (from www.julialang.org)
"""
function hfun_recentblogposts()
    curyear = Dates.Year(Dates.today()).value
    ntofind = 3
    nfound  = 0
    recent  = Vector{Pair{String,Date}}(undef, ntofind)
    for year in curyear:-1:2019
        for month in 12:-1:1
            ms = "0"^(1-div(month, 10)) * "$month"
            base = joinpath("blog", "$year", "$ms")
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            surls = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps       = splitext(post)[1]
                surl     = "blog/$year/$ms/$ps"
                surls[i] = surl
                pubdate  = pagevar(surl, :published)
                days[i]  = isnothing(pubdate) ?
                                1 : day(Date(pubdate, dateformat"d U Y"))
            end
            # go over month post in antichronological orders
            sp = sortperm(days, rev=true)
            for (i, surl) in enumerate(surls[sp])
                recent[nfound + 1] = (surl => Date(year, month, days[sp[i]]))
                nfound += 1
                nfound == ntofind && break
            end
            nfound == ntofind && break
        end
        nfound == ntofind && break
    end
    #
    io = IOBuffer()
    for (surl, date) in recent
        url   = "/$surl/"
        title = pagevar(surl, :title)
        sdate = "$(day(date)) $(monthname(date)) $(year(date))"
        blurb = pagevar(surl, :rss)
        write(io, """
            <div class="col-lg-4 col-md-12 blog">
              <h3><a href="$url" class="title" data-proofer-ignore>$title</a>
              </h3><span class="article-date">$date</span>
              <p>$blurb</p>
            </div>
            """)
    end
    return String(take!(io))
end
