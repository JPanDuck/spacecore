<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>가상계좌 정보</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
            background: var(--cream-base);
            color: var(--text-primary);
            margin: 50px;
        }
        h2 { 
            color: var(--choco);
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: 600;
            color: var(--text-primary);
        }
        input {
            width: 250px;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            background: var(--white);
            color: var(--text-primary);
        }
        button {
            margin-top: 20px;
            padding: 12px 24px;
            background: var(--amber);
            color: var(--white);
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
        }
        button:hover {
            background: var(--mocha);
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: var(--amber);
            font-weight: 500;
        }
        a:hover {
            color: var(--mocha);
        }
        p {
            margin: 12px 0;
            color: var(--text-primary);
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
