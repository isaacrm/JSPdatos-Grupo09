<%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import = "java.sql.*" %><%!
    //método obtener conexión
    public Connection getConnection() throws SQLException {
        //define driver
        String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
        //obtener posición de la base (debe estar en una carpeta data dentro del mismo lugar que este jsp)
        String filePath= getServletContext().getRealPath("\\") + "\\data\\datos.mdb";
        String userName="",password="";
        //concatenar cadena de conexión
        String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;
        //declaración de ocnexión
        Connection conn = null;
        try{
            //conectar
            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            conn = DriverManager.getConnection(fullConnectionString,userName,password);
        }
        catch (Exception e) {
            System.out.println("Error: " + e);
        }
        return conn;
    };
%><% //proceso
//--abre conexión
Connection conexion = getConnection();
//--proceso escritura
if (!conexion.isClosed()){
    Statement sentencia = conexion.createStatement();
     String ls_autor_B= request.getParameter("autor_B");    
     String ls_titulo_B= request.getParameter("titulo_B");
     String ls_query=" select * from libros";
    ResultSet conjuntoResultados=sentencia.executeQuery(ls_query);
    int cantidad =0;
    if(ls_titulo_B != "" && ls_autor_B != "") {
        ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
        ls_query += " where titulo like " + "'%" + ls_titulo_B +"%'";
        ls_query += " or autor like " + "'%" + ls_autor_B +"%'";
        //obtener cantidad de resultados        
        ResultSet conteoSQL = sentencia.executeQuery("select count(*) from libros where titulo like " + "'%" +ls_titulo_B+ "%'"+" or autor like " + "'%" + ls_autor_B +"%';");
        conteoSQL.next();
        cantidad = conteoSQL.getInt(1);
        //obtener listado de libros
        conjuntoResultados = sentencia.executeQuery(ls_query );
        
    }
    else if (ls_titulo_B != "" && ls_autor_B=="") {
        ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
        ls_query += " where titulo like " + "'%" + ls_titulo_B +"%'";
        //obtener cantidad de resultados        
        ResultSet conteoSQL = sentencia.executeQuery("select count(*) from libros where titulo like " + "'%" + ls_titulo_B +"%';");
        conteoSQL.next();
         cantidad = conteoSQL.getInt(1);
        //obtener listado de libros
        conjuntoResultados = sentencia.executeQuery(ls_query );
    }
    else if (ls_autor_B != "" && ls_titulo_B=="") {
        ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
        ls_query += " where autor like " + "'%" + ls_autor_B +"%'";
        //obtener cantidad de resultados        
        ResultSet conteoSQL = sentencia.executeQuery("select count(*) from libros where autor like " + "'%" + ls_autor_B +"%';");
        conteoSQL.next();
         cantidad = conteoSQL.getInt(1);
        //obtener listado de libros
        conjuntoResultados = sentencia.executeQuery(ls_query );
    }
    
    out.println("{");
    out.println("   \"listado\":");
    out.println("       [");
    //inicio conteo manual
    int numero = 1;
    //Declaración formato JSON (final de elemento)
    String cierreAux;
    //mientras exista un siguiente valor...
    while (conjuntoResultados.next()) {
        //formato JSON (final de elemento)
        cierreAux = "           }";
        //si no está en la última tupla
        if(numero != cantidad)
            //añadir coma al final
            cierreAux += ",";
        //imprimir datos libro en formato JSON
        out.println("           {");
        out.println("               \"numero\":" + numero +", ");
        out.println("               \"titulo\":\""+conjuntoResultados.getString("titulo")+"\", ");
        out.println("               \"isbn\":\"" + conjuntoResultados.getString("isbn")+"\",");
        out.println("               \"editorial\":\"" + conjuntoResultados.getString("Editorial")+"\",");
        out.println("               \"fecha\":\"" + conjuntoResultados.getString("Anio")+"\",");
        out.println("               \"autor\":\"" + conjuntoResultados.getString("autor")+"\"");
        out.println(cierreAux);
        //aumentar conteo manual
        numero++;
    } ;
    //formato JSON
    out.println("       ]");
    out.println("}");
    //añadir datos a la response: tipo de contenido y disposición en el header, estatus http 200 (OK)
    response.setStatus(200);
    response.setHeader("Content-Type", "application/json");
    //response.setHeader("Content-Disposition", "attachment; filename=listado.json");
}
//--cierra conexión
conexion.close();
%>