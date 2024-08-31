<%@ page import="Models.Oglas" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Automobil" %>
<%@ page import="Models.User" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Repository.OglasRepository" %>
<%@ page import="Service.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Pretraga</title>
    <link rel="stylesheet" href="./style/pretraga.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<%
    if(session.getAttribute("rezultatPretrage") != null){
        List<Oglas> rezultatiPretrage = (List<Oglas>)session.getAttribute("rezultatPretrage");
        SlikeService slikeService = new SlikeService();
        OglasService oglasService = new OglasService();
        AutomobilService automobilService = new AutomobilService();
        UserService userService = new UserService();

        List<String> marke = automobilService.getBrands();
        List<String> zemlje = automobilService.getCountries();
        Beans.PretragaBean pretraga = (Beans.PretragaBean) session.getAttribute("pretraga");

        List<String> karoserije = automobilService.getKaroserije();
        List<String> goriva = automobilService.getTypesOfFuel();
        List<Double> ks_snjage = oglasService.getAllKs();
        List<Integer> kws = oglasService.getAllKw();
%>

<%--Navigacija--%>
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
                                Na stranici "Pretraga" korisnik za primenjene filtere moze da pogleda rezultat pretrage. Takodje korisnik moze da primeni i nove filtere pretrage isto kao i na pcoetnoj stranici. Za pretrazena vozila moguce je pogledati detalje za svako nadjeno vozilo.
                            </li>
                        </ol>
                    </div>
                </div>
            </li>
        </ul>
    </nav>
    <%
        if(session.getAttribute("user") != null){
            UserBean user = (UserBean) session.getAttribute("user");
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

<%--Pretraga--%>
<form action="pretragaHandler.jsp" method="post" id="forma-pretraga">
    <select name="marka" id="markaSelect">
        <option value="">Odaberi marku</option>
        <%
            for(String marka : marke){
        %>
        <option value="<%=marka%>"><%=marka%></option>
        <%
            }
        %>
    </select>

    <select name="model" id="modelSelect" disabled>
        <option value="">Odaberi model</option>
    </select>

    <select name="gorivo" id="fuelTypeSelected" disabled>
        <option value="">Odaberi vrstu goriva</option>
    </select>

    <select name="pogon" id="wheelDriveSelected" disabled>
        <option value="">Odaberi pogon</option>
    </select>

    <select name="menjac" id="gearBoxSelected" disabled>
        <option value="">Odaberi menjac</option>
    </select>

    <select name="zemlja" id="countrySelected">
        <option value="">Odaberi zemlju</option>
        <%
            for(String zemlja : zemlje){
        %>
        <option value="<%=zemlja%>"><%=zemlja%></option>
        <%
            }
        %>
    </select>

    <select name="karoserija" id="karoserijaSelected">
        <option value="">Odaberi karoseriju autombila</option>
        <%
            for(String karoserija : karoserije){
        %>
        <option value="<%=karoserija%>"><%=karoserija%></option>
        <%
            }
        %>
    </select>

    <div id="dodatniFilteri"></div>

    <button class="filter" type="button" id="detaljnijaPretragaBtn"><i class="fa-solid fa-filter"></i></button>

    <input type="submit" value="Pretrazi">
</form>

<%--Rezultat pretrage--%>
<div class="content">
    <%
        for(Oglas o : rezultatiPretrage){
            Automobil auto = automobilService.getCarByID(o.getAutomobil().getId());
            String slika = slikeService.getImageForAd(o.getId());
            User user = userService.getUserById(o.getUser_id().getId());
    %>
    <div class="ad-container">
        <div class="ad-header">
            <%
                if(o.getIstaknutOglas()){
            %>
            <span class="ad-badge">ISTAKNUT</span>
            <%
                }else{
            %>
            <div></div>
            <%
                }
            %>
            <h3><%= auto.getMarka() + " " + auto.getModel() %></h3>
            <div class="ad-price"><%= o.getCena() %> &euro;</div>
        </div>
        <div class="ad-body">
            <div class="ad-image">
                <img src="<%= slika %>" alt="Slika automobila">
            </div>
            <div class="ad-details">
                <p>Godiste: <%= o.getGodiste() %> &bull; <%= o.getKilometraza() %> km &bull; <%=o.getKw()%> kW (<%=o.getKs()%> PS)</p>
                <p><%=auto.getKaroserija()%> &bull; <%= auto.getGorivo() %> &bull; <%= auto.getMenjac() %></p>
                <p>Boja: <%= o.getBoja() %></p>
            </div>
            <div class="dealer-info">
                <p>Lokacija: <%=user.getZemlja()%> | <%=user.getGrad()%></p>
            </div>
        </div>
        <div class="ad-footer">
            <div class="dealer-info">
                <p>Prodavac: <%=user.getFirstName()%> <%=user.getLastName()%></p>
            </div>
            <div class="ad-buttons">
                <button onclick="redirekcija(<%=o.getId()%>)">Detalji</button>
            </div>
        </div>
    </div>
    <%
        }
    %>
</div>

<div class="pagination">
    <%
        int totalResults = (int) session.getAttribute("brojNadjenih");
        int pageSize = (Integer) session.getAttribute("pageSize");
        int currentPage = (Integer) session.getAttribute("currentPageNumber");
        int totalPages = (int) Math.ceil((double) totalResults / pageSize);

        if (currentPage > 0) {
    %>
    <a href="pretragaHandler.jsp?pageNumber=<%= currentPage - 1 %>&pageSize=<%= pageSize %>">&laquo; Prethodna</a>
    <%
        }

        for (int i = 0; i < totalPages; i++) {
            if (i == currentPage) {
    %>
    <a href="pretragaHandler.jsp?pageNumber=<%= i %>&pageSize=<%= pageSize %>" class="active"><%= i + 1 %></a>
    <%
    } else {
    %>
    <a href="pretragaHandler.jsp?pageNumber=<%= i %>&pageSize=<%= pageSize %>"><%= i + 1 %></a>
    <%
            }
        }

        if (currentPage < totalPages - 1) {
    %>
    <a href="pretragaHandler.jsp?pageNumber=<%= currentPage + 1 %>&pageSize=<%= pageSize %>">Sledeca &raquo;</a>
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

    document.addEventListener("DOMContentLoaded", function(){
        document.getElementById("markaSelect").addEventListener("change", function(){
            let selectedMarka = this.value;
            if (selectedMarka) {
                fetch('getDetailsByMarka?marka=' + selectedMarka)
                    .then(response => response.json())
                    .then(data => {
                        let modelSelect = document.getElementById("modelSelect");
                        let fuelTypeSelected = document.getElementById("fuelTypeSelected");
                        let wheelDriveSelected = document.getElementById("wheelDriveSelected");
                        let gearBoxSelected = document.getElementById("gearBoxSelected");

                        modelSelect.innerHTML = '<option value="">Odaberi model</option>';
                        fuelTypeSelected.innerHTML = '<option value="">Odaberi vrstu goriva</option>';
                        wheelDriveSelected.innerHTML = '<option value="">Odaberi pogon</option>';
                        gearBoxSelected.innerHTML = '<option value="">Odaberi menjac</option>';

                        let uniqueModels = new Set();
                        let uniqueFuelTypes = new Set();
                        let uniqueWheelDrives = new Set();
                        let uniqueGearBoxes = new Set();
                        let uniqueCountries = new Set();

                        data.forEach(function(car) {
                            uniqueModels.add(car.model);
                            uniqueFuelTypes.add(car.gorivo);
                            uniqueWheelDrives.add(car.pogon);
                            uniqueGearBoxes.add(car.menjac);
                            uniqueCountries.add(car.zemlja);
                        });

                        uniqueModels.forEach(function(model) {
                            let option = document.createElement("option");
                            option.value = model;
                            option.textContent = model;
                            modelSelect.appendChild(option);
                        });

                        uniqueFuelTypes.forEach(function(fuel) {
                            let option = document.createElement("option");
                            option.value = fuel;
                            option.textContent = fuel;
                            fuelTypeSelected.appendChild(option);
                        });

                        uniqueWheelDrives.forEach(function(drive) {
                            let option = document.createElement("option");
                            option.value = drive;
                            option.textContent = drive;
                            wheelDriveSelected.appendChild(option);
                        });

                        uniqueGearBoxes.forEach(function(gear) {
                            let option = document.createElement("option");
                            option.value = gear;
                            option.textContent = gear;
                            gearBoxSelected.appendChild(option);
                        });

                        modelSelect.disabled = false;
                        fuelTypeSelected.disabled = false;
                        wheelDriveSelected.disabled = false;
                        gearBoxSelected.disabled = false;
                    })
            } else {
                document.getElementById("modelSelect").innerHTML = '<option value="">Odaberi model</option>';
                document.getElementById("fuelTypeSelected").innerHTML = '<option value="">Odaberi vrstu goriva</option>';
                document.getElementById("wheelDriveSelected").innerHTML = '<option value="">Odaberi pogon</option>';
                document.getElementById("gearBoxSelected").innerHTML = '<option value="">Odaberi menjac</option>';
            }
        });
    });

    document.getElementById("detaljnijaPretragaBtn").addEventListener("click", function(){
        let dodatniFilteri = document.getElementById("dodatniFilteri");
        let icon = this.querySelector("i");

        if (!document.getElementById("additionalFields")) {
            let additionalFields = `
          <div id="additionalFields">
            <div class="wrapper">
              <span>Odaberi snagu u KW od:</span>
              <select name="kwOd" id="kwOdSelected">
              <option value="">Odaberi snagu u KW od</option>
              <%
                for(Integer kw : kws){
              %>
              <option value="<%=kw%>"><%=kw%> cm<sup>3</sup></option>
              <%
                }
              %>
              </select>
            </div>

            <div class="wrapper">
              <span>Odaberi snagu u KW do:</span>
              <select name="kwDo" id="kwDoSelected">
              <option value="">Odaberi snagu u KW do</option>
              <%
                for(Integer kw : kws){
              %>
              <option value="<%=kw%>"><%=kw%> cm<sup>3</sup></option>
              <%
                }
              %>
              </select>
            </div>

            <div class="wrapper">
              <span>Odaberi snagu u KS od:</span>
              <select name="ksOd" id="ksOdSelected">
              <option value="">Odaberi snagu u KS od</option>
              <%
                for(Double ks : ks_snjage){
              %>
              <option value="<%=ks%>"><%=ks%> ks</option>
              <%
                }
              %>
              </select>
            </div>

            <div class="wrapper">
              <span>Odaberi snagu u KW:</span>
              <select name="ksDo" id="ksDoSelected">
              <option value="">Odaberi snagu u KS do</option>
              <%
                for(Double ks : ks_snjage){
              %>
              <option value="<%=ks%>"><%=ks%> ks</option>
              <%
                }
              %>
              </select>
            </div>

           <div class="wrapper">
              <label for="kilometraza">Kilometraža od:</label>
              <input type="number" name="kilometrazaOd" id="kilometrazaOd" class="detalji-input">
           </div>

            <div class="wrapper">
              <label for="kilometraza">Kilometraža do:</label>
              <input type="number" name="kilometrazaDo" id="kilometrazaDo" class="detalji-input">
            </div>

            <div class="wrapper">
              <label for="godiste">Godište od:</label>
              <input type="number" name="godisteOd" id="godisteOd" class="detalji-input">
            </div>

            <div class="wrapper">
              <label for="godiste">Godište do:</label>
              <input type="number" name="godisteDo" id="godisteDo" class="detalji-input">
            </div>

            <div class="wrapper">
              <label for="cenaMin">Minimalna cena:</label>
              <input type="number" name="cenaMin" id="cenaMin" class="detalji-input">
            </div>

            <div class="wrapper">
              <label for="cenaMax">Maksimalna cena:</label>
              <input type="number" name="cenaMax" id="cenaMax" class="detalji-input">
            </div>

            <div class="wrapper">
              <label for="bojaVozila">Boja vozila:</label>
              <input type="text" name="bojaVozila" id="bojaVozila" class="detalji-input">
            </div>

           <div class="wrapper">
              <span>Odaberi vrstu goriva:</span>
              <select name="vrstaGoriva" id="vrstaGorivaSelected">
              <option value="">Odaberi vrstu goriva</option>
              <%
                for(String gorivo : goriva){
              %>
              <option value="<%=gorivo%>"><%=gorivo%></option>
              <%
                }
              %>
              </select>
           </div>

          </div>
        `;
            dodatniFilteri.insertAdjacentHTML('beforeend', additionalFields);
            icon.classList.remove("fa-filter");
            icon.classList.add("fa-filter-circle-xmark");
        } else {
            document.getElementById("additionalFields").remove();
            icon.classList.remove("fa-filter-circle-xmark");
            icon.classList.add("fa-filter");
        }
    });

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

<%
    }else{
        response.sendRedirect("index.jsp");
        return;
    }
%>
</html>
