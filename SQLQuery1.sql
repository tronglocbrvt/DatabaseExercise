--Q1. Cho biết danh sách giáo viên gồm mã, họ tên, phái, ngày sinh.
SELECT MAGV, HOTEN, PHAI, NGSINH
FROM GIAOVIEN
--Q2. Cho danh sách đề tài gồm mã đề tài, tên đề tài, kinh phí.
SELECT MADT, TENDT, KINHPHI
FROM DETAI
--Q3. Cho biết danh sách giáo viên có lương lớn hơn 2000.
SELECT *
FROM GIAOVIEN
WHERE LUONG > 2000
--Q4. Cho biết danh sách giáo viên thuộc bộ môn có mã là HTTT.
SELECT *
FROM GIAOVIEN
WHERE MABM = 'HTTT'
--Q5. Cho biết danh sách giáo viên thuộc bộ môn mã là HTTT có lương lớn hơn 2000.
SELECT *
FROM GIAOVIEN
WHERE MABM = 'HTTT' AND LUONG > 2000
--Q6. Cho biết những bộ môn chưa biết người làm trưởng bộ môn.
SELECT *
FROM BOMON
WHERE TRUONGBM IS NULL
--Q7. Cho biết những bộ môn đã phân công giáo viên làm trưởng bộ môn.
SELECT *
FROM BOMON
WHERE TRUONGBM IS NOT NULL
--Q8. Cho biết danh sách gồm mã, họ tên, phái, ngày sinh của các giáo viên có lương lớn hơn 2000.
SELECT MAGV, HOTEN, PHAI, NGSINH
FROM GIAOVIEN
WHERE LUONG > 2000
--Q9. Cho biết danh sách gồm mã các giáo viên có tham gia đề tài mã số 001 hoặc đề tài có mã là 002.
SELECT DISTINCT MAGV
FROM THAMGIADT
WHERE THAMGIADT.MADT = '001' OR THAMGIADT.MADT = '002'
--Q10. Cho biết danh sách gồm mã các giáo viên vừa có tham gia đề tài mã số 001 vừa có tham gia đề tài mã số 002.
SELECT DISTINCT MAGV
FROM THAMGIADT
WHERE THAMGIADT.MADT = '001'
INTERSECT
SELECT DISTINCT MAGV
FROM THAMGIADT
WHERE THAMGIADT.MADT = '002'
--Q11. Cho biết danh sách gồm mã các giáo viên có tham gia đề tài mã số 001 nhưng không có tham gia đề tài mã số 002.
SELECT DISTINCT MAGV
FROM THAMGIADT
WHERE THAMGIADT.MADT = '001'
EXCEPT
SELECT DISTINCT MAGV
FROM THAMGIADT
WHERE THAMGIADT.MADT = '002'
--Q12. Cho biết các thể hiện cho biết tất cả các giáo viên thuộc bộ môn HTTT 
-- tham gia tất cả các công việc của các đề tài cấp trường. Danh sách kết xuất gồm mã giáo viên, mã đề tài, số thứ tự.
SELECT DISTINCT GV.MAGV, TG.MADT, TG.STT
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MABM = 'HTTT' AND GV.MAGV = TG.MAGV
	AND NOT EXISTS ((SELECT CV.MADT, CV.SOTT
					FROM CONGVIEC CV, DETAI DT
					WHERE CV.MADT = DT.MADT AND DT.CAPQL = N'Trường')
					EXCEPT
					(SELECT TG2.MADT, TG2.STT
					FROM THAMGIADT TG2, DETAI D
					WHERE TG2.MAGV = TG.MAGV AND TG2.MADT = D.MADT AND D.CAPQL = N'Trường'))
--Q13. Liệt kê danh sách các thể hiện cho biết các giáo viên thuộc bộ môn mã là MMT 
-- tham gia tất cả các công việc liên quan đến đề tài mã là 001.
SELECT GIAOVIEN.*
FROM GIAOVIEN 
WHERE GIAOVIEN.MAGV IN (SELECT DISTINCT GV.MAGV
						FROM GIAOVIEN GV, THAMGIADT TG
						WHERE GV.MABM = 'MMT' AND GV.MAGV = TG.MAGV AND TG.MADT = '001'
						GROUP BY GV.MAGV
						HAVING COUNT(*) = (SELECT COUNT(CV.SOTT) FROM CONGVIEC CV WHERE CV.MADT = '001'))

