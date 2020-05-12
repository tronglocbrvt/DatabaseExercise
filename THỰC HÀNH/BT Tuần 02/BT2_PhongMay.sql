create database PHONGMAY
go
use PHONGMAY
go
create table PhongMay
(
	MaPhong char(6),
	TenPhong nvarchar(40),
	MayChu char(6),
	MaNVQL char(6)
	primary key (MaPhong)	
)
go
create table MayTinh
(
	MaMT char(6),
	TenMT nvarchar(40),
	MaPM char(6),
	TinhTrang BIT
	primary key (MaMT, MaPM)	
)

go
create table NhanVien
(
	MaNV char(6),
	TenNV nvarchar(40) UNIQUE,
	MaNVQL char(6),
	PHAI nvarchar(3) check (PHAI IN ('Nam', N'Nữ'))
	primary key (MaNV)	
)

go
alter table PhongMay add constraint FK_MayChu_MaPhong foreign key (MayChu, MaPhong) references MayTinh(MaMT, MaPM)
alter table PhongMay add constraint FK_MaNVQL foreign key (MANVQL) references NhanVien(MaNV)
alter table NhanVien add constraint FK_MaNVQLNV foreign key (MANVQL) references NhanVien(MaNV)
alter table MayTinh add constraint FK_MaPM foreign key (MAPM) references PhongMay(MaPhong)

go
insert into NhanVien(MaNV, TenNV, PHAI) values ('001', N'Nguyễn Văn A', 'Nam')
insert into NhanVien(MaNV, TenNV, PHAI) values ('002', N'Nguyễn Thị Hồng', N'Nữ')
insert into NhanVien(MaNV, TenNV, PHAI) values ('003', N'Nguyễn Xuân Bảo', 'Nam')
insert into NhanVien(MaNV, TenNV, PHAI) values ('004', N'Nguyễn Thị Hằng', N'Nữ')

update NhanVien set MaNVQL = '002' where MaNV = '001'
update NhanVien set MaNVQL = '003' where MaNV = '002'
update NhanVien set MaNVQL = '004' where MaNV = '003'
update NhanVien set MaNVQL = '001' where MaNV = '004'

insert into PhongMay(MaPhong, TenPhong, MaNVQL) values ('CNPM', N'Công nghệ Phần Mềm', '001')
insert into PhongMay(MaPhong, TenPhong, MaNVQL) values ('HTTT', N'Hệ Thống Thông Tin', '004')
insert into PhongMay(MaPhong, TenPhong, MaNVQL) values ('KHMT', N'Khoa Học Máy Tính', '002')
insert into PhongMay(MaPhong, TenPhong, MaNVQL) values ('MMT', N'Mạng Máy Tính và Viễn Thông', '003')

insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('A', N'Máy A', 'CNPM', 1)
insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('B', N'Máy B', 'CNPM', 0)
insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('A', N'Máy A', 'MMT', 1)
insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('A', N'Máy A', 'HTTT', 1)
insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('B', N'Máy B', 'KHMT', 1)
insert into MayTinh(MaMT, TenMT, MaPM, TinhTrang) values ('A', N'Máy A', 'KHMT', 0)

update PhongMay set MayChu = 'A' where MaPhong = 'CNPM'
update PhongMay set MayChu = 'A' where MaPhong = 'HTTT'
update PhongMay set MayChu = 'B' where MaPhong = 'KHMT'
update PhongMay set MayChu = 'A' where MaPhong = 'MMT'