<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Registracija</title>
    <link rel="stylesheet" href="style/register.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="signup">
        <div class="signup-wrapper">
            <span class="title-signup">Registruj se</span>
            <form action="registerHandler.jsp" method="post">
                <div class="input-container">
                    <input placeholder="Email adresa:" class="input-field" type="text" id="input-field" name="email" required>
                    <label for="input-field" class="input-label">Email adresa:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Korisnicko ime:" class="input-field" type="text" id="input-field2" name="username" required>
                    <label for="input-field2" class="input-label">Korisnicko ime:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Ime:" class="input-field" type="text" id="input-field3" name="firstName" required>
                    <label for="input-field3" class="input-label">Ime:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Prezime:" class="input-field" type="text" id="input-field4" name="lastName" required>
                    <label for="input-field4" class="input-label">Prezime:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Sifra:" class="input-field" type="password" id="input-field5" name="password"
                           pattern="(?=.*\d)(?=.*[A-Z]).{6,}"
                           title="Lozinka mora sadržati najmanje jedno veliko slovo, jedan broj i biti dugačka najmanje 6 karaktera."
                           required>
                    <label for="input-field5" class="input-label">Sifra:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Potvrda sifre:" class="input-field" type="password" id="input-field6" name="confirm-password" required>
                    <label for="input-field6" class="input-label">Potvrda sifre:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Broj Telefona:" class="input-field" type="number" id="input-field7" name="contact" required>
                    <label for="input-field7" class="input-label">Broj Telefona:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Zemlja:" class="input-field" type="text" id="input-field8" name="zemlja">
                    <label for="input-field8" class="input-label">Zemlja:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Grad:" class="input-field" type="text" id="input-field9" name="grad">
                    <label for="input-field9" class="input-label">Grad:</label>
                    <span class="input-highlight"></span>
                </div>

                <button type="submit" class="signup-btn button-22">Sign up</button>
                <%
                    if (session.getAttribute("regError") != null) {
                %>
                <p style="color:red;"><%= session.getAttribute("regError") %></p>
                <%
                    }
                %>
            </form>
            <br>
            <div class="row">
                <span>Vec imate nalog? <a href="login.jsp">Prijavi se</a></span>
                <a class="homePage" href="index.jsp"><i class="fa-solid fa-house"></i></a>
            </div>
            <span>Pomoc <a href="#" onClick="openModal(event)"> <i class="fa-solid fa-question"></i></a></span>
            <div id="helpModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">&times;</span>
                    <h2>Objašnjenje stranice:</h2>
                    <ul>
                        <li style="margin-bottom: 10px;">
                            Na stranici registracije korisnik moze kreirati nalog kojim ce moci da koristi web aplikaciju.
                        </li>

                        <li>
                            Ukoliko korisnik vec ima nalog, moguce je da se prijavi na log in stranici.
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="img">
        <img src="./images/siteImages/loginImage.png" alt="">
    </div>
</div>
</body>

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
</html>
