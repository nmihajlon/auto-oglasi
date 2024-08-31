<%@ page import="Service.OglasService" %>
<%@ page import="Models.Oglas" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="pretraga" class="Beans.PretragaBean" scope="request"/>
<jsp:setProperty name="pretraga" property="*"/>

<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        int pageNumber = 0;
        int pageSize = 10;

        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }
        if (request.getParameter("pageSize") != null) {
            pageSize = Integer.parseInt(request.getParameter("pageSize"));
        }
        if (request.getParameter("marka") == null && session.getAttribute("pretraga") != null) {
            pretraga = (Beans.PretragaBean) session.getAttribute("pretraga");
        }
        else {
            session.setAttribute("pretraga", pretraga);
        }

        OglasService oglasService = new OglasService();
        List<Oglas> listaNadjenih = oglasService.searchAds(
                pretraga.getMarka(),
                pretraga.getModel(),
                pretraga.getGorivo(),
                pretraga.getPogon(),
                pretraga.getMenjac(),
                pretraga.getZemlja(),
                pretraga.getKaroserija(),
                pretraga.getKwOd(),
                pretraga.getKwDo(),
                pretraga.getKsOd(),
                pretraga.getKsDo(),
                pretraga.getKilometrazaOd(),
                pretraga.getKilometrazaDo(),
                pretraga.getGodisteOd(),
                pretraga.getGodisteDo(),
                pretraga.getCenaMin(),
                pretraga.getCenaMax(),
                pretraga.getBojaVozila(),
                pretraga.getVrstaGoriva(),
                pageNumber,
                pageSize);
        int totalResults = oglasService.countAds(
                pretraga.getMarka(),
                pretraga.getModel(),
                pretraga.getGorivo(),
                pretraga.getPogon(),
                pretraga.getMenjac(),
                pretraga.getZemlja(),
                pretraga.getKaroserija(),
                pretraga.getKwOd(),
                pretraga.getKwDo(),
                pretraga.getKsOd(),
                pretraga.getKsDo(),
                pretraga.getKilometrazaOd(),
                pretraga.getKilometrazaDo(),
                pretraga.getGodisteOd(),
                pretraga.getGodisteDo(),
                pretraga.getCenaMin(),
                pretraga.getCenaMax(),
                pretraga.getBojaVozila(),
                pretraga.getVrstaGoriva()
        );

        session.setAttribute("brojNadjenih", totalResults);
        session.setAttribute("rezultatPretrage", listaNadjenih);
        session.setAttribute("currentPageNumber", pageNumber);
        session.setAttribute("pageSize", pageSize);
        response.sendRedirect("pretraga.jsp");
    %>
</body>
</html>
