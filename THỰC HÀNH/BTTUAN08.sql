-- Câu 01
alter table Class
add evaluation nvarchar(50)

-- Câu 02
go 
create proc tinhDTB
@studentID nchar(10), @dtb float output
as 
begin
select @dtb = sum(r.mark*sub.credits) / sum(sub.credits)
from result r, subject sub
where r.studentID = @studentID
		and r.subjectID = sub.ID 
		and r.mark >= 5
		and r.times >= all (select r1.times 
							from result r1
							where r1.studentID = @studentID
								and r1.subjectID = sub.ID)
end
go

create proc fillEvaluation 
@classID nchar(10), @evaluation nvarchar(50) output
as
begin
	if (not exists (select* from Class where ID = @classID))
	begin
		print('Loi khong ton tai lop hoc')
		return
	end
	declare @i int

	select @i = count(*)
	from Student
	where student.ID in
		(select distinct r.StudentID
		from Result r, Student s, Subject su
		where s.ClassID = @classID
			and s.ID = r.StudentID
			and r.SubjectID = su.ID
			and su.Credits = 4
			and r.Mark >= 5
			and r.Times >= all(select r1.Times 
							from result r1 
							where r1.studentID = r.studentID 
								and r1.subjectID = r.subjectID)
		group by r.StudentID
		having count(*) = (select count(*)
							from Subject su1
							where su1.Credits = 4))

	if (@i != (select Class.NumofStude from Class where Class.ID = @classID))
		set @evaluation = N'Không Đạt'
	else 
	begin 
		declare c cursor for select ID from student where student.ClassID = @classID
		open c
		declare @ID nchar(10)
		declare @dtbLop float
		set @dtbLop = 0
		fetch next from c into @ID
		while(@@fetch_status = 0)
		begin
			declare @dtb float
			exec tinhDTB @ID, @dtb output
			set @dtbLop = @dtbLop + @dtb
			fetch next from c into @ID
		end
		close c
		deallocate c
		
		set @dtbLop = @dtbLop / (select Class.NumofStude from Class where Class.ID = @classID)
		if (@dtbLop > 7)
			set @evaluation = N'Giỏi'
		else 
			set @evaluation = N'Khá'
	end
	update Class set evaluation = @evaluation where Class.ID = @classID
end
go

declare @evaluation nvarchar(50)
exec fillEvaluation N'LH000001', @evaluation output

--Câu 3:
go
create proc FillToAllClass
as
begin
	declare d cursor for select Class.ID from Class
	open d
	declare @classID nchar(10)
	fetch next from d into @classID
	while(@@fetch_status = 0)
	begin
		declare @evaluation nvarchar(50)
		exec fillEvaluation @classID, @evaluation output
		fetch next from d into @classID
	end
	close d
	deallocate d
end
go
exec FillToAllClass

-- Cau 04
go
create proc DSSV
@classID nchar(10)
as
begin
	declare c cursor for
	(select distinct s.Name
		from Result r, Student s, Subject su
		where s.ClassID = @classID
			and s.ID = r.StudentID
			and r.SubjectID = su.ID
			and su.Credits =4
			and r.Mark >= 5
			and r.Times >= all(select r1.Times 
							from result r1 
							where r1.studentID = r.studentID 
								and r1.subjectID = r.subjectID)
		group by r.StudentID, s.Name
		having count(*) = (select count(*)
							from Subject su1
							where su1.Credits = 4))
	open c
	declare @HoTen nvarchar(50)
	declare @i int
	set @i = 0
	fetch next from c into @HoTen
	while(@@fetch_status = 0)
	begin
	set @i = @i + 1
	print '		' + cast(@i as varchar(10)) + '. ' + @HoTen
	fetch next from c into @HoTen
	end
	print N'Tổng cộng: ' + cast(@i as varchar(10))
	close c
	deallocate c
end
go

create proc reportClass
as
begin
	declare e cursor for
	(select Class.ID, Teacher.Name
	from Class, Teacher
	where Class.ManagerID = Teacher.ID)
	open e
	declare @ID nchar(10)
	declare @HoTenGV nvarchar(50)
	fetch next from e into @ID, @HoTenGV
	while (@@fetch_status = 0)
	begin
		print N'Mã Lớp: ' + @ID + '	' + N'Tên GVCN: ' + @HoTenGV
		print '	' + N'Danh sách sinh viên thi đậu tất cả môn học có 4t/c:'
		exec DSSV @ID
		fetch next from e into @ID, @HoTenGV
	end
	close e
	deallocate e
end
go

exec reportClass