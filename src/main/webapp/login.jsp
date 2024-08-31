<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login page</title>
    <link rel="stylesheet" href="style/login.css">
    <link rel="icon" type="image/png" href="images/siteImages/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="login">
        <div class="login-wrapper">
            <span class="title-login">Login</span>
            <form action="loginHandler.jsp" method="POST">
                <div class="input-container">
                    <input placeholder="Email adresa:" class="input-field" type="text" id="input-field" name="email" required>
                    <label for="input-field" class="input-label">Email adresa:</label>
                    <span class="input-highlight"></span>
                </div>

                <div class="input-container">
                    <input placeholder="Sifra korisnika:" class="input-field" type="password" id="input-field2" name="password" required>
                    <label for="input-field2" class="input-label">Sifra korisnika:</label>
                    <span class="input-highlight"></span>
                </div>

                <button type="submit" class="login-btn">Login</button>

                <%
                    if(session.getAttribute("loginError") != null){
                %>

                <p style="color: red"><%=session.getAttribute("loginError")%></p>

                <%
                }
                else if(session.getAttribute("regSuccess") != null){
                %>
                <p style="color: green"><%=session.getAttribute("regSuccess")%></p>
                <%
                    }
                %>
            </form>
            <br>
            <span>Potreban Vam je nalog? <a href="register.jsp">Registruj se</a></span>
            <br>
            <div class="row">
                <span>Pomoc <a href="#" onClick="openModal(event)"> <i class="fa-solid fa-question"></i></a></span>
                <a class="homePage" href="index.jsp"><i class="fa-solid fa-house"></i></a>
            </div>
            <div id="helpModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">&times;</span>
                    <h2>Objašnjenje stranice:</h2>
                    <ul>
                        <li style="margin-bottom: 10px;">
                            Na stranici prijave korisnik moze pomocu email i sifre da se prijavi na aplikaciju
                        </li>

                        <li>
                            Ukoliko korisnik nema nalog, moguce je da kreira klikom na dugme registruj se.
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