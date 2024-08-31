package Servlet;

import Models.Oglas;
import RMI.ICarAvgPriceCalculator;
import Service.OglasService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.rmi.Naming;
import java.util.List;

@WebServlet("/GetCarsAvgPriceServlet")
public class GetCarsAvgPriceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String HOST = "localhost";
    private static final int PORT = 1099;
    OglasService oglasService = new OglasService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ICarAvgPriceCalculator calculator = (ICarAvgPriceCalculator) Naming.lookup("rmi://localhost/auto_oglasi_war_exploded/RMIServer");

            String brand = request.getParameter("brand");
            String model = request.getParameter("model");

            List<Oglas> oglasi = oglasService.getAds();

            double avgPrice = calculator.calculateAveragePrice(oglasi, brand, model);
            System.out.println("SERVLET AVG: " + avgPrice);

            response.getWriter().println(avgPrice);
        }catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorJson = String.format("{\"error\": \"Error occurred: %s\"}", e.getMessage());
            response.getWriter().write(errorJson);
        }
    }
}
