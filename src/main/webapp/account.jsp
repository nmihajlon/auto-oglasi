<%@ page import="Beans.UserBean" %>
<%@ page import="Service.MessageService" %>
<%@ page import="Service.UserService" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("user") != null){
        UserBean u = (UserBean) session.getAttribute("user");
%>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="./style/account.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
                        MessageService messageService = new MessageService();
                        UserService userService = new UserService();

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
                                Na stranici sa leve strane korisnik moze da promeni svoju profilnu sliku ili da je obrise i ima uvid u osnovne informacije svoj naloga.
                            </li>

                            <li>
                                U srednjem i desnom delu stranice korisnik moze menjati informacije o svom nalogu.
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
                <img src="<%= u.getProfilePicture() != null && !u.getProfilePicture().isEmpty() ? u.getProfilePicture() : "./images/siteImages/default-profile-image.png" %>" alt="Profile Picture" class="profile-circle">
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
    <div class="content">
        <div class="col-first">
            <div class="profile-image">
                <%
                    String userProfilePicture = u.getProfilePicture();
                    if(userProfilePicture != null && userProfilePicture != ""){
                %>
                <img src="<%=userProfilePicture%>">
                <%
                    } else {
                %>
                <img src="./images/siteImages/default-profile-image.png">
                <%
                    }
                %>
            </div>
            <div class="row">
            <form action="UploadProfilePicture" method="post" enctype="multipart/form-data" class="row">
                <input type="hidden" name="email" value="<%=u.getEmail()%>">
                <input type="file" name="profilePicture" id="profilePicture" style="display:none;"/>
                <label class="choose" for="profilePicture">Odaberi sliku</label>
                <input class="upload-btn" type="submit" value="Upload" />
            </form>

            <form action="DeleteProfilePicture" method="post">
                <input type="hidden" name="email" value="<%=u.getEmail()%>">
                <input class="delete-btn" type="submit" value="Obrisi sliku" />
            </form>
            </div>
            <div class="user-info">
                <span>Ime: <%=u.getFirstName()%></span>
                <span>Prezime: <%=u.getLastName()%></span>
                <span>Korisnicko ime: <%=u.getUsername()%></span>
                <span>Email: <%=u.getEmail()%></span>
                <span>Telefon: <%=u.getContact()%></span>
                <span>Vreme izmene profila: <%=u.getUpdateProfile()%></span>
            </div>
        </div>

        <div class="col-second">

            <div class="input-container">
                <input placeholder="Korisnicko ime:" class="input-field" type="text" id="input-field2">
                <label for="input-field2" class="input-label">Korisnicko ime:</label>
                <span class="input-highlight"></span>
            </div>

            <div class="input-container">
                <input placeholder="Telefon:" class="input-field" type="text" id="input-field3">
                <label for="input-field3" class="input-label">Telefon:</label>
                <span class="input-highlight"></span>
            </div>

        </div>

        <div class="col-thrid">
            <div class="input-container">
                <input placeholder="Zemlja:" class="input-field" type="text" id="input-field4">
                <label for="input-field4" class="input-label">Zemlja:</label>
                <span class="input-highlight"></span>
            </div>

            <div class="input-container">
                <input placeholder="Grad:" class="input-field" type="text" id="input-field5">
                <label for="input-field5" class="input-label">Grad:</label>
                <span class="input-highlight"></span>
            </div>

            <button class="submitNewInfo" onclick="pokupiInformacije()">Potvrdi izmene</button>
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
    function pokupiInformacije() {
        var email = document.getElementById("input-field").value;
        var korisnickoIme = document.getElementById("input-field2").value;
        var telefon = document.getElementById("input-field3").value;
        var zemlja = document.getElementById("input-field4").value;
        var grad = document.getElementById("input-field5").value;

        var form = document.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("action", "accountHandler.jsp");

        var inputEmail = document.createElement("input");
        inputEmail.setAttribute("type", "hidden");
        inputEmail.setAttribute("name", "email");
        inputEmail.setAttribute("value", email);
        form.appendChild(inputEmail);

        var inputKorisnickoIme = document.createElement("input");
        inputKorisnickoIme.setAttribute("type", "hidden");
        inputKorisnickoIme.setAttribute("name", "korisnickoIme");
        inputKorisnickoIme.setAttribute("value", korisnickoIme);
        form.appendChild(inputKorisnickoIme);

        var inputTelefon = document.createElement("input");
        inputTelefon.setAttribute("type", "hidden");
        inputTelefon.setAttribute("name", "telefon");
        inputTelefon.setAttribute("value", telefon);
        form.appendChild(inputTelefon);

        var inputZemlja = document.createElement("input");
        inputZemlja.setAttribute("type", "hidden");
        inputZemlja.setAttribute("name", "zemlja");
        inputZemlja.setAttribute("value", zemlja);
        form.appendChild(inputZemlja);

        var inputGrad = document.createElement("input");
        inputGrad.setAttribute("type", "hidden");
        inputGrad.setAttribute("name", "grad");
        inputGrad.setAttribute("value", grad);
        form.appendChild(inputGrad);

        document.body.appendChild(form);
        form.submit();
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
    }
    else
    {
        response.sendRedirect("index.jsp");
        return;
    }
%>