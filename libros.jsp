<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
   <head>
	   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Actualizar, eliminar y crear registros</title>
      <link rel="stylesheet" href="style.css" type="text/css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   </head>
   <body>
      <script type="text/javascript" src="metodos.js">
      </script>

      <!--Realizacion de parte II, parcial 2, TPI115, por Grupo 09-->
      <br><a id="home" href=libros.jsp><H1>MANTENIMIENTO DE LIBROS</H1></a><br><center>
      <div id="formulario">
      <!--Inicio Formulario principal, donde ocurre el CRUD-->
      <form name="Actualizar">
         <table>
            <tr>
                <%
                  String controlador=request.getParameter("control");
                  String eliminapara=request.getParameter("ELim");
                     String disa=request.getParameter("disa");
                  if(disa==null){disa="";}
                  else{
                     disa="readOnly";
                  }
                %>
               <td>ISBN:</td><td id="campo"><input id="isbn" type="text" name="isbn" size="50" placeholder="&nbsp;0000000000" <%=disa%>/></td>
            </tr>
            <tr>
               <td id="title">Título:</td><td id="campo"><input id="titulo" type="text" name="titulo" size="50" placeholder="&nbsp;Ingrese un libro..."/></td>
            </tr>
            <tr>
               <td>Autor:</td><td id="campo"><input type="text" id="autor" name="autor" size="50" placeholder="&nbsp;Ingrese un autor..."/></td>
            </tr>
            <tr>
               <td>Editorial:</td><td id="campo">
                  <select name="listaEditorial" id="editorial">
                     <option value= "">Elija su editorial...</option>
                     <optgroup>
                        <%
                           ServletContext contex = request.getServletContext();
                           String path = contex.getRealPath("/data");
                           Connection conexio = getConnection(path);
                           if (!conexio.isClosed()){
                              out.write("OK");
                              Statement st = conexio.createStatement();
                              ResultSet rs = st.executeQuery("select * from Editorial");
                              // Ponemos los resultados en un table de html
                              int i=1;
                              String comparadorEditorial = "";
                              while (rs.next()) {
                                 comparadorEditorial = rs.getString("Editorial");
                                 out.println("<option>"+comparadorEditorial+"</option>");
                                 i++;
                              }
                              conexio.close();
                           }
                        %>
                     </optgroup>
                  </select>
               </td>
            </tr>
            <tr>
               <td>
                  <label>Fecha de publicación: </label></td><td id="campo">
                  <input type="date" id="fecha" name="Anio">
               </td>
            <tr>
            <tr>
               <td> Acción</td><td>
                  <%
                     String lsisbn = request.getParameter("posisbn");
                     String lstitulo = request.getParameter("postitulo");
                     if(lsisbn==null)
                        lsisbn="";
                     if(lstitulo==null)
                        lstitulo="";

                     String valor1 = "", valor2 = "",valor3="";
                     if(!lsisbn.equals("")&!lstitulo.equals(""))
                        valor1 = "checked";
                     else 
                        valor2 = "checked";
                  %>
                  <input style="margin-left: 1%;" type="radio" id="actualizar" name="Action" value="Actualizar" <%=valor1%> /> Actualizar
                  <input id="eliminar" type="radio" name="Action" value="Eliminar"/> Eliminar
                  <input id="crear" type="radio" name="Action" value="Crear" <%=valor2%>/> Crear
                  <input id="save" type="button" name="boton_A" onclick=guardar() value="GUARDAR"/>
               </td>
            </tr>
         </table>
      </form>
      <!--Fin Formulario principal, donde ocurre el CRUD-->
      <!--Inicio de entradas para realizar busqueda por titulo, autor, o ambos-->
         <table>
            <tr>
               <td colspan="2" style="padding-bottom:1%; color:white;">
                  NOTA: Puede realizar la búsqueda por título, por autor, o ambos a la vez.
               </td>
            </tr>
            <tr>
               <td>
                  Título a buscar:</td><td id="campo">
                  <input type="text" name="titulo_B" id="txtTitulo" placeholder="&nbsp;Ingrese un título..." size="55" />
               </td>
            </tr>
            <tr>
               <td>
                  Autor a buscar:</td><td id="campo">
                  <input type="text" name="autor_B" id="txtAutor" placeholder="&nbsp;Ingrese un autor..." size="55"/>
               </td>
            </tr>
            <tr>
               <td>
                  <center><input type="button"  id="btnBuscar" value="BUSCAR" onclick="busqueda()" disabled/><input id="limpiarBusqueda" type="submit" name="limpiar" value="LIMPIAR BÚSQUEDA" onclick="limpiarBusqueda()"></center>
               </td>
            </tr>
         </table>
      <!--Fin de entradas para realizar busqueda por titulo, autor, o ambos-->
      <!--Inicio Script para habilitar el boton cuando se llene alguno de los campos de busqueda-->
      <script type="text/javascript">      
      function habilitar(){
          txtTitulo=document.getElementById("txtTitulo").value;
          txtAutor=document.getElementById("txtAutor").value;
          val=0;
          if(txtTitulo=="" && txtAutor==""){
              val++;
          }
          if(val==0){
              document.getElementById("btnBuscar").disabled=false;
          }
          else{
              document.getElementById("btnBuscar").disabled=true;
          }
      }
      document.getElementById("txtTitulo").addEventListener("keyup", habilitar);
      document.getElementById("txtAutor").addEventListener("keyup", habilitar);
      document.getElementById("btnBuscar").addEventListener("click", () => {});
      </script>
      <!--Fin Script para habilitar el boton cuando se llene alguno de los campos de busqueda-->
      </div></center>
      <!--Inicio de Listado de Libros en Archivos externos-->
      <br><h2>Listado de libros</h2>
      <div id="lista"><table><tr valign="top"><td>
      <div id="descargas">
      <a id="csv" href=listado-csv.jsp download=”libros.csv”>Descargar&nbsp;CSV</a><br><br>
      <a id="txt" href="listado-txt.jsp" download="listado.txt">Descargar&nbsp;TXT</a><br><br>
      <a id="xml" href="listado-xml.jsp" download="listado.xml">Descargar&nbsp;XML</a><br><br>
      <a id="json" href="lista-json.jsp" download="listado.json">Descargar&nbsp;JSON</a>
      </div>
      <!--Fin de Listado de Libros en Archivos externos-->
      <!--Inicio de Listado de Libros en Tabla-->
      <%!
         public Connection getConnection(String path) throws SQLException {
         String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
         String filePath= path+"\\datos.mdb";
         String userName="",password="";
         String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;
            Connection conn = null;
         try{
            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            conn = DriverManager.getConnection(fullConnectionString,userName,password);
         }
         catch (Exception e) {
            System.out.println("Error: " + e);
         }
            return conn;
         }
      %>
      <%
         ServletContext context = request.getServletContext();
         String path2 = context.getRealPath("/data");
         Connection conexion = getConnection(path2);
         if (!conexion.isClosed()){
	            String orden = request.getParameter("order");
               String busqueda_C = request.getParameter("sql_sen");
               Statement st = conexion.createStatement();
               ResultSet rs = st.executeQuery("select * from libros" );
               if(orden==null){
                  rs = st.executeQuery("select * from libros" );
                  orden="ASC";
               } else if (orden.equals("ASC")||orden.equals("DESC")) {
                  rs = st.executeQuery("select * from libros ORDER BY titulo "+orden);
                  if(orden.equals("ASC"))
                     orden="DESC";
                  else
                     orden="ASC";
               }
               if(controlador==null){
                  out.println("</td><td><center><table id=\"tabla\" border=\"1\"><thead style='background-color:#767A93;'><td>#</td><td>ISBN</td><td id=\"title\"><a href='?order="+orden+"'>Título</a></td><td>Editorial</td><td>Fecha de publicación</td><td>Autor</td><td>Acción</td></thead><tbody>");
                  int i=1;
                  String isbnAux = "", tituloAux = "", editorialAux = "", fechaAux = "", autorAux = "";
                  while (rs.next())
                  {
                     isbnAux = "";
                     out.println("<tr class=\"lineaRegistro\">");
                     out.println("<td>"+ i +"</td>");
                     isbnAux = rs.getString("isbn");
                     out.println("<td>"+isbnAux+"</td>");
                     tituloAux = rs.getString("titulo");
                     out.println("<td>"+tituloAux+"</td>");
                     editorialAux = rs.getString("Editorial");
                     out.println("<td>"+ editorialAux +"</td>");
                     fechaAux = rs.getString("Anio");
                     out.println("<td>"+ fechaAux +"</td>");
                     autorAux = rs.getString("autor");
                     out.println("<td>"+autorAux+"</td>");
                     out.println("<td>");%>
                     <form name='form<%=i%>'><!-- este formulario se mete para obtener los atributos para la actualizacion -->
                        <a id="actualizate" onclick=editar() style="width:100%;">Actualizar</a>
                     </form>
                     <%
                     out.println("<a id='eliminate' style='width:100%;' onclick=eliminarDeTabla('"+isbnAux+"')>Eliminar</a></td>");
                     out.println("</tr>");
                     i++;
                  }
                  out.println("</tbody></table></center>");
               }
               conexion.close();
         }
      %>
      </td></tr></table></div>
      <!--Fin de Listado de Libros en Tabla-->
      <a href="#"><div class="up">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>↑</b></div></a><br>
   </body>
</html>