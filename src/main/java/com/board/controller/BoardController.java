package com.board.controller;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	
	// 주소 검색
	@GetMapping("/board/list")
	public void getList(
			@RequestParam(name="keyword",defaultValue="",required=false) String keyword,
			@RequestParam("page") int pageNum,
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
		model.addAttribute("pageListView", page.getPageList(pageNum, postNum, pagelistCount, service.getTotalCount(keyword), keyword));
		}
	
	// 게시물 등록 페이지 보기
	@GetMapping("/board/write")
	public void getWrite() {}
	
	// 게시물 등록
	@ResponseBody
	@PostMapping("/board/write")
	
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
