# OpenStack Windows MVP

A smallest-real OpenStack university lab: one Debian Server VM on a Windows host, running DevStack all-in-one. It demonstrates Glance (image), Nova (compute), and Cinder (block storage) with one CirrOS instance and one attached volume.

> Lab passwords only: every password is `openstack`. Never reuse these values in production.

## Architecture and minimum hardware

`Windows 10/11 → Hyper-V Default Switch → Debian Server VM → DevStack → Keystone, Glance, Nova, Neutron, Cinder, Horizon`.

Allocate the Debian VM 2 vCPU, 6 GB RAM, and a 40 GB dynamically expanding disk. The installer requires Debian 12 or 13, at least 5 GB RAM and 40 GB free disk; 6 GB is strongly recommended for a stable demonstration. This low-resource profile uses a 256 MB CirrOS flavor and a 10 GB Cinder backing file. Enable nested virtualization for KVM when possible; otherwise it automatically sets Nova/libvirt to QEMU, which is slower but fine for the single CirrOS demo. A host unable to spare 5 GB for Debian cannot reliably run this real DevStack service set.

## Quick start

1. In an Administrator PowerShell, run `./windows/check-host.ps1`. Read the warning before optionally running `./windows/enable-hyperv.ps1` and rebooting.
2. Create Debian 12 or 13 on the Hyper-V Default Switch. Full host steps are in [docs/install-windows.md](docs/install-windows.md).
3. Copy this `openstack-windows-mvp` directory into the Debian user's home directory. In Debian, run:

   ```bash
   cd ~/openstack-windows-mvp
   chmod +x debian/*.sh ubuntu/*.sh openstack/*.sh demo/*.sh
   ./debian/install-mvp.sh
   ```

4. Build the single demo environment:

   ```bash
   ./openstack/01-create-project.sh
   ./openstack/02-create-network.sh
   ./openstack/03-import-image.sh
   ./openstack/04-create-flavor.sh
   ./openstack/05-create-vm.sh
   ./openstack/06-create-volume.sh
   ./openstack/07-attach-volume.sh
   ./demo/verify.sh
   ```

5. Open `http://UBUNTU_VM_IP/dashboard`. Log in as `admin` / `openstack` for administration, or `mvp-user` / `openstack` in domain `Default` for the demo project.

Run `./demo/demo-all.sh` during the oral examination. Run `./openstack/99-cleanup.sh` to delete every MVP resource safely; it is idempotent.

See [docs/architecture.md](docs/architecture.md), [docs/api-ui-guide.md](docs/api-ui-guide.md) for API endpoints and Horizon buttons, [docs/viva-script.md](docs/viva-script.md), [docs/viva-questions.md](docs/viva-questions.md), and [docs/troubleshooting.md](docs/troubleshooting.md).
