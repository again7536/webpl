
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
    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    String sql = "select * from product where prdId=\'"+prdId+"\'";
    Boolean isSuccess = true;
    try{
        Class.forName("org.mariadb.jdbc.Driver");

        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
    } catch (Exception e) {
        isSuccess = false;
        e.printStackTrace();
    }

    JSONObject jobj = new JSONObject();
    if(isSuccess) {
        while(rs.next()) {
            int prdId_ = rs.getInt(1);
            String prdName = rs.getString(2);
            String sellerName = rs.getString(3);
            int curPrice = rs.getInt(5);
            int wishPrice = rs.getInt(6);
            java.sql.Timestamp endTime = rs.getTimestamp(7);
            String imgUrl = rs.getString(8);
            String article = rs.getString(11);

            jobj.put("prdId", prdId_);
            jobj.put("prdName", prdName);
            jobj.put("sellerName", sellerName);
            jobj.put("curPrice", curPrice);
            jobj.put("wishPrice", wishPrice);
            jobj.put("endTime", endTime.toString());
            jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
            jobj.put("article", article);
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jobj.toString());
    }
    else response.sendRedirect("http://localhost:8080/myapp/index.html");
%>