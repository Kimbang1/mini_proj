<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="bMgr" class="pack.dao.BoardMgr" scope="page" />
<jsp:useBean id="reBean" class="pack.dto.BoardBean" scope="page" />
<jsp:setProperty name="reBean" property="*" />

<%
int repUpCnt = bMgr.replyUpBoard(reBean.getRef(), reBean.getPos());
//답변 글 끼어들기가 아닐 경우 실행되는	소스 없음.
int repInsCnt = bMgr.replyBoard(reBean);
String nowPage = request.getParameter("nowPage");
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
%>

<script>
<%
if(repInsCnt > 0){ // replayUpBoard( )와 replayBoard() 가 정상실행되었음을 의미함.
	
	String url = "/bbs/list.jsp?nowPage="+nowPage;
		   url += "&keyField="+keyField;
		   url += "&keyWord="+keyWord;
%>
location.href="<%=url%>";
<%
}else{
%>
let msg = "답변글 등록중 오류가 발생했습니다.\n";
   msg += "다시 시도하시길 바랍니다.\n";
   msg += "오류가 지속되면 관리자에게 연락 바랍니다.";
alert(msg);
history.back();
<%}%>
</script>
