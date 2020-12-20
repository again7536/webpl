
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
        String sql = "select * from user where isDeleted=false";

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //connect to table 'wishlist' and query.
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        while(rs.next()){
            jobj = new JSONObject();
            String userId = rs.getString(1);
            String userName = rs.getString(2);
            String level = rs.getString(5);

            jobj.put("userId", userId);
            jobj.put("userName", userName);
            jobj.put("level", level);
            jarr.add(jobj);
        }
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    }
    finally {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jarr.toString());
        
        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>