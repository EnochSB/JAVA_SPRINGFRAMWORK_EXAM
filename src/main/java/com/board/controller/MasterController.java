package com.board.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.board.dto.FileDTO;
import com.board.service.MasterService;


@Controller
public class MasterController {
	
	@Autowired
	MasterService service;

	@GetMapping("/master/sysmanage")
	public void getSysmanage() {
		
	}
	
	@GetMapping("/master/filemanage")
	public void getFilemanage(
			Model model
			) {
		model.addAttribute("count", service.fileDeleteCount());
	}
	
	@ResponseBody
	@GetMapping("/master/fileDelete")
	public List<Map<String,String>> getFileDelete() {
		
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
		
		int count = 0;
		
		// 삭제된 파일 리스트 보기
		List<FileDTO> FileDeleteList = service.fileDeleteList();
		
		List<Map<String,String>> data = new ArrayList<>();
		// 파일 삭제
		for(FileDTO f:FileDeleteList) {
			
			// 웹브라우저에 삭제할 파일 정보 전소을 위해 리스트 컬렉션 객체에 정보를 저장
			Map<String,String> result = new HashMap<>();
			result.put("count", Integer.toString(count));
			result.put("org_filename", f.getOrg_filename());
			data.add(result);
			count ++;
			
			// 파일 삭제
			File file = new File(path + f.getStored_filename());
			file.delete();
			
			// tbl_file에서 정보 삭제
			service.deleteFile(f.getFileseqno());
		}
		return data;
	}
}
