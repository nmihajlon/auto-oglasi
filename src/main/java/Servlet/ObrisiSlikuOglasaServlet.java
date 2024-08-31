package Servlet;

import Repository.SlikeRepository;
import Service.SlikeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/ObrisiSlikuOglasa")
public class ObrisiSlikuOglasaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageUrl = request.getParameter("imageUrl");
        Integer idOglasa = Integer.parseInt(request.getParameter("idOglasa"));
        SlikeService slikeService = new SlikeService();

        slikeService.deleteImage(imageUrl);
        response.sendRedirect("izmeniOglas.jsp?idOglasa="+idOglasa);
    }
}