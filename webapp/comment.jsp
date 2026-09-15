<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String bookFile = request.getParameter("bookFile");
String username = request.getParameter("username");
String content = request.getParameter("content");

Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("org.mariadb.jdbc.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mariadb://localhost:3306/library",
        "library",
        "1234"
    );

    String sql = "INSERT INTO comments(book_file, username, content) VALUES (?, ?, ?)";
    ps = conn.prepareStatement(sql);
    ps.setString(1, bookFile);
    ps.setString(2, username);
    ps.setString(3, content);
    ps.executeUpdate();

    response.sendRedirect("read.jsp?file=" + java.net.URLEncoder.encode(bookFile, "UTF-8"));

} catch(Exception e) {
    out.println("评论失败：" + e.getMessage());
} finally {
    if(ps != null) ps.close();
    if(conn != null) conn.close();
}
%>