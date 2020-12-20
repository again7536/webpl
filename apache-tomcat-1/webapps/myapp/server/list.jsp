
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
    String seller = request.getParameter("seller");
    String minPrice = request.getParameter("minPrice");
    String maxPrice = request.getParameter("maxPrice");
    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    Boolean isSuccess = true;

    //prdName = 1, price = 2, seller = 4
    String[] sqls = new String[8];
    sqls[1] = "select * from product where prdName like ? and isSold=false";
    sqls[2] = "select * from product where isSold=false and ? <= curPrice and curPrice <= ?";
    sqls[3] = "select * from product where prdName like ? and isSold=false and ? <= curPrice and curPrice <= ?";
    sqls[4] = "select * from product where isSold=false and sellerName=?";
    sqls[5] = "select * from product where prdName like ? and isSold=false and sellerName=?";
    sqls[6] = "select * from product where isSold=false and ? <= curPrice and curPrice <= ? and sellerName=?";
    sqls[7] = "select * from product where prdName like ? and isSold=false and ? <= curPrice and curPrice <= ? and sellerName=?";
    try{
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/webpl",
            "dev001",
            "dev001"
        );
        int idx = 0;
        if(search != null && !search.equals("")) idx += 1;
        if( (minPrice != null && !minPrice.equals("")) && (maxPrice != null && !maxPrice.equals("")) ) idx += 2;
        if(seller != null && !seller.equals("")) idx += 4;

        pstmt = conn.prepareStatement(sqls[idx]);
        String[] args = new String[4];
        int argc = 0;
        search = "%" + search + "%";
        switch(idx) {
            case 1:
                args[0] = search;
                argc = 1;
                break;
            case 2:
                args[0] = minPrice;
                args[1] = maxPrice;
                argc = 2;
                break;
            case 3:
                args[0] = search;
                args[1] = minPrice;
                args[2] = maxPrice;
                argc = 3;
                break;
            case 4:
                args[0] = seller;
                argc = 1;
                break;
            case 5:
                args[0] = search;
                args[1] = seller;
                argc = 2;
                break;
            case 6:
                args[0] = minPrice;
                args[1] = maxPrice;
                args[2] = seller;
                argc = 3;
                break;
            case 7:
                args[0] = search;
                args[1] = minPrice;
                args[2] = maxPrice;
                args[3] = seller;
                argc= 4;
                break;
        }
        for(int i = 0; i < argc; i++)
            pstmt.setString(i + 1, args[i]);
        rs = pstmt.executeQuery();
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
        finally {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jarr.toString());
            if (rs != null) try { rs.close(); } catch(SQLException ex) {}
            if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
            if (conn != null) try { conn.close(); } catch(SQLException ex) {}
        }
    }
%>