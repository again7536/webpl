
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
    PreparedStatement pstmt = null;

    String sqlWithUrl = "update product set prdName=?, sellerName=?, buyerName=?, curPrice=?, endTime=?, place=?, imgUrl=?, isBidding=?, isSold=?, article=?, phone=? where prdId=?";
    String sqlNoUrl = "update product set prdName=?, sellerName=?, buyerName=?, curPrice=?, endTime=?, place=?, isBidding=?, isSold=?, article=?, phone=? where prdId=?";
    Boolean success = true;
    String newFileName = null;
    String imgUrl = null;
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        MultipartRequest multiReq = new MultipartRequest(request, realPath, 1024*1024*10, "utf-8", new DefaultFileRenamePolicy());
        
    //Get File from multipart request.
        long currentTime = System.currentTimeMillis();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");

    //Change File Name.
        String uploadFile = multiReq.getFilesystemName("image");
        if (uploadFile != null) {
            newFileName = dateFormat.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
            File oldFile = new File(realPath + uploadFile);
            File newFile = new File(realPath + newFileName);
            oldFile.renameTo(newFile);
            imgUrl = realPath + newFileName;
        }

    //Get other items from multipart request.
        String title = multiReq.getParameter("title");
        String sellerName = multiReq.getParameter("username");
        Boolean isBidding = multiReq.getParameter("bid").equals("true") ? true : false;
        int price = Integer.parseInt(multiReq.getParameter("price"));
        int curPrice = price;
        String dateStr = multiReq.getParameter("date");
        String timeStr = multiReq.getParameter("time");

        Boolean isSold = false;
        String place = multiReq.getParameter("place");
        String article = multiReq.getParameter("article");
        String phone = multiReq.getParameter("phone");
        String prdId = multiReq.getParameter("prdId");
   
        Date date=new SimpleDateFormat("yyyy-MM-dd hh:mm").parse(dateStr + " " + timeStr);
        java.sql.Timestamp ts = new java.sql.Timestamp(date.getTime());
        
    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

        //map variables to sql query and connect to table 'product'
        if (uploadFile != null) {
            pstmt = conn.prepareStatement(sqlWithUrl);
            pstmt.setString(1, title);
            pstmt.setString(2, sellerName);
            pstmt.setNull(3, java.sql.Types.CHAR);
            pstmt.setInt(4, curPrice);
            pstmt.setTimestamp(5, ts);
            pstmt.setString(6, place);
            pstmt.setString(7, imgUrl);
            pstmt.setBoolean(8, isBidding);
            pstmt.setBoolean(9, isSold);
            pstmt.setString(10, article);
            pstmt.setString(11, phone);
            pstmt.setInt(12, Integer.parseInt(prdId));
        }
        else {
            pstmt = conn.prepareStatement(sqlNoUrl);
            pstmt.setString(1, title);
            pstmt.setString(2, sellerName);
            pstmt.setNull(3, java.sql.Types.CHAR);
            pstmt.setInt(4, curPrice);
            pstmt.setTimestamp(5, ts);
            pstmt.setString(6, place);
            pstmt.setBoolean(7, isBidding);
            pstmt.setBoolean(8, isSold);
            pstmt.setString(9, article);
            pstmt.setString(10, phone);
            pstmt.setInt(11, Integer.parseInt(prdId));
        }
        pstmt.executeUpdate();
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.sendRedirect("../static/views/sell.html?isSuccess=" + success.toString());
    }
%>