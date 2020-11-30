
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
    String search = request.getParameter("search");
    ResultSet rs = null;
    Connection conn = null;
    Statement stmt = null;
    Boolean isSuccess = true;
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );
        stmt = conn.createStatement();
        rs = stmt.executeQuery("select * from product where prdName like \'%"+search+"%\' and isSold=false");
    } catch (Exception e) {
        isSuccess = false;
        e.printStackTrace();
    }
    if(isSuccess) {
        JSONArray jarr = new JSONArray();
        try{
            while(rs.next()) {
                JSONObject jobj = new JSONObject();
                int prdId = rs.getInt(1);
                String prdName = rs.getString(2);
                String sellerName = rs.getString(3);
                int curPrice = rs.getInt(5);
                java.sql.Timestamp endTime = rs.getTimestamp(6);
                String place = rs.getString(7);
                String imgUrl = rs.getString(8);

                jobj.put("prdId", prdId);
                jobj.put("prdName", prdName);
                jobj.put("sellerName", sellerName);
                jobj.put("curPrice", curPrice);
                jobj.put("place", place);
                jobj.put("endTime", endTime.toString());
                jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
                jarr.add(jobj);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jarr.toString());
    }
%>