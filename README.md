
# My personal dotfiles

## Installation script.

Installation script is provided to create symbolic links, following the directory strcuture of the `dotfiles` argument.

```shell
usage: install_sym_links.py [-h] [-o OUTPUT] [-f] [-z] dotfiles

Script to install dotfiles of a particular folder (depending on the system) to a home folder. It replicates the folder structure and add a dot (".") at the beginning of every path.

positional arguments:
  dotfiles              Relevant folder (path) where dotfiles are.

options:
  -h, --help            show this help message and exit
  -o OUTPUT, --output OUTPUT
                        Destination folder for symlink dotfiles.
  -f, --force           Overwrite already existing file. A overwritten_files folder will be created with overwritten files in their respective folder structure.
  -z, --dryrun          Dry run, no change will be made.
```

