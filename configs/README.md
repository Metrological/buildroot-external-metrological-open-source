# 🌩️ Buildroot Configurations for Thunder & Lightning

This repository contains six Buildroot defconfigs targeting Raspberry Pi and Banana Pi boards, supporting both ARMhf and AArch64 (ARM64) architectures. These images are designed to support either the [Thunder framework](https://github.com/rdkcentral/Thunder) or full Lightning development environments with [LightningJS](https://lightningjs.io).

## 🧩 Overview of Configurations

| Filename                                  | Target Board(s)          | Architecture | Includes           | Description |
|-------------------------------------------|---------------------------|--------------|--------------------|-------------|
| `bpi-m2-armhf_lightning_defconfig`        | Banana Pi M2 Plus | ARMhf        | 🌀 WPE WebKit + ⚡ Thunder | Full Lightning dev image |
| `bpi-m2-armhf_thunder_defconfig`          | Banana Pi M2 Plus | ARMhf        | ⚡ Thunder only     | Minimal Thunder runtime |
| `raspberrypi_armhf_lightning_defconfig`   | RPi 3–4           | ARMhf        | 🌀 WPE WebKit + ⚡ Thunder | Full Lightning dev image |
| `raspberrypi_armhf_thunder_defconfig`     | RPi 3–4           | ARMhf        | ⚡ Thunder only     | Minimal Thunder runtime |
| `raspberrypi_arm64_lightning_defconfig`   | RPi 3–5           | ARM64        | 🌀 WPE WebKit + ⚡ Thunder | Full Lightning dev image |
| `raspberrypi_arm64_thunder_defconfig`     | RPi 3–5           | ARM64        | ⚡ Thunder only     | Minimal Thunder runtime |

---

## ⚡ Thunder Configs

These configurations provide only the Thunder framework, its interface support, and a set of base plugins. They're ideal for deploying headless or service-oriented Thunder setups.

Features:
- Thunder framework
- Thunder interfaces (like IDispatcher)
- Essential plugins (e.g., Controller, JSONRPC)

---

## 🌀 Lightning Configs

These include everything from the Thunder configs **plus** the [WPE WebKit](https://github.com/WebPlatformForEmbedded/WPEWebKit) runtime, required to run [LightningJS](https://lightningjs.io) apps.

Features:
- All Thunder config features
- WPE WebKit (headless browser for embedded platforms)
- Optimized setup for developing and running LightningJS UI apps

---

## 🙌 Contributions

Want to add support for more boards or tweak existing configs? PRs are welcome!