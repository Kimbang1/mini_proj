<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String uId_Session = (String) session.getAttribute("uId_Session");
%>

<%@ page import="pack.dto.BoardBean"%>
<jsp:useBean id="bMgr" class="pack.dao.BoardMgr" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
int numParam = Integer.parseInt(request.getParameter("num"));

//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");

//현재 페이지 돌아가기
String nowPage = request.getParameter("nowPage");

//조회수 증가
bMgr.upCount(numParam);
BoardBean bean = bMgr.getBoard(numParam);
//List.jsp에서 클릭한 게시글의 매개변수로 전달된 글번호 데이터 가져오기

int num = bean.getNum();
String uId = bean.getuId();
String uName = bean.getuName();
String subject = bean.getSubject();
String content = bean.getContent();

int pos = bean.getPos();
int ref = bean.getRef();
int depth = bean.getDepth();
String regTM = bean.getRegTM();
int readCnt = bean.getReadCnt();
String fileName = bean.getFileName();
double fileSize = bean.getFileSize();
String fUnit = "Bytes";
if (fileSize > 1024) {
	fileSize /= 1024;
	fUnit = "KBytes";
}

String ip = bean.getIp();
session.setAttribute("bean", bean);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,	initial-scale=1.0">
<title>글내용 보기</title>
<link rel="stylesheet" href="/style/style_Common.css">
<link rel="stylesheet" href="/style/style_Template.css">
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/source/jquery-3.6.0.min.js"></script>
<script src="/script/script_BBS.js"></script>
</head>
<body>
	<div id="wrap">
		<!--헤더템플릿	시작-->
		<%@	include file="/ind/headerTmp.jsp"%>
		<!--헤더템플릿	끝-->
		
		<main id="main" class="dFlex">
			
			<div id="lnb">
				<!-- 메인 LNB 템플릿 시작 -->
				<%@ include file="/ind/mainLnbTmp.jsp"%>
				<!-- 메인 LNB 템플릿 끝 -->
			</div>
			<!-- 실제 작업 영역 시작 -->
			<div id="contents" class="bbsRead">
			<!-- 게시글 상세보기 페이지 내용 출력 시작 -->
			<h2><%=subject %></h2>
				 
				 <table id="readTbl">
				 	<tbody id="readTblBody">
				 		<tr>
				 			<td>작성자</td>
				 			<td><%=uName %></td>
				 			<td>등록일</td>
				 			<td><%=regTM %></td>
				 		</tr>
				 		<tr>
				 			<td>첨부파일</td>
				 			<td colspan="3">
				 				<input type="hidden" name="fileName" value="<%=fileName%>" id="hiddenFname">
				 				<% if (fileName != null && !fileName.equals("")) {%>
				 				<span id="downloadFile"><%=fileName %></span>
				 				(<span><%=(int)fileSize + " " + fUnit %></span>)
				 				<%} else{ %>
				 				등록된 파일이 없습니다.
				 				<%} %>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td colspan="4" id="readCountentTd"><pre><%=content %></pre></td>
				 		</tr>
				 	</tbody>
				 	
				 	<tfoot id="readTblFoot">
				 	<tr>
				 		<td colspan="4" id="footTopSapce"></td>
				 	</tr>
				 	<tr>
				 		<td colspan="4" id="articleInfoTd">
				 		<span><%="조회수 : " +readCnt %></span>
				 		<span>(<%="IP : " + ip %>)</span>
				 		</td>
				 	</tr>
				 	<tr>
				 		<td colspan="4" id="hrTd"><hr></td>
				 	</tr>
				 	
				 	<tr>
				 	<%
				 	String listBtnLabel = "";
				 	if(keyWord.equals("null")|| !keyWord.equals("")){
				 		listBtnLabel = "리스트";
				 	}else{
				 		listBtnLabel = "검색목록";
				 	}
				 	%>
				 		<td colspan="4" id="btnAreaTd" class="read">
				 		<button type="button" id="listBtn"><%=listBtnLabel %></button>
				 		<button type="button" id="replyBtn">답변</button>
				 		<%
				 		if(uId_Session != null && uId_Session.equals(uId)){
				 		%>
				 		<button id="modBtn" type="button">수정</button>	
				 		<button id="delBtn" type="button">삭제</button>	
				 		
				 		<% }%>
				 	
				 		</td>
				 	</tr>
				 </tfoot>
				 </table>
				<input type="hidden" name="nowPage" value="<%=nowPage %>" id="nowpage">
				<input type="hidden" name="num" value="<%=num %>" id="num">
				
				<!-- 검색어전송 시작 -->
				<input type="hidden" value="<%=keyField %>" id="pkeyField">
				<input type="hidden" value="<%=keyWord %>" id="keyWord">
				<!-- 검색어전송 끝 -->
				
				<!-- 게시글 상세보기페이지 내용 출력 끝 -->
			</div>
			<!-- 실제 작업영역 끝 -->
		</main>
		<!-- main#main -->
		
			<!-- 푸터 템플릿 시작 -->
				<%@ include file="/ind/footerTmp.jsp" %>
			<!-- 푸터 템플릿 끝 -->
	</div>
	<!-- div#wrap -->

</body>
</html>
