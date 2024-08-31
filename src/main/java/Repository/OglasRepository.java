package Repository;

import Database.Database;
import Models.Automobil;
import Models.Oglas;
import Models.Ostecenja;
import Models.User;
import Service.SlikeService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class OglasRepository {
    private EntityManager entityManager = Database.getEntityManager();

    public List<Oglas> getAllAds() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Oglas> criteriaQuery = criteriaBuilder.createQuery(Oglas.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<Oglas> getAllAdsPagination(int page, int pageSize) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Oglas> criteriaQuery = criteriaBuilder.createQuery(Oglas.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root);

        return entityManager.createQuery(criteriaQuery)
                .setFirstResult((page - 1) * pageSize)
                .setMaxResults(pageSize)
                .getResultList();
    }

    public Integer countAllAds() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(criteriaBuilder.count(root));
        Long count = entityManager.createQuery(criteriaQuery).getSingleResult();
        return count.intValue();
    }

    public List<Integer> getAllKw(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Integer> criteriaQuery = criteriaBuilder.createQuery(Integer.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root.get("kw"));
        criteriaQuery.orderBy(criteriaBuilder.asc(root.get("kw")));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<Double> getAllKs(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Double> criteriaQuery = criteriaBuilder.createQuery(Double.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root.get("ks"));
        criteriaQuery.orderBy(criteriaBuilder.asc(root.get("ks")));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public Oglas getAdById(Integer idOglasa){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Oglas> criteriaQuery = criteriaBuilder.createQuery(Oglas.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root).where(criteriaBuilder.equal(root.get("id"), idOglasa));
        return entityManager.createQuery(criteriaQuery).getSingleResult();
    }

    public Oglas addAd(Automobil automobil, User u, String boja, Integer godiste, Integer kilometraza, String opis, Integer cena, Double kubikaza, Integer kw, Double ks, Boolean zamena, Boolean istaknut, Date datumReg, Ostecenja ostecenja){
        Oglas o = new Oglas();
        o.setAutomobil(automobil);
        o.setBoja(boja);
        o.setGodiste(godiste);
        o.setKilometraza(kilometraza);
        o.setOpis(opis);
        o.setCena(cena);
        o.setUser_id(u);
        o.setKubikaza(kubikaza);
        o.setKw(kw);
        o.setZamena(zamena);
        o.setIstaknutOglas(istaknut);
        o.setRegistrovanDo(datumReg);
        o.setOstecenje(ostecenja);

        long ksRounded = Math.round(ks);
        o.setKs((double) ksRounded);

        EntityTransaction t = entityManager.getTransaction();
        t.begin();
        if(o.getId() == null){
            entityManager.persist(o);
        }
        else{
            entityManager.merge(o);
        }
        t.commit();
        return o;
    }

    public List<Oglas> getAllAdsForUser(Integer idUser) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Oglas> criteriaQuery = criteriaBuilder.createQuery(Oglas.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(root).where(criteriaBuilder.equal(root.get("user_id").get("id"), idUser));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public List<Oglas> searchAds(String marka, String model, String gorivo, String pogon, String menjac, String zemlja, String karoserija, Integer kwOd, Integer kwDo, Double ksOd, Double ksDo, Integer kilometrazaOd, Integer kilometrazaDo, Integer godisteOd, Integer godisteDo, Integer cenaMin, Integer cenaMax, String bojaVozila, String vrstaGoriva, int pageNumber, int pageSize) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Oglas> criteriaQuery = criteriaBuilder.createQuery(Oglas.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);

        List<Predicate> predicates = new ArrayList<>();

        // Adding conditions to the list of predicates
        if (marka != null && !marka.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("marka"), marka));
        }
        if (model != null && !model.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("model"), model));
        }
        if (gorivo != null && !gorivo.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("gorivo"), gorivo));
        }
        if (pogon != null && !pogon.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("pogon"), pogon));
        }
        if (menjac != null && !menjac.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("menjac"), menjac));
        }
        if (zemlja != null && !zemlja.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("zemlja"), zemlja));
        }
        if (karoserija != null && !karoserija.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("karoserija"), karoserija));
        }
        if (kilometrazaOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("kilometraza"), kilometrazaOd));
        }
        if (kilometrazaDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("kilometraza"), kilometrazaDo));
        }
        if (kwOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("kw"), kwOd));
        }
        if (kwDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("kw"), kwDo));
        }
        if (ksOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("ks"), ksOd));
        }
        if (ksDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("ks"), ksDo));
        }
        if (godisteOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("godiste"), godisteOd));
        }
        if (godisteDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("godiste"), godisteDo));
        }
        if (cenaMin != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("cena"), cenaMin));
        }
        if (cenaMax != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("cena"), cenaMax));
        }
        if (bojaVozila != null && !bojaVozila.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("boja"), bojaVozila));
        }
        if (vrstaGoriva != null && !vrstaGoriva.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("gorivo"), vrstaGoriva));
        }

        // Adding predicates to the query
        criteriaQuery.where(predicates.toArray(new Predicate[0]));

        // Executing the query with pagination
        return entityManager.createQuery(criteriaQuery)
                .setFirstResult(pageNumber * pageSize)
                .setMaxResults(pageSize)
                .getResultList();
    }

    public int countAds(String marka, String model, String gorivo, String pogon, String menjac, String zemlja, String karoserija, Integer kwOd, Integer kwDo, Double ksOd, Double ksDo, Integer kilometrazaOd, Integer kilometrazaDo, Integer godisteOd, Integer godisteDo, Integer cenaMin, Integer cenaMax, String bojaVozila, String vrstaGoriva) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);

        List<Predicate> predicates = new ArrayList<>();

        // Adding conditions to the list of predicates
        if (marka != null && !marka.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("marka"), marka));
        }
        if (model != null && !model.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("model"), model));
        }
        if (gorivo != null && !gorivo.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("gorivo"), gorivo));
        }
        if (pogon != null && !pogon.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("pogon"), pogon));
        }
        if (menjac != null && !menjac.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("menjac"), menjac));
        }
        if (zemlja != null && !zemlja.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("zemlja"), zemlja));
        }
        if (karoserija != null && !karoserija.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("karoserija"), karoserija));
        }
        if (kilometrazaOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("kilometraza"), kilometrazaOd));
        }
        if (kilometrazaDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("kilometraza"), kilometrazaDo));
        }
        if (kwOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("kw"), kwOd));
        }
        if (kwDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("kw"), kwDo));
        }
        if (ksOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("ks"), ksOd));
        }
        if (ksDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("ks"), ksDo));
        }
        if (godisteOd != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("godiste"), godisteOd));
        }
        if (godisteDo != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("godiste"), godisteDo));
        }
        if (cenaMin != null) {
            predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("cena"), cenaMin));
        }
        if (cenaMax != null) {
            predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("cena"), cenaMax));
        }
        if (bojaVozila != null && !bojaVozila.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("boja"), bojaVozila));
        }
        if (vrstaGoriva != null && !vrstaGoriva.isEmpty()) {
            predicates.add(criteriaBuilder.equal(root.get("automobil").get("gorivo"), vrstaGoriva));
        }

        criteriaQuery.where(predicates.toArray(new Predicate[0]));

        criteriaQuery.select(criteriaBuilder.count(root));
        Long count = entityManager.createQuery(criteriaQuery).getSingleResult();

        return count.intValue();
    }

    public Integer numberOfAds() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
        Root<Oglas> root = criteriaQuery.from(Oglas.class);
        criteriaQuery.select(criteriaBuilder.count(root));
        Long count = entityManager.createQuery(criteriaQuery).getSingleResult();
        return count.intValue();
    }

    public void deleteAd(Integer adId){
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            Oglas oglas = entityManager.find(Oglas.class, adId);
            if (oglas != null) {
                entityManager.remove(oglas);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void updateAd(Integer idOglasa, Integer cena, String opis) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            Oglas oglas = entityManager.find(Oglas.class, idOglasa);
            if (oglas != null) {
                oglas.setCena(cena);
                oglas.setOpis(opis);
                entityManager.merge(oglas);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }
}