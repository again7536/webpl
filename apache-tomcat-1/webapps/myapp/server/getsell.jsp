
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Base64" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    Connection conn = null;
    Boolean success = true;
    ResultSet rs = null;
    PreparedStatement pstmt;

    JSONArray jarr = new JSONArray();
    JSONObject jobj = null;
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        String userName = request.getParameter("username");
        String sqlWish = "select prdId from product where sellerName=\'"+userName+"\'";

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //connect to table 'wishlist' and query.
        pstmt = conn.prepareStatement(sqlWish);
        rs = pstmt.executeQuery();
        while(rs.next()){
            int prdId = rs.getInt(1);
            pstmt = conn.prepareStatement("select * from product where prdId=\'"+prdId+"\'");
            ResultSet rsWish = pstmt.executeQuery();

            jobj = new JSONObject();
            if(rsWish.next()){
                String prdName = rsWish.getString(2);
                int curPrice = rsWish.getInt(5);
                String place = rsWish.getString(7);
                String imgUrl = rsWish.getString(8);
                Boolean isBidding = rsWish.getBoolean(9);
                Boolean isSold = rsWish.getBoolean(10);

                jobj.put("prdId", prdId);
                jobj.put("prdName", prdName);
                jobj.put("curPrice", curPrice);
                jobj.put("place", place);
                jobj.put("isBidding", isBidding);
                jobj.put("isSold", isSold);
                jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
                jarr.add(jobj);
            }
        }
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    }
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jarr.toString());
%>