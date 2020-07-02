-- 8. List the teachers assigned to teach "Data Mining".
SELECT T.*
FROM TEACHER T, COURSE C, SUBJECT S
WHERE T.ID = C.TeacherID 
	AND C.SubjectID = S.ID
	AND S.Name = 'Data Mining'

-- 9. List the name of the subjects that the teacher named "Nhan Lan" was assigned
SELECT S.Name
FROM SUBJECT S, TEACHER T, COURSE C
WHERE T.Name = 'Nhan Lan'
	AND T.ID = C.TeacherID
	AND A.SubjectID = S.ID

-- 10. Show how many students have passed "Basic Informatics".
SELECT COUNT(*) AS SL
FROM RESULT R, SUBJECT S
WHERE R.SubjectID = S.ID 
	AND S.Name = 'Basic Informatics'
	AND R.Mark >= 5
	AND R.TIMES >= ALL( SELECT R1.TIMES
						FROM RESULT R1 
						WHERE R1.StudentID = R.StudentID
							AND R1.SubjectID = R.SubjectID)
GROUP BY R.SubjectID

-- 11. List the subjects that the student named "Kieu" studies in
SELECT DISTINCT S.*
FROM STUDENT ST, RESULT R, SUBJECT S
WHERE ST.Name LIKE '%Kieu'
	AND ST.ID = R.StudentID
	AND R.SubjectID = S.ID

-- 12. List the teachers who are managed by another teacher. Provide the information including the teacher name and the manager name.
SELECT T1.Name, T2.Name
FROM TEACHER T1, TEACHER T2
WHERE T1.ManagerID = T2.ID

-- 13. Provide information about students who have taken the most mark in 'Computer Networks'
SELECT ST.*
FROM STUDENT ST, RESULT R, SUBJECT S
WHERE ST.ID = R.StudentID 
	AND S.ID = R.SubjectID
	AND S.Name = 'Computer Networks'
	AND R.TIMES >= ALL( SELECT R1.TIMES
						FROM RESULT R1 
						WHERE R1.StudentID = R.StudentID
							AND R1.SubjectID = R.SubjectID)
	AND R.Mark >= ALL ( SELECT R2.MARK
						FROM RESULT R2, SUBJECT S2
						WHERE S2.ID = R2.SubjectID
							AND S2.Name = 'Computer Networks'
							AND R2.TIMES >= ALL ( SELECT R3.TIMES
												FROM RESULT R3
												WHERE R3.StudentID = R2.StudentID
													AND R3.SubjectID = R2.SubjectID))

-- 14. Provide information about students who have pass the most number of subjects.
SELECT STUDENT.*
FROM STUDENT
WHERE ID IN (SELECT ST.ID
			FROM STUDENT ST, RESULT R
			WHERE ST.ID = R.StudentID 
				AND R.Mark >= 5
				AND R.TIMES >= ALL( SELECT R1.TIMES
									FROM RESULT R1 
									WHERE R1.StudentID = R.StudentID
										AND R1.SubjectID = R.SubjectID)
			GROUP BY ST.ID
			HAVING COUNT(*) >= ALL (SELECT COUNT(*)
									FROM RESULT R2
									WHERE R2.Mark >= 5
										AND R2.TIMES >= ALL( SELECT R3.TIMES
															FROM RESULT R3
															WHERE R3.StudentID = R2.StudentID
																AND R3.SubjectID = R2.SubjectID)
									GROUP BY R2.StudentID))

-- 15. Indicate the GPA of the student ‘Nguyen Van An’
SELECT (SUM((R.Mark) * S.Credits) / SUM (S.Credits)) AS GPA_NguyenVanAn
FROM STUDENT ST, SUBJECT S, RESULT R
WHERE ST.Name = 'Nguyen Van An'
	AND ST.ID = R.StudentID
	AND S.ID = R.SubjectID
	AND R.Mark >= 5
	AND R.TIMES >= ALL( SELECT R1.TIMES
						FROM RESULT R1 
						WHERE R1.StudentID = R.StudentID
							AND R1.SubjectID = R.SubjectID)