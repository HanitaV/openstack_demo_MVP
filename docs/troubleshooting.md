# Troubleshooting

| Symptom | Likely cause | Diagnostic command | Shortest fix |
|---|---|---|---|
| `stack.sh` fails | dependency, network, or stale DevStack state | `less ~/devstack/stack.sh.log` | Fix the reported first error; run `~/devstack/unstack.sh`, then rerun installer. |
| Not enough RAM/disk | VM undersized | `free -h; df -h /` | Assign 6 GB RAM and a 40 GB disk; do not go below 5 GB RAM. |
| KVM unavailable | nested virtualization disabled | `test -e /dev/kvm && echo yes` | Enable nested virtualization, or retain QEMU fallback. |
| Nova `No valid host` | compute service/resource problem | `openstack compute service list; openstack hypervisor list` | Check `n-cpu` is up; use the small flavor and QEMU if needed. |
| VM is `ERROR` | build/network/image failure | `openstack server show mvp-vm01; openstack console log show mvp-vm01` | Delete the VM, fix reported service/image issue, rerun `05-create-vm.sh`. |
| Image upload fails | download or Glance failure | `df -h; openstack image list` | Check internet/free disk and rerun `03-import-image.sh`. |
| VM has no IP | Neutron DHCP/network issue | `openstack network show mvp-net; openstack port list --server mvp-vm01` | Rerun network script; verify Neutron services are up. |
| Volume creation fails | Cinder LVM backend unavailable | `openstack volume service list; sudo vgs` | Rerun DevStack after ensuring free disk for the 20 GB backing file. |
| Volume attach fails | VM or volume not ready | `openstack server show mvp-vm01; openstack volume show mvp-volume01` | Wait for `ACTIVE` and `available`, then rerun `07-attach-volume.sh`. |
| Horizon unreachable | incorrect VM IP/firewall | `hostname -I; sudo ss -ltnp | grep 80` | Use current VM IP and allow local port 80; verify Default Switch. |
| CLI authentication fails | wrong OpenRC/project | `source ~/devstack/openrc admin admin; openstack token issue` | Source the correct OpenRC or set `OPENRC`/`DEVSTACK_DIR`. |
