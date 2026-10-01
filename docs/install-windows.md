# Windows and Debian setup

1. Open **PowerShell as Administrator**, go to this directory, and run `Set-ExecutionPolicy -Scope Process Bypass` then `./windows/check-host.ps1`.
2. If Hyper-V is disabled, save your work, run `./windows/enable-hyperv.ps1`, accept the confirmation, and restart. The script never enables it without PowerShell's `-Confirm` prompt.
3. In Hyper-V Manager, create a Generation 2 Debian 12 or 13 VM with 2 vCPU, 6 GB startup RAM, a 40 GB dynamic VHDX, and the **Default Switch**. During Debian installation, select SSH server and create a normal sudo-enabled user. Do not assign less than 5 GB RAM to Debian: DevStack with Nova, Glance, Neutron, Cinder, Keystone, and Horizon is unlikely to remain stable.
4. To allow KVM inside the VM, from elevated PowerShell run `Set-VMProcessor -VMName "Debian OpenStack MVP" -ExposeVirtualizationExtensions $true` while the VM is off. If unavailable, proceed: the installer selects QEMU.
5. In Debian, install `sudo` if it was not selected during OS installation, then use `ip -4 addr` to find its Default Switch address. Copy the repository into the Debian user's home directory and run `./debian/install-mvp.sh`. The internal `ubuntu/` folder remains only to preserve the coursework-required layout.
6. When installation finishes, browse to `http://UBUNTU_VM_IP/dashboard`. If Windows cannot reach it, confirm both systems are on the Default Switch and check `sudo ufw status`.

VMware Workstation is an acceptable fallback: enable **Virtualize Intel VT-x/EPT or AMD-V/RVI** in VM processor settings. Use NAT networking and the same Debian sizing.
