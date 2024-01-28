# Intro

## What is the modes?

Each mode is a combination of drivers dll's that is used by AMD graphic driver. AMD graphics driver installer chooses a mode during driver installation process according to your graphics card.

 For example for RDNA2 graphic card before july 2023 by default AMD Addrenaline has been installed with "DX9 NAVI with Regular DX11". Starting from Addrenaline 23.7.2 default mode was changed to "Full DXNAVI".

## Why to change mode?

If you have AMD graphic card (including integrated graphics) and you are encountered with glitch, freezes with browsers and other apps in Windows you may try to change mode of your AMD graphic driver.

Many users [claims](https://www.reddit.com/r/Amd/comments/15ggbmw/amd_driver_2372_now_enables_dxnavi_by_default_for/)  that after changes to "Full DXNAVI" this improves games performance but for me those increase freezes in browsers.

Changing mode to "Regular DX" helps me decrease glitches and freezes with Browsers and Telegram. I have Ryzen 6800h with integrated graphics (RNDA2).

# Description

This Powershell script implements the following guide:

https://nimez-dxswitch.pages.dev/NzDXSwitch

## What this script do?

1. It reads Windows registry settings and detect current AMD graphics driver mode.
2. It lets user to choose new AMD graphics driver mode and changes Windows registry according user input.
3. It lets user to choose how to apply new setting: reload graphics driver or reboot PC.

# Warranty

There is no waranties. Use it as is.