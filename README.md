# BlioConverters.jl

`BlioConverters` is a Julia package of apps that use `Blio.jl` to convert back
and forth between SIGPROC Filterbank files and FBH5 files.  FBH5 files are HDF5
files that contain the same information as contained in a SOGPROC Filterbank
file.  The Filterbank file's data array is stored in the HDF5 has as a dataset
named `data` and the Filterbank file's header items are stored as attributes of
the `data` dataset.

## Installation

To install this package, run the following command in a terminal window:

```shell
julia -e 'import Pkg; Pkg.app.add(url="https://github.com/david-macmahon/BlioConverters.jl")'
```

After installation the apps will be installed in `$HOME/.julia/bin`.  You may
want to add this directory to your `PATH`.

## Apps

The following apps are part of this package:

- `fil2h5`
- `h52fil`

Use `<APP> -h` to see the app's command line help.