--Q14. Liệt kê danh sách các thể hiện cho biết các giáo viên thuộc bộ môn tên là ‘Mạng máy tính’ 
-- tham gia tất cả các công việc liên quan đề tài tên là ‘Ứng dụng hóa học xanh’.
SELECT GIAOVIEN.*
FROM GIAOVIEN 
WHERE GIAOVIEN.MAGV IN (SELECT DISTINCT GV.MAGV
						FROM GIAOVIEN GV, BOMON BM, THAMGIADT TG
						WHERE BM.TENBM = N'Mạng Máy Tính' AND GV.MABM = BM.MABM AND GV.MAGV = TG.MAGV
							AND TG.MADT IN (SELECT DT.MADT FROM DETAI DT WHERE DT.TENDT = N'Ứng dụng hóa học xanh')
						GROUP BY GV.MAGV
						HAVING COUNT(*) = (SELECT COUNT(CV.SOTT) 
											FROM CONGVIEC CV,DETAI D
											WHERE CV.MADT = D.MADT AND D.TENDT = N'Ứng dụng hóa học xanh'))

--Q15. Liệt kê danh sách các thể hiện cho biết giáo viên mã là 003 tham gia tất cả các công việc 
-- liên quan đến đề tài mã là 001.
SELECT DISTINCT GV.*
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = '003' AND TG.MAGV = '003' AND TG.MADT = '001'
	AND NOT EXISTS ((SELECT CV.SOTT
					FROM CONGVIEC CV
					WHERE CV.MADT = '001')
					EXCEPT
					(SELECT TG2.STT
					FROM THAMGIADT TG2
					WHERE TG2.MAGV = '003' AND TG2.MADT = '001'))

--Q16. Cho biết danh sách giáo viên và mã, tên bộ môn mà giáo viên trực thuộc. 
-- Danh sách kết xuất gồm MÃGV, HỌTÊN, PHÁI, NGÀYSINH, MÃBM, TÊNBM.
SELECT GV.MAGV, GV.HOTEN, GV.PHAI, GV.NGSINH, GV.MABM, BOMON.TENBM
FROM GIAOVIEN GV, BOMON
WHERE GV.MABM = BOMON.MABM
--Q17. Cho biết danh sách các trưởng khoa.
SELECT GIAOVIEN.*
FROM GIAOVIEN, KHOA
WHERE KHOA.TRUONGKHOA = GIAOVIEN.MAGV
--Q18. Cho biết danh sách các bộ môn và tên của người làm trưởng bộ môn.
SELECT BOMON.*, GIAOVIEN.HOTEN
FROM BOMON, GIAOVIEN
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV
--Q19. Cho biết danh sách gồm thông tin các bộ môn và tên của người làm trưởng bộ môn, 
-- đối với những bộ môn chưa biết giáo viên nào làm trưởng bộ môn thì tại các cột cho biết mã 
-- và tên của trưởng bộ môn mang giá trị rỗng (null).
SELECT BOMON.*, GIAOVIEN.HOTEN
FROM BOMON
LEFT OUTER JOIN GIAOVIEN
ON BOMON.TRUONGBM = GIAOVIEN.MAGV
--Q20. Cho biết danh sách gồm thông tin giáo viên và đề tài mà giáo viên đã tham gia, những giáo
-- viên nào chưa có tham gia đề tài thì tại các cột cho biết thông tin đề tài hiện giá trị rỗng.
-- Danh sách kết xuất gồm MÃGV, HỌTÊN, MÃĐT, STT, TÊNCV, TÊNĐT.
SELECT DISTINCT GV.MAGV, GV.HOTEN, TG.MADT, TG.STT, CV.TENCV, DT.TENDT
FROM GIAOVIEN GV
LEFT JOIN ((THAMGIADT TG JOIN DETAI DT
		ON TG.MADT = DT.MADT)
		JOIN CONGVIEC CV
		ON TG.MADT = CV.MADT AND TG.STT = CV.SOTT)
