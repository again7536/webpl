
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLIntegrityConstraintViolationException" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("utf-8");
    JSONObject jobj = new JSONObject();
    Connection conn = null;
    Boolean success = true;
    String prdId = request.getParameter("prdId");
    String userName = request.getParameter("userName");   
    String sql = "insert into shopping(prdId, userName) values(?,?)";
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
        pstmt.setString(1, prdId);
        pstmt.setString(2, userName);
        pstmt.executeUpdate();

    } catch(SQLIntegrityConstraintViolationException e){
        success = false;
        jobj.put("msg", "This item has been already added!");
    } catch (Exception e) {
        success = false;
        e.printStackTrace();
    } finally {
        jobj.put("isSuccess", success);
        response.getWriter().write(jobj.toString());
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
    }
%>