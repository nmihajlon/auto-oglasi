package RMI;

import Models.Oglas;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface ICarAvgPriceCalculator extends Remote {
    double calculateAveragePrice(List<Oglas> oglasi, String brand, String model) throws RemoteException;
}
