import argparse
import os

#parser = argparse.ArgumentParser(description='Process some integers.')
#parser.add_argument('integers', metavar='N', type=int, nargs='+',
#                    help='an integer for the accumulator')
#parser.add_argument('--sum', dest='accumulate', action='store_const',
#                    const=sum, default=max,
#                    help='sum the integers (default: find the max)')
#
#args = parser.parse_args()
#print(args.accumulate(args.integers))

system_folder = "arch_linux"
home_folder = "/home/alexandre/test"

def get_symlink_path(file):
    """Docstring."""
    split_path = file.split("/")
    split_path = split_path[1:]

    if len(split_path) > 1:
        dir_to_create = "."
        dir_to_create += "/".join(split_path[:-1])
    else:
        dir_to_create = None

    symlink = "."
    symlink += "/".join(split_path)

    return symlink, dir_to_create

dotfiles = list()
for root, directories, files in os.walk(system_folder):
    for file in files:
        dotfiles.append(os.path.join(root, file))

for file in dotfiles:
    absolute_path = os.path.abspath(file)
    symlink, dir_to_create = get_symlink_path(file)
    destination = os.path.join(home_folder, symlink)

    if dir_to_create:
        dir_to_create = os.path.join(home_folder, dir_to_create)
        os.makedirs(dir_to_create, exist_ok=True)
    os.symlink(absolute_path, destination)