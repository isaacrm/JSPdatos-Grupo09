<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,net.ucanaccess.jdbc.*" %>
<html>
   <head>
	   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Actualizar, eliminar y crear registros</title>
      <style type="text/css">
h1{
  padding-top: 10px;
  text-align: center;
  color:black;
}

#formulario{
border: black 1px solid;
display:inline-block;
padding:1%;
border-radius: 5px;
padding-bottom: 0%;
background-color: #4F71E1;
}

body{
  background-color: #BCBECF;
  color:white;
}

#campo{
padding-left: 1%;
padding-bottom: 1%;
}

#radio{
  margin-left: 2%;
}

.up{
  background:#4F71E1;
  color:white;
  bottom:1%;
  display:flex;
  height:50px;
  position:fixed;
  right:1%;
  width:50px;
  border-radius: 100%;
  align-items:center;
  border: black 0.5px solid;
}

.up:hover{
  background:#808082;
}

#save{
  display:inline-block;
  position: relative;
  left:13.5%;
}

#btnBuscar{
  padding-top: 1%;
  padding-bottom: 0px;
  display:inline-block;
  position:relative;
  left:205%;
  top:6px;
}

#limpiar{
padding: 0px;
}

#busqueda,#btnBuscar,#save,#registro,#actualizate,#eliminate{
  background-color: #C4BED4;
}

#actualizate,#eliminate{
  border:black 0.5px solid;
  height: 100%;
  background-color: #C4BED4;
  width:100%;
  padding-left:10px;
  padding-right:10px;
  padding-left:6px;
  padding-right:6px;
  border-radius: 5px;
  position: relative;
  display: block;
}

input,select{
  border-radius: 3px;
  border: black 0.5px solid;
}

#busqueda:hover,#btnBuscar:enabled:hover,#save:hover{
  background-color: #A6ACD3;
}

#actualizate:hover{
  background-color: #A8D3A6;
  color:black;
  cursor:pointer;
}

#eliminate:hover{
  background-color: #D3A6A6;
  color:black;
  cursor:pointer;
}

#tabla{
  background-color: #9DA9F4;
  text-align: center;
  display: inline-block;
  position: relative;
  display: inline-flex;
  color:black;
  margin-left: 11.5%;
}

#tabla td{
padding:1%;
border:black 0.5 solid;
}

a{color:black;}

a:hover{
  text-decoration:none;
  color:blue;}

#lista{
  position:relative;
  display:block;
  top:1%;
  color:black;}

h2{
  color:black;
  text-align: center;}

#descargas{
  position:relative;
  left:35%;}

#csv,#json,#xml,#txt{
  position:relative;
  display: inline-block;
  border:black 0.5px solid;
  font-size: 20px;
  width: 100%;
  background-color: #AB9DD3;
  border-radius: 5px;
  margin-top: 1%;
  color:black;
  padding:10px;
  text-align: center;}

h1:hover{color:blue;}

