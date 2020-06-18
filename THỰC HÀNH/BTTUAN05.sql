-- Q35. Cho	biết mức lương cao nhất của	các	giảng viên.
SELECT LUONG AS LUONG_MAX
FROM GIAOVIEN 
WHERE LUONG >= ALL (SELECT GV.LUONG
					FROM GIAOVIEN GV)

-- Q36. Cho	biết những giáo	viên có	lương lớn nhất
SELECT GIAOVIEN.*
FROM GIAOVIEN 
WHERE LUONG >= ALL (SELECT GV.LUONG
					FROM GIAOVIEN GV)
-- Q37. Cho	biết lương cao nhất	trong bộ môn “HTTT”.
SELECT LUONG AS LUONG_MAX_HTTT
FROM GIAOVIEN 
WHERE MABM = 'HTTT' AND LUONG >= ALL (SELECT GV.LUONG
									FROM GIAOVIEN GV
									WHERE GV.MABM = 'HTTT')

-- Q38. Cho	biết tên giáo viên lớn tuổi nhất của bộ môn	Hệ thống thông tin.
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON 
WHERE GIAOVIEN.MABM = BOMON.MABM 
	AND BOMON.TENBM = N'Hệ thống thông tin'
	AND DATEDIFF(DAY,NGSINH,GETDATE()) >= ALL (SELECT DATEDIFF(DAY,GV.NGSINH,GETDATE())
											FROM GIAOVIEN GV
											WHERE GV.MABM = BOMON.MABM)

-- Q39. Cho	biết tên giáo viên nhỏ tuổi	nhất khoa Công nghệ thông tin.
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON, KHOA
WHERE GIAOVIEN.MABM = BOMON.MABM 
	AND BOMON.MAKHOA= KHOA.MAKHOA
	AND KHOA.TENKHOA = N'Công nghệ thông tin'
	AND DATEDIFF(DAY,NGSINH,GETDATE()) <= ALL (SELECT DATEDIFF(DAY,GV.NGSINH,GETDATE())
											FROM GIAOVIEN GV, BOMON BM
											WHERE GV.MABM = BM.MABM
											AND BM.MAKHOA = KHOA.MAKHOA)

-- Q40. Cho	biết tên giáo viên và tên khoa của giáo viên có	lương cao nhất.
SELECT GIAOVIEN.HOTEN, KHOA.TENKHOA
FROM GIAOVIEN, KHOA, BOMON
WHERE GIAOVIEN.MABM = BOMON.MABM
	AND BOMON.MAKHOA = KHOA.MAKHOA
	AND LUONG >= ALL (SELECT GV.LUONG
					FROM GIAOVIEN GV)

--Q41. Cho biết	những giáo viên	có lương lớn nhất trong bộ môn	của	họ.
SELECT GIAOVIEN.*
FROM GIAOVIEN, BOMON, KHOA
WHERE GIAOVIEN.MABM = BOMON.MABM 
	AND BOMON.MAKHOA= KHOA.MAKHOA
	AND LUONG >= ALL (SELECT GV.LUONG
					FROM GIAOVIEN GV, BOMON BM
					WHERE GV.MABM = BM.MABM
						AND BM.MAKHOA = KHOA.MAKHOA)

--Q42. Cho biết tên	những đề tài mà	giáo viên Nguyễn Hoài An chưa tham gia.
SELECT DETAI.TENDT
FROM DETAI
WHERE NOT EXISTS (SELECT*
				FROM THAMGIADT TG, GIAOVIEN GV
				WHERE GV.HOTEN = N'Nguyễn Hoài An'
					AND TG.MAGV = GV.MAGV
					AND TG.MADT = DETAI.MADT)
-- Q43. Cho	biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham	gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài.
SELECT DETAI.TENDT, GIAOVIEN.HOTEN AS GVCNDT
FROM DETAI, GIAOVIEN
WHERE GIAOVIEN.MAGV = DETAI.GVCNDT
	AND NOT EXISTS (SELECT*
					FROM THAMGIADT TG, GIAOVIEN GV
					WHERE GV.HOTEN = N'Nguyễn Hoài An'
						AND TG.MAGV = GV.MAGV
						AND TG.MADT = DETAI.MADT)

-- Q44. Cho	biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN, BOMON BM , KHOA K
WHERE GIAOVIEN.MABM = BM.MABM
	AND BM.MAKHOA = K.MAKHOA
	AND K.TENKHOA = N'Công nghệ thông tin' 
	AND NOT EXISTS (SELECT*
					FROM THAMGIADT TG
					WHERE TG.MAGV = GIAOVIEN.MAGV)
-- Q45. Tìm	những giáo viên	không tham gia bất kỳ đề tài nào
SELECT GIAOVIEN.*
FROM GIAOVIEN
WHERE NOT EXISTS (SELECT*
				FROM THAMGIADT TG
				WHERE TG.MAGV = GIAOVIEN.MAGV)

-- Q46. Cho	biết giáo viên có lương	lớn	hơn	lương của giáo viên “Nguyễn	Hoài An”
SELECT GIAOVIEN.*
FROM GIAOVIEN
WHERE LUONG > (SELECT GV.LUONG
				FROM GIAOVIEN GV
				WHERE GV.HOTEN = N'Nguyễn Hoài An')

