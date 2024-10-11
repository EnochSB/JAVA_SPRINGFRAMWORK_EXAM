package com.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.MasterDAO;
import com.board.dto.FileDTO;

@Service
public class MasterServiceImpl implements MasterService {
	
	@Autowired
	private MasterDAO dao;
	
	// 삭제된 게시물 리스트 보기
	@Override
	public List<FileDTO> fileDeleteList() {
		return dao.fileDeleteList();
	}
	
	// tbl_file 내 데이터 삭제
	@Override
	public void deleteFile(int fileseqno) {
		dao.deleteFile(fileseqno);
	};
	
	// 삭제할 파일 갯수
	@Override
	public int fileDeleteCount() {
		return dao.fileDeleteCount();
	};
}
