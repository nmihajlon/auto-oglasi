<%@ page import="Beans.UserBean" %>
<%@ page import="Service.UserService" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.Optional" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="editUser" class="Models.User"/>
<jsp:setProperty name="editUser" property="*"/>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    UserBean userBean = (UserBean) session.getAttribute("user");
    String newEmail = request.getParameter("email");
    String newUsername = request.getParameter("korisnickoIme");
    String newContact = request.getParameter("telefon");
    String newCountry = request.getParameter("zemlja");
    String newCity = request.getParameter("grad");

    UserService userService = new UserService();
    User user = userService.getUserById(userBean.getId());

    if(!newEmail.isEmpty())
        user.setEmail(newEmail);
    if(!newUsername.isEmpty())
        user.setUsername(newUsername);
    if(!newContact.isEmpty())
        user.setContact(newContact);
    if(!newContact.isEmpty())
        user.setZemlja(newCountry);
    if(!newCity.isEmpty())
        user.setGrad(newCity);
    String pattern = "yyyy-MM-dd HH:mm:ss";
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
    String formattedDate = simpleDateFormat.format(new Date());

    user.setUpdateProfile(formattedDate);

    userService.updateUser(user);
    session.setAttribute("user", new UserBean(user.getId(), user.getUsername(), user.getEmail(), user.getContact(), user.getFirstName(), user.getLastName(), user.getUpdateProfile(), user.getMoney(), user.getSessionID(), user.getProfilePicture(), user.getAdmin(), user.getZemlja(), user.getGrad()));
    response.sendRedirect("account.jsp");
%>
</body>
</html>
