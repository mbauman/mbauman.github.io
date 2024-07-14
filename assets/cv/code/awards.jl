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
awards = filter(x->haskey(x, "award"), (reduce(vcat, [g for (_,g) in open(TOML.parse, "research/papers.toml")])))
for (i, award) in enumerate(awards)
    print("""* ~~~<a href="#pub$i" id="star$i"><sup>~~~""", fa("far fa-star", "star"), i, "~~~</sup></a>~~~ ")
    println(award["award"])
end
println()