package Service;

import Models.Automobil;
import Models.Oglas;
import Models.Ostecenja;
import Models.User;
import Repository.OglasRepository;

import java.util.Date;
import java.util.List;

public class OglasService {
    private OglasRepository oglasRepository;

    public OglasService(){
        this.oglasRepository = new OglasRepository();
    }

    public List<Oglas> getAds(){
        return oglasRepository.getAllAds();
    }
    public List<Oglas> getAdsPagination(int page, int pageSize){
        return oglasRepository.getAllAdsPagination(page, pageSize);
    }
    public Oglas getAdById(Integer idOglasa){
        return oglasRepository.getAdById(idOglasa);
    }

    public List<Integer> getAllKw(){
        return oglasRepository.getAllKw();
    }

    public List<Double> getAllKs(){
        return oglasRepository.getAllKs();
    }
    public Oglas addAd(Automobil automobil, User u, String boja, Integer godiste, Integer kilometraza, String opis, Integer cena, Double kubikaza, Integer kw, Double ks, Boolean zamena, Boolean istaknut, Date datumReg, Ostecenja ostecenja){
        return oglasRepository.addAd(automobil, u, boja, godiste, kilometraza, opis, cena, kubikaza, kw, ks, zamena, istaknut, datumReg, ostecenja);
    }
    public List<Oglas> getAdsForUser(Integer idUser){
        return oglasRepository.getAllAdsForUser(idUser);
    }
    public List<Oglas> searchAds(String marka, String model, String gorivo, String pogon, String menjac, String zemlja, String karoserija, Integer kwOd, Integer kwDo, Double ksOd, Double ksDo, Integer kilometrazaOd, Integer kilometrazaDo, Integer godisteOd, Integer godisteDo, Integer cenaMin, Integer cenaMax, String bojaVozila, String vrstaGoriva, int pageNumber, int pageSize) {
        return oglasRepository.searchAds(marka, model, gorivo, pogon, menjac, zemlja, karoserija, kwOd, kwDo, ksOd, ksDo, kilometrazaOd, kilometrazaDo, godisteOd, godisteDo, cenaMin, cenaMax, bojaVozila, vrstaGoriva, pageNumber, pageSize);
    }
    public int countAds(String marka, String model, String gorivo, String pogon, String menjac, String zemlja, String karoserija, Integer kwOd, Integer kwDo, Double ksOd, Double ksDo, Integer kilometrazaOd, Integer kilometrazaDo, Integer godisteOd, Integer godisteDo, Integer cenaMin, Integer cenaMax, String bojaVozila, String vrstaGoriva){
        return oglasRepository.countAds(marka, model, gorivo, pogon, menjac, zemlja, karoserija, kwOd, kwDo, ksOd, ksDo, kilometrazaOd, kilometrazaDo, godisteOd, godisteDo, cenaMin, cenaMax, bojaVozila, vrstaGoriva);
    }
    public Integer numberOfAds(){
        return oglasRepository.numberOfAds();
    }

    public void deleteAd(Integer adId){
        oglasRepository.deleteAd(adId);
    }
    public Integer getTotalNumberOfAds() {
        return oglasRepository.countAllAds();
    }

    public void updateAd(Integer idOglasa, Integer cena, String opis){
        oglasRepository.updateAd(idOglasa, cena, opis);
    }
}
