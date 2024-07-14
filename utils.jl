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

function hfun_fontawesome(args)
    class = args[1]
    title = get(args, 2, "icon")
    width = get(args, 3, "1.5em")
    """<i class="$class" title="$title" style="width:$width"></i>"""
end
fa(class, title) = string("~~~", hfun_fontawesome([class, title]), "~~~")

# Font awesome icons
const ICONS = Dict(
    "papers"=>fa("far fa-file-alt", "Paper"),
    "proceedings"=>fa("far fa-sticky-note", "Proceeding"),
    "whitepapers"=>fa("far fa-file", "Whitepaper"),
    "presentations"=>fa("fas fa-person-chalkboard", "Presentation"),
    "webinars"=>fa("fas fa-tv", "Webinar"),
    "chapters"=>fa("far fa-bookmark", "Book chapter"),
    "posters"=>fa("far fa-map", "Poster"),
    )
const PDF = fa("far fa-file-pdf", "Linked PDF")
const YOUTUBE = fa("fab fa-youtube", "Watch the presentation")
const SRC = fa("fab fa-github", "Source code")

"""
    {{researchitems}}

Create a list from the research/papers.toml file.
"""
function hfun_researchitems()
    groups = open(TOML.parse, "research/papers.toml")
    ord = sort!([(item["date"], g, i) for (g,arr) in groups for (i, item) in pairs(arr)], rev=true)
    io = IOBuffer()
    println(io, ICONS["papers"], " Published and peer-reviewed papers\n")
    println(io, ICONS["proceedings"], " Published and peer-reviewed conference proceedings\n")
    println(io, ICONS["whitepapers"], " Whitepapers\n")
    println(io, ICONS["chapters"], " Book chapters\n")
    println(io, ICONS["posters"], " Conference Posters\n")
    println(io, ICONS["presentations"], " Invited or refereed talks and presentations\n")
    println(io, ICONS["webinars"], " Commercial webinars and presentations\n")
    println(io, "~~~<hr />~~~")
    println(io, """~~~<ul class="fa-ul">~~~""")
    for (_, g, i) in ord
        elt = groups[g][i]
        anchor_id = haskey(elt, "anchor") ? elt["anchor"] :
            haskey(elt, "pdf") ? split(elt["pdf"], '.')[1] :
            '_' * string(hash(string(elt["date"], elt["title"])), base=62)
        print(io, """~~~<li id="$anchor_id"><a href="#$anchor_id" class="fa-li" style="font-size:75%;">~~~""", ICONS[g], "~~~</a>~~~ ")
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
        haskey(elt, "pdf") && print(io, "[", PDF, "](/assets/research/", elt["pdf"], ") ")
        haskey(elt, "source") && print(io, "[", SRC, "](", elt["source"], ") ")
        haskey(elt, "video") && print(io, "[", YOUTUBE, "](", elt["video"], ") ")
        println(io, "~~~</li>~~~")
    end
    println(io, "~~~</ul>~~~")
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

hfun_spacer((x,)) = """<div style="display:inline-block; width: $(x);"></div>"""
