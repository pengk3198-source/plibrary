<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PDF 업로드</title>
</head>

<body>

<h2>PDF 도서 업로드</h2>

<form action="uploadProcess.jsp" method="post" enctype="multipart/form-data">

도서 이름 :
<input type="text" name="bookname">

<br><br>

PDF 파일 :
<input type="file" name="pdf">

<br><br>

<input type="submit" value="업로드">

</form>

</body>
</html>