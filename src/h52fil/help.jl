function show_help()
    println(
        """
        Usage: h52fil [OPTION]... [--] H5FILE...
        Convert FBH5 file(s) to SIGPROC filterbank files.
        Header items may be added/updated using --attr.
        Output directory defaults to same directory as input file.

        Options:
            -a, --attr K=V     add/update attribute K with value V
            -d, --dir DIR      create output files in directory DIR
            -h, --help         show this command line help
            -v, --version      show version information
        """
    )
end
