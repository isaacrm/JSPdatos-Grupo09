
//Implementé este código (DESDE AQUÍ).
function guardar(){
   //Esta función se ejecuta al presionar el botón 'GUARDAR'.
   var isbn,titulo,autor,fecha,editorial;
   isbn = document.getElementById("isbn");
   titulo = document.getElementById("titulo");
   autor = document.getElementById("autor");
   fecha = document.getElementById("fecha");
   editorial = document.getElementById("editorial");

   if(document.getElementById("crear").checked){
      crear(isbn,titulo,autor,fecha,editorial);
   }else if (document.getElementById("eliminar").checked) {
      eliminar(isbn,titulo);
   }else{
      actualizar(isbn,titulo,autor,fecha,editorial);
   }
}
//Esta función limpia los campos del formulario después de realizar una acción.
function limpiarFormulario(){
      var isbn,titulo,autor,fecha,editorial;
      isbn = document.getElementById("isbn");
      titulo = document.getElementById("titulo");
      autor = document.getElementById("autor");
      fecha = document.getElementById("fecha");
      editorial = document.getElementById("editorial");
      isbn.value="";
      titulo.value="";
      autor.value="";
      fecha.value="";
      editorial.value="";
}
//Esta función elimina registros de la base de datos.
function eliminar(isbn,titulo){
   var confirmar;
   confirmar=confirm("Estás seguro que deseas eliminar "+titulo.value+" del registro?");
   if(confirmar){
      $.ajax({
         type: "GET",
         url: 'matto.jsp?isbn='+isbn.value+'&titulo='+titulo.value+'&autor='+autor.value+'&listaEditorial='+editorial.value+'&Anio='+fecha.value+'&Action=Eliminar&boton_A=GUARDAR',
         datatype: "json",
         success: [function (response) {
         obtenerLibros();
         limpiarFormulario();
         document.getElementById("crear").checked=true;}
         ]
      });
   }
}
//Esta función actualiza registros de la base de datos.
function actualizar(isbn,titulo,autor,fecha,editorial){
   $.ajax({
      type: "GET",
      url: 'matto.jsp?isbn='+isbn.value+'&titulo='+titulo.value+'&autor='+autor.value+'&listaEditorial='+editorial.value+'&Anio='+fecha.value+'&Action=Actualizar&boton_A=GUARDAR',
      datatype: "json",
      success: [function (response) {
         obtenerLibros();
         isbn.readOnly=false;
         document.getElementById("crear").checked=true;
         limpiarFormulario();
      }]
   });
}
//Esta función inserta registros en la base de datos.
function crear(isbn,titulo,autor,fecha,editorial){
   $.ajax({
      type: "GET",
      url: 'matto.jsp?isbn='+isbn.value+'&titulo='+titulo.value+'&autor='+autor.value+'&listaEditorial='+editorial.value+'&Anio='+fecha.value+'&Action=Crear&boton_A=GUARDAR',
      datatype: "json",
      success: [function (response) {
      obtenerLibros();
      limpiarFormulario();
      }]
   });
}
//(HASTA AQUÍ).
function obtenerLibros() {
   $.ajax({
      //tipo de request que se mandará
      type: "GET",
      //la página a la que le hará la request (en este caso está en la misma dirección)
      url: 'consulta.jsp',
      //tipo de datos que obtendrá (la página ya genera un documento de tipo json)
      //Nota: ver consulta.jsp, línea 69
      datatype: "json",
      //en el caso de recibir un codigo http 200 (OK)
      success: [
         //acción (recibe la respuesta de la request enviada)
         function (response) {
            //eliminar todos los elementos html que tienen la clase lineaRegistro
            $(".lineaRegistro").remove();
            //declaración de variable que se usará más adelante
            var rowsTabla = '';
            //para cada elemento del listado de libros (listado es un objeto json)
            //Nota: ver el objeto json generado por consulta.jsp para entenderlo mejor
            for(var i = 0; i < response.listado.length; i++) {
               var numeroAux=response.listado[i].numero;
               var tituloAux=response.listado[i].titulo;
               var isbnAux=response.listado[i].isbn;
               var editorialAux = response.listado[i].editorial;
               var fechaAux = response.listado[i].fecha;
               var autorAux = response.listado[i].autor;

               //anexar a la variable rowsTabla, una tupla con cada uno de los elementos del listado
               //el formato en esta linea es: <tr> <td>columna1</td> <td>columna2</td>...
               rowsTabla += '<tr class="lineaRegistro"><td>' + numeroAux + '</td><td>' + isbnAux + '</td><td>' + tituloAux + '</td><td>' + editorialAux + '</td><td>' + fechaAux + '</td><td>'+ autorAux + '</td>';
               //copy paste de los botones actualizar y eliminar originales de la tabla
               //ESTO SE DEBE CAMBIAR CUANDO LOS BOTONES FUNCIONEN CON AJAX
               //a ambos los debe envolver un solo <td>,
               //y despues de Eliminar se debe cerrar el <tr> que se abrió arriba
               rowsTabla += "<td><form name=\"form" + numeroAux + "\"><a id=\"actualizate\" href=\"libros.jsp?posisbn=" + isbnAux + "&postitulo=" + tituloAux + "&poseditorial=" + editorialAux + "&posfecha=" + fechaAux + "&posautor=" + autorAux + "&disa=1\" style=width:100%;background-color:#style=width:10%;>Actualizar</a></form>";
               rowsTabla += "<a id=\"eliminate\" style=\"width:100%;\" onclick=myFunction('"+isbnAux+"')>Eliminar</a></td></tr>";
            }
            //anexar dentro de tbody, dentro de #tabla, las tuplas generadas
            $("#tabla tbody").append(rowsTabla);
         }
      ]
   });
}
function busqueda(){
   var titulo_B,autor_B;
   titulo_B=document.getElementById("txtTitulo");
   autor_B=document.getElementById("txtAutor");
   
   if(document.getElementById("txtTitulo")!= "" && document.getElementById("txtAutor")!= ""){
      $.ajax({
         type: "GET",
         url: 'buscalibrosjsp.jsp?titulo_B='+titulo_B.value+'&autor_B='+autor_B.value+'&boton_B=BUSCAR',
         datatype: "json",
         success: [function (response) {
            $(".lineaRegistro").remove();
               var rowsTabla = '';
               for(var i = 0; i < response.listado.length; i++) {
                  var numeroAux=response.listado[i].numero;
                  var tituloAux=response.listado[i].titulo;
                  var isbnAux=response.listado[i].isbn;
                  var editorialAux = response.listado[i].editorial;
                  var fechaAux = response.listado[i].fecha;
                  var autorAux = response.listado[i].autor;

                  rowsTabla += '<tr class="lineaRegistro"><td>' + numeroAux + '</td><td>' + isbnAux + '</td><td>' + tituloAux + '</td><td>' + editorialAux + '</td><td>' + fechaAux + '</td><td>'+ autorAux + '</td>';
                  rowsTabla += "<td><form name=\"form" + numeroAux + "\"><a id=\"actualizate\" href=\"libros.jsp?posisbn=" + isbnAux + "&postitulo=" + tituloAux + "&poseditorial=" + editorialAux + "&posfecha=" + fechaAux + "&posautor=" + autorAux + "\" style=width:100%;background-color:#style=width:10%;>Actualizar</a></form>";
                  rowsTabla += "<a id=\"eliminate\" style=\"width:100%;\" onclick=myFunction('"+isbnAux+"')>Eliminar</a></td></tr>";
               }
               $("#tabla tbody").append(rowsTabla);}
         ]
      });
   }
   else if(document.getElementById("txtTitulo")!= ""){
      $.ajax({
         type: "GET",
         url: 'buscalibrosjsp.jsp?titulo_B='+titulo_B.value+'&boton_B=BUSCAR',
         datatype: "json",
         success: [function (response) {
            $(".lineaRegistro").remove(); 
               var rowsTabla = '';
               for(var i = 0; i < response.listado.length; i++) {
                  var numeroAux=response.listado[i].numero;
                  var tituloAux=response.listado[i].titulo;
                  var isbnAux=response.listado[i].isbn;
                  var editorialAux = response.listado[i].editorial;
                  var fechaAux = response.listado[i].fecha;
                  var autorAux = response.listado[i].autor;

                  rowsTabla += '<tr class="lineaRegistro"><td>' + numeroAux + '</td><td>' + isbnAux + '</td><td>' + tituloAux + '</td><td>' + editorialAux + '</td><td>' + fechaAux + '</td><td>'+ autorAux + '</td>';
                  rowsTabla += "<td><form name=\"form" + numeroAux + "\"><a id=\"actualizate\" href=\"libros.jsp?posisbn=" + isbnAux + "&postitulo=" + tituloAux + "&poseditorial=" + editorialAux + "&posfecha=" + fechaAux + "&posautor=" + autorAux + "\" style=width:100%;background-color:#style=width:10%;>Actualizar</a></form>";
                  rowsTabla += "<a id=\"eliminate\" style=\"width:100%;\" onclick=myFunction('"+isbnAux+"')>Eliminar</a></td></tr>";
               }
               $("#tabla tbody").append(rowsTabla);}
         ]
      });
      
   }
   else if(document.getElementById("txtAutor")!= ""){
      $.ajax({
         type: "GET",
         url: 'buscalibrosjsp.jsp?autor_B='+autor_B.value+'&boton_B=BUSCAR',
         datatype: "json",
         success: [function (response) {
            $(".lineaRegistro").remove();
               var rowsTabla = '';
               for(var i = 0; i < response.listado.length; i++) {
                  var numeroAux=response.listado[i].numero;
                  var tituloAux=response.listado[i].titulo;
                  var isbnAux=response.listado[i].isbn;
                  var editorialAux = response.listado[i].editorial;
                  var fechaAux = response.listado[i].fecha;
                  var autorAux = response.listado[i].autor;

                  rowsTabla += '<tr class="lineaRegistro"><td>' + numeroAux + '</td><td>' + isbnAux + '</td><td>' + tituloAux + '</td><td>' + editorialAux + '</td><td>' + fechaAux + '</td><td>'+ autorAux + '</td>';
                  rowsTabla += "<td><form name=\"form" + numeroAux + "\"><a id=\"actualizate\" href=\"libros.jsp?posisbn=" + isbnAux + "&postitulo=" + tituloAux + "&poseditorial=" + editorialAux + "&posfecha=" + fechaAux + "&posautor=" + autorAux + "\" style=width:100%;background-color:#style=width:10%;>Actualizar</a></form>";
                  rowsTabla += "</td></tr>";
               }
               $("#tabla tbody").append(rowsTabla);}
         ]
      });
   
   }
   var control=response.control.value;
}