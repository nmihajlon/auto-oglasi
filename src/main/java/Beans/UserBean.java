package Beans;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class UserBean implements Serializable {
    private Integer id;
    private String username;
    private String email;
    private String contact;
    private String firstName;
    private String lastName;
    private String updateProfile;
    private Integer money;
    private Boolean isActive;
    private String profilePicture;
    private Boolean isAdmin;
    private String zemlja;
    private String grad;

    public UserBean() {}

    public UserBean(Integer id, String username, String email, String contact, String firstName, String lastName, String updateProfile, Integer money, Boolean isActive, String profilePicture, Boolean isAdmin, String zemlja, String grad) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.contact = contact;
        this.firstName = firstName;
        this.lastName = lastName;
        this.updateProfile = updateProfile;
        this.money = money;
        this.isActive = isActive;
        this.profilePicture = profilePicture;
        this.isAdmin = isAdmin;
        this.zemlja = zemlja;
        this.grad = grad;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUpdateProfile() {
        return updateProfile;
    }

    public void setUpdateProfile(String updateProfile) {
        this.updateProfile = updateProfile;
    }

    public Integer getMoney() {
        return money;
    }

    public void setMoney(Integer money) {
        this.money = money;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public Boolean getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(Boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    public String getZemlja() {
        return zemlja;
    }

    public void setZemlja(String zemlja) {
        this.zemlja = zemlja;
    }

    public String getGrad() {
        return grad;
    }

    public void setGrad(String grad) {
        this.grad = grad;
    }
}
