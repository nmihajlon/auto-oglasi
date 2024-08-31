package Repository;

import Beans.AutomobilBean;
import Database.Database;
import Models.Automobil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;

import java.util.List;

public class AutomobilRepository {
    private EntityManager entityManager = Database.getEntityManager();

    public List<String> getAllBrands() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("marka")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getModelsByMarka(String marka){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("model")).distinct(true)
                .where(criteriaBuilder.equal(root.get("marka"), marka));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getAllGearBoxes(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("menjac")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getAllCountries(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("zemlja")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getAllFules(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("gorivo")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getAllCarBody(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("karoserija")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<String> getAllWheelDrive(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("pogon")).distinct(true);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public Integer getID(String marka, String model, String menjac, String zemlja, String pogon, String gorivo){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Integer> criteriaQuery = criteriaBuilder.createQuery(Integer.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root.get("id")).where(
                criteriaBuilder.and(
                        criteriaBuilder.equal(root.get("marka"), marka),
                        criteriaBuilder.equal(root.get("model"), model),
                        criteriaBuilder.equal(root.get("menjac"), menjac),
                        criteriaBuilder.equal(root.get("zemlja"), zemlja),
                        criteriaBuilder.equal(root.get("pogon"), pogon),
                        criteriaBuilder.equal(root.get("gorivo"), gorivo)                )
        );

        try {
            return entityManager.createQuery(criteriaQuery).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<AutomobilBean> getDetailsByMarka(String marka) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<AutomobilBean> criteriaQuery = criteriaBuilder.createQuery(AutomobilBean.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);

        criteriaQuery.select(criteriaBuilder.construct(
                AutomobilBean.class,
                root.get("id"),
                root.get("marka"),
                root.get("model"),
                root.get("menjac"),
                root.get("gorivo"),
                root.get("karoserija"),
                root.get("pogon"),
                root.get("zemlja")
        )).where(criteriaBuilder.equal(root.get("marka"), marka));

        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public Integer addVehicle(String marka, String model, String menjac, String zemlja, String pogon, String karoserija, String gorivo){
        Automobil a = new Automobil();
        a.setGorivo(gorivo);
        a.setMarka(marka);
        a.setModel(model);
        a.setZemlja(zemlja);
        a.setGorivo(gorivo);
        a.setPogon(pogon);
        a.setKaroserija(karoserija);
        a.setMenjac(menjac);

        EntityTransaction t = entityManager.getTransaction();
        t.begin();
        if(a.getId() == null){
            entityManager.persist(a);
        }
        else{
            entityManager.merge(a);
        }
        t.commit();

        return this.getID(a.getMarka(), a.getModel(), a.getMenjac(), a.getZemlja(), a.getPogon(), a.getGorivo());
    }

    public Automobil getCarByID(Integer ID){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Automobil> criteriaQuery = criteriaBuilder.createQuery(Automobil.class);
        Root<Automobil> root = criteriaQuery.from(Automobil.class);
        criteriaQuery.select(root).where(criteriaBuilder.equal(root.get("id"), ID));
        return entityManager.createQuery(criteriaQuery).getSingleResult();
    }
}
