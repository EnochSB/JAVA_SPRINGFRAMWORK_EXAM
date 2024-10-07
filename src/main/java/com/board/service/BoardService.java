package com.board.service;

import java.util.List;

import com.board.dto.AddressDTO;

public interface BoardService {
	// 게시물 리스트
	public List<AddressDTO> list(int startPoint, int postNum, String keyword);
	
	// 검색 갯수
	public int getTotalCount(String keyword);
}
