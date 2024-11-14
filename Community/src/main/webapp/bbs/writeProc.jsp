<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.dao.BoardMgr" scope="page" />
<%@ page import="java.io.*,javax.servlet.*,javax.servlet.http.*" %>

<%
//Post 방식으로 제출된 form 데이터를 처리하여 DB에 게시글을 저장
//MultipartRequest 객체를 사용하여 파일 업로드 및 데이터를 처리함
String SAVEFOLDER = "E:\\java_Web_AI\\silsp\\jsp\\Community\\src\\main\\webapp\\fileUpload";
int maxSize=10*1024*1024;
String encType = "UTF-8";
	
try {
    // 게시글 정보를 처리하는 메서드 호출
    mMgr.insertBoard(request,response);
    
    // 게시글 작성 완료 후 목록 페이지로 리다이렉트
    response.sendRedirect("/bbs/list.jsp");
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('게시글 작성 중 오류가 발생했습니다.'); history.back();</script>");
}

%>

