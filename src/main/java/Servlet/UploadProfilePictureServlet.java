package Servlet;

import Beans.UserBean;
import Models.User;
import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.Optional;

@WebServlet("/UploadProfilePicture")
@MultipartConfig(location = "", fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class UploadProfilePictureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Define the upload path
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "profilePictures";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Part filePart = request.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;

            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
            }

            String profilePicturePath = "images/profilePictures/" + fileName;

            String email = request.getParameter("email");
            UserService userService = new UserService();
            Optional<User> optionalUser = userService.getUserByEmail(email);
            if (optionalUser.isPresent()) {
                User u = optionalUser.get();
                userService.setProfilePicturePath(u.getId(), profilePicturePath);

                UserBean userBean = new UserBean(u.getId(), u.getUsername(), u.getEmail(), u.getContact(), u.getFirstName(), u.getLastName(), u.getUpdateProfile(), u.getMoney(), u.getIsActive(), profilePicturePath, u.getAdmin(), u.getZemlja(), u.getGrad());
                HttpSession session = request.getSession();
                session.setAttribute("user", userBean);
            }
        }

        response.sendRedirect("account.jsp");
    }
}
