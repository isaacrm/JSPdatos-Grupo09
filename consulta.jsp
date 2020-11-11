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
    //proceso
    //--abre conexión
    Connection conexion = getConnection();
    //--proceso escritura
    if (!conexion.isClosed()){
        Statement sentencia = conexion.createStatement();
        //obtener cantidad de resultados        
        ResultSet conteoSQL = sentencia.executeQuery("SELECT Count(*) FROM libros;");
        conteoSQL.next();
        int cantidad = conteoSQL.getInt(1);
        //obtener listado de libros
        ResultSet conjuntoResultados = sentencia.executeQuery("SELECT * FROM libros;" );
        //formato JSON
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