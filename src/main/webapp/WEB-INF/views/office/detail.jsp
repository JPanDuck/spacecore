<%@ page contentType="text/html; charset=UTF-8" %>
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
<h2>지점 상세</h2

<ul>
    <li><b>ID</b>: ${office.id}</li>
    <li><b>이름</b>: ${office.name}</li>
    <li><b>주소</b>: ${office.address}</li>
    <li><b>상태</b>: ${office.status}</li>
</ul>

<p>
    <a href="/offices/edit/${office.id}">[수정]</a>
    <a href="/offices/">[목록]</a>
</p>
