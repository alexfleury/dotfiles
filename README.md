
# My personal dotfiles

## Dotfiles

Use with [Dotbot](https://github.com/anishathalye/dotbot) as a symlink farm manager.
An install script is written in a way to accept arguments, although the limited set of options could be extended.

```shell
./install.sh [-Q -q -v] [-d base_dir] config_a config_b ...
```

Where `config_a` and `config_b` refer to the `config_a.yaml` and `config_b.yaml` files, respectively. 
The `-sudo` suffix can be used to execute a config needing elevated privileges.

## Plugins

`install.sh` takes care of installing and providing dotbot the submodule files.

- [dotbot-omni-pkg](https://github.com/Code-Maniac/dotbot-omnipkg).

## Backup scripts

Backup scripts are tracked in the `bin` folder, and they required [BorgBackup](https://borgbackup.readthedocs.io/) and [Rclone](https://rclone.org/).
After the backup process, the repository is sync with a cloud storage solution.
