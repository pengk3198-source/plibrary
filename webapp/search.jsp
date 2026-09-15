<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");
String keyword = request.getParameter("keyword");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 결과</title>

<style>
body {
    font-family: Arial;
    background: #f5f5f5;
    padding: 20px;
}

.book {
    background: white;
    padding: 15px;
    margin: 15px;
    border-radius: 10px;
    box-shadow: 0 5px 10px rgba(0,0,0,0.1);
}
</style>
</head>

<body>

<h2>🔍 검색 결과</h2>
<a href="index.jsp">← 홈으로</a>

<%
String url = "jdbc:mysql://localhost:3306/library?useUnicode=true&characterEncoding=UTF-8";
String user = "root";
String password = "1234";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

boolean found = false;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, user, password);

    String sql = "SELECT * FROM book WHERE title LIKE ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, "%" + keyword + "%");

    rs = pstmt.executeQuery();

    while (rs.next()) {
        found = true;
%>

<div class="book">
    <h3><%= rs.getString("title") %></h3>
    <p>저자: <%= rs.getString("author") %></p>
    <button onclick="location.href='read.jsp?file=<%= rs.getString("file") %>'">
        읽기
    </button>
</div>

<%
    }

    if (!found) {
%>
    <p>검색 결과 없음</p>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
}
%>

</body>
</html>