package Service;

import Models.Slike;
import Repository.SlikeRepository;

import java.util.List;

public class SlikeService {
    private SlikeRepository slikeRepository;

    public SlikeService(){
        this.slikeRepository = new SlikeRepository();
    }

    public void save(Slike slika) {
        slikeRepository.save(slika);
    }
    public String getImageForAd(Integer idAd){
        return slikeRepository.getOneImageForAdId(idAd);
    }
    public List<String> getAllImagesForAd(Integer idOglasa){
        return slikeRepository.getAllImagesForIdAd(idOglasa);
    }
    public void deleteImagesForAdId(Integer idAd) {
        slikeRepository.deleteImagesForAdId(idAd);
    }
    public boolean deleteImage(String imageUrl) {
        return slikeRepository.deleteImageByUrl(imageUrl);
    }
}
