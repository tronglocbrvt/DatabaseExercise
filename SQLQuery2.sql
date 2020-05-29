--Q1. Liệt kê danh sách sinh viên gồm mã, họ tên, phái, ngày sinh.
SELECT MASV, HOTEN, PHAI, NGAYSINH
FROM SINHVIEN

--Q2. Liệt kê danh sách sinh viên thuộc ngành tên là ’Hệ thống thông tin’ (MÃSV, HỌTÊN, PHÁI, NGÀYSINH).
SELECT MASV, HOTEN, PHAI, NGAYSINH
FROM SINHVIEN, NGANH
WHERE NGANH.TENNGANH = N'Hệ thống thông tin' AND NGANH.MANGANH = SINHVIEN.MANGANH

--Q3. Cho biết các ngành có tổng số sinh viên theo học từ trước đến nay lớn hơn 2000 (MÃNGÀNH, TÊNNGÀNH).
SELECT NGANH.MANGANH, NGANH.TENNGANH
FROM NGANH
WHERE NGANH.TSSV > 200

--Q4. Những chuyên đề nào chỉ cho phép không quá 100 sinh viên đăng ký mỗi khi được mở (MÃCĐ, TÊNCĐ).
SELECT*
FROM CHUYENDE
WHERE CHUYENDE.SOSVTD <= 100

--Q5. Danh sách các chuyên đề bắt buộc đối với ngành tên là ’Mạng máy tính’ (MÃCĐ, TÊNCĐ).
SELECT CD.MACD, CD.TENCD
FROM CHUYENDE CD, NGANH, CD_NGANH CDN
WHERE CDN.MANGANH = NGANH.MANGANH AND NGANH.TENNGANH = N'Mạng máy tính' AND CD.MACD = CDN.MACD

--Q6. Mỗi chuyên đề có tất cả bao nhiêu ngành phải học (MÃCĐ, TÊNCĐ, SỐ_NGÀNH).
SELECT CD.MACD, CD.TENCD, COUNT(*) AS SO_NGANH
FROM CHUYENDE CD, CD_NGANH
WHERE CD.MACD = CD_NGANH.MACD
GROUP BY CD.MACD, CD.TENCD

--Q7. Danh sách các sinh viên đăng ký học một chuyên đề tên là ’Java’ nhiều hơn 1 lần (MÃSV, HỌTÊN).
SELECT SV.MASV, SV.HOTEN
FROM SINHVIEN SV, DANGKY DK, CHUYENDE CD
WHERE CD.TENCD = 'Java' AND CD.MACD = DK.MACD AND SV.MASV = DK.MASV
GROUP BY SV.MASV, SV.HOTEN
HAVING COUNT(DK.MACD) > 1

--Q8. Cho danh sách các sinh viên thuộc ngành tên là ’Hệ thống thông tin’ đã đăng ký học chuyên đề “Oracle” (MÃSV, HỌTÊN).
SELECT DISTINCT SINHVIEN.*
FROM SINHVIEN, NGANH, DANGKY,CHUYENDE
WHERE NGANH.TENNGANH = N'Hệ thống thông tin' AND SINHVIEN.MANGANH = NGANH.MANGANH 
AND SINHVIEN.MASV = DANGKY.MASV AND CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = DANGKY.MACD

--Q9. Danh sách các ngành phải học nhiều hơn 2 chuyên đề (MÃNGÀNH, TÊNNGÀNH).
SELECT NGANH.MANGANH, NGANH.TENNGANH
FROM NGANH
WHERE NGANH.SOCD > 2

--Q10. Cho danh sách các sinh viên đã đăng ký nhiều hơn 2 chuyên đề trong học kỳ 1 năm 2009 (MÃSV, HỌTÊN).
SELECT SV.MASV, SV.HOTEN
FROM SINHVIEN SV, DANGKY DK
WHERE SV.MASV = DK.MASV AND DK.HOCKY = 1 AND DK.NAM = 2009
GROUP BY SV.MASV, SV.HOTEN
HAVING COUNT(DK.MACD) > 2

--Q11. Cho biết các ngành phải học chuyên đề 'Java' hoặc chuyên đề 'Oracle'.
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE (CHUYENDE.TENCD = 'Java' OR CHUYENDE.TENCD = 'Oracle') AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q12. Cho biết các ngành vừa phải học chuyên đề ’Java’ vừa phải học chuyên đề ’Oracle’.
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Java' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH
INTERSECT
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q13. Cho biết các ngành phải học chuyên đề ’Java’ nhưng không phải học chuyên đề ’Oracle’.
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Java' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH
EXCEPT
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q14. Liệt kê tên các chuyên đề mà sinh viên có mã là “0012345” đã học.
SELECT DISTINCT CHUYENDE.*
FROM CHUYENDE, DANGKY
WHERE DANGKY.MASV = '0012345' AND DANGKY.MACD = CHUYENDE.MACD

