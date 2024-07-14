+++
title = "Curriculum Vitae"
header = false
footer = false
+++

@@cv <!-- special styling class for just this page -->

# Matthew J Bauman
@@deets
    {{fontawesome "fa-solid fa-house" "Home address"}} ██████████████████
    {{spacer 2em}}{{fontawesome "fa-solid fa-phone" "Mobile phone"}} [+1-██████](tel:+1-██████)  \
    {{fontawesome "fa-solid fa-envelope" "Email"}} [mbauman@gmail.com](email:mbauman@gmail.com)
    {{spacer 2em}}{{fontawesome "fa-solid fa-globe" "Website"}} [mbauman.com](https://mbauman.com)
    {{spacer 2em}}{{fontawesome "fa-brands fa-github" "GitHub"}} [github.com/mbauman](https://github.com/mbauman)
@@

## Education
```julia:education
#hideall
using TOML: TOML
education = open(TOML.parse, "cv/cv.toml")["education"]
println("~~~<dl>~~~")
for edu in education
    println("~~~<dt>~~~", edu["year"], "~~~</dt>~~~")
    println("~~~<dd>~~~", edu["type"], ", ", edu["institution"])
    for detail in edu["details"]
        println("* ", detail)
    end
    println("~~~</dd>~~~")
end
println("~~~</dl>~~~")
```
\textoutput{education}

## Work
```julia:work
#hideall
using TOML: TOML
using Dates: year, Date
works = open(TOML.parse, "cv/cv.toml")["work"]
println("~~~<dl>~~~")
for work in works
    work["start"] < Date(2004) && continue
    time_str = get(work, "datestr") do
        string(year(work["start"]), "–", haskey(work, "stop") ? year(work["stop"]) :  "present")
    end
    print("~~~<dt>~~~", time_str, "~~~</dt>~~~")
    println("~~~<dd>~~~", work["institution"], "  \\")
    if haskey(work, "roles")
        for role in work["roles"]
            print("_", role["title"], ", ")
            if haskey(role, "datestr")
                print(role["datestr"])
            else
                print(year(role["start"]), "–", haskey(role, "stop") ? year(role["stop"]) :  "present")
            end
            println("_  \\")
        end
    else
        println("_", work["title"], "_")
    end
    if haskey(work, "details")
        println()
        foreach(work["details"]) do detail
            println("* ", detail)
        end
    end
    println("~~~</dd>~~~")
    println()
end
println("~~~</dl>~~~")
```
\textoutput{work}

## Skills and other activities

* Languages: Julia, Python, C, MATLAB, Shell, and Javascript (and HTML/CSS)
* Tools: Git, PostgreSQL, HTTP(s) APIs, SSH, Docker, AWS (EC2, EFS, S3 primarily)
* Techniques: Multi-threaded, multi-machine, and GPU-based compute; neural networks and machine learning pipelines; imputation and ETL.
* Core contributor to the Julia programming language, 2015–present
* Moderator and administrator of the Julia community discourse board ([discourse.julialang.org](https://discourse.julialang.org)), 2016–present
* Former member of Students for Urban Data Science (Carnegie Mellon University), 2015–2016

```julia:pubs
#hideall
using TOML: TOML

function fontawesome(args)
    class = args[1]
    title = get(args, 2, "icon")
    width = get(args, 3, "1.5em")
    """<i class="$class" title="$title" style="width:$width"></i>"""
end
fa(class, title) = string("~~~", fontawesome([class, title]), "~~~")

# Font awesome icons
ICONS = Dict(
    "papers"=>fa("far fa-file-alt", "Paper"),
    "proceedings"=>fa("far fa-sticky-note", "Proceeding"),
    "whitepapers"=>fa("far fa-file", "Whitepaper"),
    "presentations"=>fa("fas fa-person-chalkboard", "Presentation"),
    "webinars"=>fa("fas fa-tv", "Webinar"),
    "chapters"=>fa("far fa-bookmark", "Book chapter"),
    "posters"=>fa("far fa-map", "Poster"),
    )
PDF = fa("far fa-file-pdf", "Linked PDF")
YOUTUBE = fa("fab fa-square-youtube", "Watch the presentation")
SRC = fa("fab fa-github", "Source code")

groups = open(TOML.parse, "research/papers.toml")
io = stdout
for (name, group, icon) in
        (("Publications", vcat(groups["papers"], groups["whitepapers"], groups["chapters"]), "papers"),
         ("Presentations", groups["presentations"], "presentations"),
         ("Conference Proceedings and Posters", vcat(groups["proceedings"], groups["posters"]), "posters"))
    ord = sort!([(item["date"], i) for (i, item) in enumerate(group)], rev=true)
    println("## ", name)
    println(io, """~~~<ul class="fa-ul">~~~""")
    j = 0 # Star counter for awards (note that this is hacky and will break if any non-posters get an award)
    for (_, i) in ord
        elt = group[i]
        anchor_id = haskey(elt, "anchor") ? elt["anchor"] :
            haskey(elt, "pdf") ? split(elt["pdf"], '.')[1] :
            '_' * string(hash(string(elt["date"], elt["title"])), base=62)
        print(io, """~~~<li id="$anchor_id"><a href="#$anchor_id" class="fa-li" style="font-size:75%;">~~~""", ICONS[icon], "~~~</a>~~~ ")
        print(io, elt["authors"], ' ')
        print(io, "(~~~<span title=\"", elt["date"], "\">", Year(elt["date"]).value, "</span>~~~). ")
        haskey(elt, "url") && print(io, "[")
        print(io, elt["title"])
        haskey(elt, "url") && print(io, "](", elt["url"], ")")
        haskey(elt, "publication") && print(io, ". ")
        if haskey(elt, "editor") && haskey(elt, "publication")
            print(io, "Chapter in _")
            print(io, elt["publication"])
            print(io, "_, edited by ", elt["editor"])
        else
            print(io, get(elt, "publication", ""))
        end
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
        haskey(elt, "award") && (j+=1; print(io, """~~~<a href="#star$j" id="pub$j"><sup>~~~""", fa("far fa-star", "star"), j, "~~~</sup></a>~~~"))

        println(io, "~~~</li>~~~")
    end
    println(io, "~~~</ul>~~~")
    println(io)
    println(io)
end
```
\textoutput{pubs}

## Awards and accolades

* 2013 TA of the year, Pittsburgh Engineering Graduate Student Organization, Bioengineering Department.
```julia:awards
#hideall
using TOML: TOML
function fontawesome(args)
    class = args[1]
    title = get(args, 2, "icon")
    width = get(args, 3, "1.5em")
    """<i class="$class" title="$title" style="width:$width"></i>"""
end
fa(class, title) = string("~~~", fontawesome([class, title]), "~~~")
awards = filter(x->haskey(x, "award"), (reduce(vcat, [g for (_,g) in open(TOML.parse, "research/papers.toml")])))
for (i, award) in enumerate(awards)
    print("""* ~~~<a href="#pub$i" id="star$i"><sup>~~~""", fa("far fa-star", "star"), i, "~~~</sup></a>~~~ ")
    println(award["award"])
end
println()
```
\textoutput{awards}

@@ <!-- outermost cv div -->
