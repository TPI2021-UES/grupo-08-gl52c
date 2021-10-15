<%@page contentType="text/html" pageEncoding="iso-8859-1" import="java.sql.*,net.ucanaccess.jdbc.*" %>

<%!
public Connection getConnection(String path) throws SQLException {

   String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
   String userName="",password="";
//   String filePath= "c:\\Apache\\Tomcat\\webapps\\grupo08gl52c\\data\\datos.mdb";
   String filePath = path+"\\datos.mdb";
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

   //Datos para la actualizacion del libro
   String tituloRecuperado = request.getParameter("titulo");
   String isbnRecuperado = request.getParameter("isbn");
   String autorRecuperado = request.getParameter("autor");
   String editorialRecuperado = request.getParameter("editorial");
   String fechaRecuperado = request.getParameter("fecha");

%>
 <html>
 <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Actualizar, Eliminar, Crear registros.</title>
      <link rel = "stylesheet" href = "./style.css" />
 </head>
 <body>

<H1>MANTENIMIENTO DE LIBROS</H1>
<form action="matto.jsp" method="post" name="Actualizar">
 <table>
 <tr>
 <td>ISBN
    <input 
      type="text" 
      name="isbn" 
      <% if(isbnRecuperado==null) { %> value = "" <% } else { %> value = '<%=isbnRecuperado%>' <% } %>
   />
</td>
  </tr>
 <tr>
 <td>Titulo
    <input 
      type="text" 
      name="titulo" 
      <% if(tituloRecuperado==null) { %> value = "" <% } else { %> value = '<%=tituloRecuperado%>' <% } %>
      size="50"/>
   </td>
 </tr>
 <tr>
 <td>Editorial
    <select name = "editorial">
       <%
         if(!conexion.isClosed()) {
            Statement sta = conexion.createStatement();
            ResultSet re = sta.executeQuery("select *from Editorial");
            int contador=0;
            String idE = "";
            String select = "";
            String nombreEditorial="";
            if(editorialRecuperado!=null) {
               while(re.next()) {
                  idE=re.getString("id");
                  nombreEditorial=re.getString("nombre");
                  if(editorialRecuperado.equals(idE))  {
                     out.println("<option value='"+idE+"'"+"selected"+">"+nombreEditorial+"</option>");
                  } else {
                     out.println("<option value='"+idE+"'"+">"+nombreEditorial+"</option>");
                  }
            }
          } else {
               while(re.next()) {
                  idE=re.getString("id");
                  nombreEditorial=re.getString("nombre");
                  out.println("<option value='"+idE+"'>"+nombreEditorial+"</option>");
                  contador++;
               }

            }
            
         }
       %>
    </select>
</td>
  </tr>
 <tr>
 <td>Fecha de Publicacion
    <input 
      type="date" 
      name="fecha_publicacion" 
      <% if(fechaRecuperado==null) { %> value = "" <% } else { %> value = '<%=fechaRecuperado%>' <% } %>
   />
</td>
  </tr>
 <tr>
 <td>Autor
    <input 
      type="text" 
      name="autor" 
      size="50"
      <% if(autorRecuperado==null) { %> value = "" <% } else { %> value = '<%=autorRecuperado%>' <% } %>
   />
</td>
  </tr>
 <tr>
    <td>
        Action 
        <input
            type="radio" 
            name="Action" 
            value="Actualizar" 
         /> Actualizar
      <input 
         type="radio" 
         name="Action" 
         value="Eliminar" 
         /> Eliminar
 <input 
   type="radio" 
   name="Action" 
   value="Crear" 
   checked
    /> Crear
  </td>
 <td><input type="SUBMIT" value="ACEPTAR" />
   <a href = "./libros.jsp">Limpiar Campos</a>
</td>
 </tr>
 </form>
 </tr>
 </table>
 </form>
<br><br>


<form name = "formbusca" action = "libros.jsp" method="GET">
   Titulo a buscar: <input type = "text" name = "titulo_busqueda" placeholder = "ingrese un titulo" id = "id_buscar_titulo"/>
   Autor a buscar: <input type = "text" name = "autor_busqueda" placeholder = "ingrese un autor" id = "id_buscar_autor" />
   <input type = "submit" value = "Buscar" id = "id_boton_buscar"/>
</form>

 <a href="./listado-csv.jsp" download="libros.csv">Descargar Listado</a>


<%
//Variable para saber el orden que se mostraran
String ordenar = request.getParameter("ordenar");

//Variable para la busqueda del libro
String buscarTitulo = request.getParameter("titulo_busqueda");
String buscarAutor = request.getParameter("autor_busqueda");


String urlordenar = "./libros.jsp?ordenar=ascendente";
if (!conexion.isClosed()){
   Statement st = conexion.createStatement();
   String queryBase = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id";
   ResultSet rs = st.executeQuery(queryBase);
   if(ordenar==null) {
   } else  {
      if(ordenar.equals("ascendente")) {
         urlordenar = "./libros.jsp?ordenar=descendente";
         queryBase = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id order by titulo asc";
      }
      if(ordenar.equals("descendente")) {
         urlordenar = "./libros.jsp?ordenar=ascendente";
         queryBase = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id order by titulo desc";
      }
     rs = st.executeQuery(queryBase);
   }

   String query="";
   if(buscarTitulo!=null && buscarAutor!=null) {
      if(buscarTitulo.equals("")) {
         out.println("<p>entra</p>");
         if(buscarAutor.equals("")) {
            rs = st.executeQuery(queryBase);
         } else {
            query  = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id where autor like '%" +buscarAutor+"%'";
            out.println("entra");
            rs=st.executeQuery(query);
         }
      } else {
         if(buscarAutor.equals("")) {
            
            query  = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id where titulo like '%" +buscarTitulo+"%'";
            rs=st.executeQuery(query);
         } else {
            query  = "select li.isbn, li.titulo, li.autor, li.fechaPublicacion, edi.id, edi.nombre from libros as li inner join Editorial as edi on li.idEditorial = edi.id where titulo like '%" +buscarTitulo+"%' or autor like '%"+buscarAutor+"%'";
            rs=st.executeQuery(query);
         }
      }

   }

   // Ponemos los resultados en un table de html
   out.println("<table class = 'main-container__table' border=\"1\"><thead class = 'main-container__thead'><th class = 'main-container__th'>Num.</th><th class = 'main-container__th'>ISBN</th>"+"<th class='main-container__th'><a href='"+urlordenar+"'"+">"+"Titulo"+"</th>"+"<th class = 'main-container__th'>Autor</th>"+"<th class = 'main-container__th'>Editorial</th>"+"<th class = 'main-container__th'>Fecha Publicacion</th>"+"<th class = 'main-container__th'>Accion</th></thead>");
   int i=1;
   String isbn="";
   String titulo="";
   String nombreEditorial = "";
   String autor = "";
   String idEdi="";
   String datePublacicion="";
   String urlActualizar="";
   String urlEliminar="";
   while (rs.next())
   {
      titulo = rs.getString("titulo");
      isbn=rs.getString("isbn");
      nombreEditorial = rs.getString("nombre");
      autor = rs.getString("autor");
      idEdi=rs.getString("id");
      datePublacicion=rs.getString("fechaPublicacion");
      urlActualizar = "./libros.jsp?titulo="+titulo+"&isbn="+isbn+"&autor="+autor+"&editorial="+idEdi+"&fecha="+datePublacicion+"&actionr=Actualizar";
      urlEliminar = "./matto.jsp?Action=Eliminar&isbn="+isbn;
      out.println("<tr>");
      out.println("<td class = 'main-container__td'>"+ i +"</td>");
      out.println("<td class = 'main-container__td'>"+isbn+"</td>");
      out.println("<td class = 'main-container__td'>"+titulo+"</td>");
      out.println("<td class = 'main-container__td'>"+autor+"</td>");
      out.println("<td class = 'main-container__td'>"+nombreEditorial+"</td>");
      out.println("<td class = 'main-container__td'>"+datePublacicion+"</td>");
      out.println("<td class = 'main-container__td'>"+ "<a href='"+urlActualizar+"'" + ">" + "Actualizar</a><br>" + "<a href='"+urlEliminar+"'"+">"+"Eliminar</a>" +"</td>");
      out.println("</tr>");
      i++;
   }
   out.println("</table>");

   // cierre de la conexion
   conexion.close();
}

%>
 </body>
 <script src = "./libros.js"></script>
 </html>