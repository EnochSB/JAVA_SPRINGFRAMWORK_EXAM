package com.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.BoardDAO;
import com.board.dto.AddressDTO;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDAO dao;
	
	// 리스트
	@Override
	public List<AddressDTO> list(int startPoint, int postNum, String keyword) {
		return dao.list(startPoint, postNum, keyword);
	}
	// 검색 갯수
	@Override
	public int getTotalCount(String keyword) {
		return dao.getTotalCount(keyword);
	};
}