ON GV.MAGV = TG.MAGV
--Q21. Cho biết danh sách gồm mã, họ tên, phái, ngày sinh của các giáo viên thuộc bộ môn tên là ‘Hệ thống thông tin’.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN, GIAOVIEN.PHAI, GIAOVIEN.NGSINH
FROM GIAOVIEN, BOMON
WHERE BOMON.TENBM = N'Hệ thống thông tin' AND GIAOVIEN.MABM = BOMON.MABM
--Q22. Với những đề tài cấp trường và cấp Đại học quốc gia thuộc chủ đề là ‘Quản lý giáo dục’,
-- cho biết mã và tên các giáo viên làm chủ nhiệm đề tài
SELECT DISTINCT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM DETAI, GIAOVIEN, THAMGIADT, CHUDE
WHERE CHUDE.TENCD = N'Quản lý giáo dục' AND CHUDE.MACD = DETAI.MACD
	AND (DETAI.CAPQL = N'Trường' OR DETAI.CAPQL = 'ĐHQG')
	AND DETAI.GVCNDT = GIAOVIEN.MAGV
--Q23. Cho biết danh sách giáo viên và tên người quản lý chuyên môn với kết quả gồm các cột sau: 
-- MÃGV, HỌTÊN, NGÀYSINH, TÊN_GVQLCM. Chỉ xuất thông tin các giáo viên có người quản lý chuyên môn.
SELECT GV1.MAGV, GV1.HOTEN, GV1.NGSINH, GV2.HOTEN AS TEN_GVQLCM
FROM GIAOVIEN GV1, GIAOVIEN GV2
WHERE GV1.GVQLCM = GV2.MAGV
--Q24. Cho biết danh sách gồm mã và tên các giáo viên có tham gia đề tài tên là ‘HTTT quản lý
-- các trường ĐH’ hoặc đề tài có tên là ‘HTTT quản lý giáo vụ cho một Khoa’.
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE (DT.TENDT = N'HTTT quản lý các trường ĐH' OR DT.TENDT = N'HTTT quản lý giáo vụ cho một Khoa')
	AND DT.MADT = TG.MADT AND GV.MAGV = TG.MAGV
--Q25. Cho biết danh sách gồm mã và tên các giáo viên vừa có tham gia đề tài tên là ‘Ứng dụng
-- hóa học xanh’ vừa có tham gia đề tài có tên là ‘Nghiên cứu tế bào gốc’.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE DT.TENDT = N'Ứng dụng hóa học xanh'
	AND DT.MADT = TG.MADT AND GV.MAGV = TG.MAGV
INTERSECT
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE DT.TENDT = N'Nghiên cứu tế bào gốc'
	AND DT.MADT = TG.MADT AND GV.MAGV = TG.MAGV
--Q26. Những giáo viên nào chưa từng tham gia đề tài (mã giáo viên, tên giáo viên).
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT*
				  FROM THAMGIADT
				  WHERE GIAOVIEN.MAGV = THAMGIADT.MAGV)
--Q27. Cho biết danh sách các giáo viên có người quản lý chuyên môn không ở cùng một thành phố.
SELECT GV1.*
FROM GIAOVIEN GV1, GIAOVIEN GV2
WHERE GV1.GVQLCM = GV2.MAGV AND GV2.DIACHI <> GV1.DIACHI -- DIACHI = THANHPHO
--Q28. Cho biết danh sách các giáo viên tham gia tất cả các công việc của đề tài mã là 001.
SELECT DISTINCT GV.*
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV AND TG.MADT = '001'
	AND NOT EXISTS ((SELECT CV.SOTT
					FROM CONGVIEC CV
					WHERE CV.MADT = '001')
					EXCEPT
					(SELECT TG2.STT
					FROM THAMGIADT TG2
					WHERE TG2.MAGV = TG.MAGV AND TG2.MADT = '001'))
