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
%><%
    Connection conexion = getConnection();
    if (!conexion.isClosed()){
        Statement sentencia = conexion.createStatement();
        
        String tituloBuscar=request.getParameter("filter");
        String ls_query = "";
        
        if(tituloBuscar != ""){
            ls_query = " select libros.isbn, libros.titulo, libros.Editorial, libros.Anio, libros.autor from libros ";
            ls_query += " where titulo like " + "'%" + ls_titulo_B +"%'";
            //obtener cantidad de resultados        
            ResultSet conteoSQL = sentencia.executeQuery("select count(*) from libros where titulo like " + "'%" +ls_titulo_B+ "%';");
            int cantidad = conteoSQL.getInt(1);
            //obtener listado de libros
            ResultSet conjuntoResultados = sentencia.executeQuery(ls_query );
        
        }
        response.setStatus(200);
        response.setHeader("Content-Type", "application/json");
    }
    conexion.close();
%>