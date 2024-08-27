
# My personal dotfiles

## Dotfiles

Use with [Dotbot](https://github.com/anishathalye/dotbot) as a symlink farm manager.
An install script is written in a way to accept arguments, although the limited options could be extended.

```shell
./install.sh [-Q -q -v] [-d base_dir] [-p plugin] config_a config_b-sudo ...
```

Where `config_a` and `config_b` refer to the `config_a.yaml` and `config_b.yaml` files, respectively. 
The `-sudo` suffix can be used to execute a config needing elevated privileges.

## Plugins

- [dotbot-brew](https://github.com/wren/dotbot-brew): add `-p dotbot_plugins/dotbot-brew`.

- [dotbot-apt](https://github.com/bryant1410/dotbot-apt): add `-p dotbot_plugins/dotbot-apt`.

## Backup scripts

Backup scripts are tracked in the `bin` folder, and they required [BorgBackup](https://borgbackup.readthedocs.io/) and [Rclone](https://rclone.org/).
After the backup process, the repository is sync with a cloud storage solution.

## Dependencies for the ZSH shell

- bat
- fastfetch
- fzf
- oh-my-zsh
- zoxide
