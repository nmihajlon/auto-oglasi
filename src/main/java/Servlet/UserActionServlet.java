package Servlet;

import Models.User;
import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/userActionServlet")
public class UserActionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdParam = request.getParameter("userId");
        String action = request.getParameter("action");

        if (userIdParam != null && action != null) {
            int userId = Integer.parseInt(userIdParam);
            UserService userService = new UserService();

            try {
                if ("deactivate".equals(action)) {
                    User user = userService.getUserById(userId);
                    String pattern = "yyyy-MM-dd HH:mm:ss";
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
                    String formattedDate = simpleDateFormat.format(new Date());

                    user.setUpdateProfile(formattedDate);
                    userService.updateUser(user);
                    userService.deactivateUser(userId);
                } else if ("activate".equals(action)) {
                    User user = userService.getUserById(userId);
                    String pattern = "yyyy-MM-dd HH:mm:ss";
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
                    String formattedDate = simpleDateFormat.format(new Date());

                    user.setUpdateProfile(formattedDate);
                    userService.updateUser(user);
                    userService.activateUser(userId);
                }

                response.setStatus(HttpServletResponse.SC_OK);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
