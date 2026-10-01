# MVP architecture

```text
Windows 10/11 laptop
└─ Hyper-V Default Switch (or VMware Workstation)
   └─ Debian 12/13 VM: 4 vCPU / 10 GB RAM / 60 GB disk
      └─ DevStack all-in-one
         ├─ Keystone: identity and tokens
         ├─ Glance: CirrOS image catalog
         ├─ Nova: instance lifecycle
         ├─ Neutron: mvp-net, subnet, router, security rules
         ├─ Cinder: one 1 GB block volume
         └─ Horizon: browser dashboard
```

The only tenant workload is `mvp-vm01`. Nova requests its creation using `mvp-cirros` from Glance, Neutron connects it to `mvp-net` (`192.168.100.0/24`), and Cinder attaches `mvp-volume01`. Nova controls lifecycle; libvirt calls KVM when `/dev/kvm` is available, otherwise QEMU emulates virtualization in software.

This intentionally is not production architecture: it has one node, lab passwords, DevStack, file-backed LVM Cinder storage, and no high availability.
