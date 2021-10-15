
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
    String isbn="";
    String titulo = "";
    String autor = "";
    String fechaPublicacion = "";
    String nombre="";
    writer.append("[");
    while(re.next()) {
        isbn=re.getString("isbn");
        titulo=re.getString("titulo");
        autor=re.getString("autor");
        fechaPublicacion=re.getString("fechaPublicacion");
        nombre=re.getString("nombre");  
          
        writer.append("{");
        writer.append("\"isbn\": ");
        writer.append("\""+isbn+"\"").append(",");
        writer.append("\"titulo\": ");
        writer.append("\""+titulo+"\"").append(",");
        writer.append("\"autor\": ");
        writer.append("\""+autor+"\"").append(",");
        writer.append("\"fechaPublicacion\": ");
        writer.append("\""+fechaPublicacion+"\"").append(",");
        writer.append("\"Editorial\": ");
        writer.append("\""+nombre+"\"");
        writer.append("}").append(",");
    }
   writer.append("]");
}
response.setHeader("Content-Type", "text/json");
response.setHeader("Content-Disposition", "attachment; filename=libros.json");
response.setStatus(response.SC_ACCEPTED);
%>