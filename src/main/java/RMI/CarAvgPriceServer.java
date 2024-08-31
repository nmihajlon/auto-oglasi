package RMI;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public class CarAvgPriceServer {
    public static final int PORT = 1099;

    public static void main(String[] args) {
        try {
            CarAvgPriceCalculatorRMI calculator = new CarAvgPriceCalculatorRMI();
            LocateRegistry.createRegistry(PORT);
            Naming.rebind("rmi://localhost/auto_oglasi_war_exploded/RMIServer", calculator);
            System.out.println("RMI Server je startovan na portu: " + PORT);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}