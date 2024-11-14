package pack.dao;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import pack.dbcp.DBCP;
import pack.dto.BoardBean;

public class BoardMgr {

	Connection conn = null;
	Statement stmt = null; // Select 역할
	PreparedStatement pstmt = null; // 입력, 삭제, 수정 역할
	ResultSet rs = null; // 결과값 가져오기

	private static final String SAVEFOLDER = "E:\\java_Web_AI\\silsp\\jsp\\Community\\src\\main\\webapp\\fileUpload";
	private static String encType = "UTF-8";
	private static int maxSize = 10 * 1024 * 1024;

//	게시판 입력(/bbs/writeProc.jsp)시작
	public void insertBoard(HttpServletRequest req, HttpServletResponse res) throws Exception {
	    String sql = null;
	    MultipartRequest multi = null;
	    int fileSize = 0;
	    String fileName = null;

	    try {
	        conn = DBCP.mtdConn();
	        sql = "select max(num) from tblBoard";
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        int ref = 1; // 답변글 작성용, 원본글의 글번호(num)와 일치
	        if (rs.next())
	            ref = rs.getInt(1) + 1;

	        File file = new File(SAVEFOLDER);
	        if (!file.exists())
	            file.mkdirs();

	        multi = new MultipartRequest(req, SAVEFOLDER, maxSize, encType, new DefaultFileRenamePolicy());

	        if (multi.getFilesystemName("fileName") != null) {
	            fileName = multi.getFilesystemName("fileName");
	            fileSize = (int) multi.getFile("fileName").length();
	        }

	        String content = multi.getParameter("content");

	        if (multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
	            content = content.replace("<", "&lt");
	        }

	        sql = "insert into tblBoard ( ";
	        sql += "uId, uName, subject, content, ref, pos, depth, ";
	        sql += "regTM, ip, readCnt,	fileName, fileSize ) values (";
	        sql += "?,?,?,?,?,0,0,now(),?,0,?,?)";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, multi.getParameter("uId"));
	        pstmt.setString(2, multi.getParameter("uName"));
	        pstmt.setString(3, multi.getParameter("subject"));
	        pstmt.setString(4, content);
	        pstmt.setInt(5, ref);
	        pstmt.setString(6, multi.getParameter("ip"));
	        pstmt.setString(7, fileName);
	        pstmt.setInt(8, fileSize);
	        pstmt.executeUpdate();

	        // 삽입 후 리다이렉트 처리
	        res.sendRedirect("/bbs/list.jsp");

	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        throw new Exception("게시글 삽입 실패", e);
	    } finally {
	        try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
	        try { pstmt.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
	    }
	}
//	게시판 입력(/bbs/writeProc.jsp)끝

