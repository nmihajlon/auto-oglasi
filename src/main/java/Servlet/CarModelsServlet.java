package Servlet;

import Beans.AutomobilBean;
import Repository.AutomobilRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;

@WebServlet("/getDetailsByMarka")
public class CarModelsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AutomobilRepository automobilService;

    public CarModelsServlet(){
        this.automobilService = new AutomobilRepository();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String marka = request.getParameter("marka");
        List<AutomobilBean> details = automobilService.getDetailsByMarka(marka);
        String json = new Gson().toJson(details);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}
