<%@ page import="java.util.List" %>
<%@ page import="Models.Oglas" %>
<%@ page import="Models.Automobil" %>
<%@ page import="Models.User" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Service.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Auto oglasi</title>
  <link rel="stylesheet" href="style/index.css">
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

<%
  AutomobilService automobilService = new AutomobilService();
  OglasService oglasService = new OglasService();
  SlikeService slikeService = new SlikeService();

  List<String> marke = automobilService.getBrands();
  List<Oglas> listaOglasa = oglasService.getAds();

  List<String> zemlje = automobilService.getCountries();
  List<String> karoserije = automobilService.getKaroserije();
  List<String> goriva = automobilService.getTypesOfFuel();
  List<Double> ks_snjage = oglasService.getAllKs();
  List<Integer> kws = oglasService.getAllKw();

%>

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
    <option value="">Odaberi zemlju autombila</option>
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

  <button type="button" id="detaljnijaPretragaBtn"><i class="fa-solid fa-filter"></i></button>

  <input type="submit" value="Pretrazi">
</form>

<%
  int pageSize = 20;
  int pageNumber = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
  List<Oglas> listaOglasa1 = oglasService.getAdsPagination(pageNumber, pageSize);

  int totalAds = oglasService.getTotalNumberOfAds();
  int totalPages = (int) Math.ceil((double) totalAds / pageSize);
%>

<div class="cars-wrapper">
  <%
    for(Oglas oglas : listaOglasa1){
      if(oglas.getIstaknutOglas()){
      String putanjaSlike = "";

      try {
        putanjaSlike = slikeService.getImageForAd(oglas.getId());
      } catch (Exception e) {
        putanjaSlike = "";
      }

      Automobil auto = oglas.getAutomobil();
  %>
  <div class="card" onclick="redirekcija(<%=oglas.getId()%>)">
    <div class="image">
      <img src="<%=putanjaSlike%>" alt="slika_automobila">
    </div>
    <div class="info">
      <div class="naziv-vozila">Naziv: <%=auto.getMarka()%> <%=auto.getModel()%></div>
      <div class="secound-row">
        <span>Cena: <%=oglas.getCena()%> &euro;</span><span>Godiste: <%=oglas.getGodiste()%></span>
      </div>
    </div>
  </div>
  <%
      }
    }
  %>
</div>

<div class="pagination">
  <%
    if(pageNumber > 1) {
  %>
  <a class="arrow left" href="index.jsp?page=<%= pageNumber - 1 %>">&#9664;</a>
  <%
    }

    for(int i = 1; i <= totalPages; i++) {
      if(i == pageNumber) {
  %>
<%--  <a class="active" href="index.jsp?page=<%= i %>"><%= i %></a>--%>
  <%
  } else {
  %>
<%--  <a href="index.jsp?page=<%= i %>"><%= i %></a>--%>
  <%
      }
    }

    if(pageNumber < totalPages) {
  %>
  <a class="arrow right" href="index.jsp?page=<%= pageNumber + 1 %>">&#9654;</a>
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

<script>
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
                  //let countrySelected = document.getElementById("countrySelected");

                  modelSelect.innerHTML = '<option value="">Odaberi model</option>';
                  fuelTypeSelected.innerHTML = '<option value="">Odaberi vrstu goriva</option>';
                  wheelDriveSelected.innerHTML = '<option value="">Odaberi pogon</option>';
                  gearBoxSelected.innerHTML = '<option value="">Odaberi menjac</option>';
                  //countrySelected.innerHTML = '<option value="">Odaberi zemlju</option>';

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
        //document.getElementById("countrySelected").innerHTML = '<option value="">Odaberi zemlju automobila</option>';
      }
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

  });

  function redirekcija(idOglasa){
    window.location.href = "auto-oglas.jsp?id=" + idOglasa;
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