<%@ page import="Beans.UserBean" %>
<%@ page import="Models.Oglas" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Automobil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Models.Ostecenja" %>
<%@ page import="Service.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Oglas</title>
    <link rel="stylesheet" href="style/auto-oglas.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%
    UserBean u = (UserBean)session.getAttribute("user");
%>

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
                        UserService userService = new UserService();
                        MessageService messageService = new MessageService();

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
                                Na stranici "Auto-oglas" korisnik ima mogucnost da pogleda detaljne informacije o vozilu koje ga interesuje. Sa leve strane nalaze se sve dostupne slike vozila, dok se sa desne strane nalaze
                                osnovne informacije o vozilu, informacije o prodavcu i informacije o ceni. Spustanjem na dole korisniku se daju jos neki detalji o vozilu kao i specifikacije vozila.
                                Klikom na dugme kontaktiraj prodavca, korisnik ce biti prebacen na chat stranicu sa prodavcem vozila.
                            </li>

                            <li>Na dnu stranice nalazi se i opis vozila koji je kreirao prodavac.</li>
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

<%--Kraj nav--%>

<%
    String idOglasaParam = request.getParameter("id");
    Integer idOglasa;
    if(idOglasaParam != null && !idOglasaParam.isEmpty()){
        idOglasa = Integer.parseInt(idOglasaParam);
    }
    else{
        response.sendRedirect("index.jsp");
        return;
    }

    OglasService oglasService = new OglasService();
    SlikeService slikeService = new SlikeService();
    UserService userService = new UserService();
    AutomobilService automobilService = new AutomobilService();

    Oglas oglas = oglasService.getAdById(idOglasa);
    List<String> slike = slikeService.getAllImagesForAd(idOglasa);
    User seller = userService.getUserById(oglas.getUser_id().getId());
    Automobil auto = automobilService.getCarByID(oglas.getAutomobil().getId());
%>

<div class="content">
    <div class="content-slider">
        <div class="slider-container">
            <div class="slider" id="slider">
                <button class="arrow left" onclick="prevSlide()">&#10094;</button>
                <%
                    for(String slika : slike) {
                %>
                    <img src="<%=slika%>" alt="Slika oglasa">
                <%
                    }
                %>
                <button class="arrow right" onclick="nextSlide()">&#10095;</button>
            </div>
        </div>

        <div class="thumbnails">
            <% for(int i = 0; i < slike.size(); i++) { %>
                <img src="<%=slike.get(i)%>" onclick="showSlide( <%=i%> )">
            <% } %>
        </div>
    </div>

    <div class="content-contact">
        <div>
            <h3><%=auto.getMarka()%> <%=auto.getModel()%></h3>
            <span><%=oglas.getGodiste()%> god.</span>
        </div>

        <span class="subTitle">Pogon: <%=auto.getPogon()%> / Menjac: <%=auto.getMenjac()%> / Gorivo: <%=auto.getGorivo()%></span>
        <hr>
        <h3>Cena: <%=oglas.getCena()%> &euro;</h3>
        <hr>
        <h4>Informacije o prodavcu:</h4>
            <span>Ime i prezime: <%=seller.getFirstName()%> <%=seller.getLastName()%></span>
            <br>
            <span>Lokacija <i class="fa-solid fa-location-dot"></i>  : <%=seller.getZemlja()%> <%=seller.getGrad()%></span>
        <hr>
        <h4>Kontakt:</h4>
        <div class="prodavac-kontakt">
            <a href= "mailto: <%=seller.getEmail()%>"> E-mail prodavca </a>
            <span>Telefon <i class="fa-solid fa-phone"></i>  :  <%=seller.getContact()%></span>
        </div>
        <form action="chat.jsp" method="post">
            <input type="hidden" name="receiverEmail" value="<%=seller.getEmail()%>">
            <button class="message-btn" type="submit">Kontaktiraj prodavca</button>
        </form>
    </div>

<%--Kratke informacije deo--%>
</div>

