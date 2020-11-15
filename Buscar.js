function mostrar(){
   var titulo_B,autor_B;
   titulo_B=document.getElementById("txtTitulo");
   autor_B=document.getElementsById("txtAutor");
limpiarFormulario();
obtenerLibros2(titulo_B,autor_B);

}
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
  editorial.value="";}
                 function obtenerLibros2(titulo_B,autor_B){
                    $.ajax({
                      
                       //tipo de request que se mandará
                       type: "GET",
                       //la página a la que le hará la request (en este caso está en la misma dirección)
                       url: 'buscar.jsp?titulo_B='+titulo_B.value+'&autor_B='+autor_B.value,
                       //tipo de datos que obtendrá (la página ya genera un documento de tipo json)
                       //Nota: ver consulta.jsp, línea 69
                       datatype: "json",
                       //en el caso de recibir un codigo http 200 (OK)
                       success: [
                          //acción (recibe la respuesta de la request enviada)
                          function (response) {
                           limpiarFormulario();
                             //eliminar todos los elementos html que tienen la clase lineaRegistro
                             $("\lineaRegistro").remove();

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