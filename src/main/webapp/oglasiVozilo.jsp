<%@ page import="java.util.List" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Models.Ostecenja" %>
<%@ page import="Service.*" %>
<%@ page import="Models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Oglasi vozilo</title>
    <link rel="stylesheet" href="./style/oglasiVozilo.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%
    if(session.getAttribute("user") == null){
        response.sendRedirect("index.jsp");
        return;
    }

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
                                Na stranici "Oglasi vozilo" korisnik moze da popuni podatke o svom vozilu i tako ga postavi kao jedan od oglasa na web aplikaciji.
                                Postoji i mogucnost da korisnik zatrazi informacije o prosecnoj ceni vozila koje kaci (ako ona postoji) kako bi lakse formirao svoju cenu.
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

<%
    AutomobilService automobilService = new AutomobilService();
    OglasService oglasService = new OglasService();
    SlikeService slikeService = new SlikeService();

    List<String> marke = automobilService.getBrands();
%>

<div class="content">
    <form id="forma-oglas" action="oglasiVozilo" method="post" enctype="multipart/form-data">
        <select name="marka" id="markaSelect" required>
            <option value="">Odaberi marku</option>
            <%
                for(String marka : marke){
            %>
            <option value="<%=marka%>"><%=marka%></option>
            <%
                }
            %>
        </select>

        <select name="model" id="modelSelect" required>
            <option value="">Odaberi model</option>
        </select>

        <select name="gorivo" id="fuelTypeSelected" required>
            <option value="">Odaberi vrstu goriva</option>
        </select>

        <select name="pogon" id="wheelDriveSelected" required>
            <option value="">Odaberi pogon</option>
        </select>

        <select name="karoserija" id="karoserijaSelected" required>
            <option value="">Odaberi karoseriju</option>
        </select>

        <select name="menjac" id="gearBoxSelected" required>
            <option value="">Odaberi menjac</option>
        </select>

        <select name="zemlja" id="countrySelected" required>
            <option value="">Odaberi zemlju</option>
        </select>


    <%--  Dodatne informacije o vozilu  --%>
        <span>Godiste vozila: </span>
        <input type="text" name="godiste" id="" placeholder="2024" required>

        <select name="ostecenja" id="ostecenjaSelect" required>
            <option value="">Odaberi oštećenje</option>
            <%
                for (Ostecenja ostecenje : Ostecenja.values()) {
                    if (ostecenje == Ostecenja.OSTECEN) {
            %>
            <option value="OSTECEN">Oštećen</option>
            <%
            } else if (ostecenje == Ostecenja.DELIMICNO_OSTECEN) {
            %>
            <option value="DELIMICNO_OSTECEN">Delimično oštećen</option>
            <%
            } else if (ostecenje == Ostecenja.NIJE_OSTECEN) {
            %>
            <option value="NIJE_OSTECEN">Nije oštećen</option>
            <%
                    }
                }
            %>
        </select>

        <span>Kilometraza vozila: </span>
        <input type="text" name="kilometraza" placeholder="150000" required>

        <span>Kubikaza vozila: </span>
        <input type="text" name="kubikaza" placeholder="1998" required>

        <span>Kilovati vozila: </span>
        <input type="text" name="kw" placeholder="88" required>

        <span>Boja vozila: </span>
        <input type="text" placeholder="Crna" name="boja">

        <span>Cena vozila: </span>
        <input type="text" placeholder="15500" name="cena">

        <button onclick="prosecnaCena()" class="prosecnaCena">Prikazi prosecnu cenu za vozilo</button>
        <p id="prosecnaCena" class="prosecnaCenaText"></p>

        <span>Datum do kada je vozilo registrovano: </span>
        <input type="date" name="datum_registracije" id="datum_registracije">

        <div class="checkbox-wrapper-13">
            <input id="c1-13" type="checkbox" name="istaknut" value="true">
            <label for="c1-13">Istakni oglas</label>
        </div>

        <div class="checkbox-wrapper-13">
            <input id="c1-14" type="checkbox" name="zamena" value="true">
            <label for="c1-14">Zamena</label>
        </div>


        <span>Dodaj opis svog vozila:</span>
        <textarea name="opis" cols="30" rows="5" placeholder="Dodaj opis za vozilo" required></textarea>

        <label for="images" class="drop-container" id="dropcontainer">
            <span class="drop-title">Dodaj slike vozila:</span>
            ili
            <input type="file" name="slikeVozila" id="images" accept="image/*" multiple>
        </label>

        <input type="hidden" name="userBean" value="<%=u%>">

        <input type="submit" value="Oglasi vozilo" style="cursor: pointer">
    </form>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("markaSelect").addEventListener("change", function() {
            let selectedMarka = this.value;
            if (selectedMarka) {
                fetch('getDetailsByMarka?marka=' + selectedMarka)
                    .then(response => response.json())
                    .then(data => {
                        let modelSelect = document.getElementById("modelSelect");
                        let fuelTypeSelected = document.getElementById("fuelTypeSelected");
                        let wheelDriveSelected = document.getElementById("wheelDriveSelected");
                        let karoserijaSelected = document.getElementById("karoserijaSelected");
                        let gearBoxSelected = document.getElementById("gearBoxSelected");
                        let countrySelected = document.getElementById("countrySelected");

                        modelSelect.innerHTML = '<option value="">Odaberi model</option>';
                        fuelTypeSelected.innerHTML = '<option value="">Odaberi vrstu goriva</option>';
                        wheelDriveSelected.innerHTML = '<option value="">Odaberi pogon</option>';
                        karoserijaSelected.innerHTML = '<option value="">Odaberi karoseriju</option>';
                        gearBoxSelected.innerHTML = '<option value="">Odaberi menjac</option>';
                        countrySelected.innerHTML = '<option value="">Odaberi zemlju</option>';

                        let uniqueModels = new Set();
                        let uniqueFuelTypes = new Set();
                        let uniqueWheelDrives = new Set();
                        let uniqueKaroserija = new Set();
                        let uniqueGearBoxes = new Set();
                        let uniqueCountries = new Set();

                        data.forEach(function(car) {
                            uniqueModels.add(car.model);
                            uniqueFuelTypes.add(car.gorivo);
                            uniqueWheelDrives.add(car.pogon);
                            uniqueKaroserija.add(car.karoserija);
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

                        uniqueKaroserija.forEach(function(karoserija) {
                            let option = document.createElement("option");
                            option.value = karoserija;
                            option.textContent = karoserija;
                            karoserijaSelected.appendChild(option);
                        });

                        uniqueGearBoxes.forEach(function(gear) {
                            let option = document.createElement("option");
                            option.value = gear;
                            option.textContent = gear;
                            gearBoxSelected.appendChild(option);
                        });

                        uniqueCountries.forEach(function(country) {
                            let option = document.createElement("option");
                            option.value = country;
                            option.textContent = country;
                            countrySelected.appendChild(option);
                        });
                    })
                    .catch(error => console.error('Error:', error));
            } else {
                document.getElementById("modelSelect").innerHTML = '<option value="">Odaberi model</option>';
                document.getElementById("fuelTypeSelected").innerHTML = '<option value="">Odaberi vrstu goriva</option>';
                document.getElementById("wheelDriveSelected").innerHTML = '<option value="">Odaberi pogon</option>';
                document.getElementById("karoserijaSelected").innerHTML = '<option value="">Odaberi karoseriju</option>';
                document.getElementById("gearBoxSelected").innerHTML = '<option value="">Odaberi menjac</option>';
                document.getElementById("countrySelected").innerHTML = '<option value="">Odaberi zemlju</option>';
            }
        });
    });

    function prosecnaCena() {
        let marka = document.getElementById("markaSelect").value;
        let model = document.getElementById("modelSelect").value;

        if (marka && model) {
            fetch('http://localhost:8080/auto_oglasi_war_exploded/GetCarsAvgPriceServlet?brand=' + marka + '&model=' + model)
                .then(response => response.text())
                .then(data => {
                    document.getElementById("prosecnaCena").textContent = "Prosečna cena za " + marka + " " + model + " je: " + data + " EUR";
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById("prosecnaCena").textContent = "Greška prilikom dobijanja prosečne cene.";
                });
        } else {
            document.getElementById("prosecnaCena").textContent = "Molimo odaberite marku i model.";
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

    let today = new Date().toISOString().split('T')[0];
    document.getElementById("datum_registracije").setAttribute('min', today);
</script>

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