function show_help()
    println(
        """
        Usage: fil2h5 [OPTION]... [--] FBFILE...
        Convert SIGPROC Filterbank file(s) to FBH5 file(s).
        Attributes may be added/updated using --attr.
        Output directory defaults to same directory as input file.
        Default is no compression, use -b or -s N to use compression.
        Default chunking is none or 512,1,16 if compression is used.
        Chunk dimension ordering is chans,ifs,times.

        Options:
            -a, --attr K=V     add/update attribute K with value V
            -b, --bitshuffle   use bitshuffle/lz4 compression
            -c, --chunk A,B,C  use chunk size (A,B,C)
            -d, --dir DIR      create output files in directory DIR
            -s, --shuffle N    use shuffle/deflate compression level N (0-9)
            -x, --external     use external dataset (point to data in FB file)
            -h, --help         show this command line help
            -v, --version      show version information
        """
    )
end
