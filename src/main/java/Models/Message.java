package Models;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "messages")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver;

    @Column(nullable = false, length = 1000)
    private String content;

    @Column(nullable = false)
    private LocalDateTime time_stamp;

    public Message() {}

    public Message(User user, User receiver, String content) {
        this.user = user;
        this.receiver = receiver;
        this.content = content;
        this.time_stamp = LocalDateTime.now();
    }

    // Getteri i setteri
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public User getReceiver() {
        return receiver;
    }
    public void setReceiver(User receiver) {
        this.receiver = receiver;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getTimestamp() {
        return time_stamp;
    }
    public Date getTimestampAsDate() {
        return Date.from(time_stamp.atZone(ZoneId.systemDefault()).toInstant());
    }
    public void setTimestamp(LocalDateTime timestamp) {
        this.time_stamp = timestamp;
    }
}