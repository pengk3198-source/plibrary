<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
String pw = request.getParameter("pw");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

    Class.forName("org.mariadb.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mariadb://localhost:3306/library",
        "library",
        "1234"
    );

    String sql =
        "SELECT * FROM users WHERE id=? AND pw=?";

    ps = conn.prepareStatement(sql);

    ps.setString(1, id);
    ps.setString(2, pw);

    rs = ps.executeQuery();

    if(rs.next()){

        // 登录成功
        session.setAttribute("user", id);

        out.println("<script>");
        out.println("alert('登录成功');");
        out.println("location.href='index.jsp';");
        out.println("</script>");

    }else{

        out.println("<script>");
        out.println("alert('登录成功');");
        out.println("history.back();");
        out.println("</script>");
    }

}catch(Exception e){

    out.println("错误：" + e.getMessage());

}finally{

    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(conn != null) conn.close();
}
%>