--Q1. Tên của những thủy thủ đã đăng ký tàu mã là 103. 
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, DANGKY DK
WHERE DK.MATAU = '103' AND DK.MATT = TT.MATT

--Q2. Tên của những thủy thủ có bậc lớn hơn 7.
SELECT DISTINCT TENTT
FROM THUYTHU
WHERE BAC > 7

--Q3. Tên và tuổi của những thủy thủ có bậc lớn hơn 7.
SELECT DISTINCT TENTT, TUOI
FROM THUYTHU
WHERE BAC > 7

--Q4. Tìm tên thủy thủ, tên tàu và ngày đăng ký của tất cả những lần đăng ký.
SELECT DISTINCT TT.TENTT, TAU.TENTAU, DK.NGAY
FROM THUYTHU TT, TAU, DANGKY DK
WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU

--Q5. Tên của những thủy thủ có đăng ký tàu màu đỏ.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, TAU, DANGKY DK
WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU AND TAU.MAU = N'Đỏ'

--Q6. Tìm màu của những con tàu mà thủy thủ tên là Hùng đã đăng ký.
SELECT DISTINCT TAU.MAU
FROM THUYTHU TT, TAU, DANGKY DK
WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU AND TT.TENTT = N'Hùng'

--Q7. Tên của những thủy thủ đã đăng ký ít nhất 1 con tàu.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT
WHERE EXISTS (SELECT*
			FROM DANGKY DK
			WHERE DK.MATT = TT.MATT)

--Q8. Tên của những thủy thủ đã có lần đăng ký con tàu màu đỏ hoặc con tàu màu xanh.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT
WHERE EXISTS (SELECT*
			FROM DANGKY DK, TAU
			WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU AND (TAU.MAU = N'Đỏ' OR TAU.MAU = N'Xanh'))

--Q9. Tên của những thủy thủ đã có lần đăng ký con tàu màu đỏ lẫn con tàu màu xanh.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT
WHERE EXISTS (SELECT*
			FROM DANGKY DK, TAU
			WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU AND TAU.MAU = N'Đỏ')
INTERSECT
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT
WHERE EXISTS (SELECT*
			FROM DANGKY DK, TAU
			WHERE DK.MATT = TT.MATT AND DK.MATAU = TAU.MATAU AND TAU.MAU = N'Xanh')

--Q10. Tên của những thủy thủ đã đăng ký tối thiểu 2 con tàu.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, DANGKY DK
WHERE TT.MATT = DK.MATT 
GROUP BY TT.MATT, TT.TENTT
HAVING COUNT(*) >= 2

--Q11. Tìm mã của những thủy thủ có tuổi lớn hơn 20 chưa từng đăng ký con tàu màu đỏ.
SELECT TT.MATT
FROM THUYTHU TT
WHERE TT.TUOI > 20 AND NOT EXISTS (SELECT*
								FROM DANGKY DK, TAU
								WHERE TT.MATT = DK.MATT AND DK.MATAU = TAU.MATAU AND TAU.MAU = N'Đỏ')

--Q12. Tên của những thủy thủ đã đăng ký tất cả các con tàu.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, DANGKY DK
WHERE TT.MATT = DK.MATT
	AND NOT EXISTS (SELECT TAU.MATAU
					FROM TAU
					EXCEPT
					SELECT DK1.MATAU
					FROM DANGKY DK1
					WHERE DK1.MATT = DK.MATT)

--Q13. Tên của những thủy thủ đã đăng ký tất cả những con tàu có tên là “Marine”.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, DANGKY DK
WHERE TT.MATT = DK.MATT
	AND NOT EXISTS (SELECT TAU.MATAU
					FROM TAU
					WHERE TAU.TENTAU = N'Marine'
					EXCEPT
					SELECT DK1.MATAU
					FROM DANGKY DK1
					WHERE DK1.MATT = DK.MATT)

--Q14. Tên thủy thủ đã đăng ký tất cả những con tàu màu đỏ.
SELECT DISTINCT TT.TENTT
FROM THUYTHU TT, DANGKY DK
WHERE TT.MATT = DK.MATT
	AND NOT EXISTS (SELECT TAU.MATAU
					FROM TAU
					WHERE TAU.MAU = N'Đỏ'
					EXCEPT
					SELECT DK1.MATAU
					FROM DANGKY DK1
					WHERE DK1.MATT = DK.MATT)
