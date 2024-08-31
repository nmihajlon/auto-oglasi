package Repository;

import Beans.UserBean;
import Database.Database;
import Models.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserRepository {
    private EntityManager entityManager = Database.getEntityManager();

    public Optional<User> getUserByEmail(String email) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<User> criteriaQuery = criteriaBuilder.createQuery(User.class);
        Root<User> root = criteriaQuery.from(User.class);
        criteriaQuery.where(criteriaBuilder.equal(root.get("email"), email));
        return entityManager.createQuery(criteriaQuery).getResultList().stream().findFirst();
    }

    public User getUserById(Integer id){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<User> criteriaQuery = criteriaBuilder.createQuery(User.class);
        Root<User> root = criteriaQuery.from(User.class);
        criteriaQuery.where(criteriaBuilder.equal(root.get("id"), id));
        return entityManager.createQuery(criteriaQuery).getSingleResult();
    }

    public List<User> getAllUsers(){
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<User> criteriaQuery = criteriaBuilder.createQuery(User.class);
        Root<User> root = criteriaQuery.from(User.class);
        criteriaQuery.select(root);
        return entityManager.createQuery(criteriaQuery).getResultList();
    }

    public void addNewUser(User user){
        EntityTransaction t = entityManager.getTransaction();
        t.begin();
        if(user.getId() == null){
            entityManager.persist(user);
        }
        else{
            entityManager.merge(user);
        }
        t.commit();
    }

    public void setProfilePicturePath(Integer id, String profilePicturePath){
        EntityTransaction t = entityManager.getTransaction();
        try {
            t.begin();
            User user = entityManager.find(User.class, id);
            if (user != null) {
                user.setProfilePicture(profilePicturePath);
                entityManager.merge(user);
            }
            t.commit();
        } catch (Exception e) {
            if (t.isActive()) {
                t.rollback();
            }
            throw e;
        }
    }

    public void updateUser(User user) {
        EntityTransaction t = entityManager.getTransaction();
        try {
            t.begin();
            entityManager.merge(user);
            t.commit();
        } catch (Exception e) {
            if (t.isActive()) {
                t.rollback();
            }
            throw e;
        }
    }

    public void deactivateUser(int userId) {
        EntityTransaction t = entityManager.getTransaction();
        try {
            t.begin();
            User user = entityManager.find(User.class, userId);
            if (user != null) {
                user.setIsActive(false);
                entityManager.merge(user);
            }
            t.commit();
        } catch (Exception e) {
            if (t.isActive()) {
                t.rollback();
            }
            throw e;
        }
    }

    public void activateUser(Integer userId){
        EntityTransaction t = entityManager.getTransaction();
        try {
            t.begin();
            User user = entityManager.find(User.class, userId);
            if (user != null) {
                user.setIsActive(true);
                entityManager.merge(user);
            }
            t.commit();
        } catch (Exception e) {
            if (t.isActive()) {
                t.rollback();
            }
            throw e;
        }
    }

    public List<User> searchUsers(String searchQuery) {
        List<User> users = getAllUsers();
        return users.stream()
                .filter(user -> user.getFirstName().toLowerCase().contains(searchQuery.toLowerCase()) ||
                        user.getLastName().toLowerCase().contains(searchQuery.toLowerCase()) ||
                        user.getEmail().toLowerCase().contains(searchQuery.toLowerCase()) ||
                        user.getUsername().toLowerCase().contains(searchQuery.toLowerCase()))
                .collect(Collectors.toList());
    }
}
