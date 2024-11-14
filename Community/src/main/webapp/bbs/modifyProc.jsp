<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,pack.dao.BoardMgr" %>
 <%
 request.setCharacterEncoding("UTF-8");
 
 int num = Integer.parseInt(request.getParameter("num"));
 String uName = request.getParameter("uName");
 String uId = request.getParameter("uId");
 String subject = request.getParameter("subject");
 String content = request.getParameter("content");
 String contentType = request.getParameter("contentType");
 String fileName = request.getParameter("fileName");
 String ip = request.getParameter("ip");

 BoardMgr bMgr = new BoardMgr();
 boolean isUpdated = bMgr.updateBoard(num, uName, uId, subject, content, contentType, fileName, ip);
 
 if(isUpdated){
	 out.println("<script>alert('수정이 완료되었습니다.'); location.href='/bbs/read.jsp?num=" + num + "';</script>");
 }else{
	 out.print("<script>alert('수정에 실패했습니다. 다시 도전!'); history.back();</script>");
 }
 %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<link rel="stylesheet" href="/style/style.css?v">
</head>
<body>
	<div id="wrap">
		
	</div>
	<!-- div#wrap -->
	<script src="/script/jquery-3.7.1.min.js"></script>
	<script src="/script/script.js"></script>
</body>
</html>    