	// 게시판 리스트 출력(/bbs/list.jsp)시작
	public Vector<BoardBean> getBoardList(String keyField, String keyWord, int start, int end) {
		Vector<BoardBean> vList = new Vector<>();
		String sql = null;

		try {
			conn = DBCP.mtdConn();

			if (keyWord.equals("null") || keyWord.equals("")) {

				// 검색어가 없을 경우
				sql = "select * from tblBoard" + "order by ref desc, pos asc limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				// 검색어가 있을 경우
				sql = "select * from tblBoard" + "where" + keyField + "like ?"
						+ "order by ref desc, pos asc limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%" + keyWord + "%");
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {
				BoardBean bean = new BoardBean();
				bean.setNum(rs.getInt("num"));
				bean.setuName(rs.getString("uName"));
				bean.setSubject(rs.getString("subject"));
				bean.setPos(rs.getInt("pos"));
				bean.setRef(rs.getInt("ref"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegTM(rs.getString("regTM"));
				bean.setReadCnt(rs.getInt("readCnt"));
				vList.add(bean);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return vList;
	}

	// 게시판 리스트 출력(/bbs/list.jsp)끝

	// 총 게시물 수(/bbs/list.jsp) 시작
	public int getTotalCount(String keyField, String keyWord) {
		
		String sql = null;
		int totalCnt = 0;
		
		try {
			conn = DBCP.mtdConn();
			
			if(keyWord.equals("null")||keyWord.equals("")) {
				
				sql="select count(*) from tblBoard";
				pstmt =conn.prepareStatement(sql);
				
			}else {
				sql = "select count(*) from tblBoard";
				sql += "where" + keyField + "like ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,"%"+keyWord+"%");
			}
			rs = pstmt.executeQuery();
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return totalCnt;
	}

	// 총 게시물 수(/bbs/list.jsp) 끝
	
	//게시판 뷰페이지 조회수 증가 시작(/bbs/read.jsp,내용보기 페이지)	
	
	public void upCount(int num) {
		String sql = null;
		try {
			conn = DBCP.mtdConn();
			sql = "update tblBoard set readCnt = readCont+1 where num=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.execute();
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
	
	}
	
	//게시판 뷰페이지 조회수 증가 끝(/bbs/read.jsp,내용보기 페이지)
	
	//상세보기 페이지 게시글 출력 시작(/bbs/read.jsp,내용보기 페이지)
	
	public BoardBean getBoard(int num) {
		String sql = null;
		
		BoardBean bean = new BoardBean();
		try {
			conn = DBCP.mtdConn();
			sql = "select * from tblBoard where num=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				 bean.setNum(rs.getInt("num"));
				 bean.setuId(rs.getString("uId"));
				 bean.setuName(rs.getString("uName"));
				 bean.setSubject(rs.getString("subject"));
				 bean.setContent(rs.getString("content"));
				 bean.setPos(rs.getInt("pos"));
				 bean.setRef(rs.getInt("ref"));
				 bean.setDepth(rs.getInt("depth"));
				 bean.setRegTM(rs.getString("regTM"));
				 bean.setReadCnt(rs.getInt("readCnt"));
				 bean.setFileName(rs.getString("fileName"));
				 bean.setFileSize(rs.getInt("fileSize"));
				 bean.setIp(rs.getString("ip"));
			}
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return bean;
	}
	
	//상세보기 페이지 게시글 출력 끝(/bbs/read.jsp,내용보기 페이지)
	
	
	//상세보기 페이지 파일다운로드 시작(/bbs/read.jsp)

	public class FileDownloader {

	    private static final String SAVEFOLDER = "/path/to/savefolder"; // 저장 폴더 경로 설정

	    public void downLoad(HttpServletRequest req, HttpServletResponse res) {
	        String fileName = req.getParameter("fileName");
	        
	        try {
	            File file = new File(SAVEFOLDER + File.separator + fileName);

	            if (!file.exists() || !file.isFile()) {
	                throw new FileNotFoundException("Requested file not found.");
	            }

	            byte[] buffer = new byte[4096];
	            res.setHeader("Accept-Ranges", "bytes");
	            res.setContentType("application/octet-stream");
	            res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

	            try (BufferedInputStream fIn = new BufferedInputStream(new FileInputStream(file));
	                 BufferedOutputStream fOut = new BufferedOutputStream(res.getOutputStream())) {

	                int bytesRead;
	                while ((bytesRead = fIn.read(buffer)) != -1) {
	                    fOut.write(buffer, 0, bytesRead);
	                }
	                fOut.flush();
	            }
	        } catch (Exception e) {
	            System.out.println("파일 처리 오류: " + e.getMessage());
	        }
	    }
	}
	///////// 변경 사항//////////////////
	//JspWriter 및 PageContext 제거: JspWriter나 PageContext를 사용하지 않고, HttpServletResponse의 getOutputStream()을 통해 파일을 전송하도록 변경했습니다.
	//파일 다운로드 경로 설정: SAVEFOLDER 경로를 설정하고, 요청된 파일 이름에 따라 해당 파일을 찾도록 했습니다.
	//에러 처리 및 파일 존재 여부 확인: 파일이 존재하지 않을 경우 예외를 발생시켜 오류를 처리합니다.
	
	
	//상세보기 페이지 파일다운로드 끝(/bbs/read.jsp)
	
	//게시글 삭제(/bbs/delete.jsp)시작
	public int deleteBoard(int num) {
	    String sql;
	    int exeCnt = 0;

	    try {
	        conn = DBCP.mtdConn();

	        // 게시글의 파일 삭제 시작
	        sql = "select fileName from tblBoard where num = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        rs = pstmt.executeQuery();

	        if (rs.next() && rs.getString(1) != null) {
	            String fName = rs.getString(1);
	            if (!fName.isEmpty()) {
	                String fileSrc = SAVEFOLDER + "/" + fName;
	                File file = new File(fileSrc);

	                if (file.exists()) {
	                    file.delete(); // 파일 삭제 실행
	                }
	            }
	        }
	        rs.close();
	        pstmt.close();
	        // 게시글의 파일 삭제 끝

	        // 게시글 삭제 시작
	        sql = "delete from tblBoard where num = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        exeCnt = pstmt.executeUpdate();

	    } catch (Exception e) {
	        System.out.println("파일 처리 이슈: " + e.getMessage());
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception ex) {
	            System.out.println("자원 정리 오류: " + ex.getMessage());
	        }
	    }
	    return exeCnt;
	
	}
	//게시글 삭제(/bbs/delete.jsp)끝
	
	//게시글 수정페이지(/bbs/updateProc.jsp) 시작
	public int updateBoard(BoardBean bean) {
		
		String sql = null;
		int exeCnt =0;
		
		try {
			
			conn =DBCP.mtdConn();
			sql = "update tblBoard set uName=?, Subject=?, content=? where num=?"; 
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, bean.getuName());
			pstmt.setString(2, bean.getSubject());
			pstmt.setString(3, bean.getContent());
			pstmt.setInt(4, bean.getNum());
			exeCnt = pstmt.executeUpdate();
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
		return	exeCnt;
	}
	
	//게시글 수정페이지(/bbs/updateProc.jsp) 끝

	//게시글 답변페이지(/bbs/replyProc.jsp)시작

	public int replyBoard(BoardBean bean) {
		
		String sql = null;
		int cnt =0;
		
		try {
			conn = DBCP.mtdConn();
			
			sql = "insert into tblBoard (";
			sql += "uName, content, subject, ";
			sql += "ref, pos, depth, ";
			sql += "regTM, readCnt, ip) values ( ";
			sql += "?,?,?,?,?,?, now(), 0, ?";
			
			int depth = bean.getDepth() + 1;
			int pos = bean.getPos() + 1;
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,bean.getuName());
			pstmt.setString(2,bean.getContent());
			pstmt.setString(3,bean.getSubject());
			pstmt.setInt(4, bean.getRef());
			pstmt.setInt(5,pos);
			pstmt.setInt(6, depth);
			pstmt.setString(7,bean.getIp());
			cnt = pstmt.executeUpdate();
			
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
	return cnt;
	}
	//게시글 답변페이지(/bbs/replyProc.jsp)끝
	
	//답변글 끼어들기 시작(/bbs/replyProc.jsp)
	public int replyUpBoard(int ref, int pos) {
		
		String sql = null;
		int cnt = 0;
		
		try {
			conn = DBCP.mtdConn();
			
			///// 게시글의 포지션 증가 시작//////
			sql = "update tblBoard set pos = pos +1";
			sql += "where ref = ? and pos >?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,ref);
			pstmt.setInt(2,pos);
			cnt = pstmt.executeUpdate();
					
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
	return cnt;
	}
	//답변글 끼어들기 끝(/bbs/replyProc.jsp)
	
	
	//다운로드 작업시작(/bbs/download.jsp)
	public void downLoad(HttpServletRequest req, HttpServletResponse res, JspWriter out, PageContext pageContent) {
			
		String fileName = req.getParameter("fileName");
		String filePath = "/your/file/path/" + fileName;	//파일 경로 설정
		File file = new File(filePath);
		
		if (file.exists()) {
            res.setContentType("application/octet-stream");
            try {
                res.setHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");
            }catch(IOException e) {
            	e.printStackTrace();
            }try (FileInputStream fileIn = new FileInputStream(file); OutputStream outStream = res.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileIn.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            try {
                out.println("<script>alert('File not found');history.back();</script>");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
            
	}	//다운로드 작업끝(/bbs/download.jsp)
	
	//글 수정 처리페이지 구현 시작(/bbs/modifyProc.jsp)
	public boolean updateBoard(int num, String uName, String uId, String subject, String content, String contentType, String fileName, String ip ) {
		
		boolean result = false;
		Connection conn = null;
		
		
		try {
			conn = DBCP.mtdConn();
			String sql = "update board set subject=?, content=?, contentType=?, fileName=?, ip=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, subject);
	        pstmt.setString(2, content);
	        pstmt.setString(3, contentType);
	        pstmt.setString(4, fileName);
	        pstmt.setString(5, ip);
	        pstmt.setInt(6, num);

	        int rows = pstmt.executeUpdate();
	        result = (rows > 0);
			
		}catch(Exception e) {
			e.getMessage();	
		}finally {
			try {conn.close();} catch (Exception ex) {System.out.println(ex.getMessage());}
			try { pstmt.close();}catch(Exception ex) {System.out.println(ex.getMessage());}
			try { conn.close(); } catch (Exception ex) { System.out.println(ex.getMessage()); }
		}
	return result;
	}	
	
	//글 수정 처리페이지 구현 끝(/bbs/modifyProc.jsp)
	
	}
	
	
