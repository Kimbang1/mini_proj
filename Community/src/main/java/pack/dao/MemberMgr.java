package pack.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.Vector;

import pack.dbcp.DBCP;
import pack.dto.MemberBean;
import pack.dto.ZipcodeBean;

public class MemberMgr {

	Connection conn = null;
	Statement stmt = null; // Select 역할
	PreparedStatement pstmt = null; // 입력, 삭제, 수정 역할
	ResultSet objRS = null; // 결과값 가져오기
	 
	
	
	/* 아이디 중복 검사 시작(/member/idCheck.jsp) */
	public boolean checkId(String id) {
		boolean res = false; // true면 입력한 ID는 사용불가, false면 사용가능
		try {
			
			conn = DBCP.mtdConn(); // DBCP 클래스를 직접 호출
			String sql = "select count(*) from member where uId =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			objRS = pstmt.executeQuery();
			if (objRS.next()) {
				int recordCnt = objRS.getInt(1);
				if (recordCnt == 1) res = true;
			}
		} catch (Exception e) {
			System.out.println("오류발생 : " + e.getMessage());
		} finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return res;
	}
	/* 아이디 중복 검사 끝 */

	/* 우편번호 찾기 시작(/member/zipCheck.jsp) */
	public List<ZipcodeBean> zipcodeRead(String area3) {
		List<ZipcodeBean> objList = new Vector<>();
		try {
			conn = DBCP.mtdConn();
			String sql = "select zipcode, area1, area2, area3, area4 from tblZipcode where area3 like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + area3 + "%");
			objRS = pstmt.executeQuery();
			while (objRS.next()) {
				ZipcodeBean zipBean = new ZipcodeBean();
				zipBean.setZipcode(objRS.getString(1));
				zipBean.setArea1(objRS.getString(2));
				zipBean.setArea2(objRS.getString(3));
				zipBean.setArea3(objRS.getString(4));
				zipBean.setArea4(objRS.getString(5));
				objList.add(zipBean);
			}
		} catch (Exception e) {
			System.out.println("오류발생 : " + e.getMessage());
		} finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return objList;
	}
	/* 우편번호 찾기 끝 */

	/* 회원가입 시작(/member/memberProc.jsp) */
	public boolean insertMember(MemberBean bean) {
	    boolean flag = false;
	    try {
	        conn = DBCP.mtdConn();
	        
	        // joinTM은 now()로 자동 설정되므로 ?를 제외하고 8개만 설정
	        String sql = "insert into member (uId, uPw, uName, uEmail, gender, uBirthday, uZipcode, uAddr, uHobby, uJob) "
	                     + "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";  // 9개의 ?로 설정됨, 실제는 8개만 필요함
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, bean.getuId());
	        pstmt.setString(2, bean.getuPw());
	        pstmt.setString(3, bean.getuName());
	        pstmt.setString(4, bean.getuEmail());
	        pstmt.setString(5, bean.getGender());
	        pstmt.setString(6, bean.getuBirthday());
	        pstmt.setString(7, bean.getuZipcode());
	        pstmt.setString(8, bean.getuAddr());

	        // 취미 설정
	        String[] hobby = bean.getuHobby();
	        String[] hobbyName = {"인터넷", "여행", "게임", "영화", "운동"};
	        char[] hobbyCode = {'0', '0', '0', '0', '0'};
	        for (int i = 0; i < hobby.length; i++) {
	            for (int j = 0; j < hobbyName.length; j++) {
	                if (hobby[i].equals(hobbyName[j])) {
	                    hobbyCode[j] = '1';
	                }
	            }
	        }

	        pstmt.setString(9, new String(hobbyCode));  // 9번째 매개변수: 취미
	        pstmt.setString(10, bean.getuJob());  // 10번째 매개변수: 직업

	        int rowCnt = pstmt.executeUpdate();
	        if (rowCnt > 0) flag = true;
	    } catch (Exception e) {
	        System.out.println("오류발생 : " + e.getMessage());
	    } finally {
	        try { pstmt.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
	        try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
	    }
	    return flag;
	}
	/* 회원가입 끝 */

	/* 로그인 처리 시작(/member/loginProc.jsp) */
	public boolean loginMember(String id, String pw) {
		boolean loginChkTF = false;
		try {
			conn = DBCP.mtdConn();
			String sql = "select count(*) from member where uId = ? and uPw = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			objRS = pstmt.executeQuery();
			if (objRS.next()) {
				int recordCnt = objRS.getInt(1);
				if (recordCnt == 1) loginChkTF = true;
				System.out.println("아이디: " + id);
				System.out.println("비밀번호: " + pw);
			}
		} catch (Exception e) {
			System.out.println("오류발생 : " + e.getMessage());
			
		} finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		System.out.println("retutn :" +loginChkTF);
		return loginChkTF;
	}
	/* 로그인 처리 끝 */

	/* 회원정보 수정 시작(/member/memberModProc.jsp) */
	public MemberBean modifyMember(String id) {
		MemberBean mBean = new MemberBean();
		try {
			conn = DBCP.mtdConn();
			String sql = "select uId, uPw, uName, uEmail, gender, uBirthday, uZipcode, uAddr, uHobby, uJob from member where uId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			objRS = pstmt.executeQuery();
			if (objRS.next()) {
				mBean.setuId(objRS.getString("uId"));
				mBean.setuPw(objRS.getString("uPw"));
				mBean.setuName(objRS.getString("uName"));
				mBean.setuEmail(objRS.getString("uEmail"));
				mBean.setGender(objRS.getString("gender"));
				mBean.setuBirthday(objRS.getString("uBirthday"));
				mBean.setuZipcode(objRS.getString("uZipcode"));
				mBean.setuAddr(objRS.getString("uAddr"));
				mBean.setuHobby(objRS.getString("uHobby").split(""));
				mBean.setuJob(objRS.getString("uJob"));
			}
		} catch (Exception e) {
			System.out.println("오류발생 : " + e.getMessage());
		} finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return mBean;
	}
	/* 회원정보 수정 끝 */

	/* 회원탈퇴 시작*/
	
	public boolean deleteMember(String uId) {
		boolean flag = false;
		try {
			conn = DBCP.mtdConn();
			String sql="delete from member where uId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,uId);
			int rowCnt = pstmt.executeUpdate();
			if(rowCnt > 0) {
				flag = true;
			}
			}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return flag;
	}
	
	/* 회원탈퇴 끝*/
	
	/* 로그인 사용자 이름 반환 시작(/member/write.jsp) */
	public String getMemberName(String uId) {
		String uName = "";
		try {
			conn = DBCP.mtdConn();
			String sql = "select uName from member where uId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uId);
			objRS = pstmt.executeQuery();
			if (objRS.next()) {
				uName = objRS.getString(1);
			}
		} catch (Exception e) {
			System.out.println("오류발생 : " + e.getMessage());
		} finally {
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return uName;
	}
	/* 로그인 사용자 이름 반환 끝 */
}
