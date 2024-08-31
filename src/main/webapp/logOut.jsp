<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    session.removeAttribute("user");
    response.sendRedirect("index.jsp");
%>
</body>
</html>
