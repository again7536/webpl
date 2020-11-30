
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.SQLIntegrityConstraintViolationException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    Connection conn = null;
    String sqlUser = "insert into user(userId, userPw, userName) values(?, ?, ?)";
    Boolean success = true;
    JSONObject jobj = new JSONObject();
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");
        String userName = request.getParameter("userName");

    //connect to database.
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );

    //map variables to sql query and connect to table 'product'
        PreparedStatement pstmt = conn.prepareStatement(sqlUser);
        pstmt.setString(1, userId);
        pstmt.setString(2, userPw);
        pstmt.setString(3, userName);
        pstmt.executeUpdate();
    } catch(SQLIntegrityConstraintViolationException e){
        success = false;
        jobj.put("msg", "ID or username is already in use");
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        jobj.put("isSuccess", success);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jobj.toString());
    }
%>