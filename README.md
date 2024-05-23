
# My personal dotfiles

## Dotfiles

Use with [GNU Stow](https://www.gnu.org/software/stow/) as a symlink farm manager.

```shell
stow --verbose --dotfiles --target=$HOME --restow  src/dir1 src/dir2 ...
```

## Backup scripts

Backup scripts are tracked here, and they required [BorgBackup](https://borgbackup.readthedocs.io/) and [Rclone](https://rclone.org/).
After the backup process, the repository is sync with a cloud storage solution.
