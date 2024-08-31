<%@ page import="Beans.UserBean" %>
<%@ page import="java.util.Optional" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Oglas" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Automobil" %>
<%@ page import="Service.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Moji oglasi</title>
    <link rel="stylesheet" href="./style/mojiOglasi.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<%
    if(session.getAttribute("user") != null){
        UserBean userBean = (UserBean) session.getAttribute("user");
        UserService userService = new UserService();
        OglasService oglasService = new OglasService();
        AutomobilService automobilService = new AutomobilService();
        SlikeService slikeService = new SlikeService();

        Optional<User> optionalUser = userService.getUserByEmail(userBean.getEmail());
        if(optionalUser.isPresent()){
            User user = optionalUser.get();
            List<Oglas> oglasi = oglasService.getAdsForUser(user.getId());
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
                                Na stranici "Moji oglasi" dostupna su vozila koje je korisnik okacio na web aplikaciju. Korisnik koji je kreirao moze menjati, obrisati ili pogledati detalje o svom oglasu.
                                Pored toga za svaki oglas prikazana je jedna slika i kratke informacije o vozilu, kao i to da li je auto istaknut ili ne.
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

<div class="content">
    <%
        for(Oglas o : oglasi){
            Automobil auto = automobilService.getCarByID(o.getAutomobil().getId());
            String slika = slikeService.getImageForAd(o.getId());
    %>
    <div class="ad-container">
        <div class="ad-header">
            <span class="ad-badge">ISTAKNUT</span>
            <h3><%= auto.getMarka() + " " + auto.getModel() %></h3>
            <div class="ad-price"><%= o.getCena() %> &euro;</div>
        </div>
        <div class="ad-body">
            <div class="ad-image">
                <%
                    if(slika != null && !slika.isEmpty()){
                %>
                <img src="<%= slika %>" alt="Slika automobila">
                <%
                } else {
                %>
                <img src="./images/siteImages/default-image.png" alt="Slika automobila nije pronađena">
                <%
                    }
                %>
            </div>
            <div class="ad-details">
                <p>Godiste: <%= o.getGodiste() %> &bull; <%= o.getKilometraza() %> km &bull; <%=o.getKw()%> kW (<%=o.getKs()%> HP)</p>
                <p><%=auto.getKaroserija()%> &bull; <%= auto.getGorivo() %> &bull; <%= auto.getMenjac() %></p>
                <p>Boja: <%= o.getBoja() %></p>
                <%
                    String opis = o.getOpis();
                    if (opis != null && opis.length() > 250) {
                        opis = opis.substring(0, 250) + "...";
                    }
                    else{
                        opis = "Za vozilo nije dodat opis.";
                    }
                %>
                <p>Opis: <%= opis %></p>
            </div>
        </div>
        <div class="ad-footer">
            <div class="dealer-info">
                <p>Prodavac <i class="fa-solid fa-user"></i> : <%=user.getFirstName()%> <%=user.getLastName()%></p>
                <p>Lokacija <i class="fa-solid fa-location-dot"></i> :   <%=user.getZemlja()%> | <%=user.getGrad()%></p>
            </div>
            <div class="ad-buttons">
                <button style="background-color: #7286D3" onclick="redirekcijaIzmeni(<%=o.getId()%>)">Izmeni oglas</button>
                <button style="background-color: #EF4B4B" onClick="openDelModal(event)">Obrisi oglas</button>
                <div class="modal" id="delModal">
                    <div class="modal-content1">
                        <span class="close" onclick="closeDelModal()">&times;</span>
                        <div class="modal-content2">
                            <h2>Da li ste sigurni da zelite da obrisete oglas?</h2>
                            <div style="margin-top: 1rem; display: flex; flex-direction: row;">
                                <button style="background: #B4B4B8; color: black" onclick="closeDelModal()">Ponisti</button>
                                <form action="deleteAd" method="post">
                                    <input type="hidden" name="adId" value="<%= o.getId() %>">
                                    <button type="submit" style="background-color: #EF4B4B">Obrisi oglas</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <button onclick="redirekcija(<%=o.getId()%>)">Detalji</button>
            </div>
        </div>
    </div>
    <%
        }
    %>
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
    function redirekcija(idOglasa){
        window.location.href = "auto-oglas.jsp?id=" + idOglasa;
    }

    function openDelModal(event){
        event.preventDefault();
        var modal = document.getElementById("delModal");
        modal.style.display = "block";
    }

    function closeDelModal(){
        var modal = document.getElementById("delModal");
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        var modal = document.getElementById("helpModal");
        if (event.target == modal) {
            modal.style.display = "none";
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

    window.onclick = function(event) {
        var modal = document.getElementById("delModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    function redirekcijaIzmeni(idOglasa){
        window.location.href = "izmeniOglas.jsp?idOglasa="+idOglasa;
    }
</script>

<%
        }
    }else{
        response.sendRedirect("index.jsp");
        return;
    }
%>
</html>
