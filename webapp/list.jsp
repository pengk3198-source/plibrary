<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자 도서관</title>
</head>

<body>

<h2>전자 도서 목록</h2>

<%

String path = application.getRealPath("/") + "books";

File folder = new File(path);

File[] files = folder.listFiles();

if(files != null){
    for(File f : files){
%>

<a href="books/<%=f.getName()%>" target="_blank">
📖 <%=f.getName()%>
</a>

<br><br>

<%
    }
}
%>

</body>
</html>