# BlioConverters.jl

`BlioConverters` is a Julia package of apps that use `Blio.jl` to convert back
and forth between SIGPROC Filterbank files and FBH5 files.  FBH5 files are HDF5
files that contain the same information as contained in a SIGPROC Filterbank
file.  The Filterbank file's data array is stored in the HDF5 has as a dataset
named `data` and the Filterbank file's header items are stored as attributes of
the `data` dataset.

## Installation

To install this package, run the following command in a terminal window:

```shell
julia -e 'import Pkg; Pkg.Apps.add(url="https://github.com/david-macmahon/BlioConverters.jl")'
```

After installation the apps will be installed in `$HOME/.julia/bin`.  You may
want to add this directory to your `PATH`.

## Apps

The following apps are part of this package:

- [`fil2h5`](#fil2h5)
- [`h52fil`](#h52fil)

### `fil2h5`

`fil2h5` converts one or more SIGPROC Filterbank files to FBH5 (Filterbank HDF5)
files.

#### Usage

Here is its command line help for `fil2h5`:

```plain
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
```

#### Options

##### Output directory

By default, the FBH5 files will be created in the same directory as the input
files.  You can use `-d` (or `--dir`) to specify an alternate output directory.

##### Attributes

The Filterbank format supports a very limited set of metadata (aka header
items).  The header items of each input Filterbank file will be stored as
attributes of the `data` dataset in the corresponding output FBH5 file.  HDF5 is
a richer file format than Filterbank so metadata fields beyond those supported
by the Filterbank format can be added (pr existing ones modified) by using the
`-a` (or `--attr`) option.  This option requires a `KEY=VALUE` argument, where
`KEY` will be the name of the attribute and `VALUE` will be the value of the
attribute.

`VALUE` will stored as an integer if it parses as an integer, a double precision
floating point number if it parses as floating point, otherwise a string.  To
store a numeric string, put double quotes around it (which might need special
handling to prevent your shell from eating them).  For example,
`-a 'nchans=65536'` will store `65536` as an integer, but
`-a 'src_name="65536"'` will store `65536` as a string.  This can also be used
to store a string that starts with a quote.  For example,
`-a 'src_name=""QUOTED_SRC""'` will store `"QUOTED_SRC"` as the value of the
`src_name` attribute.

This option can be specified multiple times for multiple attributes.

##### Chunking

The `data` dataset set may be "chunked" by passing a chunk size as three comma
separated integers.  Chunking is required if compression is used (see below).
In the absence of compression, chunking is optional.  If compression and
chunking are not specified the data will be unchunked and uncompressed.  The
ordering of the chunk dimensions is "channels, ifs, times".  See the HDF5 docs
for more information about chunking.
  
NB: The dimension ordering it the reverse order of C/Python implementations.

##### Compression

Two modes of compression are supported to compress the data in the FBH5 file:
"bitshuffle" and "shuffle+deflate".  To use "bitshuffle" compression, pass the
`-b` (or `--bitshuffle`) option.  To use the "shuffle+deflate" compression, pass
the `-s N` (or `--shuffle N`) option.  The `N` argument specifies the
compression level for "deflate" (0=min, 9=max).  The "bitshuffle" compression
requires readers of the output file to have the HDF5 `bitshuffle` plug-in
installed whereas the "shuffle+deflate" compression is built into the HDF5
libraries.  If neither compression option is specified, the output HDF5 file
will not use compression.  If both options are specified the last one wins.
  
Compression requires that the dataset be chunked.  If compression is
specified, but a chunk size is not (see above), the chunk size will default to
`512,1,16`.

##### External datasets

By default the data array in the Filterbank file is copied into the `data`
dataset of the FBH5 file.  To save disk space, the `-x` (or `--external`) option
can be used to create the `data` dataset as an "external dataset" that points to
the data array of the Filterbank file rather than containing a copy of the data.
While this saves disk space it requires extra attention to ensure that the
Filterbank file can be found by the HDF5 libraries when reading the FBH5 file.
See the HDF5 docs for more details.  When creating an external dataset the
chunking and compression options are ignored.

### `h52fil`

`h52fil` converts one or more FBH5 (Filterbank HDF5) files to SIGPROC Filterbank
files.  Here is its command line help:

```plain
Usage: h52fil [OPTION]... [--] H5FILE...
Convert FBH5 file(s) to SIGPROC filterbank files.
Header items may be added/updated using --attr.
Output directory defaults to same directory as input file.

Options:
    -a, --attr K=V     add/update attribute K with value V
    -d, --dir DIR      create output files in directory DIR
    -h, --help         show this command line help
    -v, --version      show version information
```

The Filterbank file format is more basic than the HDF5 file format so converting
from FBH5 format to Filterbank format supports fewer options than the other way
around.  The output directory and attributes options are similar to the those of
[`fil2h5`](#fil2h5).

The Filterbank format only supports specific attributes (header items).
Unsupported attributes are silently dropped.
