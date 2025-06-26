# Thunder & Lightning Buildroot Configurations

Buildroot defconfigs for Thunder framework and Lightning development environments targeting Raspberry Pi and Banana Pi platforms. Supports ARMv7 (32-bit) and AArch64 (64-bit) architectures with optimized cross-platform compatibility.

## Configuration Matrix

| Configuration                             | Target Platforms         | Architecture | Components                 | Use Case |
|-------------------------------------------|--------------------------|--------------|----------------------------|----------|
| `bpi-m2-armv7_thunder_defconfig`          | Banana Pi M2 Plus[^1]    | ARMv7        | Thunder framework only     | Headless Thunder runtime |
| `bpi-m2-armv7_wpe_defconfig`        | Banana Pi M2 Plus[^1]    | ARMv7        | Thunder + WPE WebKit       | Lightning/WPEWebkit development |
| `raspberrypi_armv7_thunder_defconfig`     | RPi 2–4[^2][^3]          | ARMv7        | Thunder framework only     | Headless Thunder runtime |
| `raspberrypi_armv7_wpe_defconfig`   | RPi 2–4[^2][^3]          | ARMv7        | Thunder + WPE WebKit       | Lightning/WPEWebkit development |
| `raspberrypi_aarch64_thunder_defconfig`     | RPi 2–5[^2][^4]          | AArch64      | Thunder framework only     | Headless Thunder runtime |
| `raspberrypi_aarch64_wpe_defconfig`   | RPi 2–5[^2][^4]          | AArch64      | Thunder + WPE WebKit       | Lightning/WPEWebkit development |

## Architecture Notes

[^1]: Banana Pi M2 Zero supported with `BR2_TARGET_UBOOT_BOARD_DEFCONFIG="bananapi_m2_zero"` due to inverted SD card detect GPIO.

[^2]: Raspberry Pi 2 support requires v1.2 boards (BCM2837 SoC). Earlier revisions (BCM2836) incompatible.

[^3]: ARMv7 builds use Cortex-A53 targeting: ~98-100% performance on RPi2 v1.2/3, ~95-98% on RPi4. Optimized for maintainability over per-SoC tuning.

[^4]: AArch64 builds leverage native 64-bit execution across all supported SoCs with generic optimizations.

## Build Targets

### Thunder Runtime
Minimal Thunder framework deployment for headless or service-oriented applications:
- Thunder core framework and plugin architecture
- Base interfaces (IDispatcher, JSONRPC, Controller)
- Essential system plugins
- Optimized for embedded service deployment

### Lightning Development Environment  
Complete Thunder + WPE WebKit stack for LightningJS application development:
- All Thunder runtime components
- WPE WebKit embedded browser engine
- LightningJS runtime support
- Development and debugging tools

## Contributing

Submit pull requests for additional platform support or configuration improvements. Ensure compatibility testing across target hardware before submission.