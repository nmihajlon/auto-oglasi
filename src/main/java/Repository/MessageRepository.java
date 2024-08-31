package Repository;

import Database.Database;
import Models.Message;
import Models.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.util.*;

public class MessageRepository {

    private EntityManager entityManager = Database.getEntityManager();

    public Optional<Message> getById(Long id) {
        return Optional.ofNullable(entityManager.find(Message.class, id));
    }

    public List<Message> getAll() {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Message> cq = cb.createQuery(Message.class);
        Root<Message> root = cq.from(Message.class);
        cq.select(root);
        return entityManager.createQuery(cq).getResultList();
    }

    public List<Message> getMessagesBetweenUsers(User user, User receiver) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Message> cq = cb.createQuery(Message.class);
        Root<Message> root = cq.from(Message.class);
        cq.where(cb.or(
                cb.and(cb.equal(root.get("user"), user), cb.equal(root.get("receiver"), receiver)),
                cb.and(cb.equal(root.get("user"), receiver), cb.equal(root.get("receiver"), user))
        ));
        cq.orderBy(cb.asc(root.get("time_stamp")));
        return entityManager.createQuery(cq).getResultList();
    }

    public void addMessage(Message message) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(message);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void updateMessage(Message message) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.merge(message);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void deleteById(Long id) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            Message message = entityManager.find(Message.class, id);
            if (message != null) {
                entityManager.remove(message);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }
    public void deleteByUserId(Long userId) {
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();

            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaDelete<Message> cd = cb.createCriteriaDelete(Message.class);
            Root<Message> root = cd.from(Message.class);
            cd.where(cb.equal(root.get("user").get("id"), userId));

            entityManager.createQuery(cd).executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public List<User> getAllConversation(Integer userId) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();

        // Prvi upit: SELECT DISTINCT user.id FROM Message WHERE receiver.id = :userId
        CriteriaQuery<Long> cq1 = cb.createQuery(Long.class);
        Root<Message> root1 = cq1.from(Message.class);
        cq1.select(root1.get("user").get("id")).distinct(true);
        cq1.where(cb.equal(root1.get("receiver").get("id"), userId));
        List<Long> userIds1 = entityManager.createQuery(cq1).getResultList();

        // Drugi upit: SELECT DISTINCT receiver.id FROM Message WHERE user.id = :userId
        CriteriaQuery<Long> cq2 = cb.createQuery(Long.class);
        Root<Message> root2 = cq2.from(Message.class);
        cq2.select(root2.get("receiver").get("id")).distinct(true);
        cq2.where(cb.equal(root2.get("user").get("id"), userId));
        List<Long> userIds2 = entityManager.createQuery(cq2).getResultList();

        // Spoji rezultate i osiguraj jedinstvenost
        Set<Long> userIdsSet = new HashSet<>();
        userIdsSet.addAll(userIds1);
        userIdsSet.addAll(userIds2);

        // Povuci User objekte za jedinstvene ID-jeve
        CriteriaQuery<User> cq3 = cb.createQuery(User.class);
        Root<User> root3 = cq3.from(User.class);
        cq3.select(root3).where(root3.get("id").in(userIdsSet));
        return entityManager.createQuery(cq3).getResultList();
    }

    public void close() {
        Database.closeEntityManager(entityManager);
    }
}