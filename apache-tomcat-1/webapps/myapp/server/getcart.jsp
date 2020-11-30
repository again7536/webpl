
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
        String userName = request.getParameter("userName");
        String sql = "select a.* from product a, shopping b where a.prdId = b.prdId and b.userName=?";

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //connect to table 'wishlist' and query.
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userName);
        rs = pstmt.executeQuery();
        while(rs.next()){
            jobj = new JSONObject();
            int prdId = rs.getInt(1);
            String prdName = rs.getString(2);
            int curPrice = rs.getInt(5);
            String place = rs.getString(7);
            String imgUrl = rs.getString(8);
            Boolean isBidding = rs.getBoolean(9);
            Boolean isSold = rs.getBoolean(10);

            jobj.put("prdId", prdId);
            jobj.put("prdName", prdName);
            jobj.put("place", place);
            jobj.put("curPrice", curPrice);
            jobj.put("img", Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get(imgUrl))));
            jobj.put("isBidding", isBidding);
            jobj.put("isSold", isSold);
            jarr.add(jobj);
        }
    }
    catch (Exception e) {
        e.printStackTrace();
    }
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jarr.toString());
%>