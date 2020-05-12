create database TruongHoc
go
use TruongHoc
go
create table Truong
(
	MaTruong char(6),
	TenTruong nvarchar(40)
	primary key (MaTruong)	
)
go
create table DayNha
(
	MaDay char(3),
	MaTruong char(6),
	TenDay nvarchar(30)
	primary key (MaDay, MaTruong),
	foreign key (MaTruong) references Truong(MaTruong)
)
go
create table Phong
(
	MaPhong char(5),
	MaDay char(3),
	MaTruong char(6),
	MaPhongQuanLy char(5)
	primary key (MaPhong, MaDay, MaTruong),
	foreign key (MaDay, MaTruong) references DayNha(MaDay, MaTruong),
	foreign key (MaPhongQuanLy, MaDay, MaTruong) references Phong(MaPhong, MaDay, MaTruong)
)
go
insert into Truong(MaTruong, TenTruong) values ('HCMUS', N'Khoa Học Tự Nhiên')
insert into Truong(MaTruong, TenTruong) values ('HCMUT', N'Bách Khoa')
insert into Truong(MaTruong, TenTruong) values ('HCMUEL', N'Kinh Tế Luật')
insert into Truong(MaTruong, TenTruong) values ('HCMUIT', N'Công nghệ thông tin')

insert into DayNha(MaDay, MaTruong, TenDay) values ('A', 'HCMUS', N'Dãy nhà A')
insert into DayNha(MaDay, MaTruong, TenDay) values ('A', 'HCMUT', N'Dãy nhà A')
insert into DayNha(MaDay, MaTruong, TenDay) values ('B', 'HCMUIT', N'Dãy nhà B')
insert into DayNha(MaDay, MaTruong, TenDay) values ('B', 'HCMUEL', N'Dãy nhà B')

insert into Phong(MaPhong, MaDay, MaTruong) values ('001', 'A', N'HCMUS')
insert into Phong(MaPhong, MaDay, MaTruong) values ('002', 'A', N'HCMUS')
insert into Phong(MaPhong, MaDay, MaTruong) values ('003', 'A', N'HCMUS')
insert into Phong(MaPhong, MaDay, MaTruong) values ('001', 'A', N'HCMUT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('002', 'A', N'HCMUT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('003', 'A', N'HCMUT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('001', 'B', N'HCMUIT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('002', 'B', N'HCMUIT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('003', 'B', N'HCMUIT')
insert into Phong(MaPhong, MaDay, MaTruong) values ('001', 'B', N'HCMUEL')
insert into Phong(MaPhong, MaDay, MaTruong) values ('002', 'B', N'HCMUEL')
insert into Phong(MaPhong, MaDay, MaTruong) values ('003', 'B', N'HCMUEL')

update Phong set MaPhongQuanLy = '003' where MaPhong = '001' and MaDay = 'A' and MaTruong = 'HCMUS'
update Phong set MaPhongQuanLy = '002' where MaPhong = '003' and MaDay = 'A' and MaTruong = 'HCMUS'
update Phong set MaPhongQuanLy = '001' where MaPhong = '002' and MaDay = 'A' and MaTruong = 'HCMUS'

update Phong set MaPhongQuanLy = '002' where MaPhong = '001' and MaDay = 'A' and MaTruong = 'HCMUT'
update Phong set MaPhongQuanLy = '001' where MaPhong = '003' and MaDay = 'A' and MaTruong = 'HCMUT'
update Phong set MaPhongQuanLy = '003' where MaPhong = '002' and MaDay = 'A' and MaTruong = 'HCMUT'

update Phong set MaPhongQuanLy = '001' where MaPhong = '001' and MaDay = 'B' and MaTruong = 'HCMUEL'
update Phong set MaPhongQuanLy = '002' where MaPhong = '003' and MaDay = 'B' and MaTruong = 'HCMUEL'
update Phong set MaPhongQuanLy = '003' where MaPhong = '002' and MaDay = 'B' and MaTruong = 'HCMUEL'

update Phong set MaPhongQuanLy = '003' where MaPhong = '001' and MaDay = 'B' and MaTruong = 'HCMUIT'
update Phong set MaPhongQuanLy = '002' where MaPhong = '002' and MaDay = 'B' and MaTruong = 'HCMUIT'
update Phong set MaPhongQuanLy = '001' where MaPhong = '003' and MaDay = 'B' and MaTruong = 'HCMUIT'

