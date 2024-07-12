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
    "presentations"=>"""<i class="fas fa-person-chalkboard" title="Webinar" style="width:1.5em"></i>""",
    "webinars"=>"""<i class="fas fa-tv" title="Presentation" style="width:1.5em"></i>""",
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
    println(io, "~~~", ICONS["chapters"], "~~~ Book chapters\n")
    println(io, "~~~", ICONS["posters"], "~~~ Conference Posters\n")
    println(io, "~~~", ICONS["presentations"], "~~~ Invited and/or refereed talks and presentations\n")
    println(io, "~~~", ICONS["webinars"], "~~~ Commercial webinars and presentations\n")
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
        haskey(elt, "source") && print(io, "[~~~", SRC, "~~~](", elt["source"], ") ")
        haskey(elt, "video") && print(io, "[~~~", YOUTUBE, "~~~](", elt["video"], ") ")
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
    for year in sort!(filter!(x->all(isdigit, x), readdir("notes")), rev=true)
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
