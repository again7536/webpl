
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    Boolean isSuccess = true;
    JSONArray jarr = new JSONArray();
    try{
        String prdId = request.getParameter("prdId");

        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );
        pstmt = conn.prepareStatement("select * from bid where prdId=? order by bidTime desc");
        pstmt.setInt(1, Integer.parseInt(prdId));
        rs = pstmt.executeQuery();

        while(rs.next()) {
            JSONObject jobj = new JSONObject();
            int price = rs.getInt(3);
            String bidderName = rs.getString(4);
            java.sql.Timestamp ts = rs.getTimestamp(5);
            Date date=new Date(ts.getTime());

            jobj.put("price", price);
            jobj.put("bidderName", bidderName);
            jobj.put("time", date.toString());
            jarr.add(jobj);
        }
    } catch (Exception e) {
        isSuccess = false;
        e.printStackTrace();
    }
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jarr.toString());
%>