# 5–10 minute viva script

**0:00–1:00 — Architecture.** Say: “Em triển khai một mô hình Private Cloud đơn giản sử dụng OpenStack. OpenStack cung cấp hạ tầng IaaS. Trong bài này em tập trung demo ba dịch vụ chính: Glance cho Imaging, Nova cho Compute, Cinder cho Storage.” Show `docs/architecture.md` or Horizon.

**1:00–2:00 — Identity and services.** Run `openstack token issue`, then `openstack service list`. Explain that Keystone authenticates users and issues the token used by all services.

**2:00–3:00 — Imaging.** Run `openstack image list`. Say: “Đây là image `mvp-cirros` do Glance quản lý. Nova dùng image từ Glance làm mẫu hệ điều hành khi tạo máy ảo.”

**3:00–5:00 — Compute.** Run `openstack server list` and `openstack server show mvp-vm01`. Say: “Nova quản lý vòng đời instance: tạo, chạy, xem trạng thái, xóa. Nova không tự thực hiện ảo hóa CPU; libvirt cùng KVM hoặc QEMU là lớp hypervisor.” Point out `ACTIVE`.

**5:00–6:30 — Storage.** Run `openstack volume list` and `openstack volume show mvp-volume01`. Say: “Cinder cung cấp block storage bền vững. Volume này độc lập với root disk của VM và đang ở trạng thái `in-use` vì đã được gắn vào instance.”

**6:30–8:00 — Dashboard.** Show Horizon: Project → Images, Instances, Volumes, Networks. Finish: “Ba chức năng yêu cầu của bài gồm Compute, Imaging và Storage đều đã hoạt động.”

For a one-command sequence, run `./demo/demo-all.sh`.
