package Servlet;

import Service.AutomobilService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet("/DodajAutomobilServlet")
public class DodajAutomobilServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String marka = request.getParameter("marka");
        String model = request.getParameter("model");
        String menjac = request.getParameter("menjac");
        String zemlja = request.getParameter("zemlja");
        String pogon = request.getParameter("pogon");
        String karoserija = request.getParameter("karoserija");
        String gorivo = request.getParameter("gorivo");

        AutomobilService automobilService = new AutomobilService();
        Integer existingCarId = automobilService.getCarID(marka, model, menjac, zemlja, pogon, gorivo);
        HttpSession session = request.getSession();

        if (existingCarId == null) {
            automobilService.addVehicle(marka, model, menjac, zemlja, pogon, karoserija, gorivo);
            session.setAttribute("uspesnoDodatoVozilo", "Vozilo je uspešno dodato!");
            response.sendRedirect("admin.jsp");
        } else {
            session.setAttribute("neuspesnoDodatoVozilo", "Vozilo vec postoji!");
            response.sendRedirect("admin.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
