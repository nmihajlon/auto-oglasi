package RMI;

import Models.Oglas;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

public class CarAvgPriceCalculatorRMI extends UnicastRemoteObject implements ICarAvgPriceCalculator {

    protected CarAvgPriceCalculatorRMI() throws RemoteException {
        super();
    }

    @Override
    public double calculateAveragePrice(List<Oglas> oglasi, String brand, String model) throws RemoteException {
        double total = 0;
        int count = 0;
        for (Oglas oglas : oglasi) {
            if (oglas.getAutomobil().getMarka().equalsIgnoreCase(brand) && oglas.getAutomobil().getModel().equalsIgnoreCase(model)) {
                total += oglas.getCena();
                count++;
            }
        }

        System.out.println("IZRACUNAO: " + total/count);
        return count == 0 ? 0 : total / count;
    }
}