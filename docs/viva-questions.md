# Viva questions and short answers

1. **OpenStack là gì?** Nền tảng mã nguồn mở để xây dựng và quản lý hạ tầng đám mây, đặc biệt IaaS.
2. **IaaS là gì?** Cung cấp tài nguyên tính toán, mạng và lưu trữ dưới dạng dịch vụ.
3. **Private Cloud là gì?** Cloud phục vụ một tổ chức hoặc phạm vi người dùng riêng.
4. **Ba dịch vụ chính trong demo?** Nova (Compute), Glance (Image), Cinder (Block Storage).
5. **Nova làm gì?** Quản lý vòng đời instance: tạo, chạy, xem, xóa.
6. **Glance làm gì?** Lưu trữ và quản lý catalog image VM.
7. **Cinder làm gì?** Cấp phát volume block storage bền vững.
8. **Keystone làm gì?** Xác thực, phân quyền, project và token.
9. **Neutron làm gì?** Tạo và quản lý network, subnet, router, port, security group.
10. **Horizon là gì?** Dashboard web để quản trị OpenStack.
11. **Image là gì?** Mẫu đĩa hệ điều hành để khởi tạo VM.
12. **Instance là gì?** Máy ảo đang được Nova quản lý.
13. **Volume là gì?** Một thiết bị block storage gắn độc lập vào VM.
14. **Root disk khác volume Cinder?** Root disk khởi tạo cùng instance; Cinder volume quản lý độc lập và có thể gắn lại.
15. **Flavor là gì?** Mẫu tài nguyên VM gồm vCPU, RAM và disk.
16. **`mvp.nano` có cấu hình gì?** 1 vCPU, 512 MB RAM, 1 GB disk.
17. **Tại sao dùng CirrOS?** Image rất nhỏ, boot nhanh, phù hợp lab/demo.
18. **Project là gì?** Vùng tách biệt tài nguyên và quota cho một nhóm người dùng.
19. **User `mvp-user` thuộc đâu?** Thuộc `mvp-project`, với role `member`.
20. **Token Keystone dùng để làm gì?** Chứng minh danh tính khi gọi OpenStack API.
21. **Network `mvp-net` dùng để làm gì?** Kết nối instance trong mạng tenant.
22. **Subnet CIDR của demo?** `192.168.100.0/24`.
23. **Router OpenStack dùng để làm gì?** Kết nối subnet tenant ra external network nếu có.
24. **Security group là gì?** Firewall ảo áp dụng lên port/instance.
25. **Tại sao mở ICMP?** Để có thể kiểm tra ping.
26. **Tại sao mở TCP 22?** Để hỗ trợ SSH nếu instance có đường mạng phù hợp.
27. **Nova và KVM khác gì?** Nova điều phối lifecycle; KVM là hypervisor chạy CPU virtualization.
28. **libvirt có vai trò gì?** Lớp API/driver để Nova điều khiển hypervisor.
29. **QEMU là gì?** Trình giả lập/ảo hóa phần mềm, dùng fallback khi thiếu KVM.
30. **Nếu không có KVM thì sao?** Dùng QEMU; boot chậm hơn nhưng vẫn phù hợp MVP.
31. **DevStack là gì?** Công cụ triển khai OpenStack cho development và lab, không dành production.
32. **Tại sao không dùng Ceph?** MVP chỉ cần một volume; Ceph tăng độ phức tạp ngoài phạm vi.
33. **Trạng thái `ACTIVE` nghĩa là gì?** Instance đã được Nova tạo và chạy thành công.
34. **Trạng thái volume `in-use` nghĩa là gì?** Volume đã được attach vào một instance.
35. **Horizon đăng nhập thế nào?** Dùng URL `/dashboard`, domain `Default`, tài khoản admin hoặc `mvp-user`.
