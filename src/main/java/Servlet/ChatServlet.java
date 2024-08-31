package Servlet;

import Models.Message;
import Models.User;
import Service.MessageService;
import Service.UserService;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/message")
public class ChatServlet {
    private static Set<Session> userSessions = Collections.newSetFromMap(new ConcurrentHashMap<Session, Boolean>());
    private static Map<String, Session> emailSessionMap = new ConcurrentHashMap<>();
    private MessageService messageService = new MessageService();
    private UserService userService = new UserService();
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        try {
            String queryString = session.getQueryString();
            System.out.println("Query string: " + queryString);
            String encodedEmail = queryString.split("=")[1];
            String email = URLDecoder.decode(encodedEmail, StandardCharsets.UTF_8.name());
            if (email != null) {
                emailSessionMap.put(email, session);
                session.getUserProperties().put("email", email);
                System.out.println("Session opened for email: " + email + " sesija: " + session);
            }
            userSessions.add(session);
        } catch (Exception e) {
            System.err.println("Error on WebSocket connection open: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        try {
            String email = (String) session.getUserProperties().get("email");
            if (email != null) {
                emailSessionMap.remove(email);
                System.out.println("Session closed for email: " + email);
            }
            userSessions.remove(session);
        } catch (Exception e) {
            System.err.println("Error on WebSocket connection close: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String message, Session userSession) {
        try {
            System.out.println("Received message: " + message);

            // Format: senderEmail:receiverEmail:messageContent:timestamp
            String[] parts = message.split(":");
            String senderEmail = parts[0].trim();
            String receiverEmail = parts[1].trim();
            String messageContent = parts[2].trim();
            String timestamp = parts[3]; // Format: yyyy-MM-dd HH:mm:ss

            // Save the message to the database
            User sender = userService.getUserByEmail(senderEmail).orElse(null);
            User receiver = userService.getUserByEmail(receiverEmail).orElse(null);
            if (sender != null && receiver != null) {
                Message msg = new Message(sender, receiver, messageContent);
                messageService.addMessage(msg);

                // Send the message to both sender and receiver
                sendToUser(senderEmail, senderEmail + ":" + messageContent + ":" + timestamp);
                sendToUser(receiverEmail, senderEmail + ":" + messageContent + ":" + timestamp);
            }
        } catch (Exception e) {
            System.err.println("Error on message receive: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void sendToUser(String email, String message) {
        try {
            Session session = emailSessionMap.get(email);
            if (session != null && session.isOpen()) {
                session.getAsyncRemote().sendText(message);
            }
        } catch (Exception e) {
            System.err.println("Error sending message to user: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void broadcast(String message) {
        try {
            for (Session session : userSessions) {
                if (session.isOpen()) {
                    session.getAsyncRemote().sendText(message);
                }
            }
        } catch (Exception e) {
            System.err.println("Error broadcasting message: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
