package com.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.board.dto.BoardDTO;
import com.board.service.BoardService;

@RestController
public class BoardRestController {
	
	@Autowired
	BoardService service;
	
	// 게시물 전체 목록 보기
	@GetMapping("/board/listAll")
	public List<BoardDTO> getList() throws Exception {
		return service.listAll();
	}
}
