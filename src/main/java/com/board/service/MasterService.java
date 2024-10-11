package com.board.service;

import java.util.List;

import com.board.dto.FileDTO;

public interface MasterService {

	// 삭제된 게시물 리스트 보기
	public List<FileDTO> fileDeleteList();
	
	// tbl_file 내 데이터 삭제
	public void deleteFile(int fileseqno);
	
	// 삭제할 파일 갯수
	public int fileDeleteCount();
}
