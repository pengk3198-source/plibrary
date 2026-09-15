<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>전자 도서관</title>

<style>

body{
    background:#f2f2f5;
    margin:0;
    font-family:Arial;
}

.top-bar{
    height:70px;
    background:linear-gradient(to right,#5d5fef,#7d4fd9);
}

.book-list {
    display: grid;
    grid-template-columns: repeat(4, 200px);
    gap: 25px;
    justify-content: center;
    padding: 40px;
}

.book-card {
    background: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.15);
    text-align: center;
}

.book-cover {
    width: 100%;
    height: 250px;
    object-fit: cover;
}

.book-card h3 {
    font-size: 16px;
    padding: 12px;
}

.book-card a {
    display:inline-block;
    margin-bottom:15px;
    padding:8px 16px;
    background:#6b5fd3;
    color:white;
    text-decoration:none;
    border-radius:6px;
}

body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #f4f6f9;

}
/* 背景遮罩 */
.modal {
    display: none;
    position: fixed;
    z-index: 999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    
    background: rgba(0,0,0,0.5);
}

/* 弹窗内容 */
.modal-content {
    background: white;
    width: 300px;
    margin: 150px auto;
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    position: relative;
}

/* 关闭按钮 */
.close {
    position: absolute;
    right: 15px;
    top: 10px;
    font-size: 20px;
    cursor: pointer;
}

/* 输入框 */
.modal-content input {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border-radius: 8px;
    border: 1px solid #ccc;
}

/* 按钮 */
.modal-content button {
    width: 100%;
    padding: 10px;
    background: #6c63ff;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
}

/* ===== 顶部导航 ===== */
.navbar {
    background: #2c3e50;
    color: white;
    padding: 15px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.navbar h1 {
    margin: 0;
    font-size: 22px;
}

.navbar a {
    color: white;
    margin-left: 20px;
    text-decoration: none;
}

.navbar a:hover {
    color: #1abc9c;
}

/* ===== 主横幅 ===== */
.hero {
    background: linear-gradient(135deg,#667eea, #764ba2);
    color: white;
    text-align: center;
    padding: 80px 20px;
}

.hero h2 {
    font-size: 36px;
}

.hero p {
    margin: 15px 0;
}

.search-box input {
    padding: 10px;
    width: 250px;
    border: none;
    border-radius: 5px;
}

.search-box button {
    padding: 10px 15px;
    border: none;
    background: #1abc9c;
    color: white;
    border-radius: 5px;
    cursor: pointer;
}

/* ===== 图书卡片 ===== */
.books {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding: 40px;
    gap: 20px;
}

.book {
    background: rgb(255, 255, 255);
    width: 200px;
    border-radius: 12px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: 0.3s;
}

.book:hover {
    transform: translateY(-5px);
}

.book img {
    width: 100%;
    height: 250px;
    object-fit: cover;
}

.book .info {
    padding: 15px;
    text-align: center;
}

.book h4 {
    margin: 10px 0 5px;
}

.book p {
    font-size: 13px;
    color: #666;
}

.book button {
    margin-top: 10px;
    padding: 8px;
    border: none;
    background: #6c63ff;
    color: white;
    border-radius: 6px;
    cursor: pointer;
}

/* ===== 页脚 ===== */
.footer {
    background: #2c3e50;
    color: white;
    text-align: center;
    padding: 20px;
}
.book-cover{
    width:100%;
    height:250px;
    object-fit:cover;
    border-radius:8px 8px 0 0;
}

</style>
</head>

<body>
    

<!-- 顶部导航 -->
<div class="navbar">
    <h1>📚 전자 도서관</h1>
    <div>
        <a href="#">홈</a>
        <a href="form.jsp">회원가입</a>
        <a href="#" onclick="openLogin()">로그인</a>
    </div>
</div>

<!-- 主横幅 -->
<div class="hero">
    <h2>온라인 도서관에 오신 것을 환영합니다</h2>
    <p>원하는 책을 검색하고 언제든지 읽어보세요</p>

    <div class="search-box">
        <input type="text" placeholder="책 이름 검색...">
        <button>검색</button>
    </div>
    
</div>

<!-- 图书展示 -->
<%@ page import="java.io.File" %>

<div class="books">

<%
String path = "C:/jsp/apache-tomcat-11.0.18/webapps/library/books";
File folder = new File(path);
File[] files = folder.listFiles();

if(files != null){
    for(File f : files){

        String fileName = f.getName();

        if(fileName.endsWith(".pdf")){

            String title = fileName.replace(".pdf", "");
 %>           

    <div class="book">
        <img src="covers/<%= title %>.jpg" class="book-cover">

        <div class="info">
            <h4><%= title %></h4>
            <p>전자책</p>

            <button onclick="location.href='read.jsp?file=<%= fileName %>'">
                읽기
            </button>
        </div>
    </div>

<%
        } 
    } 
} 
%>

</div>

<!-- 页脚 -->
<div class="footer">
    © 2026 전자 도서관 | All Rights Reserved
</div>

<script>
function searchBook() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let books = document.getElementsByClassName("book");

    for (let i = 0; i < books.length; i++) {
        let name = books[i].getAttribute("data-name");

        if (name.includes(input)) {
            books[i].style.display = "block";
        } else {
            books[i].style.display = "none";
        }
    }
}
</script>

<div id="loginModal" class="modal">

    <div class="modal-content">
        <span class="close" onclick="closeLogin()">&times;</span>

        <h2>로그인</h2>

        <form action="loginCheck.jsp" method="post">
            <input type="text" name="userId" placeholder="아이디" required>
            <input type="password" name="userPw" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>
    </div>

</div>
<script>
function openLogin() {
    document.getElementById("loginModal").style.display = "block";
}

function closeLogin() {
    document.getElementById("loginModal").style.display = "none";
}

// 点击外面关闭
window.onclick = function(event) {
    let modal = document.getElementById("loginModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>
</body>
</html>