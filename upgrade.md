
## Boot process

* Firmware  (UEFI/BIOS) - initializes the HW and starts the bootloader (GRUB) which loads the kernel into memory. (`fwupdmgr`)

* Bootloader (GRUB) - selects and loads the kernel into memory, and introduces the kernel to the initramfs (initial RAM filesystem). `initramfs` helps the newly loaded kernel access/mount the real root filesystem during boot.

* Linux kernel -  initializes the devices and starts the init process (systemd) which then starts all the userspace services and daemons.

## Questions/Information-gathering before upgrade

* Long uptime `uptime -p` usually means userspace (non-kernel packages) and kernel patches have **piled up**. 

* Check is system reboot is required (a system reboot is advisory only), unattended-upgrades can trigger a restart if is enabled and active.

```bash
# check if a pending reboot is required
cat /var/run/reboot-required 

# which packages trigger it
cat /var/run/reboot-required.pkgs 
```

* [unattended-upgrades](https://ubuntu.com/server/docs/how-to/software/automatic-updates/). `upgrades` service that automatically installs security (and optionally other) updates in the background, without you running `apt upgrade` manually. Unattended upgrades performs the equivalent of `apt update` and `apt upgrade` to refresh the package lists, to become aware of the new state of the package repositories. Then it checks which upgrades are available and applies them. Always check if `unattended-upgrades.service` is enabled and active 

```bash
# is unattended-upgrades enabled and active
systemctl is-enabled unattended-upgrades # masked means it cannot be started at all — not manually, not by another service depending on it, not by a timer. It's the strongest form of "off."

systemctl is-active unattended-upgrades

# config file 
file /etc/apt/apt.conf.d/50unattended-upgrades

# check timer
systemctl is-enabled apt-daily.timer apt-daily-upgrade.timer
```
## apt vs dpkg

* `apt` is the high-level frontend built on top of `dpkg` 
* `dpkg` is the low-level package manager — it directly reads the local package database `/var/lib/dpkg/status` . `dpkg` does not know anything about internet it just installes what you hand it in the `deb` file.

```bash
# tells you want is installed right now
dpkg -l
```

* `apt` vs `apt-get`: `apt` tool is now the default package management utility for Debian-based Linux distros, and it’s replacing both `apt-get` and `apt-cache` (`apt update == apt-get update`)

* Does `apt upgrade` stays Ubuntu-only, or also pulls vendor software ? `apt` pulls packages from repos defined in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/*.list` (commonly known as jammy)

* `jammy` is split in sub-repos (pockets)

```bash
jammy	          original release packages, frozen at launch
jammy-updates	  bug fixes and non-security updates
jammy-security	security patches only
jammy-backports	newer versions backported, opt-in
```

# Upgrade commands

```bash
# refresh the package index - local metadata cache for the repos
apt update
apt-get update -qq 

# review available upgrades
# reads the local cache and compares it with the currently installed packages (from dpkg database)
# show what's actually available to upgrade, based on fresh cache
apt list --upgradable

# -s option simulates the operation WITHOUT applying package changes
# Dry run upgrade :Confirms nothing will be removed — upgrade shouldn't remove packages 
# should not restart the service but the package's own service 
# might be restarted by the maintainer scripts
apt-get -s upgrade

# Downloads and installs the new packages, including the kernel. This is the step that writes into /boot
# since dist-upgrade can remove packages, 
# run a dry-run to verify nothing would be removed
apt-get -s dist-upgrade | grep '^Remv' 
apt-get -y dist-upgrade

# check what's still running old code in memory
# check if any system services or daemons need to be restarted after package updates and library upgrades
sudo needrestart -b -r l 

# upgrade all packages, including kernel (does not remove any packages)
apt-get upgrade

# check what needs to be held to avoid kernel upgrade
apt-mark showmanual | grep linux

# upgrade only user-space packages: hold-kernel package:
apt-mark hold linux-generic linux-image-generic linux-headers-generic linux-modules-generic

# check the overall boot time: time spent in firmware, bootloader, kernel, and userspace.
systemd-analyze
```

---

* First we need to identify which packages can be upgraded without restarting any services/daemons.
So we can apply userspace OS patches on a live k3s node. It does not involve reboot, drain, or restart k3s/containerd.

* Some applications/userspace packages need a service restart so that memory matches what is on disk. i.e. if you upgrade `libssl3` on disk. `sshd` (already running) keeps using the old `libssl3` in memory until `sshd` itself restarts. 

* Kernel upgrades always needs reboot (a reboot loads the newly installed kernel through the bootloader). A kernel upgrade is two phases: install on disk (running kernel unchanged) then reboot (GRUB loads the new one).

Kernel install = `apt update` + `apt upgrade`, which places the real kernel binary (vmlinuz-*) plus initramfs into `/boot`, alongside headers and a version-syncing meta-package. 
Activation = reboot, where GRUB loads the newest installed vmlinuz into memory, handing off to the kernel and then to systemd.

```

## Kernel upgrade


```bash
# Ubuntu splits the kernel into several coordinated packages, all versioned together:
linux-image-generic: the actual kernel binary (vmlinuz) + modules
linux-headers-generic: headers needed to compile kernel modules
linux-generic: a meta-package — just a dependency wrapper that pulls in the matching image + headers + firmware

# check for kernel-specific packages
apt list --upgradable | grep -E 'linux-image|linux-generic|linux-headers|linux-modules'

# check current running vs what’s on disk (installed kernels)
uname -r
lsb_release -a
ls /boot/vmlinuz-*

# check /boot has room (new kernel images are large, ~50-100MB each)
df -h /boot
df -h / /boot /boot/efi
systemctl --failed

# keep only the latest 2 kernels, remove older ones
apt autoremove --purge

# if kernel upgrade fails, boot an older kernel from GRUB
```


