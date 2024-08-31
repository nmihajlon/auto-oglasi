<%@ page import="Models.Message" %>
<%@ page import="Service.MessageService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Service.UserService" %>
<%@ page import="Models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    UserBean userBean = (UserBean) session.getAttribute("user");
    if(userBean == null){
        response.sendRedirect("index.jsp");
        return;
    }
    UserService userService = new UserService();
    User user = userService.convertUserBeanToUser(userBean);
    String receiverEmail = request.getParameter("receiverEmail");



    if (user != null && receiverEmail != null) {
        MessageService messageService = new MessageService();
        User receiver = userService.getUserByEmail(receiverEmail).orElse(null);
        if (receiver != null) {
            List<Message> messages = messageService.getMessagesBetweenUsers(user, receiver);
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat</title>
    <link rel="stylesheet" href="./style/chat.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <script type="text/javascript">
        var websocket;
        var userEmail = "<%= user.getEmail() %>";
        var receiverEmail = "<%= receiverEmail %>";

        function connect() {
            websocket = new WebSocket("ws://localhost:8080/auto_oglasi_war_exploded/message?email=" + encodeURIComponent(userEmail));
            websocket.onopen = function(event) {
                console.log("Connected to the server.");
            };

            websocket.onmessage = function(event) {
                var message = event.data;
                console.log("Received message: " + message);

                // Parse the message
                var parts = message.split(":");
                var sender = parts[0];
                var content = parts[1];
                var time = parts[2];

                // Display the message in the chat window
                var chatArea = document.getElementById("chatArea");
                chatArea.innerHTML += "<div class='message'><div class='message-content'>" + sender + ": " + content + "</div><div class='message-time'>" + time + "</div></div>";
                chatArea.scrollTop = chatArea.scrollHeight;
            };

            websocket.onclose = function(event) {
                console.log("Disconnected from the server.");
                console.log("Code: " + event.code + ", Reason: " + event.reason);
            };

            websocket.onerror = function(event) {
                console.error("WebSocket error: ", event);
            };
        }

        function sendMessage() {
            var messageContent = document.getElementById("messageContent").value;
            console.log("Message content: " + messageContent);
            var date = new Date();
            var options = {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                timeZone: 'Europe/Belgrade'
            };

            var formattedDate = date.toLocaleString('en-GB', options).replace(",", "");
            var message = userEmail + ":" + receiverEmail + ": " + messageContent + ": " + formattedDate;
            console.log("Message: "+message);
            websocket.send(message);

            document.getElementById("messageContent").value = "";
        }

        window.onload = function() {
            connect();
            var chatArea = document.getElementById("chatArea");
            chatArea.scrollTop = chatArea.scrollHeight; // Automatically scroll to bottom when the page loads

            document.getElementById("messageContent").addEventListener("keyup", function(event) {
                if (event.keyCode === 13) {
                    sendMessage();
                }
            });
        };

        function openModal(event) {
            event.preventDefault();
            var modal = document.getElementById("helpModal");
            modal.style.display = "block";
        }

        function closeModal() {
            var modal = document.getElementById("helpModal");
            modal.style.display = "none";
        }

        window.onclick = function(event) {
            var modal = document.getElementById("helpModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</head>
<body>

<header>
    <a href="index.jsp"><img src="./images/siteImages/logo.png" alt="logo" class="logo"></a>
    <nav>
        <ul class="nav-links">
            <%
                if(session.getAttribute("user") != null){
            %>
            <li><a href="oglasiVozilo.jsp">Oglasi vozilo</a></li>
            <li class="dropdown">
                <a href="#">Poruke</a>
                <div class="dropdown-content">
                    <span class="title">Poruke sa korisnicima</span>
                    <hr>
                    <%
                        UserBean u = (UserBean) session.getAttribute("user");

                        List<User> listContact = messageService.getAllConversation(u.getId());
                        if(listContact.isEmpty()){
                            out.println("<span class = 'subTitle'>Nemate jos uvek poruka sa drugim korisnicima</span>");
                        }
                        else{
                            for(User pom : listContact) {
                                User contactUser = userService.getUserById(pom.getId());
                    %>
                    <a class="contact" href="chat.jsp?receiverEmail=<%=contactUser.getEmail()%>"><%=contactUser.getFirstName()%> <%=contactUser.getLastName()%></a>
                    <%
                            }
                        }
                    %>
                </div>
            </li>

            <li><a href="mojiOglasi.jsp">Moji oglas</a></li>
            <%
                if(u.getIsAdmin()){
            %>
            <li>
                <a href="admin.jsp">Admin panel</a>
            </li>
            <%
                    }
                }
            %>

            <li>
                <a href="aboutUs.jsp">O nama</a>
            </li>

            <li>
                <a href="#" class="help" onClick="openModal(event)"><i class="fa-solid fa-question"></i></a>

                <div id="helpModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h2>Objašnjenje stranice:</h2>
                        <ol type="1">
                            <li style="margin-bottom: 10px;">
                                Navigacioni meni na vrhu stranice:
                                <ul>
                                    <li>Logo stranice: klikom na logo web stranice vracamo se na pocetnu stranu web aplikacije.</li>
                                    <li <%if(session.getAttribute("user") != null)%>>Oglasi vozilo: link kojim prijavljeni korisnik moze otici na stranicu za oglasavanje svog vozila.</li>
                                    <li <%if(session.getAttribute("user") != null)%>>Poruke: link koji predstavlja padajuci meni u kojem mozemo pregledati sa kim smo imali komunicirali dok klikom na nekog korisnika bicemo preusmereni na chat sa tom osobom.</li>
                                    <li <%if(session.getAttribute("user") != null)%>>Moji oglas: Na stranici "Moji oglasi" korisnik moze videti sve oglase koje je postavio do sada.</li>
                                    <%
                                        if(session.getAttribute("user") != null){
                                            UserBean ub = (UserBean) session.getAttribute("user");
                                            if(ub.getIsAdmin()){
                                    %>
                                    <li>
                                        Admin panel: Predvidjen je samo za admin-a i omogucava uvid u razne informacije vezane za web aplikaciju.
                                    </li>
                                    <%
                                            }
                                        }
                                    %>
                                    <li <%if(session.getAttribute("user") != null)%>>Account: Omogucava korisniku pregled osnovnih informacija o svom nalogu.</li>
                                    <li <%if(session.getAttribute("user") == null)%>>Login: Omogucava korisniku da ukoliko ima nalog i njegov nalog je aktiviran pristupi web aplikaciji.</li>
                                    <li <%if(session.getAttribute("user") == null)%>>Registracija: Omogucava kreiranje novog naloga za korisnika.</li>
                                    <li>Logout: Prijavljen korisnik moze se odjaviti sa aplikacije i u tom trenutku njegova sesija se brise.</li>
                                </ul>
                            </li>

                            <li style="margin-bottom: 10px;">
                                Na stranici "Chat" korisnik moze komunicirati sa drugim korisnicima, moguce je da prime i salje poruke u realnom vremenu a prikazan je i datum kada su poruke stizale.
                            </li>
                        </ol>
                    </div>
                </div>
            </li>
        </ul>
    </nav>
    <%
        if(session.getAttribute("user") != null){
    %>
    <div class="nav-right-links">
        <a class="account" href="account.jsp">
            <button>
                <img src="<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : "./images/siteImages/default-profile-image.png" %>" alt="Profile Picture" class="profile-circle">
                Nalog
            </button>
        </a>
        <form action="logOut.jsp" method="get">
            <button type="submit">Logout</button>
        </form>
    </div>
    <%
    }else{
    %>
    <div class="nav-right-links">
        <a class="login" href="login.jsp"><button>Login</button></a>
        <a class="register" href="register.jsp"><button>Sign up</button></a>
    </div>
    <%
        }
    %>
</header>

<%--Kraj navigacije--%>
<div class="chat-container">
    <h1>Poruke sa korisnikom: <%= receiver.getFirstName() %> <%=receiver.getLastName()%></h1>
    <div id="chatArea" style="overflow-y: auto; max-height: 400px;">
        <%
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            for (int i = 0; i < messages.size(); i++) {
                Message msg = messages.get(i);
                String sender = msg.getUser().getEmail();
                String content = msg.getContent();
                String time = dateFormat.format(msg.getTimestampAsDate());
                out.print("<div class='message'>");
                out.print("<div class='message-content'>" + sender + ": " + content + "</div>");
                out.print("<div class='message-time'>" + time + "</div>");
                out.print("</div>");
            }
        %>
    </div>
    <input type="text" id="messageContent" placeholder="Type your message here...">
    <button id="sendButton" onclick="sendMessage()">Send</button>
</div>
<script>
    function openModal(event) {
        event.preventDefault();
        var modal = document.getElementById("helpModal");
        modal.style.display = "block";
    }

    function closeModal() {
        var modal = document.getElementById("helpModal");
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        var modal = document.getElementById("helpModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>
</body>
</html>
<%
        } else {
            out.println("Receiver not found.");
        }
    } else {
        out.println("User not logged in or receiver email not provided.");
    }
%>
