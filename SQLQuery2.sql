﻿--Q1
SELECT MASV, HOTEN, PHAI, NGAYSINH
FROM SINHVIEN
--Q2
SELECT MASV, HOTEN, PHAI, NGAYSINH
FROM SINHVIEN, NGANH
WHERE NGANH.TENNGANH = N'Hệ thống thông tin' AND NGANH.MANGANH = SINHVIEN.MANGANH
--Q3
SELECT NGANH.MANGANH, NGANH.TENNGANH
FROM NGANH
WHERE NGANH.TSSV > 200
--Q4
SELECT*
FROM CHUYENDE
WHERE CHUYENDE.SOSVTD <= 100
--Q5
SELECT CD.MACD, CD.TENCD
FROM CHUYENDE CD, NGANH, CD_NGANH CDN
WHERE CDN.MANGANH = NGANH.MANGANH AND NGANH.TENNGANH = N'Mạng máy tính' AND CD.MACD = CDN.MACD
--Q6
SELECT CD.MACD, CD.TENCD, COUNT(*) AS SO_NGANH
FROM CHUYENDE CD, CD_NGANH
WHERE CD.MACD = CD_NGANH.MACD
GROUP BY CD.MACD, CD.TENCD
--Q7

--Q8
SELECT DISTINCT SINHVIEN.*
FROM SINHVIEN, NGANH, DANGKY,CHUYENDE
WHERE NGANH.TENNGANH = N'Hệ thống thông tin' AND SINHVIEN.MANGANH = NGANH.MANGANH 
AND SINHVIEN.MASV = DANGKY.MASV AND CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = DANGKY.MACD
--Q9

--Q10

--Q11
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE (CHUYENDE.TENCD = 'Java' OR CHUYENDE.TENCD = 'Oracle') AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q12
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Java' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH
INTERSECT
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q13
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Java' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH
EXCEPT
SELECT NGANH.*
FROM NGANH, CHUYENDE, CD_NGANH
WHERE CHUYENDE.TENCD = 'Oracle' AND CHUYENDE.MACD = CD_NGANH.MACD
		AND CD_NGANH.MANGANH = NGANH.MANGANH

--Q14 ---------- MÃ LÀ 0012345
SELECT DISTINCT CHUYENDE.*
FROM CHUYENDE, DANGKY
WHERE DANGKY.MASV = '002' AND DANGKY.MACD = CHUYENDE.MACD