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
      </script><!--
Este es un botón con un único propósito de debug, eliminar antes de la entrega.
Descomentar el botón para probar la función que actualiza la tabla.

<input type="submit" value="Presiona aquí para actualizar la tabla" id="obtener" onclick="obtenerLibros()"/>

-->
<%
String lsisbn = request.getParameter("posisbn");
String lstitulo = request.getParameter("postitulo");
String lseditorial = request.getParameter("poseditorial");
String lsfecha = request.getParameter("posfecha");
String lsautor = request.getParameter("posautor");

if(lsisbn==null)
   lsisbn="";
if(lstitulo==null)
   lstitulo="";
if(lsautor==null)
   lsautor="";
if(lseditorial==null)
   lseditorial="";
if(lsfecha==null)
   lsfecha="";
%>
      <br><a id="home" href=libros.jsp><H1>MANTENIMIENTO DE LIBROS</H1></a><br><center><div id="formulario">
      <form name="Actualizar">
         <table>
            <tr>
               <!--Hay que usar JSP y AJAX con un SPA-->
               <!--Cambiando disabled por readOnly. Para poder usarlo en metodo get-->
                <%
                String controlador=request.getParameter("control");
                String eliminapara=request.getParameter("ELim");
                  String disa=request.getParameter("disa");
                if(disa==null){disa="";}
                else{
                  disa="readOnly";
                }
                %>
               <td>ISBN:</td><td id="campo"><input id="isbn" type="text" name="isbn" value="<%=lsisbn%>" size="50" placeholder="&nbsp;0000000000" <%=disa%>/></td>
            </tr>
            <tr>
               <td id="title">Título:</td><td id="campo"><input id="titulo" type="text" name="titulo" value="<%=lstitulo%>" size="50" placeholder="&nbsp;Ingrese un libro..."/></td>
            </tr>
            <!--INICIO DE AGREGADO POR EJERCICIO 5 (Campo Autor)-->
            <tr>
               <td>Autor:</td><td id="campo"><input type="text" id="autor" name="autor" value="<%=lsautor%>" size="50" placeholder="&nbsp;Ingrese un autor..."/></td>
            </tr>
            <!--FIN DE AGREGADO POR EJERCICIO 5-->
            <!-- listbox de editorial ejerciocio 7 */ -->
            <!------------------------------ comienzo de corrrecion ------------------->
            <tr>
               <td>Editorial:</td><td id="campo">
                  <select name="listaEditorial" id="editorial">
                     <option value= "">Elija su editorial...</option>
                     <optgroup>
                        <%
                        /* agregado ejercicio 7 editorial ----  agregar campos --- campos a listbox */
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
                              if(!lseditorial.equals(""))
                                 if(lseditorial.equals(comparadorEditorial))
                                    out.println("<option selected=\"selected\">"+comparadorEditorial+"</option>");
                                 else
                                    out.println("<option>"+comparadorEditorial+"</option>");
                              else
                                 out.println("<option>"+comparadorEditorial+"</option>");
                              i++;
                           }
                           // cierre de la conexion
                           conexio.close();
                        }
                        %>
                     </optgroup>
                  </select>
               </td>
            </tr>
            <!------------------------------ fin  de corrrecion               ------------------->
            <!------------------------------ comienzo de corrrecion               ------------------->
            <tr>
               <td>
                  <label>Fecha de publicación: </label></td><td id="campo">
                  <input type="date" id="fecha" name="Anio" value="<%=lsfecha%>">
               </td>
            <tr>
            <!------------------------------ fin de corrrecion               ------------------->
            <tr>
               <td> Acción</td><td>
                  <%
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
               <!--BOTON CON NOMBRE CAMBIADO-->
            </tr>
         </table>
      </form>
      <!--INICIO DE AGREGADO POR EJERCICIO 3 (busqueda)-->
         <!--INICIO DE AGREGADO EJERCICIO 6-->
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
         <!--FIN DE AGREGADO EJERCICIO 6-->
      <!--FIN DE AGREGADO POR EJERCICIO 3-->
      <!--INICIO AGREGADO VALIDACION DE BOTON BUSCAR EJERCICIO 6-->
      
      <script type="text/javascript">
      //document.getElementsByClassName("delete").onclick = function() {myFunction()};
      
      function myFunction(variable) {
      		//id = document.getElementsByClassName("isbn")
      		//document.getElementById("delete").innerHTML = "YOU CLICKED ME!";
      		console.log(variable);
      		var nuevaUrl = "matto.jsp?Action=Eliminar&isbn="+variable+"&boton_A=ACEPTAR";
      		//ventana = window.open(nuevaUrl);
            ventana = location.replace(nuevaUrl);
           
      	}

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
      
      </div></center>
      <!--FIN AGREGADO VALIDACION DE BOTON BUSCAR EJERCICIO 6-->
<br><h2>Listado de libros</h2>
      <div id="lista"><table><tr valign="top"><td><div id="descargas">
      <a id="csv" href=listado-csv.jsp download=”libros.csv”>Descargar&nbsp;CSV</a><br><br>
      <a id="txt" href="listado-txt.jsp" download="listado.txt">Descargar&nbsp;TXT</a><br><br>
      <a id="xml" href="listado-xml.jsp" download="listado.xml">Descargar&nbsp;XML</a><br><br>
      <a id="json" href="lista-json.jsp" download="listado.json">Descargar&nbsp;JSON</a></div>
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
               //out.write("OK");
               //Obtiene el parametro de orden
	            String orden = request.getParameter("order");
               String busqueda_C = request.getParameter("sql_sen"); //Lo mismo que en el matto
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
               //if(controlador.equals(null)){controlador="0";}
               // Ponemos los resultados en un table de html
               //INICIO DE AGREGADO POR EJERCICIO 5
               if(controlador==null){
                  out.println("</td><td><center><table id=\"tabla\" border=\"1\"><thead style='background-color:#767A93;'><td>#</td><td>ISBN</td><td id=\"title\"><a href='?order="+orden+"'>Título</a></td><td>Editorial</td><td>Fecha de publicación</td><td>Autor</td><td>Acción</td></thead><tbody>");
                  //FIN DE AGREGADO POR EJERCICIO 5
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
                        <a id="eliminate"  href="libros.jsp?posisbn=<%=isbnAux%>&poseditorial=<%=editorialAux%>&posfecha=<%=fechaAux%>&posautor=<%=autorAux%>&disa=3" style="width:100%" >Eliminar</a>
                     </form>
                     <%
                     out.println("</td>");
                     
                     out.println("</tr>");
                     i++;
                  }
                  out.println("</tbody></table></center>");
                  //INICIO AGREGADO POR EJERCICIO 3
               }
               //FIN AGREGADO POR EJERCICIO 3
               // cierre de la conexion
               conexion.close();
         }
      %></td></tr></table></div>
<a href="#"><div class="up">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>↑</b></div></a><br>
   </body>
</html>