--Q15. Danh sách các sinh viên đã đăng ký học 2 chuyên đề trong học kỳ 1 năm 2004.
CREATE VIEW SVDK AS
SELECT SV.MASV
FROM SINHVIEN SV, DANGKY DK
WHERE SV.MASV = DK.MASV AND DK.HOCKY = 1 AND DK.NAM = 2004
GROUP BY SV.MASV
HAVING COUNT(DK.MACD) = 2
SELECT SINHVIEN.*
FROM SINHVIEN
JOIN SVDK
ON SINHVIEN.MASV = SVDK.MASV

--Q16. Danh sách các sinh viên đã đăng ký học 2 chuyên đề trong học kỳ 1 năm 2004 đều có điểm là “Đạt”.
CREATE VIEW SVDK AS
SELECT SV.MASV
FROM SINHVIEN SV, DANGKY DK
WHERE SV.MASV = DK.MASV AND DK.HOCKY = 1 AND DK.NAM = 2004 AND DK.DIEM = N'Đạt'
GROUP BY SV.MASV
HAVING COUNT(DK.MACD) = 2
SELECT SINHVIEN.*
FROM SINHVIEN
JOIN SVDK
ON SINHVIEN.MASV = SVDK.MASV

--Q17. Cho danh sách các sinh viên đã học tất cả các chuyên đề bắt buộc đối với ngành ’Hệ thống thông tin’.
CREATE VIEW SVDK AS
SELECT DISTINCT SV.MASV
FROM SINHVIEN SV, DANGKY DK, NGANH
WHERE NGANH.TENNGANH = N'Hệ thống thông tin' AND SV.MASV = DK.MASV AND SV.MANGANH = NGANH.MANGANH
	AND NOT EXISTS (SELECT MACD
					FROM CD_NGANH CDN, NGANH N
					WHERE N.TENNGANH = N'Hệ thống thông tin' AND CDN.MANGANH = N.MANGANH 
					EXCEPT
					SELECT DK1.MACD
					FROM DANGKY DK1
					WHERE DK.MASV = DK1.MASV)
SELECT SV.*
FROM SINHVIEN SV
JOIN SVDK
ON SV.MASV = SVDK.MASV


--Q18. Danh sách các sinh viên đã đăng ký học nhiều hơn 1 chuyên đề trong năm học 2005.
CREATE VIEW SVDK AS
SELECT SV.MASV
FROM SINHVIEN SV, DANGKY DK
WHERE SV.MASV = DK.MASV AND DK.NAM = 2005
GROUP BY SV.MASV
HAVING COUNT(DK.MACD) > 1 
SELECT SINHVIEN.*
FROM SINHVIEN
JOIN SVDK
ON SINHVIEN.MASV = SVDK.MASV

--Q19. Danh sách các sinh viên thuộc ngành ’Hệ thống thông tin’ đã học chuyên đề ’Oracle’ mà không học chuyên đề ’CSDL phân tán’ trong năm 2005.
SELECT SV.*
FROM NGANH N, CHUYENDE CD, SINHVIEN SV, DANGKY DK
WHERE N.TENNGANH = N'Hệ thống thông tin' AND SV.MANGANH = N.MANGANH
	AND CD.TENCD = 'Oracle' AND CD.MACD = DK.MACD AND SV.MASV = DK.MASV AND DK.NAM = 2005
EXCEPT
SELECT SV.*
FROM NGANH N, CHUYENDE CD, SINHVIEN SV, DANGKY DK
WHERE N.TENNGANH = N'Hệ thống thông tin' AND SV.MANGANH = N.MANGANH
	AND CD.TENCD = 'CSDL phân tán' AND CD.MACD = DK.MACD AND SV.MASV = DK.MASV AND DK.NAM = 2005

--Q20. Cho đến hiện tại, cho biết mỗi chuyên ngành có bao nhiêu sinh viên theo học.
SELECT NGANH.MANGANH, NGANH.TENNGANH, NGANH.TSSV
FROM NGANH

--Q21. Liệt kê các thể hiện dữ liệu cho biết tất cả các sinh viên thuộc ngành tên là ’Hệ thống thông tin’ đăng ký 
-- học tất cả các chuyên đề bắt buộc đối với ngành ’Hệ thống thông tin’ trong học kỳ 1 năm 2010 (MÃSV, MÃCĐ, HỌCKỲ, NĂM).
SELECT DK.MASV, DK.MACD, DK.HOCKY, DK.NAM
FROM NGANH N, DANGKY DK, SINHVIEN SV
WHERE N.TENNGANH = N'Hệ thống thông tin' AND N.MANGANH = SV.MANGANH AND SV.MASV = DK.MASV
	AND DK.HOCKY = 1 AND DK.NAM = 2010
	AND NOT EXISTS (SELECT MACD
					FROM CD_NGANH
					WHERE CD_NGANH.MANGANH = N.MANGANH
					EXCEPT
					SELECT DK1.MACD
					FROM DANGKY DK1, CD_NGANH CND
					WHERE DK1.MASV = DK.MASV AND DK1.MACD = CND.MACD AND CND.MANGANH = N.MANGANH)

