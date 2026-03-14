module H52FIL

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
    for h5name in args
        fbname = h5name
        if !isempty(opts[:dir])
            fbname = joinpath([opts[:dir], basename(fbname)])
        end
        fbname = replace(fbname, r".(h5|hdf5|fbh5)$"=>"") * ".fil"
        Filterbank.h52fil(h5name, fbname; opts[:attrs]...)
    end
end

end # module H52FIL
