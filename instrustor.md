You are a senior OpenStack lab engineer and DevOps engineer.

Build the SMALLEST REAL OpenStack MVP that can run on a Windows 10/11 laptop
and can be demonstrated in a university oral examination.

The project is NOT production infrastructure.

The only objective is to demonstrate:

1. Compute Service
2. Imaging Service
3. Storage Service

The MVP must be simple enough that a student can understand and explain
the entire system in 5-10 minutes.

==================================================
1. TARGET ENVIRONMENT
==================================================

HOST:

Windows 10/11 x64

Preferred host virtualization:

Hyper-V

Fallback:

VMware Workstation

Do NOT attempt to install OpenStack services directly on Windows.

Architecture:

Windows
  |
  +-- Ubuntu Server VM
        |
        +-- DevStack All-in-One
              |
              +-- Keystone
              +-- Glance
              +-- Nova
              +-- Neutron
              +-- Cinder
              +-- Horizon

Inside OpenStack:

Create only ONE small VM.

==================================================
2. DESIGN PHILOSOPHY
==================================================

This is a university viva MVP.

Priority:

working demo
>
production architecture

working single-node
>
multi-node OpenStack

one working VM
>
multiple VMs

one image
>
multiple images

one network
>
complex networking

one volume
>
distributed storage

KISS principle must be followed.

==================================================
3. DEPLOYMENT METHOD
==================================================

Use DevStack All-in-One unless there is a concrete compatibility reason not to.

Reason:

- intended for development/lab
- easy to reset
- easy to automate
- provides real OpenStack APIs
- suitable for a temporary university demo

Do NOT use:

Kolla-Ansible
OpenStack-Ansible
Kubernetes
Ceph
MAAS
Juju
Terraform
Prometheus
Grafana

unless absolutely required.

They are outside the MVP scope.

==================================================
4. WINDOWS HOST
==================================================

Create PowerShell scripts:

windows/
  check-host.ps1
  enable-hyperv.ps1
  show-network-info.ps1

check-host.ps1 must display:

- Windows version
- RAM
- CPU model
- CPU core count
- Hyper-V status
- virtualization support
- free disk space

Do NOT automatically enable Hyper-V without clearly warning the user.

Provide instructions for creating an Ubuntu VM.

Recommended VM configuration:

CPU:
4 vCPU

RAM:
10 GB

Disk:
60 GB dynamically allocated

Network:
Hyper-V Default Switch

OS:
Ubuntu Server

==================================================
5. NESTED VIRTUALIZATION
==================================================

Detect whether nested virtualization is available.

Preferred path:

KVM

Fallback path:

QEMU software virtualization

If /dev/kvm exists:

use KVM

Otherwise:

configure Nova/libvirt to use:

virt_type = qemu

The project MUST still support the viva demo even without nested virtualization.

Display a warning:

"KVM unavailable. Using QEMU. VM boot will be slower but suitable for MVP demo."

==================================================
6. OPENSTACK SERVICES
==================================================

CORE SERVICES FOR THE EXAM:

Nova
Compute

Glance
Imaging

Cinder
Block Storage

SUPPORT SERVICES:

Keystone
Identity

Neutron
Networking

Horizon
Dashboard

Do not install unnecessary OpenStack services.

==================================================
7. GUEST IMAGE
==================================================

Use CirrOS by default.

Reason:

- tiny image
- fast download
- fast boot
- low RAM requirement
- ideal for OpenStack lab demonstration

Image name:

mvp-cirros

Verify:

openstack image list

Expected:

mvp-cirros
active

Optionally document how to use Ubuntu cloud image,
but do NOT make Ubuntu guest image mandatory.

==================================================
8. OPENSTACK RESOURCES
==================================================

Create:

Project:

mvp-project

User:

mvp-user

Flavor:

mvp.nano

Specifications:

1 vCPU
512 MB RAM
1 GB disk

Network:

mvp-net

Subnet:

mvp-subnet

CIDR:

192.168.100.0/24

Router:

mvp-router

VM:

mvp-vm01

Volume:

mvp-volume01

Size:

1 GB

==================================================
9. COMPUTE DEMO
==================================================

Nova demo must demonstrate:

openstack server create

and:

openstack server list

VM must reach:

ACTIVE

Command:

openstack server show mvp-vm01

Student explanation:

"Nova is the OpenStack Compute service.
It manages the lifecycle of virtual machine instances."

Also explain:

Nova does not itself execute CPU virtualization.

libvirt + KVM/QEMU provide the virtualization layer.

