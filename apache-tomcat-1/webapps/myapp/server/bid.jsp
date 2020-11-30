
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
    String curPrice = request.getParameter("curPrice");
    int price = Integer.parseInt(curPrice);
    String prdId = request.getParameter("prdId");
    String bidderName = request.getParameter("bidderName");   
    String sql = "update product set curPrice=? where prdId=?";
    String bidSql = "insert into bid(prdId, price, bidderName) values(?,?,?)";
    try{
        Class.forName("org.mariadb.jdbc.Driver");

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //query and connect to table 'product'
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, price);
        pstmt.setString(2, prdId);
        pstmt.executeUpdate();

        pstmt = conn.prepareStatement(bidSql);
        pstmt.setString(1, prdId);
        pstmt.setInt(2, price);
        pstmt.setString(3, bidderName);
        pstmt.executeUpdate();
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        JSONObject jobj = new JSONObject();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.sendRedirect("../static/views/product.html?id="+prdId);
    }
%>