--Q22. Danh sách các sinh viên chưa học chuyên đề nào (MÃSV, HỌTÊN).
SELECT SV.*
FROM SINHVIEN SV
WHERE NOT EXISTS (SELECT*
				FROM DANGKY DK
				WHERE SV.MASV = DK.MASV)

--Q23. Cho biết năm nào, học kỳ nào mở tất cả các chuyên đề bắt buộc cho ngành “Hệ thống thông tin”.
SELECT DISTINCT CDM.HOCKY, CDM.NAM
FROM CD_MO CDM, NGANH N
WHERE N.TENNGANH = N'Hệ thống thông tin' 
AND NOT EXISTS (SELECT CDN.MACD
				FROM CD_NGANH CDN
				WHERE CDN.MANGANH = N.MANGANH
				EXCEPT
				SELECT CDM1.MACD
				FROM CD_MO CDM1
				WHERE CDM1.HOCKY = CDM.HOCKY AND CDM1.NAM = CDM.NAM)
--Q24 Cho biết mã, tên của các chuyên đề thuộc chuyên ngành của sinh viên có mã là “0012345” mà sinh viên này chưa đăng ký học. 
SELECT DISTINCT CD.MACD, CD.TENCD
FROM CHUYENDE CD
WHERE CD.MACD IN (SELECT CDN.MACD
				FROM CD_NGANH CDN, SINHVIEN SV
				WHERE SV.MASV = '0012345' AND CDN.MANGANH = SV.MANGANH
				EXCEPT
				SELECT DK1.MACD
				FROM DANGKY DK1
				WHERE DK1.MASV = '0012345')

--Q25. Danh sách các sinh viên thuộc ngành “Hệ thống thông tin” chỉ học duy nhất 1 chuyên đề trong học kỳ 1 năm 2005.
CREATE VIEW SVDK AS
SELECT SV.MASV
FROM NGANH N, DANGKY DK, SINHVIEN SV
WHERE N.TENNGANH = N'Hệ thống thông tin' AND N.MANGANH = SV.MANGANH AND DK.HOCKY = 1 
	AND DK.NAM = 2005 AND SV.MASV = DK.MASV
GROUP BY SV.MASV
HAVING COUNT(DK.MACD) = 1
SELECT SV.*
FROM SINHVIEN SV
JOIN SVDK
ON SV.MASV = SVDK.MASV

--Q26. Cho biết tên các chuyên đề mà mọi ngành đều phải học chúng.
SELECT CD.TENCD
FROM CHUYENDE CD
WHERE NOT EXISTS (SELECT NGANH.MANGANH
				FROM NGANH
				EXCEPT
				SELECT CDN.MANGANH
				FROM CD_NGANH CDN
				WHERE CDN.MACD = CD.MACD)
--Q27. Danh sách các chuyên đề bắt buộc đối với chuyên ngành tên là “Mạng máy tính” đã được mở ra trong học kỳ 1 năm 2005.
SELECT DISTINCT CDN.*
FROM CD_NGANH CDN, CD_MO CDM, NGANH N
WHERE CDM.HOCKY = 1 AND CDM.NAM = 2005 AND N.TENNGANH = N'Mạng máy tính' AND N.MANGANH = CDN.MANGANH
	AND CDM.MACD = CDN.MACD

--Q28. Danh sách các chuyên đề vừa là chuyên đề bắt buộc cho chuyên ngành tên là “Hệ thống thông tin” 
-- vừa là chuyên đề bắt buộc cho chuyên ngành tên là “Công nghệ tri thức”.
SELECT CD.*
FROM CD_NGANH CDN, NGANH N, CHUYENDE CD
WHERE CDN.MANGANH = N.MANGANH AND N.TENNGANH = N'Hệ thống thông tin' AND CD.MACD = CDN.MACD
INTERSECT 
SELECT CD.*
FROM CD_NGANH CDN, NGANH N, CHUYENDE CD
WHERE CDN.MANGANH = N.MANGANH AND N.TENNGANH = N'Công nghệ tri thức' AND CD.MACD = CDN.MACD

--Q29. Cho danh sách các sinh viên chưa từng học lại một chuyên đề nào.
CREATE VIEW CHUAHOCLAI AS
SELECT SV.MASV
FROM SINHVIEN SV
EXCEPT
SELECT DK.MASV
FROM DANGKY DK
GROUP BY DK.MASV, DK.MACD
HAVING COUNT(DK.DIEM) >= 2

SELECT SV.*
FROM SINHVIEN SV
JOIN CHUAHOCLAI
ON SV.MASV = CHUAHOCLAI.MASV
