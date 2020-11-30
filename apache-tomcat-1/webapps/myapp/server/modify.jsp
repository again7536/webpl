
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Base64" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    String prdId = request.getParameter("prdId");
    String userName = request.getParameter("userName");
    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    Boolean isSuccess = true;
    try{
    //connect to database.
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );
    //query to database.
        pstmt = conn.prepareStatement("select * from product where prdId=\'"+prdId+"\'");
        rs = pstmt.executeQuery();
    //parse from database result.
        JSONObject jobj = new JSONObject();
        if(rs.next()){
            String prdName = rs.getString(2);
            String sellerName = rs.getString(3);
            int curPrice = rs.getInt(5);
            java.sql.Timestamp endTime = rs.getTimestamp(6);
            String place = rs.getString(7);
            String imgUrl = rs.getString(8);
            Boolean isBidding = rs.getBoolean(9);
            Boolean isSold = rs.getBoolean(10);
            String article = rs.getString(11);

            jobj.put("prdId", prdId);
            jobj.put("prdName", prdName);
            jobj.put("sellerName", sellerName);
            jobj.put("curPrice", curPrice);
            jobj.put("place", place);
            jobj.put("isBidding", isBidding);
            jobj.put("isSold", isSold);
            jobj.put("endTime", endTime.toString());
            jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
            jobj.put("article", article);
        }
    } catch (Exception e) {
        isSuccess = false;
        e.printStackTrace();
    }
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jobj.toString());
%>