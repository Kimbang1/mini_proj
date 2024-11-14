<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" />
<jsp:useBean id="mBean" class="pack.dto.MemberBean" />
<jsp:setProperty name="mBean" property="*" />

<%
    String uId_Session = (String) session.getAttribute("uId_Session");  // 세션에서 uId 가져오기

    if (uId_Session == null || uId_Session.isEmpty()) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='/login.jsp';</script>");
    } else {
        // 회원 탈퇴 처리
        boolean result = mMgr.deleteMember(uId_Session);  // MemberMgr의 삭제 메서드 호출

        if (result) {
            session.invalidate();  // 세션 삭제
            out.println("<script>alert('회원탈퇴가 완료되었습니다.'); location.href='/index.jsp';</script>");
        } else {
            out.println("<script>alert('회원탈퇴에 실패했습니다. 다시 시도해 주세요.'); history.back();</script>");
        }
    }
%>
