<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>결제 상세</title>
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
<h2>결제 상세</h2>

<c:if test="${not empty payment}">
    <p>결제 ID: ${payment.id}</p>
    <p>가상계좌 ID: ${payment.vaId}</p>
    <p>결제 금액: ${payment.amount}</p>
    <p>상태: ${payment.status}</p>
    <p>생성일: ${payment.createdAt}</p>
</c:if>

<c:if test="${empty payment}">
    <p>결제 정보가 없습니다.</p>
</c:if>

<hr/>
<a href="/payments/">결제 목록으로</a>
</body>
</html>
