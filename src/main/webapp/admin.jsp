<%@ page import="Beans.UserBean" %>
<%@ page import="Service.UserService" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="Service.MessageService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin panel</title>
    <link rel="stylesheet" href="style/admin.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<%
    UserBean userBean = (UserBean) session.getAttribute("user");
    if(userBean != null && userBean.getIsAdmin()){
        UserService userService = new UserService();

        String searchQuery = request.getParameter("searchQuery");

        List<User> lista;
        if (searchQuery != null && !searchQuery.isEmpty()) {
            lista = userService.searchUsers(searchQuery);
        } else {
            lista = userService.getAllUsers();
        }
%>
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
                        MessageService messageService = new MessageService();
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
                                Korisnik koji ima privilegije administratora moze da pretrazuje, deaktivira i aktivira korisnike, ima potpuni uvid u sve informacije o svakom korisniku kao i vreme bilo kakve promene na njihovim profilima.
                            </li>

                            <li>Administrator moze dodati model automobila koji trenutno ne postoji na web aplikaciji.</li>
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
                <img src="<%= userBean.getProfilePicture() != null && !userBean.getProfilePicture().isEmpty() ? userBean.getProfilePicture() : "./images/siteImages/default-profile-image.png" %>" alt="Profile Picture" class="profile-circle">
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

<div class="search-bar">
    <form class="forma" action="admin.jsp" method="get">
        <input type="text" name="searchQuery" placeholder="Pretraži korisnike..." value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
        <button type="submit">Pretraži</button>
    </form>
</div>

<div class="content">
    <table class="styled-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Ime</th>
            <th>Prezime</th>
            <th>Email</th>
            <th>Korisničko ime</th>
            <th>Zemlja</th>
            <th>Grad</th>
            <th>Admin</th>
            <th>Aktivan nalog</th>
            <th>Izmene profila</th>
            <th>Akcija</th>
        </tr>
        </thead>
        <tbody>
        <%
            for(User user : lista){
        %>
        <tr>
            <td><%=user.getId()%></td>
            <td><%=user.getFirstName()%></td>
            <td><%=user.getLastName()%></td>
            <td><%=user.getEmail()%></td>
            <td><%=user.getUsername()%></td>
            <td><%=user.getZemlja()%></td>
            <td><%=user.getGrad()%></td>
            <td><%=user.getAdmin()%></td>
            <%
                if(user.getIsActive()){
            %>
            <td class="active" style="color: #009879">Aktivan</td>
            <%
            } else {
            %>
            <td class="active" style="color: #EF4B4B">Neaktivan</td>
            <%
                }
            %>
            <%
                if(user.getUpdateProfile() != null){
                    String updateProfile = user.getUpdateProfile().replace("T", " ");
            %>
            <td><%=updateProfile%></td>
            <%
            } else {
            %>
            <td></td>
            <%
                }
            %>
            <%
                if(!user.getAdmin()){
            %>
            <td class="action">
                <i style="color: #009879" class="fa-solid fa-unlock" onclick="activateUser(<%=user.getId()%>)"></i>
                <i class="fa-solid fa-lock" style="color: #EF4B4B" onclick="deactivateUser(<%= user.getId() %>)"></i>
            </td>
            <%
                }
            %>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="form-container">
        <h2>Dodaj novi automobil</h2>
        <form action="DodajAutomobilServlet" method="post" class="styled-form">
            <label for="marka">Marka:</label>
            <input type="text" id="marka" name="marka" required><br>

            <label for="model">Model:</label>
            <input type="text" id="model" name="model" required><br>

            <label for="menjac">Menjač:</label>
            <input type="text" id="menjac" name="menjac" required><br>

            <label for="zemlja">Zemlja porekla:</label>
            <input type="text" id="zemlja" name="zemlja" required><br>

            <label for="pogon">Pogon:</label>
            <input type="text" id="pogon" name="pogon" required><br>

            <label for="pogon">Karoserija:</label>
            <input type="text" id="karoserija" name="karoserija" required><br>

            <label for="gorivo">Gorivo:</label>
            <input type="text" id="gorivo" name="gorivo" required><br>

            <button type="submit">Dodaj vozilo</button>
        </form>

        <%
            if(session.getAttribute("uspesnoDodatoVozilo") != null){
        %>
        <p style="color: green"><%=session.getAttribute("uspesnoDodatoVozilo")%></p>
        <%
        }else if(session.getAttribute("neuspesnoDodatoVozilo") != null){
        %>
        <p style="color: red"><%=session.getAttribute("neuspesnoDodatoVozilo")%></p>
        <%
            }
        %>
    </div>
</div>

<div class="footer">
    <div class="footer-section levi">
        <a href="#"><i class="fab fa-youtube"></i></a>
        <a href="#"><i class="fab fa-facebook-f"></i></a>
        <a href="#"><i class="fab fa-twitter"></i></a>
        <a href="#"><i class="fab fa-instagram"></i></a>
        <a href="#"><i class="fab fa-linkedin"></i></a>
    </div>

    <div class="footer-section centar">
        <p>&copy; 2024 Auto Oglasi - kreirao Mihajlo Nikolic.</p>
    </div>

    <div class="footer-section desno">
        <h4>Kontakt</h4>
        <p>Email: support@autooglasi.com</p>
        <p>Telefon: +123 456 7890</p>
    </div>
</div>

</body>

<script>
    function deactivateUser(userId){
        if (confirm("Da li ste sigurni da želite da deaktivirate ovog korisnika?")) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "userActionServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert("Korisnik je uspešno deaktiviran.");
                    location.reload();
                } else {
                    alert("Došlo je do greške: " + xhr.responseText);
                }
            };

            xhr.send("userId=" + userId + "&action=deactivate");
        }
    }

    function activateUser(userId){
        if (confirm("Da li ste sigurni da želite da aktivirate nalog ovog korisnika?")) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "userActionServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert("Korisnik je uspešno aktiviran.");
                    location.reload();
                } else {
                    alert("Došlo je do greške: " + xhr.responseText);
                }
            };

            xhr.send("userId=" + userId + "&action=activate");
        }
    }

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

</html>
<%
    } else {
        response.sendRedirect("index.jsp");
    }
%>
