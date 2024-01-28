# Intro

## What are the AMD graphic driver modes?

Each mode is a combination of drivers dll's that is used by AMD graphic driver. AMD graphics driver installer chooses a mode during driver installation process according to your graphics card.

 For example for RDNA2 graphic card before july 2023 by default AMD Addrenaline has been installed with "DX9 NAVI with Regular DX11". Starting from Addrenaline 23.7.2 default mode was changed to "Full DXNAVI".

## Why to change mode?

If you have AMD graphic card (including integrated graphics) and you are encountered with glitch, freezes with browsers and other apps in Windows you may try to change mode of your AMD graphic driver.

Many users [claims](https://www.reddit.com/r/Amd/comments/15ggbmw/amd_driver_2372_now_enables_dxnavi_by_default_for/)  that after changes to "Full DXNAVI" this improves games performance but for me those increase freezes in browsers.

Changing mode to "Regular DX" helps me decrease [glitches and freezes](https://community.amd.com/t5/drivers-software/freezes-after-idle-in-applications-when-hardware-acceleration-is/m-p/656887) with Browsers and Telegram. I have Ryzen 6800h with integrated graphics (RNDA2).

# Description

You may change mode manually set registry settings according this guide:

https://nimez-dxswitch.pages.dev/NzDXSwitch

This Powershell script just automate those actions.

## What this script do?

1. It reads Windows registry settings and detect current AMD graphics driver mode.
2. It lets user to choose new AMD graphics driver mode and changes Windows registry according user input.
3. It lets user to choose how to apply new setting: reload graphics driver or reboot PC.

# Requirements

- Windows 10/11 (only 11 was tested at this moment)
- Administration right. You must run script as Administrator (set new registry settings requires this).

# Warranty

There is no waranties. Use it as is.