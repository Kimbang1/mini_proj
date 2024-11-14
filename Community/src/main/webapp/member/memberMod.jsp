<%@page import="java.util.Arrays"%>
<%@page import="pack.dto.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String uId_Session = (String)session.getAttribute("uId_Session");
%>
<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" />

<%
//out.print(uId_session)
MemberBean mBean = mMgr.modifyMember(uId_Session);
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,	initial-scale=1.0">
<title>회원정보수정</title>
<link rel="stylesheet" href="/style/style_Common.css">
<link rel="stylesheet" href="/style/style_Template.css">
</head>

<body>
	<div id="wrap">
		<!-- 헤더템플릿 시작 -->
		<%@include file="/ind/headerTmp.jsp"%>
		<!-- 헤더템플릿 끝 -->
		<main id="main" class="dFlex">

			<!-- 실제 작업 영역 시작 -->
			<div id="contents" class="joinIsert">
				<form name="regFrm" id="regFrm">
					<table id="regFrmTbl">
    <caption>회원 정보 수정</caption>
    <tbody>
        <!-- 아이디 -->
        <tr>
            <td class="req">아이디</td>
            <td><%= mBean.getuId() %></td>
            <td>&nbsp;</td>
        </tr>

        <!-- 패스워드 -->
        <tr>
            <td class="req">패스워드</td>
            <td>
                <input type="password" name="uPw" id="uPw" maxlength="20">
                <input type="checkbox" id="pwView"> 비밀번호 보기
            </td>
            <td>
                <span>영어소문자/숫자, _, @, $, 5~20</span>
            </td>
        </tr>

        <!-- 패스워드 확인 -->
        <tr>
            <td class="req">패스워드 확인</td>
            <td>
                <input type="password" id="uPw_Re" maxlength="20">
                <span id="pwChk"></span>
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- 이름 -->
        <tr>
            <td class="req">이름</td>
            <td>
                <input type="text" name="uName" id="uName" maxlength="20" value="<%= mBean.getuName() %>">
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- Email -->
        <tr>
            <td class="req">Email</td>
            <td>
                <%
                String uEmail = mBean.getuEmail();
                String uEmail1 = "";
                String uEmail2 = "";

                // uEmail이 null이 아닐 경우에만 @를 기준으로 분리
                if (uEmail != null && !uEmail.isEmpty()) {
                    int idxAt = uEmail.indexOf("@");
                    if (idxAt != -1) {
                        uEmail1 = uEmail.substring(0, idxAt);
                        uEmail2 = uEmail.substring(idxAt + 1);
                    }
                }
                %>
                
                <input type="text" id="uEmail_01" maxlength="20" size="7" value="<%= uEmail1 %>">
                <span>@</span>
                <input type="text" id="uEmail_02" maxlength="40" size="10" value="<%= uEmail2 %>">
                <select id="emailDomain" class="frmDropMenu">
                    <option value="">직접입력</option>
                    <option>naver.com</option>
                    <option>daum.net</option>
                </select>
                <button type="button" id="emailAuthBtn" class="frmBtn">인증코드받기</button>
                <div id="emailAuthArea">
                    <span>인증코드 입력</span>
                    <input type="text" id="emailAuth" size="25">
                    <button type="button" class="frmBtn">인증하기</button>
                </div>
                <input type="hidden" name="uEmail" id="uEmail">
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- 성별 -->
        <tr>
            <td>성별</td>
            <td>
                <%
                    String gender = mBean.getGender();
                    String chkMale = "", chkFemale = "";
                    if (gender != null) {
                        if (gender.equals("1")) chkMale = "checked";
                        else if (gender.equals("2")) chkFemale = "checked";
                    }
                %>
                <label>남 <input type="radio" name="gender" value="1" <%= chkMale %>></label>
                <label>여 <input type="radio" name="gender" value="2" <%= chkFemale %>></label>
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- 생년월일 -->
        <tr>
            <td>생년월일</td>
            <td>
                <input type="text" name="uBirthday" id="uBirthday" maxlength="6" size="8"> &nbsp;&nbsp;&nbsp;&nbsp;
                <span>ex. 830815</span>
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- 우편번호 -->
        <tr>
            <td>우편번호</td>
            <td>
                <input type="text" name="uZipcode" id="uZipcode" maxlength="7" size="7" readonly>
                <button type="button" id="findZipBtn" class="frmBtn">우편번호찾기</button>
            </td>
            <td>
                <span>우편번호 찾기 버튼을 클릭하세요.</span>
            </td>
        </tr>

        <!-- 주소 -->
        <tr>
            <td>주소</td>
            <td>
                <input type="text" name="uAddr" id="uAddr" maxlength="100" size="50">
            </td>
            <td>&nbsp;</td>
        </tr>

        <!-- 취미 -->
        <tr>
            <td>취미</td>
            <%
                String[] uHobby = mBean.getuHobby();
            %>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <script>
                $(function() {
                    let chkBoxAry = <%= Arrays.toString(uHobby) %>;
                    chkBoxAry.forEach((hobby, i) => {
                        if (hobby == "1") {
                            $("input[name=uHobby]").eq(i).prop("checked", true);
                        }
                    });
                });
            </script>
            <td>
                <label>인터넷 <input type="checkbox" name="uHobby" value="인터넷"></label>
                <label>여행 <input type="checkbox" name="uHobby" value="여행"></label>
                <label>게임 <input type="checkbox" name="uHobby" value="게임"></label>
                <label>영화 <input type="checkbox" name="uHobby" value="영화"></label>
                <label>운동 <input type="checkbox" name="uHobby" value="운동"></label>
            </td>
            <td></td>
        </tr>

        <!-- 직업 -->
        <tr>
            <td>직업</td>
            <% String uJob = ""; 
            	if(mBean.getuJob() !=null)uJob = mBean.getuJob();
            %>
            <td>
                <select name="uJob" id="uJob" class="frmDropMenu">
                    <option <% if (uJob.equals("")) out.print("selected"); %>> - 선택 - </option>
                    <option <% if (uJob.equals("교수")) out.print("selected"); %>>교수</option>
                    <option <% if (uJob.equals("학생")) out.print("selected"); %>>학생</option>
                    <option <% if (uJob.equals("회사원")) out.print("selected"); %>>회사원</option>
                    <option <% if (uJob.equals("공무원")) out.print("selected"); %>>공무원</option>
                    <option <% if (uJob.equals("자영업")) out.print("selected"); %>>자영업</option>
                    <option <% if (uJob.equals("전문직")) out.print("selected"); %>>전문직</option>
                    <option <% if (uJob.equals("주부")) out.print("selected"); %>>주부</option>
                    <option <% if (uJob.equals("무직")) out.print("selected"); %>>무직</option>
                </select>
            </td>
            <td></td>
        </tr>

        <!-- 제출 버튼들 -->
        <tr>
            <td colspan="3">
            <!-- 수정후 저장하는 버튼으로 바꾸기 -->
                <button type="button" id="joinSbmBtn" class="frmBtn">회원가입</button>
                <button type="reset" class="frmBtn">다시쓰기</button>
                <button id="loginBtn" class="frmBtn">로그인</button>
            </td>
        </tr>
    </tbody>
</table>
					
				</form>
				<!-- form[name=regFrm] -->
			</div>
			<!-- 실제 작업 영역 끝 -->
		</main>
		<!--푸터템플릿 시작-->
		<%@	include file="/ind/footerTmp.jsp"%>
		<!--푸터템플릿 끝-->
	</div>
	<!-- div#wrap -->
	<script src="/script/script_Join.js"></script>
	
</body>
</html>
