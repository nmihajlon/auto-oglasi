package Service;

import Models.Automobil;
import Repository.AutomobilRepository;

import java.util.List;

public class AutomobilService {
    private AutomobilRepository automobilRepository;
    public AutomobilService(){
        this.automobilRepository = new AutomobilRepository();
    }

    public List<String> getBrands(){
        return automobilRepository.getAllBrands();
    }

    public List<String> getGearBoxes(){
        return automobilRepository.getAllGearBoxes();
    }
    public List<String> getCountries(){
        return automobilRepository.getAllCountries();
    }

    public List<String> getTypesOfFuel(){
        return automobilRepository.getAllFules();
    }

    public List<String> getAllWheelDrive(){
        return automobilRepository.getAllWheelDrive();
    }

    public Integer getCarID(String marka, String model, String menjac, String zemlja, String pogon, String gorivo){
        return automobilRepository.getID(marka, model, menjac, zemlja, pogon, gorivo);
    }

    public Integer addVehicle(String marka, String model, String menjac, String zemlja, String pogon, String karoserija, String gorivo){
        return automobilRepository.addVehicle(marka, model, menjac, zemlja, pogon, karoserija, gorivo);
    }

    public Automobil getCarByID(Integer ID){
        return automobilRepository.getCarByID(ID);
    }

    public List<String> getKaroserije(){ return automobilRepository.getAllCarBody();}
}
