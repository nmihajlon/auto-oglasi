package Service;

import Beans.UserBean;
import Models.User;
import Repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.swing.text.html.Option;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class UserService {
    private UserRepository userRepository;
    private BCryptPasswordEncoder passwordEncoder;

    public UserService(){
        this.userRepository = new UserRepository();
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    private String sessionGenerator(){
        return UUID.randomUUID().toString();
    }

    public User getUserById(Integer id){
        return userRepository.getUserById(id);
    }

    public List<User> getAllUsers() {
        return userRepository.getAllUsers();
    }

    public Optional<User> getUserByEmail(String email){
        return userRepository.getUserByEmail(email);
    }

    public Optional<UserBean> login(String email, String password){
        Optional<User> userOptional = userRepository.getUserByEmail(email);
        if(userOptional.isPresent()){
            User user = userOptional.get();

            if(passwordEncoder.matches(password, user.getPassword()) && user.getIsActive()){
                return Optional.of(convertUserToUserBean(user));
            }
        }
        return Optional.empty();
    }

    public void addNewUser(User user){
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.addNewUser(user);
    }

    public UserBean convertUserToUserBean(User user){
        return new UserBean(user.getId(), user.getUsername(), user.getEmail(), user.getContact(), user.getFirstName(), user.getLastName(), user.getUpdateProfile(), user.getMoney(), user.getIsActive(), user.getProfilePicture(), user.getAdmin(), user.getZemlja(), user.getGrad());
    }

    public User convertUserBeanToUser(UserBean user){
        return new User(user.getId(), user.getEmail(), user.getUsername(), user.getFirstName(), user.getLastName(), user.getContact(), user.getIsAdmin(), user.getMoney(), null, user.getProfilePicture(), user.getIsActive(), user.getUpdateProfile(), user.getZemlja(), user.getGrad());
    }

    public void setProfilePicturePath(Integer id, String profilePicturePath){
        userRepository.setProfilePicturePath(id, profilePicturePath);
    }

    public void updateUser(User user) {
        userRepository.updateUser(user);
    }

    public void deactivateUser(Integer userId){
        userRepository.deactivateUser(userId);
    }

    public void activateUser(Integer userId){
        userRepository.activateUser(userId);
    }

    public List<User> searchUsers(String searchQuery) {
        return userRepository.searchUsers(searchQuery);
    }
}