#csv:hover,#json:hover,#xml:hover,#txt:hover{background-color: #E7CDEC;}
        </style>

   </head>
   <body>
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
      <form action="matto.jsp" method="get" name="Actualizar">
         <table>
            <tr>
               <!--Cambiando disabled por readOnly. Para poder usarlo en metodo get-->
                <%
                String controlador=request.getParameter("control");
                  String disa=request.getParameter("disa");
                if(disa==null){disa="";}
                else{
                  disa="readOnly";
                }
                %>
               <td>ISBN:</td><td id="campo"><input type="text" name="isbn" value="<%=lsisbn%>" size="50" placeholder="&nbsp;0000000000" <%=disa%>/></td>
            </tr>
            <tr>
               <td id="title">Título:</td><td id="campo"><input type="text" name="titulo" value="<%=lstitulo%>" size="50" placeholder="&nbsp;Ingrese un libro..."/></td>
            </tr>
            <!--INICIO DE AGREGADO POR EJERCICIO 5 (Campo Autor)-->
            <tr>
               <td>Autor:</td><td id="campo"><input type="text" name="autor" value="<%=lsautor%>" size="50" placeholder="&nbsp;Ingrese un autor..."/></td>
            </tr>
            <!--FIN DE AGREGADO POR EJERCICIO 5-->
            <!-- listbox de editorial ejerciocio 7 */ -->
            <!------------------------------ comienzo de corrrecion ------------------->
            <tr>
               <td>Editorial:</td><td id="campo">
                  <select name="listaEditorial" >
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
                  <input type="date" name="Anio" value="<%=lsfecha%>">
               </td>
            <tr>
            <!------------------------------ fin de corrrecion               ------------------->
            <tr>
               <td> Acción</td><td>
                  <%
                     String valor1 = "", valor2 = "";
                     if(!lsisbn.equals(""))
                        valor1 = "checked";
                     else
                        valor2 = "checked";
                  %>
                  <input style="margin-left: 1%;" type="radio" name="Action" value="Actualizar" <%=valor1%> /> Actualizar
                  <input id="radio" type="radio" name="Action" value="Eliminar" /> Eliminar
                  <input id="radio" type="radio" name="Action" value="Crear" <%=valor2%> /> Crear
                  <input id="save" type="SUBMIT" name="boton_A" value="GUARDAR"/>
               </td>
               <!--BOTON CON NOMBRE CAMBIADO-->
            </tr>
         </table>
      </form>
      <!--INICIO DE AGREGADO POR EJERCICIO 3 (busqueda)-->
      <form style="text-align:left;" name="formbusca" action="matto.jsp" method="GET">
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
                  <input type="text" name="titulo_B" id="txtTitulo" placeholder="&nbsp;Ingrese un título..." size="55"/>
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
                  <center><input type="SUBMIT" name="boton_B" id="btnBuscar" value="BUSCAR" disabled/></center>
               </td>
            </tr>
         </table>
         <!--FIN DE AGREGADO EJERCICIO 6-->
      </form>
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
      <form id="limpiar" name="formlimpiar" action="libros.jsp" method="get">
         <input id="busqueda" type="submit" name="limpiar" value="LIMPIAR BÚSQUEDA">
      </form></div></center>
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
                  out.println("</td><td><center><table id=\"tabla\" border=\"1\"><tr style='background-color:#767A93;'><td>#</td><td>ISBN</td><td id=\"title\"><a href='?order="+orden+"'>Título</a></td><td>Editorial</td><td>Fecha de publicación</td><td>Autor</td><td>Acción</td></tr>");
                  //FIN DE AGREGADO POR EJERCICIO 5
                  int i=1;
                  String isbnAux = "", tituloAux = "", editorialAux = "", fechaAux = "", autorAux = "";
                  while (rs.next())
                  {
                     isbnAux = "";
                     out.println("<tr>");
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
                     <form name='form<%=i%>' method='get' action='libros.jsp'><!-- este formulario se mete para obtener los atributos para la actualizacion -->
                        <a id="actualizate" href="libros.jsp?posisbn=<%=isbnAux%>&postitulo=<%=tituloAux%>&poseditorial=<%=editorialAux%>&posfecha=<%=fechaAux%>&posautor=<%=autorAux%>&disa=1" style="width:100%;background-color:#style="width:10%;"">Actualizar</a>
                     </form>
                     <%
                     out.println("<a id='eliminate' style='width:100%;' onclick=myFunction('"+isbnAux+"')>Eliminar</a></td>");
                     out.println("</tr>");
                     i++;
                  }
                  out.println("</table></center>");
                  //INICIO AGREGADO POR EJERCICIO 3
               }else{
                  if(busqueda_C!=null){
                     rs=st.executeQuery(busqueda_C);
                     // Ponemos los resultados en un table de html
                     if(rs.next()){
                        rs=st.executeQuery(busqueda_C);//########### Aca se vuelve a ejecutar la busqueda porque el if de arriba ya lo hizo una vez, entonces mostrará desde el segundo que encontro#########################
                        out.println("</td><td style='padding-left:45%;'><br></br><h3><b style='color:black;'>El resulado de la búsqueda es:</b></h3><br></br><center><table id=\"tabla\" border=\"1\"><tr style='background-color:#767A93;'><td>#</td><td>ISBN</td><td><a href='?order="+orden+"'>Título</a></td><td>Editorial</td><td>Fecha de publicación</td><td>Autor</td></tr>");
                        int i=1;
                        while (rs.next())
                           {
                           out.println("<tr>");
                           out.println("<td>"+ i +"</td>");
                           out.println("<td>"+rs.getString("isbn")+"</td>");
                           out.println("<td>"+rs.getString("titulo")+"</td>");
                           out.println("<td>"+rs.getString("Editorial")+"</td>");
                           out.println("<td>"+rs.getString("Anio")+"</td>");
                           /*INICIO DE AGREGADO POR EJERCICIO 5*/
                           out.println("<td>"+rs.getString("autor")+"</td>");
                           /*FIN DE AGREGADO POR EJERCICIO 5*/
                           out.println("</tr>");
                           i++;
                        }
                     out.println("</table></center>");
                     }else{
                        out.println("</td><td><br><br><h3><b style='color:red;padding-left:21%;'>No&nbsp;se&nbsp;ha&nbsp;encontrado&nbsp;ningún&nbsp;libro&nbsp;con&nbsp;esas&nbsp;características.</b></h3>");
                     }
                  }
               }
               //FIN AGREGADO POR EJERCICIO 3
               // cierre de la conexion
               conexion.close();
         }
      %></td></tr></table></div>
<a href="#"><div class="up">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>↑</b></div></a><br>
   </body>
</html>
