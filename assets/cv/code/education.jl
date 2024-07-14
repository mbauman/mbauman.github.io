# This file was generated, do not modify it. # hide
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