--Q29. Có tất cả bao nhiêu giáo viên.
SELECT COUNT(*) AS SL_GV
FROM GIAOVIEN
--Q30. Mỗi bộ môn có bao nhiêu giáo viên (mã bộ môn, tên bộ môn, số giáo viên).
SELECT GIAOVIEN.MABM, BOMON.TENBM, COUNT(*) SL_GV
FROM BOMON, GIAOVIEN
WHERE GIAOVIEN.MABM = BOMON.MABM
GROUP BY GIAOVIEN.MABM, BOMON.TENBM
--Q31. Mỗi bộ môn có bao nhiêu giáo viên sinh trước năm 1975 (mã bộ môn, tên bộ môn, số giáo viên).
SELECT GIAOVIEN.MABM, BOMON.TENBM, COUNT(*) SL_GV
FROM BOMON, GIAOVIEN
WHERE GIAOVIEN.MABM = BOMON.MABM AND YEAR(GIAOVIEN.NGSINH) < 1975
GROUP BY GIAOVIEN.MABM, BOMON.TENBM
--Q32. Cho biết những bộ môn có số giáo viên nữ lớn hơn 5 (mã bộ môn, tên bộ môn, số giáo viên nữ).
SELECT GIAOVIEN.MABM, BOMON.TENBM, COUNT(*) SL_GV_Nu
FROM BOMON, GIAOVIEN
WHERE GIAOVIEN.MABM = BOMON.MABM AND GIAOVIEN.PHAI = N'Nữ' 
GROUP BY GIAOVIEN.MABM, BOMON.TENBM
HAVING COUNT(*) > 5
--Q33. Có bao nhiêu đề tài được thực hiện từ năm 2007 đến năm 2010.
SELECT COUNT(*) AS SL_DETAI
FROM DETAI
WHERE YEAR(DETAI.NGAYBD) BETWEEN 2007 AND 2010
--Q34. Thêm vào bảng THAMGIAĐT các bộ dữ liệu cho biết giáo viên mã là 003 tham gia tất cả các công việc của đề tài mã là 001.
INSERT INTO THAMGIADT(MAGV, MADT, STT)
SELECT DISTINCT '003', CV.MADT, CV.SOTT
FROM CONGVIEC CV
WHERE CV.MADT = '001' AND CV.SOTT IN ((SELECT CV1.SOTT
									FROM CONGVIEC CV1
									WHERE CV1.MADT = '001')
									EXCEPT
									(SELECT TG.STT
									FROM THAMGIADT TG
									WHERE TG.MAGV = '003' AND TG.MADT = '001'))
--Q35. Xóa các dòng dữ liệu liên quan đến đề tài 002 trong bảng THAMGIAĐT.
DELETE FROM THAMGIADT
WHERE THAMGIADT.MADT = '002'
--Q36. Cập nhật lương của những giáo viên thuộc bộ môn mã là HTTT tăng 1.5 lần.
UPDATE GIAOVIEN
SET LUONG = LUONG*1.5
WHERE GIAOVIEN.MABM = 'HTTT'
--Q37. Sửa phụ cấp cho những giáo viên tham gia đề tài mã là 006 thành 2.
UPDATE THAMGIADT
SET PHUCAP = 2
WHERE THAMGIADT.MADT = '006'
	
---------------------- BÀI 3
--Q1. Hãy cho biết thông tin giáo viên (MAGV, HOTEN) làm trưởng bộ môn hoặc trưởng khoa.
SELECT DISTINCT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON, KHOA
WHERE GIAOVIEN.MAGV = BOMON.TRUONGBM OR GIAOVIEN.MAGV = KHOA.TRUONGKHOA
--Q2. Hãy cho biết thông tin giáo viên nào trùng ngày sinh với người quản lý chuyên môn của mình. 
-- Kết quả cho ra thông tin: mã giáo viên, tên giáo viên, mã giáo viên quản lý, tên giáo viên quản lý
SELECT GV1.MAGV, GV1.HOTEN, GV2.MAGV AS MAGVQL, GV2.HOTEN AS TENGVQL
FROM GIAOVIEN GV1, GIAOVIEN GV2
WHERE GV1.GVQLCM = GV2.MAGV AND GV1.NGSINH = GV2.NGSINH
--Q3. Cho biết mã, tên các giáo viên thuộc bộ môn Hệ thống thông tin và chưa từng tham gia đề tài nào.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON
WHERE BOMON.TENBM = N'Hệ thống thông tin' AND BOMON.MABM = GIAOVIEN.MABM 
										  AND  NOT EXISTS (SELECT*
														   FROM THAMGIADT
														   WHERE THAMGIADT.MAGV = GIAOVIEN.MAGV)
