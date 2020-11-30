
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Date" %>
<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>

<%
    request.setCharacterEncoding("utf-8");
    String path_= null;
    String realPath = request.getSession().getServletContext().getRealPath("/static/images/product/");
    ResultSet rs = null;
    Connection conn = null;
    String sqlProduct = "insert into product(prdName, sellerName, buyerName, curPrice, wishPrice, endTime, imgUrl, isBidding, isSold, article) values(?, ?, ?, ?, ? ,?, ?, ?, ?, ?)";
    String sqlTags = "insert into tags(prdName, sellerName, tag) values(?, ?, ?)";
    Boolean success = true;
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        MultipartRequest multiReq = new MultipartRequest(request, realPath, 1024*1024*10, "utf-8", new DefaultFileRenamePolicy());
        
    //Get File from multipart request.
        long currentTime = System.currentTimeMillis();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");

    //Change File Name.
        String uploadFile = multiReq.getFilesystemName("image");
        String newFileName = dateFormat.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
        File oldFile = new File(realPath + uploadFile);
        File newFile = new File(realPath + newFileName);
        oldFile.renameTo(newFile);

    //Get other items from multipart request.
        String title = multiReq.getParameter("title");
        String sellerName = multiReq.getParameter("username");
        int price = Integer.parseInt(multiReq.getParameter("price"));
        int wishPrice = price;
        int curPrice = 0;
        String dateStr = multiReq.getParameter("date");
        String timeStr = multiReq.getParameter("time");
        String imgUrl = realPath + newFileName;
        Boolean isBidding = false;
        Boolean isSold = false;
        String tags = multiReq.getParameter("tags");
        String article = multiReq.getParameter("article");

        if(price == 0) {
            isBidding = true;
            wishPrice = 0;
        }        
        Date date=new SimpleDateFormat("yyyy-MM-dd hh:mm").parse(dateStr + " " + timeStr);
        java.sql.Timestamp ts = new java.sql.Timestamp(date.getTime());
        
    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //map variables to sql query and connect to table 'product'
        PreparedStatement pstmt = conn.prepareStatement(sqlProduct);
        pstmt.setString(1, title);
        pstmt.setString(2, sellerName);
        pstmt.setNull(3, java.sql.Types.CHAR);
        pstmt.setInt(4, curPrice);
        pstmt.setInt(5, wishPrice);
        pstmt.setTimestamp(6, ts);
        pstmt.setString(7, imgUrl);
        pstmt.setBoolean(8, isBidding);
        pstmt.setBoolean(9, isSold);
        pstmt.setString(10, article);
        pstmt.executeUpdate();

    //map variables to sql query and connect to table 'tags'
        //for(String tag: tags){
        pstmt = conn.prepareStatement(sqlTags);
        pstmt.setString(1, title);
        pstmt.setString(2, sellerName);
        pstmt.setString(3, tags);
        pstmt.executeUpdate();
        //}
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.sendRedirect("../static/views/sell.html?isSuccess=" + success.toString());
    }
%>