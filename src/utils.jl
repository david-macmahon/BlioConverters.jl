module Utils

import ..BlioConverters, Blio, HDF5, H5Zbitshuffle

export show_version, autoparse, parse_kv, parse_chunk

function show_version(appname="")
    isempty(appname) || print(appname, " from ")
    for m in (BlioConverters, Blio, HDF5, H5Zbitshuffle)
        println(m, " version ", pkgversion(m))
    end
    println("julia version ", VERSION)
end

function autoparse(s::AbstractString)::Union{Int,Float64,AbstractString}
    v = something(tryparse(Int, s), tryparse(Float64, s), s)
    if v isa AbstractString
        v = replace(v, r"^\"(.*)\"$"=>s"\1")
    end
    v
end

function parse_kv(arg)::Pair{Symbol,Any}
    k, v = split(arg, "=")
    Symbol(k)=>autoparse(v)
end

function parse_chunk(arg)::NTuple{3, int}
    strs = split(arg, ",")
    length(strs) == 3 || return (0,0,0)
    chunk = tryparse.(Int, strs)
    any(isnothing, chunk) && return (0,0,0)
    Tuple(chunk)
end

end # module Utils