--Q4. Cho biết khoa nào (tên khoa) có nhiều bộ môn trực thuộc nhất.
SELECT DISTINCT KHOA.TENKHOA
FROM KHOA, BOMON
WHERE BOMON.MAKHOA = KHOA.MAKHOA
GROUP BY KHOA.TENKHOA
HAVING COUNT(BOMON.MABM) >= ALL(SELECT COUNT(BOMON.MABM)
								FROM BOMON, KHOA
								WHERE BOMON.MAKHOA = KHOA.MAKHOA
								GROUP BY KHOA.TENKHOA)
--Q5. Với mỗi đề tài, cho biết giáo viên nào tham gia đề tài đó với tổng phụ cấp lớn nhất. 
-- Thông tin xuất ra gồm có tên đề tài, tên giáo viên, tổng tiền phụ cấp.
SELECT DT.TENDT, GV.HOTEN, SUM(TG.PHUCAP) AS PHUCAP_MAX
FROM THAMGIADT TG, DETAI DT, GIAOVIEN GV
WHERE GV.MAGV = TG.MAGV AND TG.MADT = DT.MADT
GROUP BY TG.MADT, TG.MAGV, DT.TENDT, GV.HOTEN
HAVING SUM(TG.PHUCAP) >= ALL(SELECT SUM(TG1.PHUCAP)
							FROM THAMGIADT TG1
							WHERE TG.MADT = TG1.MADT
							GROUP BY TG1.MAGV, TG1.MADT)
--Q6. Cho biết trưởng khoa (tên trưởng khoa) có tuổi nhỏ nhất trong tất cả các trưởng khoa.
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV, KHOA K
WHERE K.TRUONGKHOA = GV.MAGV AND (DATEDIFF(D, GETDATE(), GV.NGSINH)) >= ALL(SELECT DATEDIFF(D, GETDATE(), GV.NGSINH)
																			FROM GIAOVIEN GV, KHOA K
																			WHERE K.TRUONGKHOA = GV.MAGV)

--Q7. Cho biết giáo viên nào (mã giáo viên, tên giáo viên) tham gia đã tham gia tất cả các công việc thuộc một đề tài bất ky
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MAGV = TG.MAGV AND TG.MADT = DT.MADT
GROUP BY TG.MADT, GV.MAGV, GV.HOTEN
HAVING COUNT(*) = (SELECT COUNT(CV.SOTT)
					FROM CONGVIEC CV
					WHERE CV.MADT = TG.MADT)

--Q8. Cho biết đề tài nào (mã đề tài, tên đề tài) thuộc cấp quản lý ‘Quốc gia’ được tất cả các giáo viên thuộc bộ môn hệ thống thông tin tham gia thực hiện.
SELECT DISTINCT DT.MADT, DT.TENDT
FROM DETAI DT, THAMGIADT TG
WHERE DT.CAPQL = N'Quốc gia' AND DT.MADT = TG.MADT
	AND NOT EXISTS ((SELECT GV.MAGV
					FROM GIAOVIEN GV, BOMON BM
					WHERE BM.TENBM = N'Hệ thống thông tin' AND BM.MABM = GV.MABM)
					EXCEPT
					(SELECT TG1.MAGV
					FROM THAMGIADT TG1
					WHERE TG1.MADT = TG.MADT))
-- Cách 2
SELECT DISTINCT DT.MADT, DT.TENDT
FROM DETAI DT, THAMGIADT TG
WHERE DT.CAPQL = N'Quốc gia' AND DT.MADT = TG.MADT
	AND TG.MAGV IN (SELECT GV.MAGV 
					FROM GIAOVIEN GV, BOMON BM
					WHERE BM.TENBM = N'Hệ thống thông tin' AND BM.MABM = GV.MABM)
GROUP BY DT.MADT, DT.TENDT 
HAVING COUNT(DISTINCT TG.MAGV) = (SELECT COUNT(G.MAGV)
								FROM GIAOVIEN G, BOMON B
								WHERE B.TENBM = N'Hệ thống thông tin' AND B.MABM = G.MABM)


--Q9. Hãy cho biết giáo viên (mã giáo viên, tên giáo viên) nào tham gia thực hiện nhiều đề tài nhất trong từng bộ môn của họ
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV
GROUP BY GV.MABM, GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) >= ALL (SELECT COUNT(DISTINCT TG1.MADT)
									FROM THAMGIADT TG1, GIAOVIEN GV1
									WHERE GV1.MABM = GV.MABM AND GV1.MAGV = TG1.MAGV
									GROUP BY GV1.MABM, TG1.MAGV)