==================================================
10. IMAGING DEMO
==================================================

Glance demo:

Download CirrOS.

Upload:

openstack image create \
  --disk-format qcow2 \
  --container-format bare \
  --file cirros.img \
  mvp-cirros

Verify:

openstack image list

Student explanation:

"Glance stores and manages VM images.
Nova uses a Glance image as the operating-system template
when creating an instance."

==================================================
11. STORAGE DEMO
==================================================

Cinder demo:

Create:

openstack volume create \
  --size 1 \
  mvp-volume01

Verify:

openstack volume list

Attach:

openstack server add volume \
  mvp-vm01 \
  mvp-volume01

Verify:

openstack volume show mvp-volume01

Expected:

status = in-use

Student explanation:

"Cinder provides persistent block storage.
A Cinder volume can be attached to a VM independently
from the VM root disk."

==================================================
12. NETWORKING
==================================================

Networking must stay minimal.

Create:

mvp-net

mvp-subnet

192.168.100.0/24

mvp-router

Security group rules:

ICMP

TCP 22

If external networking / floating IP works easily,
configure it.

Otherwise:

do NOT make Floating IP mandatory.

Horizon console access is acceptable for the MVP.

==================================================
13. HORIZON
==================================================

Horizon must be enabled.

Windows browser should access:

http://UBUNTU_VM_IP/dashboard

Document:

admin login

and:

mvp-user login

The student should be able to visually show:

Project
Images
Instances
Volumes
Networks

==================================================
14. REPOSITORY STRUCTURE
==================================================

Create:

openstack-windows-mvp/
|
+-- README.md
|
+-- windows/
|   +-- check-host.ps1
|   +-- enable-hyperv.ps1
|   +-- show-network-info.ps1
|
+-- ubuntu/
|   +-- 01-check-vm.sh
|   +-- 02-install-dependencies.sh
|   +-- 03-install-devstack.sh
|   +-- 04-configure-openstack.sh
|
+-- openstack/
|   +-- 01-create-project.sh
|   +-- 02-create-network.sh
|   +-- 03-import-image.sh
|   +-- 04-create-flavor.sh
|   +-- 05-create-vm.sh
|   +-- 06-create-volume.sh
|   +-- 07-attach-volume.sh
|   +-- 08-status.sh
|   +-- 99-cleanup.sh
|
+-- demo/
|   +-- demo-all.sh
|   +-- verify.sh
|
+-- docs/
    +-- architecture.md
    +-- install-windows.md
    +-- viva-script.md
    +-- viva-questions.md
    +-- troubleshooting.md

==================================================
15. DEVSTACK CONFIGURATION
==================================================

Create a minimal:

local.conf.example

Enable only required services.

Required:

Keystone
Nova
Glance
Neutron
Cinder
Horizon

Do not add advanced services.

If KVM unavailable:

configure libvirt Nova driver for QEMU.

Keep passwords easy for lab use.

Example:

ADMIN_PASSWORD=openstack
DATABASE_PASSWORD=openstack
RABBIT_PASSWORD=openstack
SERVICE_PASSWORD=openstack

Clearly warn:

"Lab passwords only. Never use these passwords in production."

==================================================
16. MASTER INSTALL SCRIPT
==================================================

Create:

ubuntu/install-mvp.sh

The script should:

1. check Ubuntu version
2. check RAM
3. check disk space
4. check internet connectivity
5. check KVM
6. install dependencies
7. clone DevStack
8. generate local.conf
9. run stack.sh
10. verify OpenStack APIs
11. print Horizon URL

At completion print:

============================================

OPENSTACK MVP INSTALLED

Horizon:
http://<IP>/dashboard

Core exam services:

Nova    OK
Glance  OK
Cinder  OK

Support:

Keystone OK
Neutron  OK
Horizon  OK

============================================

==================================================
17. MASTER DEMO
==================================================

Create:

demo/demo-all.sh

It must show the demo in viva order:

1.

openstack service list

2.

openstack image list

Explain:

GLANCE

3.

openstack server list

Explain:

NOVA

4.

openstack volume list

Explain:

CINDER

5.

openstack server show mvp-vm01

6.

openstack volume show mvp-volume01

Finally:

======================================

OPENSTACK MVP VIVA READY

Imaging:
Glance      PASS

Compute:
Nova        PASS

Storage:
Cinder      PASS

======================================

==================================================
18. VERIFY SCRIPT
==================================================

verify.sh checks:

OpenStack CLI works

Keystone token works

