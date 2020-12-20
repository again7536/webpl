
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
    PreparedStatement pstmt = null;

    JSONArray jarr = new JSONArray();
    JSONObject jobj = null;
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        String userName = request.getParameter("username");
        String sqlSell = "select * from product where sellerName=?";
        String sqlLike = "select count(userName) as count from wishlist where prdId=?";

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //connect to table 'wishlist' and query.
        pstmt = conn.prepareStatement(sqlSell);
        pstmt.setString(1, userName);

        rs = pstmt.executeQuery();
        while(rs.next()){
            jobj = new JSONObject();
            int prdId = rs.getInt(1);
            String prdName = rs.getString(2);
            int curPrice = rs.getInt(5);
            java.sql.Timestamp endTime = rs.getTimestamp(6);
            String place = rs.getString(7);
            String imgUrl = rs.getString(8);
            Boolean isBidding = rs.getBoolean(9);
            Boolean isSold = rs.getBoolean(10);

            int like = 0;
            pstmt = conn.prepareStatement(sqlLike);
            pstmt.setInt(1, prdId);
            ResultSet rsLike = pstmt.executeQuery();
            if(rsLike.next()) like = rsLike.getInt("count");

            jobj.put("prdId", prdId);
            jobj.put("prdName", prdName);
            jobj.put("curPrice", curPrice);
            jobj.put("endTime", endTime.toString());
            jobj.put("place", place);
            jobj.put("isBidding", isBidding);
            jobj.put("isSold", isSold);
            jobj.put("like", like);
            jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
            jarr.add(jobj);
        }
    } 
    catch (Exception e) {
        success = false;
        e.printStackTrace();
    }
    finally{
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jarr.toString());
        
        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>