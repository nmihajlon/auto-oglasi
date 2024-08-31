package Service;

import Models.Message;
import Models.User;
import Repository.MessageRepository;

import java.util.List;
import java.util.Optional;

public class MessageService {
    private MessageRepository messageRepository;

    public MessageService() {
        this.messageRepository = new MessageRepository();
    }

    public Optional<Message> getMessageById(Long id) {
        return messageRepository.getById(id);
    }

    public List<Message> getAllMessages() {
        return messageRepository.getAll();
    }

    public List<Message> getMessagesBetweenUsers(User user, User receiver) {
        return messageRepository.getMessagesBetweenUsers(user, receiver);
    }

    public void addMessage(Message message) {
        messageRepository.addMessage(message);
    }

    public void updateMessage(Message message) {
        messageRepository.updateMessage(message);
    }

    public void deleteMessageById(Long id) {
        messageRepository.deleteById(id);
    }
    public void deleteMessageByUserId(Long id) {
        messageRepository.deleteByUserId(id);
    }

    public List<User> getAllConversation(Integer userId){ return messageRepository.getAllConversation(userId); }

    public void close() {
        messageRepository.close();
    }
}