mvp-cirros = active

mvp-vm01 = ACTIVE

mvp-volume01 = in-use

network exists

If all true:

MVP READY FOR VIVA

Otherwise display exactly what failed.

==================================================
19. VIVA DOCUMENT
==================================================

Create:

docs/viva-script.md

The entire presentation should require no more than 5-10 minutes.

Suggested speech:

"Em triển khai một mô hình Private Cloud đơn giản sử dụng OpenStack.

OpenStack cung cấp hạ tầng IaaS.

Trong bài này em tập trung demo ba dịch vụ chính:

Glance cho Imaging,
Nova cho Compute,
Cinder cho Storage."

Then:

openstack image list

Say:

"Đây là image do Glance quản lý."

Then:

openstack server list

Say:

"Nova dùng image từ Glance để tạo máy ảo."

Then:

openstack volume list

Say:

"Cinder tạo block storage và volume được gắn vào VM."

Then show:

openstack server show mvp-vm01

and:

openstack volume show mvp-volume01

Finish:

"Ba chức năng yêu cầu của bài gồm Compute, Imaging và Storage
đều đã hoạt động."

==================================================
20. VIVA QUESTIONS
==================================================

Create at least 30 short Q&A.

Focus heavily on:

OpenStack
Private Cloud
IaaS

Nova
Glance
Cinder

Keystone
Neutron
Horizon

VM
Image
Volume

KVM
QEMU
Hypervisor

Examples:

Q:
OpenStack là gì?

A:
OpenStack là nền tảng mã nguồn mở dùng để xây dựng và quản lý
hạ tầng điện toán đám mây, đặc biệt là IaaS.

Q:
Ba dịch vụ chính của demo?

A:

Nova:
Compute

Glance:
Image

Cinder:
Block Storage

Q:
Nova và KVM khác gì nhau?

A:
Nova quản lý vòng đời VM.
KVM thực hiện ảo hóa ở mức hypervisor.

Q:
Tại sao dùng CirrOS?

A:
CirrOS rất nhỏ và khởi động nhanh,
phù hợp cho demo OpenStack.

Q:
Cinder Volume khác VM root disk thế nào?

A:
Root disk thường gắn với instance.
Cinder volume là block storage riêng
và có thể quản lý độc lập.

Q:
Nếu không có KVM thì sao?

A:
Có thể dùng QEMU software virtualization.
Nó chậm hơn nhưng phù hợp demo nhỏ.

==================================================
21. TROUBLESHOOTING
==================================================

Only document common failures:

stack.sh failed

not enough RAM

not enough disk

KVM unavailable

Nova:
No valid host

VM:
ERROR

Glance:
image upload failure

Neutron:
VM has no IP

Cinder:
volume creation failed

Cinder:
volume attach failed

Horizon:
page unreachable

CLI:
authentication failed

Each troubleshooting entry must have:

Symptom

Cause

Diagnostic command

Shortest fix

==================================================
22. CLEANUP
==================================================

Create:

openstack/99-cleanup.sh

Delete:

volume attachment

VM

volume

router interface

router

subnet

network

image

user

project

Make cleanup idempotent.

==================================================
23. DO NOT OVERENGINEER
==================================================

Do NOT add:

Kubernetes
Docker application stack
Ceph
Swift
Heat
Magnum
Octavia
Manila
Trove
Terraform
Ansible
Prometheus
Grafana
ELK
Kafka
Hadoop
Spark
MongoDB
React
Node.js

The exam only requires:

Compute
Storage
Imaging

==================================================
24. DEFINITION OF DONE
==================================================

The project is complete only when:

openstack token issue

works.

openstack image list

contains:

mvp-cirros
active

openstack server list

contains:

mvp-vm01
ACTIVE

openstack volume list

contains:

mvp-volume01
in-use

Horizon is accessible from the Windows browser.

==================================================
25. WORKING STYLE
==================================================

Do not blindly generate scripts.

Work phase by phase.

Phase 1:
inspect environment

Phase 2:
validate Windows host

Phase 3:
validate Ubuntu VM

Phase 4:
install DevStack

Phase 5:
verify APIs

Phase 6:
create demo resources

Phase 7:
verify demo

Phase 8:
write viva documentation

After each phase:

run tests.

If a step fails:

diagnose and fix it before continuing.

Start by producing:

1. final architecture
2. minimum hardware requirements
3. repository tree
4. Windows setup instructions
5. Ubuntu DevStack local.conf
6. installation scripts
7. verification scripts
8. viva documentation