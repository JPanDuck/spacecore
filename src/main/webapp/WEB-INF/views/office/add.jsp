<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>공유오피스 지점 등록</title>
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
        select {
            width: 250px;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        div {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<h2>공유오피스지점 등록</h2>

<form action="/offices/add" method="post">
    지점명: <input type="text" name="name"><br>
    주소: <input type="text" name="address"><br>
    위도: <input type="text" name="latitude"><br>
    경도: <input type="text" name="longitude"><br>
    <div>
        상태:
        <select name="status">
            <option value="ACTIVE" selected>ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
        </select>
    </div>
    <button type="submit">등록</button>
</form>

<a href="/offices/">[목록으로]</a>
</body>
</html>