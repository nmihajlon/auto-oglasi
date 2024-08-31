package Servlet;

import Beans.UserBean;
import Models.User;
import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/DeleteProfilePicture")
public class DeleteProfilePictureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserService userService = new UserService();
        Optional<User> optionalUser = userService.getUserByEmail(email);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            String profilePicturePath = user.getProfilePicture();
            if (profilePicturePath != null && !profilePicturePath.isEmpty()) {
                File file = new File(getServletContext().getRealPath("") + File.separator + "images" + File.separator + profilePicturePath);
                if (file.exists()) {
                    file.delete();
                }
                userService.setProfilePicturePath(user.getId(), null);

                User updatedUser = userService.getUserByEmail(email).orElse(null);
                if (updatedUser != null) {
                    UserBean userBean = new UserBean(updatedUser.getId(), updatedUser.getUsername(), updatedUser.getEmail(), updatedUser.getContact(), updatedUser.getFirstName(), updatedUser.getLastName(), updatedUser.getUpdateProfile(), updatedUser.getMoney(), updatedUser.getIsActive(), updatedUser.getProfilePicture(), updatedUser.getAdmin(), updatedUser.getZemlja(), updatedUser.getGrad());
                    HttpSession session = request.getSession();
                    session.setAttribute("user", userBean);
                }
            }
        }

        response.sendRedirect("account.jsp");
    }
}
