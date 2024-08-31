package Repository;

import Database.Database;
import Models.Slike;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;

import java.io.File;
import java.util.List;

public class SlikeRepository {

    String folderPath;
    public SlikeRepository(){}
    public SlikeRepository(String folderPath){
        this.folderPath = folderPath;
    }
    private EntityManager entityManager = Database.getEntityManager();

    public List<String> getAllImagesForIdAd(Integer idAd) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Slike> root = criteriaQuery.from(Slike.class);
        criteriaQuery.select(root.get("slika"));
        criteriaQuery.where(criteriaBuilder.equal(root.get("oglas").get("id"), idAd));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public String getOneImageForAdId(Integer idAd) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Slike> root = criteriaQuery.from(Slike.class);
        criteriaQuery.select(root.get("slika"));
        criteriaQuery.where(criteriaBuilder.equal(root.get("oglas").get("id"), idAd));
        List<String> resultList = entityManager.createQuery(criteriaQuery).setMaxResults(1).getResultList();
        return resultList.isEmpty() ? null : resultList.get(0);
    }

    public void save(Slike slika) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(slika);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void deleteImagesForAdId(Integer idAd) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
            CriteriaQuery<Slike> criteriaQuery = criteriaBuilder.createQuery(Slike.class);
            Root<Slike> root = criteriaQuery.from(Slike.class);
            criteriaQuery.where(criteriaBuilder.equal(root.get("oglas").get("id"), idAd));
            List<Slike> slikeList = entityManager.createQuery(criteriaQuery).getResultList();

            for (Slike slika : slikeList) {
                entityManager.remove(slika);
            }

            transaction.commit();

            for (Slike slika : slikeList) {
                File file = new File(folderPath, slika.getSlika());
                if (file.exists()) {
                    if (file.delete()) {
                        System.out.println("Deleted file: " + file.getAbsolutePath());
                    } else {
                        System.out.println("Failed to delete file: " + file.getAbsolutePath());
                    }
                }
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public boolean deleteImageByUrl(String imageUrl){
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            // Pronađi sliku u bazi podataka
            CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
            CriteriaQuery<Slike> criteriaQuery = criteriaBuilder.createQuery(Slike.class);
            Root<Slike> root = criteriaQuery.from(Slike.class);
            criteriaQuery.where(criteriaBuilder.equal(root.get("slika"), imageUrl));
            List<Slike> slikeList = entityManager.createQuery(criteriaQuery).getResultList();

            // Ako slika ne postoji, vraćaj false
            if (slikeList.isEmpty()) {
                return false;
            }

            // Obriši sliku iz baze podataka
            for (Slike slika : slikeList) {
                entityManager.remove(slika);
            }

            transaction.commit();

            // Obriši sliku iz fizičkog skladišta
            File file = new File(folderPath, imageUrl);
            if (file.exists()) {
                if (file.delete()) {
                    System.out.println("Deleted file: " + file.getAbsolutePath());
                    return true;
                } else {
                    System.out.println("Failed to delete file: " + file.getAbsolutePath());
                    return false;
                }
            } else {
                System.out.println("File does not exist: " + file.getAbsolutePath());
                return false;
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
}