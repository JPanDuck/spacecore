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
<h2>지점 수정</h2>


<form action="/offices/edit" method="post">
    <input type="hidden" name="id" value="${office.id}"/>
    <div>
        지점명: <input type="text" name="name" value="${office.name}" required/>
    </div>
    <div>
        주소: <input type="text" name="address" value="${office.address}"/>
    </div>
    <div>
        상태:
        <select name="status">
            <option value="ACTIVE" ${room.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
            <option value="INACTIVE" ${room.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
        </select>
    </div>
    <button type="submit">수정</button>
</form>

<p><a href="/offices/detail/${office.id}">[상세보기]</a> | <a href="/offices/">[목록]</a></p>
