# **RBXKeyscore**

![](https://b.catgirlsare.sexy/2m4jaknzH5MP.png)

RBXKeyscore or "Roblox XKeyscore" is a collection of shell scripts that aim to provide, within the command line, easy access to combined features of the [Roblox API](https://api.roblox.com/docs).

The [current version](https://github.com/remfly/RBXKeyscore/releases/tag/v0.2.0) contains the following utility:
- User Search


## **Getting Started**

Before anything, make sure you have [jq](https://stedolan.github.io/jq/) installed!

```bash
# clone the repository
$ git clone https://github.com/remfly/RBXKeyscore.git
# cd into the directory
$ cd RBXKeyscore/
# run a script
$ ./scripts/example.sh
```

Alternatively navigate to the [releases](https://github.com/remfly/RBXKeyscore/releases) page and download the latest version either as `zip` or `tar.gz`. After extracting the compressed folder you should be good to go!

## **Tips & Tricks**

By default, RBXKeyscore disables the **bold** output style.

For a visually fancier experience, follow these steps:

1. Install the `tput` utility. It may be in different packages depending on your distribution, but generally will be found in `ncurses` or `ncurses-utils`.
2. Edit the [preferences file](./data/preferences.json) and set `"useBold"` to `true`, save it and done!

## **Help & Support**

If you encounter any bugs or run into unexpected problems, please open an issue in the GitHub Issues page of the repository. You may also join my [Discord server](https://discord.gg/xZ5j6jJcKE) and get help directly from me there.
