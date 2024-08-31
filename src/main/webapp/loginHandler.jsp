<%@ page import="Service.UserService" %>
<%@ page import="java.util.Optional" %>
<%@ page import="Beans.UserBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="userLogin" class="Models.User"/>
<jsp:setProperty name="userLogin" property="*"/>
<html>
<head>
    <title>Title</title>
</head>
<body>

<%
    UserService userService = new UserService();

    Optional<UserBean> u = userService.login(userLogin.getEmail(), userLogin.getPassword());

    if(u.isPresent()){
        session.setAttribute("user", u.get());
        response.sendRedirect("index.jsp");

    }
    else{
        session.setAttribute("loginError", "Neispravno su unete mail adresa ili sifra ili je nalog neaktivan. Kontaktirajte administratora.");
        response.sendRedirect("login.jsp");
    }
%>

</body>
</html>
