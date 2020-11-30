
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
    String greeting = null;

    JSONArray jarr = new JSONArray();
    JSONObject jobj = new JSONObject();
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        String userName = request.getParameter("username");
        String sqlUser = "select greeting from user where userName=\'"+userName+"\'";

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //connect to table 'user' and query.
        PreparedStatement pstmt = conn.prepareStatement(sqlUser);
        rs = pstmt.executeQuery();
        if(!rs.next()) success = false;
        else {
            greeting = rs.getString(1);
            jobj.put("greeting", greeting);
        }
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    }
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jobj.toString());
%>