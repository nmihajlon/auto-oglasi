package Servlet;

import Models.Oglas;
import Models.Slike;
import Service.OglasService;
import Service.SlikeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet("/IzmeniOglasServlet")
@MultipartConfig
public class IzmeniOglasServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SlikeService slikeService = new SlikeService();
        OglasService oglasService = new OglasService();

        Integer oglasId = Integer.parseInt(request.getParameter("oglasId"));
        Oglas oglas = oglasService.getAdById(oglasId);

        if (oglas == null) {
            response.sendRedirect("mojiOglasi.jsp");
            return;
        }

        String opis = request.getParameter("opis");
        Integer cena = Integer.parseInt(request.getParameter("cena"));

        oglasService.updateAd(oglasId, cena, opis);

        String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "cars";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        Part newImagePart = request.getPart("newImage");
        if (newImagePart != null && newImagePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + newImagePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;

            try (InputStream inputStream = newImagePart.getInputStream()) {
                Files.copy(inputStream, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
            }

            String picturePath = "images/cars/" + fileName;
            Slike slika = new Slike();
            slika.setOglas(oglas);
            slika.setSlika(picturePath);
            slikeService.save(slika);
        }

        response.sendRedirect("mojiOglasi.jsp");
    }
}