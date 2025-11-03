<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>내 정보 수정</title>
  <style>
    body { font-family: "Pretendard", sans-serif; margin: 40px; }
    form { max-width: 400px; margin: auto; }
    label { display: block; margin-top: 15px; font-weight: bold; }
    input { width: 100%; padding: 8px; margin-top: 5px; }
    button { margin-top: 20px; padding: 10px 15px; background-color: #6b4f4f; color: white; border: none; cursor: pointer; border-radius: 6px; }
    button:hover { background-color: #8c6b6b; }
    .link { display: block; margin-top: 20px; text-align: center; color: #6b4f4f; text-decoration: none; }
  </style>
</head>

<body>
<h2 style="text-align:center;">내 정보 수정</h2>

<form id="editForm">
  <label>이름</label>
  <input type="text" name="name" value="${user.name}" required>

  <label>이메일</label>
  <input type="email" name="email" value="${user.email}" required>

  <label>전화번호</label>
  <input type="text" name="phone" value="${user.phone}">

  <button type="submit">수정 완료</button>
</form>

<a class="link" href="${pageContext.request.contextPath}/user/mypage">← 마이페이지로 돌아가기</a>

<script>
  document.getElementById("editForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const form = e.target;
    const data = {
      name: form.name.value,
      email: form.email.value,
      phone: form.phone.value
    };

    try {
      const res = await fetch("${pageContext.request.contextPath}/api/user/me", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
      });

      if (res.ok) {
        alert("✅ 내 정보가 성공적으로 수정되었습니다.");
        window.location.href = "${pageContext.request.contextPath}/user/mypage";
      } else {
        const msg = await res.text();
        alert("❌ 수정 실패: " + msg);
      }
    } catch (err) {
      console.error("수정 요청 중 오류:", err);
      alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
    }
  });
</script>
</body>
</html>
