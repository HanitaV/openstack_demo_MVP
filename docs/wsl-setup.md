# Debian WSL 2 setup

DevStack in WSL is a low-resource, best-effort lab configuration. It is suitable for the one CirrOS VM demonstration, but a normal Hyper-V Debian VM remains the more reliable option. WSL does not remove the minimum requirement: allocate at least 5 GB RAM to Debian and preferably 6 GB.

## 1. Configure WSL from Windows

Open **PowerShell as your normal Windows user** and verify that Debian is WSL version 2:

```powershell
wsl --version
wsl -l -v
```

If Debian shows version 1, run `wsl --set-version Debian 2`. Update WSL if necessary with `wsl --update`.

Create `%USERPROFILE%\.wslconfig` with the following contents. This affects all WSL 2 distributions:

```ini
[wsl2]
memory=6GB
processors=2
swap=8GB
localhostForwarding=true
```

Run `wsl --shutdown` after saving this file.

## 2. Enable systemd in Debian

Open Debian and run:

```bash
sudo apt-get update
sudo apt-get install -y systemd systemd-sysv sudo
printf '[boot]\nsystemd=true\n' | sudo tee /etc/wsl.conf
exit
```

Back in PowerShell, run `wsl --shutdown`, reopen Debian, then confirm:

```bash
ps -p 1 -o comm=
free -h
systemctl is-system-running
```

The first command must print `systemd`. `degraded` is acceptable for this lab if required DevStack services can start.

## 3. Install and access the MVP

Keep the repository in the Linux filesystem at `~/openstack_demo_MVP`, not under `/mnt/c`; DevStack and Git are slower and permission-sensitive on Windows-mounted paths.

```bash
cd ~/openstack_demo_MVP
chmod +x debian/*.sh ubuntu/*.sh openstack/*.sh demo/*.sh
./debian/00-check-wsl.sh
./debian/install-mvp.sh
```

Because WSL 2 forwards Linux listening ports to Windows localhost by default, open `http://localhost/dashboard` in the Windows browser after DevStack finishes. If it does not load, check `sudo ss -ltnp | grep ':80'` in Debian and `wsl --status` in PowerShell.

KVM is usually unavailable in WSL. The supplied installer automatically configures QEMU, so CirrOS startup is slower. Do not attempt multiple instances or add OpenStack services in this environment.
