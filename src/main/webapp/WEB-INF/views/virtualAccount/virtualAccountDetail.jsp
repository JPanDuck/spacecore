<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>가상계좌 정보</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #fafafa;
            margin: 50px;
        }
        h2 { color: #333; }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input {
            width: 250px;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #7b6cf6;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #6957f2;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #7b6cf6;
        }
    </style>
</head>
<body>
<h2>가상계좌 상세</h2>
<p>예약 ID: ${reservationId}</p>
<p>계좌번호: ${accountNo != null ? accountNo : '가상계좌 없음'}</p>

<form action="/virtual-accounts/expire" method="post">
    <button type="submit">만료처리 실행</button>
</form>

<a href="/reservations/detail/${reservationId}">예약 상세로</a>
</body>
</html>
