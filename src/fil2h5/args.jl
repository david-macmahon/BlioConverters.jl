function parse_args!(args)
    opts = Dict{Symbol,Any}(
        :attrs => Dict{Symbol, Any}(),
        :chunk => (),
        :copy => true,
        :dir => "",
        :filters => []
    )

    # Stop processing at end of args, first non-option, or error
    while !isempty(args) && startswith(first(args), "-") && !isempty(opts)
        arg = popfirst!(args)
        if arg == "--"
            # Done with options!
            break
        elseif arg == "-a" || arg == "--attr"
            if isempty(args)
                println("$arg requires an argument")
                empty!(opts)
            end
            k,v = parse_kv(popfirst!(args))
            opts[:attrs][k] = v
        elseif arg == "-b" || arg == "--bitshuffle"
            opts[:filters] = [BitshuffleFilter(compressor=:lz4)]
        elseif arg == "-c" || arg == "--chunk"
            if isempty(args)
                println("$arg requires an argument")
                empty!(opts)
            end
            argarg = popfirst!(args)
            opts[:chunk] = parse_chunk(argarg)
            if opts[:chunk] == (0,0,0)
                println("invalid chunk size $argarg")
                empty!(opts)
            end
        elseif arg == "-d" || arg == "--dir"
            if isempty(args)
                println("$arg requires an argument")
                empty!(opts)
            end
            opts[:dir] = popfirst!(args)
        elseif arg == "-s" || arg == "--shuffle"
            if isempty(args)
                println("$arg requires an argument")
                empty!(opts)
            end
            argarg = popfirst!(args)
            n = tryparse(Int, argarg)
            if n === nothing || n < 0 || 9 < n
                println("invalid compression level $argarg")
                empty!(opts)
            end
            opts[:filters] = [Filters.Shuffle(), Filters.Deflate(n)]
        elseif arg == "-x" || arg == "--external"
            opts[:copy] = false
        elseif arg == "-h" || arg == "--help"
            show_help()
            empty!(args) # ensure nothing to process
        elseif arg == "-v" || arg == "--version"
            show_version("fil2h5")
            empty!(args) # ensure nothing to process
        else
            println("error: unsupported argument \"$arg\"")
            show_help()
            empty!(opts)
        end
    end

    opts
end
