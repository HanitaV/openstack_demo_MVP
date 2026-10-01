# API and Horizon UI Guide

This guide helps a new user locate the OpenStack APIs and demonstrate the same MVP resources through the Horizon dashboard. Replace `UBUNTU_VM_IP` below with the Debian VM address shown after installation. Although the path contains `ubuntu/` for coursework compatibility, the VM is Debian.

## Web endpoints

| Service | Purpose | Typical DevStack endpoint |
|---|---|---|
| Horizon | Browser dashboard | `http://UBUNTU_VM_IP/dashboard` |
| Keystone | Authentication and token API | `http://UBUNTU_VM_IP/identity/v3` |
| Nova | Compute API | `http://UBUNTU_VM_IP/compute/v2.1` |
| Glance | Image API | `http://UBUNTU_VM_IP/image` |
| Cinder | Block Storage API | `http://UBUNTU_VM_IP/volume/v3` |
| Neutron | Network API | `http://UBUNTU_VM_IP/network/v2.0` |

Do not hard-code these paths in scripts. DevStack registers the authoritative URLs in Keystone. After installation, run:

```bash
source ~/devstack/openrc admin admin
openstack endpoint list
openstack endpoint list --service nova
```

The OpenStack CLI is the recommended API client for this lab. It obtains a Keystone token and sends authenticated requests automatically:

```bash
source ~/devstack/openrc mvp-user mvp-project
openstack token issue
openstack server list
openstack image list
openstack volume list
```

## Horizon buttons and pages

Open `http://UBUNTU_VM_IP/dashboard`, select domain `Default`, and sign in as `mvp-user` with password `openstack`. Choose the `mvp-project` project if Horizon offers a project switcher.

| What to show | Horizon location | Button or detail to use |
|---|---|---|
| Image | **Project → Compute → Images** | Find `mvp-cirros`; show its `Active` status. |
| VM | **Project → Compute → Instances** | Find `mvp-vm01`; click its name to show `Active`, flavor, image, and network. |
| VM console | **Project → Compute → Instances** | Use the **Console** button next to `mvp-vm01`. |
| Create VM | **Project → Compute → Instances** | Click **Launch Instance**; select `mvp-cirros`, flavor `mvp.nano`, and network `mvp-net`. Do not create a second VM during the normal demo. |
| Volume | **Project → Volumes → Volumes** | Find `mvp-volume01`; show status `In-Use`. |
| Attach volume | **Project → Volumes → Volumes** | Use **Manage Attachments** and select `mvp-vm01`; it is already attached after the setup scripts. |
| Network | **Project → Network → Networks** | Click `mvp-net`, then inspect subnet `mvp-subnet` and CIDR `192.168.100.0/24`. |
| Router | **Project → Network → Routers** | Click `mvp-router` to show its subnet interface and optional external gateway. |

Horizon labels can vary slightly by DevStack release. If a page name differs, use the Project menu and look for the same resource type: Images, Instances, Volumes, Networks, or Routers.

## API flow in the MVP

1. Keystone authenticates `mvp-user` and returns a token plus endpoint catalog.
2. Glance provides `mvp-cirros` as the image template.
3. Nova creates and manages `mvp-vm01` using that image and `mvp.nano`.
4. Neutron connects the instance to `mvp-net`.
5. Cinder creates `mvp-volume01` and Nova attaches it to the VM.

All supplied passwords are lab-only. Use the CLI or Horizon rather than exposing API endpoints to the public internet.
