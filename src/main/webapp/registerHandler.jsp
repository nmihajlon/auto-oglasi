<%@ page import="Service.UserService" %>
<%@ page import="Models.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="userReg" class="Models.User"/>
<jsp:setProperty name="userReg" property="*"/>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    UserService userService = new UserService();
    String password2 = request.getParameter("confirm-password");
    if(userReg.getPassword().equals(password2)){
        User user = new User();
        user.setEmail(userReg.getEmail());
        user.setPassword(userReg.getPassword());
        if(userReg.getContact() != null){
            user.setContact(userReg.getContact());
        }
        else{
            user.setContact(null);
        }
        user.setFirstName(userReg.getFirstName());
        user.setLastName(userReg.getLastName());
        user.setAdmin(false);
        user.setMoney(0);
        user.setUsername(userReg.getUsername());
        user.setZemlja(userReg.getZemlja());
        user.setGrad(userReg.getGrad());
        String pattern = "yyyy-MM-dd HH:mm:ss";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        String formattedDate = simpleDateFormat.format(new Date());
        user.setUpdateProfile(formattedDate);

        user.setIsActive(true);

        userService.addNewUser(user);

        session.setAttribute("regSuccess", "Uspesno ste se registrovali.");

        response.sendRedirect("login.jsp");
    }
    else{
        session.setAttribute("regError", "Polje password i confirm password se ne poklapaju");
        response.sendRedirect("register.jsp");
    }
%>
</body>
</html>
