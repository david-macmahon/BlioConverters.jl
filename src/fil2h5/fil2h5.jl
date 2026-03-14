module FIL2H5

using Blio, HDF5, H5Zbitshuffle
using ..Utils

include("args.jl")
include("help.jl")

function (@main)(args)
    opts = parse_args!(args)
    @debug "got" opts args

    # Exit on arg error
    isempty(opts) && exit(1)

    # Process any input files
    for fbname in args
        h5name = fbname
        if !isempty(opts[:dir])
            h5name = joinpath([opts[:dir], basename(h5name)])
        end
        h5name = replace(h5name, r".fil$"=>"") * ".h5"
        Filterbank.fil2h5(fbname, h5name;
            copy=opts[:copy],
            chunk=opts[:chunk],
            filters=opts[:filters],
            opts[:attrs]...
        )
    end
end

end # module FIL2H5
