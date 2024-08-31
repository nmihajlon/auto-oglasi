<%@ page import="Service.MessageService" %>
<%@ page import="Service.UserService" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>O nama</title>
    <link rel="stylesheet" href="style/aboutUs.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
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
                                Filteri za pretragu: Korisnik moze pretraziti oglase po nekom od kriterijuma poput marke, modela, vrste goriva, pogona, menjaca, zemlje iz koje poticu odredjene marke, karoserije auta. Otvaranjem dodatnih filtera mozemo postaviti jos nacina filtracije oglasa. Dugme pretraga vodi nas na novu stranicu koja ce primeniti filtere koje je korisnik postavio.
                            </li>

                            <li>Pregled vozila: Na pocetnoj stranici mozemo videti neke od oglasa.</li>
                        </ol>
                    </div>
                </div>
            </li>
        </ul>
    </nav>
    <%
        if(session.getAttribute("user") != null){
            UserBean u = (UserBean) session.getAttribute("user");
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

<div class="content">
    <h1>O sajtu auto-oglasi</h1>

    <div class="aboutUs">
        <h3>O nama</h3>
        <div class="aboutUsContent">
            <div>
                <p>Auto-oglasi su najposeceniji sajt za kupovinu i prodaju automobila.</p>
                <br>
                <p>Kupcima ovaj sajt zeli da olaksa donosenje prave odluke o kupovini, kroz jednostavnu pretragu sirokog spektra vozila.</p>
                <br>
                <p>Prodavcima sajt auto-oglasi tezi da pomogne u pospesivanju prodaje koriscenjem interneta u poslovanju i omoguciti im brze i lakse povezivanje sa kupcima.</p>
            </div>

            <img class="logoSajta" src="images/siteImages/logo.png" alt="">
        </div>
        <hr>
        <div class="aboutUsContent">
            <div>
                <p>Sajt Auto-oglasi zeli da utice na unapredjenje razvoja trzista automobila kroz povecanje koriscenja interneta u kupoprodaji vozila.</p>
                <br>
                <p>Kupcima ovaj sajt želi da olakša donošenje prave odluke o kupovini, kroz kreiranje mogućnosti lakog upoređivanja širokog spektra ponude vozila, kao i kroz pružanje zaokružene celine praktičnih i neophodnih informacija.</p>
                <br>
            </div>
        </div>
        <hr>
        <h3 style="margin-top: 1rem">Kontakt</h3>
        <div class="aboutUsContent">
            <div>
                <p><b>Korisnicki servis</b></p>
                <p><i class="fa-solid fa-phone"></i> +123 456 7890</p>
                <p><i class="fa-solid fa-fax"></i> +123 456 7899</p>
            </div>
            <div>
                <p><b>Email</b></p>
                <p>kontakt@autooglasi.com</p>
                <p>kontakt@autooglasiprodaja.com</p>
                <p>kontakt@autooglasipomoc.com</p>
            </div>
        </div>
        <hr>
        <h3 style="margin-top: 1rem">Mapa</h3>
        <div class="aboutUsContent">
            <div id="mapa" style="width: 100%">
                <iframe id="mapaa" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1120.6361109032626!2d20.922543759207393!3d44.015408415469024!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x475101b2526ad8d7%3A0x6ed67583be4391e4!2sRadoja%20Domanovi%C4%87a%2C%20Kragujevac!5e0!3m2!1sen!2srs!4v1622616207291!5m2!1sen!2srs" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
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

</html>
