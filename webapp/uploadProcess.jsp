<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,jakarta.servlet.http.Part" %>

<%
request.setCharacterEncoding("UTF-8");

Part filePart = request.getPart("pdf");

String fileName = filePart.getSubmittedFileName();

String uploadPath = application.getRealPath("/") + "books";

File uploadDir = new File(uploadPath);

if(!uploadDir.exists()){
    uploadDir.mkdir();
}

String filePath = uploadPath + File.separator + fileName;

filePart.write(filePath);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>업로드 성공</title>
</head>

<body>

<h2>PDF 업로드 성공</h2>

<a href="books/<%=fileName%>" target="_blank">
PDF 읽기
</a>

<br><br>

<a href="index.jsp">홈으로</a>

</body>
</html>