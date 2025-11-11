<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>예약 수정</title>
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
        p {
            margin: 15px 0;
        }
    </style>
</head>
<body>
<h2>예약 수정</h2>

<form action="/reservations/edit" method="post">
    <input type="hidden" name="id" value="${reservation.id}">
    <p>사용자 ID: <input type="text" name="userId" value="${reservation.userId}" required></p>
    <p>룸 ID: <input type="text" name="roomId" value="${reservation.roomId}" required></p>
    <p>시작 시각: <input type="datetime-local" name="startAt"
                     value="${fn:substring(reservation.startAt,0,16)}" required></p>
    <p>종료 시각: <input type="datetime-local" name="endAt"
                     value="${fn:substring(reservation.endAt,0,16)}" required></p>
    <p>이용 단위: <input type="text" name="unit" value="${reservation.unit}"></p>
    <p>금액: <input type="number" name="amount" value="${reservation.amount}" step="1000"></p>
    <p>메모: <input type="text" name="memo" value="${reservation.memo}"></p>
    <button type="submit">수정 저장</button>
</form>

<hr/>
<a href="/reservations/detail/${reservation.id}">상세로</a>
</body>
</html>