-- Q47. Tìm những trưởng bộ môn	tham gia tối thiểu 1 đề tài
SELECT GIAOVIEN.*
FROM GIAOVIEN, BOMON
WHERE BOMON.TRUONGBM = GIAOVIEN.MAGV
	AND EXISTS (SELECT*
				FROM THAMGIADT TG
				WHERE TG.MAGV = GIAOVIEN.MAGV)

-- Q48. Tìm	giáo viên trùng	tên	và cùng	giới tính với giáo viên	khác trong cùng	bộ môn
SELECT GV1.*
FROM GIAOVIEN GV1
WHERE EXISTS (SELECT*
			FROM GIAOVIEN GV2
			WHERE GV2.PHAI = GV1.PHAI 
				AND GV2.HOTEN = GV1.HOTEN
				AND GV2.MABM = GV1.MABM
				AND GV2.MAGV != GV1.MAGV)

-- Q49. Tìm	những giáo viên	có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công nghệ phần mềm”SELECT GV1.*
FROM GIAOVIEN GV1
WHERE GV1.LUONG > ANY(SELECT GV2.LUONG
					FROM GIAOVIEN GV2, BOMON BM
					WHERE GV2.MABM = BM.MABM
						AND BM.TENBM = N'Công nghệ phần mềm')

-- Q50. Tìm	những giáo viên	có lương lớn hơn lương của tất cả giáo viên	thuộc bộ môn "Hệ thống thông tin"
SELECT GV1.*
FROM GIAOVIEN GV1
WHERE GV1.LUONG > ALL(SELECT GV2.LUONG
					FROM GIAOVIEN GV2, BOMON BM
					WHERE GV2.MABM = BM.MABM
						AND BM.TENBM = N'Hệ thống thông tin')

-- Q51. Cho	biết tên khoa có đông giáo viên nhất
SELECT KHOA.TENKHOA
FROM KHOA, GIAOVIEN GV, BOMON BM
WHERE GV.MABM = BM.MABM
	AND BM.MAKHOA = KHOA.MAKHOA
GROUP BY KHOA.MAKHOA, KHOA.TENKHOA
HAVING COUNT(*)	>= ALL (SELECT COUNT(*)
						FROM KHOA K, GIAOVIEN GV1, BOMON BM1
						WHERE GV1.MABM = BM1.MABM
							AND BM1.MAKHOA = K.MAKHOA
						GROUP BY K.MAKHOA)
-- Q52. Cho	biết họ tên	giáo viên chủ nhiệm	nhiều đề tài nhất
SELECT GV.HOTEN
FROM GIAOVIEN GV, DETAI DT
WHERE GV.MAGV = DT.GVCNDT
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(*)	>= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV1, DETAI DT1
						WHERE GV1.MAGV = DT1.GVCNDT
						GROUP BY GV1.MAGV)
-- Q53. Cho	biết mã	bộ môn có nhiều	giáo viên nhất
SELECT MABM
FROM GIAOVIEN 
GROUP BY MABM
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV
						GROUP BY GV.MABM)

-- Q54. Cho	biết tên giáo viên và tên bộ môn của giáo viên tham	gia	nhiều đề tài nhất
SELECT GV.HOTEN, BM.TENBM
FROM GIAOVIEN GV, BOMON BM, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV 
	AND GV.MABM = BM.MABM
GROUP BY GV.HOTEN, BM.TENBM, TG.MAGV
HAVING COUNT (DISTINCT TG.MADT) >= ALL(SELECT COUNT(DISTINCT TG1.MADT)
									FROM THAMGIADT TG1
									GROUP BY TG1.MAGV)

-- Q55. Cho	biết tên giáo viên tham	gia	nhiều đề tài nhất của bộ môn HTTT
SELECT GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV 
	AND GV.MABM = 'HTTT'
GROUP BY GV.HOTEN, TG.MAGV
HAVING COUNT (DISTINCT TG.MADT) >= ALL(SELECT COUNT(DISTINCT TG1.MADT)
									FROM THAMGIADT TG1, GIAOVIEN GV1
									WHERE GV1.MAGV = TG1.MAGV 
										AND GV1.MABM = 'HTTT'
									GROUP BY TG1.MAGV)

--Q56. Cho biết tên	giáo viên và tên bộ môn	của	giáo viên có nhiều người thân nhất
SELECT GV.HOTEN, BM.TENBM
FROM GIAOVIEN GV, BOMON BM, NGUOITHAN NT
WHERE GV.MABM = BM.MABM 
	AND GV.MAGV = NT.MAGV
GROUP BY GV.HOTEN, BM.TENBM, GV.MAGV
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV1, NGUOITHAN NT1
						WHERE GV1.MAGV = NT1.MAGV
						GROUP BY GV1.MAGV)

--Q57. Cho biết tên	trưởng bộ môn mà chủ nhiệm nhiều đề tài	nhất
SELECT GV.HOTEN
FROM GIAOVIEN GV, DETAI DT, BOMON BM
WHERE GV.MAGV = BM.TRUONGBM
	AND BM.TRUONGBM = DT.GVCNDT
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(*)	>= ALL (SELECT COUNT(*)
						FROM GIAOVIEN GV1, DETAI DT1, BOMON BM1
						WHERE GV1.MAGV = BM1.TRUONGBM
							AND BM1.TRUONGBM = DT1.GVCNDT
						GROUP BY GV1.MAGV)