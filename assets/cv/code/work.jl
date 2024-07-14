# This file was generated, do not modify it. # hide
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