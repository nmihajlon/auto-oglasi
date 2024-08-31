package Servlet;

import Beans.UserBean;
import Models.*;
import Service.AutomobilService;
import Service.OglasService;
import Service.SlikeService;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import Service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/oglasiVozilo")
@MultipartConfig
public class OglasiVoziloServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AutomobilService automobilService = new AutomobilService();
        OglasService oglasService = new OglasService();
        SlikeService slikeService = new SlikeService();

        UserBean user = (UserBean) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        UserService userService = new UserService();
        User u = userService.convertUserBeanToUser(user);

        String marka = request.getParameter("marka");
        String model = request.getParameter("model");
        String menjac = request.getParameter("menjac");
        String zemlja = request.getParameter("zemlja");
        String pogon = request.getParameter("pogon");
        String karoserija = request.getParameter("karoserija");
        String gorivo = request.getParameter("gorivo");
        String godisteParam = request.getParameter("godiste");
        Double kubikaza = Double.parseDouble(request.getParameter("kubikaza"));
        Integer kw = Integer.parseInt(request.getParameter("kw"));
        Double ks = kw * 1.359621617;
        String boja = request.getParameter("boja");
        Boolean zamena = "true".equals(request.getParameter("zamena"));
        Boolean istaknut = "true".equals(request.getParameter("istaknut"));
        String datumRegistracijeParam = request.getParameter("datum_registracije");
        String ostecenjaParam = request.getParameter("ostecenja");

        Integer godiste = null;
        if (godisteParam != null && !godisteParam.isEmpty()) {
            godiste = Integer.parseInt(godisteParam);
        }
        String kilometrazaParam = request.getParameter("kilometraza");
        Integer kilometraza = null;
        if (kilometrazaParam != null && !kilometrazaParam.isEmpty()) {
            kilometraza = Integer.parseInt(kilometrazaParam);
        }
        String cenaParam = request.getParameter("cena");
        Integer cena = null;
        if (cenaParam != null && !cenaParam.isEmpty()) {
            cena = Integer.parseInt(cenaParam);
        }
        String opis = request.getParameter("opis");

        Date datumRegistracije = null;
        try {
            datumRegistracije = new SimpleDateFormat("yyyy-MM-dd").parse(datumRegistracijeParam);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Ostecenja ostecenja = null;
        if (ostecenjaParam != null && !ostecenjaParam.isEmpty()){
            ostecenja = Ostecenja.valueOf(ostecenjaParam);
        }

        Automobil auto = new Automobil();
        auto.setMarka(marka);
        auto.setModel(model);
        auto.setMenjac(menjac);
        auto.setZemlja(zemlja);
        auto.setPogon(pogon);
        auto.setKaroserija(karoserija);
        auto.setGorivo(gorivo);

        Integer idCar = automobilService.getCarID(marka, model, menjac, zemlja, pogon, gorivo);

        if(idCar == null) {
            idCar = automobilService.addVehicle(marka, model, menjac, zemlja, pogon, karoserija, gorivo);
        }

        Automobil automobil = automobilService.getCarByID(idCar);
        Oglas oglas = oglasService.addAd(automobil, u, boja, godiste, kilometraza, opis, cena, kubikaza, kw, ks, zamena, istaknut, datumRegistracije, ostecenja);

        String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "cars";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        for (Part part : request.getParts()) {

            if (part.getName().equals("slikeVozila") && part.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                String filePath = uploadPath + File.separator + fileName;

                try (InputStream inputStream = part.getInputStream()) {
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
        }

        response.sendRedirect("index.jsp");
    }
}