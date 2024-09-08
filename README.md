
# My personal dotfiles

## Dotfiles

Use with [Dotbot](https://github.com/anishathalye/dotbot) as a symlink farm manager.
An install script is written in a way to accept arguments, although the limited set of options could be extended.

```shell
./install.sh [-Q -q -v] [-d base_dir] config_a.yaml config_b.yaml ...
```

Where `config_a.yaml` and `config_b.yaml` refers to different config files. 

## Plugins

`install.sh` takes care of installing and providing dotbot the submodule files.

- [dotbot-omni-pkg](https://github.com/Code-Maniac/dotbot-omnipkg).

## Backup scripts

Backup scripts are tracked in the `bin` folder, and they require [BorgBackup](https://borgbackup.readthedocs.io/) and [Rclone](https://rclone.org/).
After the backup process, the repository can be synced with a cloud storage solution.
