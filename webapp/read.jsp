<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String file = request.getParameter("file");
%>
<%
request.setCharacterEncoding("UTF-8");
String fileName = request.getParameter("file");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책 읽기</title>

<style>
body {
    margin: 0;
    font-family: Arial;
}

.topbar {
    background: #2c3e50;
    color: white;
    padding: 10px 20px;
}

.topbar a {
    color: #1abc9c;
    text-decoration: none;
}

.viewer {
    width: 100%;
    height: 90vh;
}
.comment-box {
    background: white;
    padding: 15px;
    margin: 15px 0;
    border-radius: 10px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.1);
}

textarea {
    width: 400px;
    height: 100px;
}

input, textarea {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
}
</style>

</head>

<body>

<div class="topbar">
    <a href="index.jsp">← 돌아가기</a>
</div>

<iframe class="viewer" src="books/<%= file %>"></iframe>
<hr>

<h3>评论区</h3>

<form action="comment.jsp" method="post">
    <input type="hidden" name="bookFile" value="<%= fileName %>">

    <input type="text" name="username" placeholder="请输入昵称" required>

    <br><br>

    <textarea name="content" placeholder="请输入评论" required></textarea>

    <br><br>

    <button type="submit">提交评论</button>
</form>
<%@ page import="java.sql.*" %>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("org.mariadb.jdbc.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mariadb://localhost:3306/library",
        "library",
        "1234"
    );

    String sql = "SELECT * FROM comments WHERE book_file=? ORDER BY created_at DESC";
    ps = conn.prepareStatement(sql);
    ps.setString(1, fileName);
    rs = ps.executeQuery();

    while(rs.next()) {
%>
        <div class="comment-box">
            <b><%= rs.getString("username") %></b>
            <p><%= rs.getString("content") %></p>
            <small><%= rs.getString("created_at") %></small>
        </div>
<%
    }
} catch(Exception e) {
    out.println("评论加载失败：" + e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(conn != null) conn.close();
}
%>

</body>
</html>