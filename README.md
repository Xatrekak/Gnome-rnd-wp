# Gnome-rnd-wp
Provides and rotates Gnome wallpapers from a [ntbg.app](https://github.com/Xatrekak/wallpaperRD), A free service that pulls anime wallpapers from wallhaven.cc 


# Install Insctruction

Open a terminal

```Shell
cd /tmp
git clone https://github.com/Xatrekak/Gnome-rnd-wp
cd Gnome-rnd-wp/
chmod +x install.sh
./install.sh
```

# Installation Options Guide

Our installation script supports various long options to customize the setup process. Here’s a brief guide on how to use each of these options:

    --nsfw_lvl: Sets the NSFW (Not Safe for Work) level for the application. Accepts values sfw (Safe for Work), pg13 (Potentially not safe for work or children), nsfw (Explicit content), all (Randomly pulls from all 3 primary categories), and auto (Automatically adjusts based on the time of day).
        Example: --nsfw_lvl auto

    --timezone: Configures the timezone for the auto NSFW level feature. This option accepts any standard timezone format.
        Example: --timezone America/New_York

    --timer: Sets a timer in minutes for how often the background should change. The format is Xmin, where X is the number of minutes.
        Example: --timer 15min

These options can be combined to tailor the installation according to your preferences.

# Examples

```bash
./install.sh
```
Easy install with sane defaults. Pulls a new SFW background every 10 minutes.

```bash
./install.sh --nsfw_lvl pg13 --timer 30min
```
This command would set the NSFW level to pg13, and change the background every 30 minutes.

```bash
./install.sh --nsfw_lvl all --timer 1440min
```
This command would set the NSFW level to all, and change the background once perday from a random rating.

```bash
./install.sh --nsfw_lvl auto --timezone Europe/Berlin --timer 10min
```
This command would set the NSFW level to auto, use Europe/Berlin as the timezone, and change the background every 10 minutes.
A list of timezones can be found here: [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

```bash
./install.sh --nsfw_lvl nsfw --timer 1min
```
A new super spicy background everymin.