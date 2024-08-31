package Servlet;

import Repository.SlikeRepository;
import Service.SlikeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.OglasService;

import java.io.File;
import java.io.IOException;

@WebServlet("/deleteAd")
public class ObrisiOglasServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageFolderPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "cars";
        SlikeRepository slikeRepository = new SlikeRepository(imageFolderPath);

        int adId = Integer.parseInt(request.getParameter("adId"));
        slikeRepository.deleteImagesForAdId(adId);
        OglasService oglasService = new OglasService();

        oglasService.deleteAd(adId);
        response.sendRedirect("mojiOglasi.jsp");
    }
}
