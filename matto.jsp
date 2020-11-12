<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,net.ucanaccess.jdbc.*"%>
<%@page import = "java.sql.*" %>
<%
    /* Paso 0) Obtener parametros de los botones INICIO AGREGADO EJERCICIO 3*/
    String ls_boton_A = request.getParameter("boton_A");
    String ls_boton_B = request.getParameter("boton_B");
    /*FIN AGREGADO POR EJERCICIO 3*/
    /* Paso 1) Obtener los datos del formulario */
    String ls_isbn = request.getParameter("isbn");
    String ls_titulo = request.getParameter("titulo");
    String ls_action = request.getParameter("Action");
    /*INICIO DE AGREGADO POR EJERCICIO 5*/
    String ls_autor = request.getParameter("autor");
    /*FIN DE AGREGADO POR EJERCICIO 5*/
    /*INICIO AGREGADO EJERCICIO3*/
    String ls_titulo_B = request.getParameter("titulo_B");
    String ls_autor_B = request.getParameter("autor_B"); /*AGREGADO EJERCICIO 6*/
    int condicional=0;
    /*FIN AGREGADO EJERCICIO3*/
    /* parametro para la editorial ejercicio 7 */
    String ls_Editorial = request.getParameter("listaEditorial");
    String ls_Anio = request.getParameter("Anio");

    /* Paso 2) Inicializar variables */
    String ls_result = "Base de datos actualizada...";
    String ls_query = "";
    ServletContext context = request.getServletContext();
    String path = context.getRealPath("/data");
    String filePath= path+"\\datos.mdb";
    String ls_dburl = "jdbc:odbc:Driver={MicroSoft Access Driver (*.mdb)};DBQ="+filePath;
    String ls_usuario = "";
    String ls_password = "";
    String ls_dbdriver = "sun.jdbc.odbc.JdbcOdbcDriver";

    /* Paso 3) Crear query&nbsp; */
    if (ls_boton_A != null) {
        if (ls_action.equals("Crear")) {
            ls_query = " insert into libros (isbn, titulo,Editorial,anio,autor)";
            ls_query += " values (";
            ls_query += "'" + ls_isbn + "',";
            ls_query += "'" + ls_titulo + "',";
            ls_query += "'" + ls_Editorial + "',";
            ls_query += "'" + ls_Anio +"',";
            ls_query += "'" + ls_autor + "');";
        }

        if (ls_action.equals("Eliminar")) {
            ls_query = " delete from libros where isbn = ";
            ls_query += "'" + ls_isbn + "'";
        }
        /*  ------- actualizado ya corregido  ------------+  */
        if (ls_action.equals("Actualizar")) {
            ls_query = " UPDATE libros";
            ls_query += " set titulo= " + "'" + ls_titulo + "', ";
            /*parametro de la editorial ejercicio 7  */
            ls_query += "Editorial = " + "'" + ls_Editorial + "', ";
            ls_query += "Anio= " + "'"  +ls_Anio + "', ";
            /*INICIO DE AGREGADO POR EJERCICIO 5*/
            ls_query += "autor= " + "'" + ls_autor + "'";
            /*FIN DE AGREGADO POR EJERCICIO 5*/
            ls_query += " where isbn = " + "'" + ls_isbn + "';";
        }
        /*  ------- actualizado ya corregido  ------------+  */
    }
    /*INICIO METODO DE BUSQUEDA EJERCICIO 3*/
    if(ls_boton_B != null) {
        if(ls_titulo_B != "" && ls_autor_B != "") {
            ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
            ls_query += " where titulo like " + "'%" + ls_titulo_B +"%'";
            ls_query += " or autor like " + "'%" + ls_autor_B +"%'";//############################ Acá era or ##############################################
            condicional++;
        }
        else if (ls_titulo_B != "") {
            ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
            ls_query += " where titulo like " + "'%" + ls_titulo_B +"%'";
            condicional++;
        }
        /*INICIO AGREGADO EJERCICIO 6*/
        else if (ls_autor_B != "") {
            ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
            ls_query += " where autor like " + "'%" + ls_autor_B +"%'";
            condicional++;
        }
        /*FIN AGREGADO EJERCICIO 6*/
    }
    /* Paso4) Conexi�n a la base de datos */
    Connection l_dbconn = null;
    try {
        Class.forName(ls_dbdriver);
        /*&nbsp; getConnection(URL,User,Pw) */
        l_dbconn = DriverManager.getConnection(ls_dburl,ls_usuario,ls_password);
        /*Creaci�n de SQL Statement */
        Statement l_statement = l_dbconn.createStatement();
        /* Ejecuci�n de SQL Statement */
        /*AGREGADO POR EJERCICIO 3*/
        if(condicional==1) {
            ResultSet rs = l_statement.executeQuery(ls_query);
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td><b>"+rs.getString("isbn")+"</b></td>");
                out.println("<td><b>"+rs.getString("titulo")+"</b></td>");
                out.println("<td><b>"+rs.getString("Editorial")+"</b></td>");
                out.println("<td><b>"+rs.getString("Anio")+"</b></td>");
                out.println("<td><b>"+rs.getString("autor")+"</b></td>");
                out.println("</tr><br></br>");
            }
        } else {
            l_statement.execute(ls_query);
        }
        /*MODIFICACIONES HECHAS ANTES PARA EVITAR EJECUCION DOBLE*/
    } catch (ClassNotFoundException e) {
        ls_result = " Error creando el driver!";
        ls_result += " <br/>" + e.toString();
    } catch (SQLException e) {
        ls_result = " Error procesando el SQL!";
        ls_result += " <br/>" + e.toString() + "<br><br>";
    } finally {
        /* Cerramos */
        try {
            if (l_dbconn != null) {
            l_dbconn.close();
            }
        } catch (SQLException e) {
            ls_result = "Error al cerrar la conexi�n.";
            ls_result += " <br/>" + e.toString();
        }
    }
%>
<html>
    <head><title>Estado de la base de datos</title>
    <!--
Eliminé los estilos, porque esta página ya no va a cargarse visualmente.
  -->
  </head>
    <body>
        La siguiente instrucción fue ejecutada:
        <br/><br/>
        &nbsp;&nbsp;&nbsp;&nbsp;<%=ls_query%>
        <br/><br/>
        El resultado fue:
        <br/><br/>
        &nbsp;&nbsp;&nbsp;&nbsp;<%=ls_result%>
        <br/><br/>
        <!--INICIO AGREGADO EJERCICIO 3-->
        <%
        if (ls_boton_A != null){ %>
            <a href="libros.jsp">&nbsp;&nbsp;&nbsp;&nbsp;Ir a la página principal</a>
        <%
        }
        if(ls_boton_B !=null) { %>
            <form name="resultado_B" action="libros.jsp" method="get">
                <input type="text" name="sql_sen" value="<%=ls_query%>" size="50"readonly />
                <input type="hidden" name="control" value="1"/>
                <input id="continue" type="submit" name="busqueda_com" value="CONTINUAR"/>
            </form>
            <a href="libros.jsp">&nbsp;&nbsp;&nbsp;&nbsp;Regresar a la página anterior</a>
        <%
        } %>
        <!--FIN AGREGADO EJERCICIO 3-->
    </body>
</html>
