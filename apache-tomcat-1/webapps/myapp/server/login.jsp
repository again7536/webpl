
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
    ResultSet rs = null;
    String userName = null;
    String authPw = null;
    JSONObject jobj = new JSONObject();
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");
        String sqlUser = "select * from user where userId=\'"+userId+"\'";

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
            authPw = rs.getString(2);
            userName = rs.getString(3);
            if(userPw.equals(authPw) == false)
                success = false;
        }
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    }
    if(success) {
        Cookie cookie = new Cookie("username", userName);
        cookie.setDomain("localhost");
        cookie.setPath("/");
        response.addCookie(cookie);
    }
    jobj.put("isSuccess", success);
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jobj.toString());
%>