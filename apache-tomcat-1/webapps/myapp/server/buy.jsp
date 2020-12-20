
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    String buyerName = request.getParameter("userName");
    String prdId = request.getParameter("prdId");
    String sql = "update product set buyerName=?, isSold=true where prdId=?";
    PreparedStatement pstmt = null;
    try{
        Class.forName("org.mariadb.jdbc.Driver");

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //query and connect to table 'product'
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, buyerName);
        pstmt.setString(2, prdId);
        pstmt.executeUpdate();
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        JSONObject jobj = new JSONObject();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jobj.toString());

        if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>