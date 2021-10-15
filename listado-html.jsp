<%@page  import="java.sql.*,net.ucanaccess.jdbc.*" %>
<%@page import="java.io.*" %>

<%!
public Connection getConnection(String path) throws SQLException {

   String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
   String userName="",password="";
   String filePath =  path+"\\datos.mdb";
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
   String path = context.getRealPath("/data");
Connection conexion = getConnection(path);

String queryBase = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id";
if(!conexion.isClosed()) {
    PrintWriter writer = response.getWriter();
    Statement st = conexion.createStatement();
    ResultSet re = st.executeQuery(queryBase);
    writer.append("<!DOCTYPE htlm>");
    writer.append("<htlm>");
    writer.append("<head>");
    writer.append("<title>Listado Libros</title>");
    writer.append("</head>");
    writer.append("<body>");
    String isbn="";
    String titulo = "";
    String autor = "";
    String fechaPublicacion = "";
    String nombre="";
    writer.append("<table>");
    writer.append("<thead><tr><th>ISBN</th><th>Titulo</th><th>Author</th><th>Fecha Publicacion</th><th>Editorial</th></tr></thead>");
    while(re.next()) {
        isbn=re.getString("isbn");
        titulo=re.getString("titulo");
        autor=re.getString("autor");
        fechaPublicacion=re.getString("fechaPublicacion");
        nombre=re.getString("nombre");  

        writer.append("<tr>");

        writer.append("<td>");
        writer.append(isbn);
        writer.append("</td>");
        
        writer.append("<td>");
        writer.append(titulo);
        writer.append("</td>");

        writer.append("<td>");
        writer.append(autor);
        writer.append("</td>");

        writer.append("<td>");
        writer.append(fechaPublicacion);
        writer.append("</td>");

        writer.append("<td>");
        writer.append(nombre);
        writer.append("</td>");
        writer.append("</tr>");
    }
    writer.append("</table>");
    writer.append("</body>");
    writer.append("</htlm>");
}
response.setHeader("Content-Type", "text/html");
response.setHeader("Content-Disposition", "attachment; filename=libros.html");
response.setStatus(response.SC_ACCEPTED);
%>