function parse_args!(args)
    opts = Dict{Symbol,Any}(
        :attrs => Dict{Symbol, Any}(),
        :dir => "",
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
        elseif arg == "-d" || arg == "--dir"
            if isempty(args)
                println("$arg requires an argument")
                empty!(opts)
            end
            opts[:dir] = popfirst!(args)
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
