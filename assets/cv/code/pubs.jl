# This file was generated, do not modify it. # hide
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