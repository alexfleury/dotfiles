"""Script to install dotfiles of a particular folder (depending on the system)
to a home folder. It replicates the folder structure and add a dot (".") at the
beginning of every path.
"""

import argparse
import os
from dataclasses import dataclass, field, InitVar


@dataclass
class DotFile:
    """Docstring."""
    rel_path: InitVar[str]
    system_path: InitVar[str]
    name: str = field(init=False)
    abs_path: str = field(init=False)
    folder: str = field(init=False)

    def __post_init__(self, rel_path, system_path):
        self.abs_path = os.path.abspath(rel_path)

        path_to_name, self.name = os.path.split(rel_path)

        common = os.path.commonpath({path_to_name, system_path})
        self.folder = path_to_name[len(common)+1:]

        if self.folder:
            self.folder = "." + self.folder
        else:
            self.name = "." + self.name

    def create_symbolic_link(self, home_path):
        symlink_path = os.path.join(home, self.folder, self.name)

        if self.folder:
            folder_path = os.path.join(home_path, self.folder)
            os.makedirs(folder_path, exist_ok=True)

        os.symlink(self.abs_path, symlink_path)


def get_dotfiles(directory_path):
    """Dosctring."""

    list_dotfiles = list()
    for root, _, files in os.walk(directory_path):
        for file in files:
            list_dotfiles += [DotFile(os.path.join(root, file), directory_path)]

    return list_dotfiles


# Python option.
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("dotfiles", type=str,
                    help="Relevant folder (path) where dotfiles are.")
args = parser.parse_args()

home = "/home/alexandre/test"#os.path.expanduser("~")
overwrite = True
dry_run = True

list_dotfiles = get_dotfiles(args.dotfiles)

for dotfile in list_dotfiles:
    dotfile.create_symbolic_link(home)