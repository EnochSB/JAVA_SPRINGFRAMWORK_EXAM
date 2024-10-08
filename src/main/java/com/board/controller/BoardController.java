package com.board.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.board.dto.BoardDTO;
import com.board.dto.FileDTO;
import com.board.service.BoardService;
import com.board.util.Page;

@Controller
public class BoardController {
	
	@Autowired
	BoardService service;
	
	// JdbcTemplate 사용응 위한 의존성 주입
	private JdbcTemplate jdbcTemplate;
	public BoardController(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	// 게시물 목록 보기
	@GetMapping("/board/list")
	public void getList(
			@RequestParam(name="keyword",defaultValue="",required=false)
			String keyword,
			@RequestParam("page")
			int pageNum,
			Model model
			) throws Exception {
		
		int postNum = 10; // 한 페이지에 출력할 데이터 갯수
		int startPoint = (pageNum - 1)*postNum; // 테이블에서 읽어 올 행의 위치. 0부터 시작.
		// 1페이지: 0~4, 2페이지: 5~9,... => 0, 5, 10 ...이 startPoint에 들어가야함. 
		int pagelistCount = 10; // 한 번에 보여줄 페이지 리스트의 페이지 갯수.
		
		Page page = new Page();
		
		model.addAttribute("list", service.list(startPoint, postNum, keyword));
		model.addAttribute("page", pageNum);
		model.addAttribute("keyword", keyword);
		model.addAttribute("pageList", page.getPageList(pageNum, postNum, pagelistCount, service.getTotalCount(keyword), keyword));
		}
	
	// 게시물 등록 페이지 보기
	@GetMapping("/board/write")
	public void getWrite() {}
	
	// 게시물 수정 화면 보기
	@GetMapping("/board/modify")
	public void getModify(
			Model model,
			@RequestParam("seqno")
			int seqno,
			@RequestParam("page")
			int pageNum,
			@RequestParam(name="keyword",required=false)
			String keyword
			) throws Exception{
		
		model.addAttribute("view", service.view(seqno));
		model.addAttribute("page", pageNum);
		model.addAttribute("keyword", keyword);
		model.addAttribute("fileListView", service.fileListView(seqno));
	}
	
	// 게시물 등록
	@ResponseBody
	@PostMapping("/board/write")
	public String postWrite(
			BoardDTO board,
			@RequestParam(name="sendToFileList",required=false)
			List<MultipartFile> multipartFile,
			@RequestParam("kind")
			String kind,
			@RequestParam(name="deleteFileList",required=false)
			int[] deleteFileList
			) throws Exception {
		
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정
		String os = System.getProperty("os.name").toLowerCase();
		String path;
		if(os.contains("win")) {
			path ="c:\\Repository\\file\\";
		} else {
			path = "/home/hasb/Repository/file";
		}
		
		// 디렉토리가 존재하는지 체크 없다면 생성
		File p = new File(path);
		if(!p.exists()) {
			p.mkdir();
		}
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정 종료
		
		int seqno=0;
		
		// 게시물 등록
		if(kind.equals("I")) {
			service.write(board);
			seqno = service.getMaxSeqno(board.getUserid());	// 해당 userid가 등록한 최신 게시물의 seqno
			System.out.println("게시물 등록됨");
		}
		
		// 게시물 수정
		if(kind.equals("U")) {
			seqno = board.getSeqno();
			service.modify(board);
			if(deleteFileList != null) {
				for(int i=0; i<deleteFileList.length; i++) {
					// tbl_file에서 수정시 선택한 첨부 파일의 checkfile을 'N'으로 변경
					Map<String,Object> data = new HashMap<>();
					data.put("kind", "F");
					data.put("fileseqno", deleteFileList[i]);
					service.deleteFileList(data);
				}
			}
		}
		
		// 첨부파일이 들어왔을 때
		if(!multipartFile.isEmpty()) {
			System.out.println("파일 업로드 시작");
			File targetFile = null;
			Map<String, Object> fileInfo = null;
			
			// 각 첨부파일 파일명 변경(확장자는 유지)
			for(MultipartFile mpr:multipartFile) {
				
				String org_filename = mpr.getOriginalFilename();
				// .을 포함한 다음 문자열만 리턴 예) test.txt => '.txt'를 리턴
				String org_fileExtension = org_filename.substring(org_filename.lastIndexOf('.'));
				String stored_filename = UUID.randomUUID().toString().replaceAll("-","") + org_fileExtension;
				
				targetFile = new File(path + stored_filename);
				mpr.transferTo(targetFile); // MultipartFile 이라는 MiME Type의 데이터를 파일로 변환해 저장
				
				fileInfo = new HashMap<>();
				fileInfo.put("org_filename", org_filename);
				fileInfo.put("stored_filename", stored_filename);
				fileInfo.put("filesize", mpr.getSize());
				// insert: service.getMaxSeqno(board.getUserid())에서 리턴된 값. 작성자가 작성한 최신 게시물의 seqno
				fileInfo.put("seqno", seqno);
				fileInfo.put("userid", board.getUserid());
				service.fileInfoRegistry(fileInfo);
				System.out.println("파일 업로드 완료");
			}
		}
		return "{\"message\":\"good\"}";
	}
	
	// 게시물 상세 보기
	@GetMapping("/board/view")
	public void getView(
			Model model,
			@RequestParam("seqno")
			int seqno,
			@RequestParam("page")
			int pageNum,
			@RequestParam(name="keyword",defaultValue="",required=false)
			String keyword,
			HttpSession session
			) throws Exception {
		// 게시물 조회수 증가, 게시물을 쓴 작성자의 아이디와 전체 로그인 중인 사람의 아이디를 비교해 본인이 슨 게시물은 상세 보기를 해도 증가 안됨.
		
		BoardDTO view = service.view(seqno);	// view.getUserid() => 게시물을 작성한 사람의 아이디
		String SessionUserid = (String)session.getAttribute("userid");	// 현재 로그인 중인 사람의 아이디
		
		// 조회수 증가
		if(!SessionUserid.equals(view.getUserid()))
			service.hitno(seqno);
		
		model.addAttribute("view", service.view(seqno));
		model.addAttribute("page", pageNum);
		model.addAttribute("keyword", keyword);
		model.addAttribute("pre_seqno", service.pre_seqno(seqno, keyword));
		model.addAttribute("next_seqno", service.next_seqno(seqno, keyword));
		model.addAttribute("fileListView", service.fileListView(seqno));
	}
	
	// 게시물 삭제
	@GetMapping("/board/deleteBoard")
	public String getDeleteBoard(
			@RequestParam("seqno")
			int seqno
			) throws Exception {
		
		Map<String,Object> data = new HashMap<>();
		data.put("kind", "B");	// 게시물 삭제. 게시물에 포함된 모든 첨부 파일 삭제
		data.put("seqno", seqno);
		
		// tbl_file에서 checkfile을 'N'으로 설정
		service.deleteFileList(data);
		
		// tbl_board에서 게시물을 삭제
		service.deleteBoard(seqno);
		
		return "redirect:/board/list?page=1";
	}
	
	
	// 파일 다운로드
	@GetMapping("/board/fileDownload")
	public void getFileDownload(
			@RequestParam("fileseqno")
			int fileseqno,
			HttpServletResponse rs
			) throws Exception {
		
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정
		String os = System.getProperty("os.name").toLowerCase();
		String path;
		if(os.contains("win")) {
			path ="c:\\Repository\\file\\";
		} else {
			path = "/home/hasb/Repository/file";
		}
		
		// 디렉토리가 존재하는지 체크 없다면 생성
		File p = new File(path);
		if(!p.exists()) p.mkdir();
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정 종료
		
		FileDTO fileInfo = service.fileInfo(fileseqno);
		
		// commons-io 라이브러리의 readFileToByteArray
		// 다운로드할 경로 + 파일명을 매개변수로 입력 받아 byte 데이터타입의 1차원 배열로 저장
		byte[] fileByte = FileUtils.readFileToByteArray(new File(path + fileInfo.getStored_filename()));
		
		// 예) HTTP Response Header => Content-Disposition: aattachment; filename="sample.jpg";
		// HTTP Response Body => 1차원 Byte 타입으로 변환된 배열
		rs.setContentType("application/octect-stream");
		rs.setContentLength(fileByte.length);
		rs.setHeader(
				"Content-Disposition", 
				"attachment; filename=\"" +
				URLEncoder.encode(fileInfo.getOrg_filename(), "UTF-8") +
				"\";"
				);
		rs.getOutputStream().write(fileByte);	// stream을 통해 1차원 byte타입 배열로 변환된 데이터(추후 파일로 변환)를 Buffer에 저장
		rs.getOutputStream().flush(); // 버퍼에 있는 애용을 write
		rs.getOutputStream().close(); // 스트림 닫기
	}
	
	// 테스트용 게시물 만들기
	@GetMapping("/board/boardmaker")
	public void getBoardMaker() {}
	
	@ResponseBody
	@PostMapping("/board/boardmaker")
	public String postBoardMaker() {
		String sql = "insert into tbl_board (userid,writer,title,content) values (?,?,?,?)";
		
		int i;
		for(i=1; i<=300; i++) {
			String content = (i%2==0)?"날씨 좋아":"날씨 나빠";
			jdbcTemplate.update(sql, "gktjd425", "하성범", "나는 테스트" + i + "번", content);
			
		}
		return "{\"message\":\"good\",\"counter\":\"" + (i-1) + "\"}";
	}
}