<div class="wrapper">
    <div class="short-info">
        <h3>Informacije o vozilu:</h3>
        <div></div>
        <div></div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/rode.png" alt="">
            <span><%=oglas.getKilometraza()%> km</span>
        </div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/speed.png" alt="">
            <span><%=oglas.getKw()%> kw | <%=oglas.getKs()%> ks</span>
        </div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/petrol.png" alt="">
            <span><%=auto.getGorivo()%></span>
        </div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/gearbox.png" alt="">
            <span><%=auto.getMenjac()%></span>
        </div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/calendar.png" alt="">
            <span><%=oglas.getGodiste()%> god.</span>
        </div>
        <div class="icon-wrapper">
            <img src="./images/siteImages/user.png" alt="">
            <span><%=seller.getFirstName()%> <%=seller.getLastName()%></span>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="info">
        <h3>Tehnicke specifikacije:</h3>
        <table id="tabela">
            <tr>
                <td>Stanje vozila:</td>
                <%
                    if(oglas.getOstecenje() == Ostecenja.OSTECEN){
                %>
                <td>Ostecen</td>
                <%
                    }else if(oglas.getOstecenje() == Ostecenja.DELIMICNO_OSTECEN){
                %>
                <td>Delimicno ostecen</td>
                <%
                    }else{
                %>
                <td>Nije ostecen</td>
                <%
                    }
                %>
            </tr>

            <tr>
                <td>Karoserija:</td>
                <td><%=auto.getKaroserija()%></td>
            </tr>

            <tr>
                <td>Kilometraza vozila:</td>
                <td><%=oglas.getKilometraza()%> km</td>
            </tr>

            <tr>
                <td>Zapremina motora:</td>
                <td><%=oglas.getKubikaza()%> cm<sup>3</sup></td>
            </tr>

            <tr>
                <td>Snaga motora:</td>
                <td><%=oglas.getKw()%> kw | <%=oglas.getKs()%> ks</td>
            </tr>

            <tr>
                <td>Tip pogona:</td>
                <td><%=auto.getPogon()%></td>
            </tr>
        </table>

        <div class="more-info">
            <a id="text" onclick="moreInfo()">Pogledaj jos informacija o vozilu</a>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="info">
        <h3>Opis oglasa:</h3>
        <p class="opis-oglasa"><%=oglas.getOpis()%></p>
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

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.slider img');
    const thumbnails = document.querySelectorAll('.thumbnails img');

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.style.display = i === index ? 'block' : 'none';
        });
        thumbnails.forEach((thumb, i) => {
            thumb.classList.toggle('active', i === index);
        });
        currentSlide = index;
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length;
        showSlide(currentSlide);
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        showSlide(currentSlide);
    }

    showSlide(currentSlide);

    function moreInfo() {
        const tabela = document.getElementById("tabela");
        const text = document.getElementById("text");

        const redovi = [
            {label: 'Boja vozila:', value: '<%=oglas.getBoja()%>'},
            {label: 'Broj vrata:', value: '4/5'},
            {label: 'Broj sedista:', value: '5'},
            <%
                if(oglas.getRegistrovanDo() != null){
                    Date registrovanDo = oglas.getRegistrovanDo();
                    SimpleDateFormat sdf = new SimpleDateFormat("MM/yyyy");
                    String formatiranString = sdf.format(registrovanDo);
            %>
            {label: 'Registrovan do:', value: '<%=formatiranString%>'}
            <%
                }
            %>
        ];

        const dodatniRedovi = document.querySelectorAll(".dodat-red");
        text.innerText = "Pogledaj jos informacija o vozilu";
        if (dodatniRedovi.length > 0) {
            dodatniRedovi.forEach(row => row.remove());

        }
        else{
            text.innerText = "Sakri dodatne informacije o vozilu";
            redovi.forEach(red => {
                const tr = document.createElement('tr');
                tr.classList.add('dodat-red');
                const tdLabel = document.createElement('td');
                const tdValue = document.createElement('td');
                tdLabel.textContent = red.label;
                tdValue.textContent = red.value;
                tr.appendChild(tdLabel);
                tr.appendChild(tdValue);
                tabela.appendChild(tr);
            });
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

</body>
</html>
