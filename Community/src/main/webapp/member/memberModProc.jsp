<%@page import="pack.dto.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" />
<jsp:useBean id="mBean" class="pack.dto.MemberBean" />
<jsp:setProperty name="mBean" property="*" />

<% 
request.setCharacterEncoding("UTF-8");

//회원 정보를 수정하고 결과를 반환받음 (MemberBean 객체 또는 null)
MemberBean joinRes = mMgr.modifyMember(mBean.getuId()); 
//회원 데이터가 성공적으로 조회되었는지 확인
boolean isModified = (joinRes != null);

%>

<script>
<% if(isModified) { %>
	alert("정보를 수정하셨습니다");
	location.href="/index.jsp";
<% }else{ %>
	alert("회원정보 수정 중 문제가 발생했습니다. 다시 시도해주세요.\n 만일 문제가 계속될 경우 고객센터(02-1234-5678)로 연락해주세요.")
	history.back();
<%}%>
</script>
   