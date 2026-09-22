
# My personal dotfiles

## Dotfiles

Use with [Dotbot](https://github.com/anishathalye/dotbot) as a symlink farm manager.
An install script is written in a way to accept arguments, although the limited set of options could be extended.

```shell
./install.sh [-Q -q -v] [-d base_dir] config_a.yaml config_b.yaml ...
```

Where `config_a.yaml` and `config_b.yaml` refers to different config files. 

## Backup scripts

Backup scripts are tracked in the `bin` folder, and they require [BorgBackup](https://borgbackup.readthedocs.io/) and the [Google Cloud CLI](https://cloud.google.com/sdk/gcloud).
After the backup process, the repository is synced to a cloud storage bucket with `gcloud storage rsync`.
