"""Script to install dotfiles of a particular folder (depending on the system)
to a home folder. It replicates the folder structure and add a dot (".") at the
beginning of every path.
"""

import argparse
import os
from dataclasses import dataclass, field, InitVar


@dataclass
class DotFile:
    """Class to store information about a dotfile.

    Args:
    rel_path (str): Relative path of the dotfile.
    system_path (str): Relative path of where dotfiles are stored. This argument
        enables the detection of the folder to be ignored. Therefore, the script
        can be called from anywhere.

    Attributes:
    name (str): File name (with a leading period if necessary).
    folder (str): Folder structure to the dotfile (with a leading period if
        necessary).
    abs_path (str): Absolute path for symbolic linking of the dotfile.
    """

    rel_path: InitVar[str]
    system_path: InitVar[str]
    name: str = field(init=False)
    folder: str = field(init=False)
    abs_path: str = field(init=False)

    def __post_init__(self, rel_path, system_path):

        # Getting the absolute path of the tracked dotfile.
        self.abs_path = os.path.abspath(rel_path)

        name_path, self.name = os.path.split(rel_path)

        # Removing the common path in folder and system_path.
        common = os.path.commonpath({name_path, system_path})
        self.folder = name_path[len(common)+1:]

        # Adding a leading period where necessary.
        if self.folder:
            # Macos Library folder does not have a leading
            # period.
            if not self.folder[:7] == "Library":
                self.folder = "." + self.folder
        else:
            self.name = "." + self.name

    def create_symbolic_link(self, home_path, overwrite=False, dry_run=False):
        """Create a symbolic link based on several options. It can overwrite
        existing file (while backing them up in a new folder (overwrited_files)
        and a dry-run option is available.

        Args:
        home_path (str): Where the symlinks will be (or would have been)
            created.
        overwrite (bool): If overwriting existing file is OK.
        dry_run (bool): If set to True, only messages are displayed and no local
            changes are applied.
        """

        # Getting the symlink path.
        symlink_path = os.path.join(home_path, self.folder, self.name)

        # Creating the folder tree if applicable.
        if self.folder:
            folder_path = os.path.join(home_path, self.folder)
            os.makedirs(folder_path, exist_ok=True)

        # Check if the destination file already exists.
        if os.path.exists(symlink_path):

            # Some choice depending on if we want to overwrite the destination
            # file and if it is a dry-run (no changes, a test run).
            if overwrite and dry_run:
                print(f"OVERWRITE - Symbolic link {symlink_path} pointing to "\
                      f"{self.abs_path}.")
            elif overwrite:
                archiving_path = os.path.join("overwritten_files", self.folder)
                os.makedirs(archiving_path, exist_ok=True)
                os.replace(symlink_path, os.path.join(archiving_path,
                    self.name))
                os.symlink(self.abs_path, symlink_path)
            elif dry_run:
                print(f"NOTHING - Symbolic link {symlink_path} pointing to "\
                      f"{self.abs_path}.")
            else:
                pass
        # Overwrite option is not used if the destination file does not exist.
        else:
            if dry_run:
                print(f"CREATION - Symbolic link {symlink_path} pointing to "\
                      f"{self.abs_path}.")
            else:
                os.symlink(self.abs_path, symlink_path)


def get_dotfiles(directory_path):
    """Function to go through all existing dotfiles in a folder. DotFile objects
    are created for each of them and they are stored in a list.

    Args:
        directory_path: Folder where the dotfiles are stored (and tracked).

    Returns:
        list of DotFile: List containg all information for every dotfiles.
    """

    list_dotfiles = list()
    for root, _, files in os.walk(directory_path):
        for file in files:
            list_dotfiles += [DotFile(os.path.join(root, file), directory_path)]

    return list_dotfiles


# Python options.
parser = argparse.ArgumentParser(description=__doc__)

parser.add_argument("dotfiles", type=str,
    help="Relevant folder (path) where dotfiles are.")
parser.add_argument('-o', '--output', type=str, default=os.path.expanduser("~"),
    help="Destination folder for symlink dotfiles.")
parser.add_argument('-f', '--force', action="store_true",
    help="Overwrite already existing file. A overwrited_files folder will be "\
         "created with overwrited files in their respective folder structure.")
parser.add_argument('-z', '--dryrun', action="store_true",
    help="Dry run, no change will be made.")

args = parser.parse_args()

# Reading available dotfiles.
list_dotfiles = get_dotfiles(args.dotfiles)

# For every dotfile, create a symlink (many behaviors based on the arguments).
for dotfile in list_dotfiles:
    dotfile.create_symbolic_link(args.output, args.force, args.dryrun)
